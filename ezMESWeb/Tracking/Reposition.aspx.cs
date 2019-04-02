/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : Reposition.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2008
*    Platform Dependencies  : .NET 
*    Description            : UI for Reposition step
*    Log                    :
*    06/06/2018: xdong: Add _location parameter to call to db stored procedure pass_lot_step
*    12/04/2018: xdong: fixed the bug that reposition not going to target step
*    04/01/2019: xdong: added _value1 input parameter to db sp call to pass_lot_step, following the sp change
----------------------------------------------------------------*/

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommonLib.Data.EzSqlClient;
using AjaxControlToolkit;

namespace ezMESWeb.Tracking
{
  public partial class Reposition : TrackTemplate
  {
    protected Label lblStep, lblUom,  lblError2,  lblStartTime, lblStepStatus, lblMessage;
    protected Label lblSubProcessId, lblPositionId, lblSubPositionId, lblStepId, lblApprover;
    protected TextBox txtQuantity, txtComment, txtPassword, txtResult;
    protected DropDownList drpEquipment, drpApprover;
    private string  stepId;
    protected Button btnDo;
    protected SqlDataSource sdsPDGrid;
    public DataColumnCollection colc;
    protected ModalPopupExtender MessagePopupExtender;
    protected RadioButtonList rbResult;
    protected Table tbSteps;
    //protected Panel MessagePanel;

    protected override void OnInit(EventArgs e)
    {
      base.OnInit(e);

      string response;
      TableRow newRow;
      TableCell newCell;

      if (Session["UserID"] == null)
        Server.Transfer("/Default.aspx");
      else
      {
        Label tLabel = (Label)Page.Master.FindControl("lblName");
        if (!tLabel.Text.StartsWith("Welcome"))
          tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
      }

      if (!IsPostBack)
      {
        stepId = Request.QueryString["step"];
        lblUom.Text = Session["uom"].ToString();
        txtQuantity.Text = Request.QueryString["quantity"];
        

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
 
          //ezCmd.CommandText = "SELECT comment FROM lot_status WHERE id = " + Session["lot_id"].ToString();
          //ezCmd.CommandType = CommandType.Text;
          //txtComment.Text = ezCmd.ExecuteScalar().ToString();

          ezCmd.CommandText = "SELECT name, emp_usage, emp_id  FROM step where id=" + stepId;
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();

          if (ezReader.Read())
          {
            lblStep.Text = String.Format("{0}", ezReader[0]);

            string empUsage = String.Format("{0}", ezReader[1]);
            string empId = String.Format("{0}", ezReader[2]);
            ezReader.Close();
            //ezReader.Dispose();

            if (empId.Length > 0)
            {
              ezCmd.CommandText = "check_emp_access";
              ezCmd.CommandType = CommandType.StoredProcedure;
              ezCmd.Parameters.AddWithValue("@_emp_id", Convert.ToInt32(Session["UserID"]));
              ezCmd.Parameters.AddWithValue("@_emp_usage", empUsage);
              ezCmd.Parameters.AddWithValue("@_allow_emp_id", Convert.ToInt32(empId));
              ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

              if (Convert.ToInt32(ezCmd.ExecuteScalar()) == 0)
                lblError.Text = "You are not allowed to access this step.";

              response = ezCmd.Parameters["@_response"].Value.ToString();
              if (response.Length > 0)
              {
                lblError.Text = response;
              }

              if (lblError.Text.Length > 0)
              {
                btnDo.Visible = false;
                lblStep.Visible = false;
                lblUom.Visible = false;
                txtQuantity.Visible = false;
                txtComment.Visible = false;
                //lblEquipment.Visible = false;
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
              }
            }
          }
          else
          {
            if ((ezReader!=null)&&(!ezReader.IsClosed))
              ezReader.Close();
            //ezReader.Dispose();
          }
          //toggle approval controls depending whether the step needs approval
          ezCmd.Dispose();
          ezReader.Dispose();
          // if not reinitialize an new ezCmd,
          // for some reason, there is an error saying Reader is not closed with the command. -- x.d.
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText =
            "SELECT need_approval, approve_emp_usage, approve_emp_id FROM process_step WHERE process_id= "
            + Session["process_id"].ToString()
            + " AND position_id = "
            + Request.QueryString["position"]
            + " AND step_id = " + Request.QueryString["step"];
          ezCmd.CommandType = CommandType.Text;
      
          
          ezReader = ezCmd.ExecuteReader();
          if (ezReader.Read())
          {
            if (ezReader[0].ToString().Equals("1"))
            {
              switch (ezReader[1].ToString())
              {
                case "employee group":
                  ezCmd.CommandText = "SELECT CONCAT(firstname, ' ', lastname), id FROM employee WHERE eg_id = "
                    + ezReader[2].ToString();
                  break;
                case "employee":
                  ezCmd.CommandText = "SELECT CONCAT(firstname, ' ', lastname), id FROM employee WHERE id = "
                    + ezReader[2].ToString();
                  break;
                  //didn't deal with "employee category"
              }
              ezCmd.CommandType = CommandType.Text;
              ezReader.Close();
              ezReader = ezCmd.ExecuteReader();
              if (ezReader.Read())
              {
                drpApprover.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
                lblApprover.Visible = true;
                drpApprover.Visible = true;
                txtPassword.Visible = true;
              }
              ezReader.Close();
              ezReader.Dispose();
            }
          }

          if (Request.QueryString["step_type"].Equals("reposition"))
          {
            ezCmd.CommandText =
                  "SELECT null as sub_process_id, p.position_id, null as sub_position_id, p.step_id, s.name, s.description "
                + " FROM process_step p, step s WHERE process_id = "
                + Request.QueryString["process_id"].ToString()
                + " AND if_sub_process = 0 AND s.id = p.step_id and s.id != "
                + Request.QueryString["step"] 
                + " UNION SELECT p1.process_id, p.position_id, p1.position_id, p1.step_id, s.name, s.description "
                + " FROM process_step p, process_step p1, step s WHERE p.process_id = "
                + Request.QueryString["process_id"].ToString()
                + " AND p.if_sub_process = 1 AND p.step_id = p1.process_id AND s.id = p1.step_id and s.id !="
                + Request.QueryString["step"] + " ORDER BY 2,3";

            ezCmd.CommandType = CommandType.Text;

            ezReader.Close();
            ezReader.Dispose();

            ezReader = ezCmd.ExecuteReader();

            while (ezReader.Read())
            {
              newRow = CreateTableRow();


              newCell = CreateTableCell(
                String.Format("<input type=\"radio\" name=\"rdbSelect\" id=\"rdbSelect\" value=\"{2},{0},{3},{4}\" OnClick=\"writeResult('{2},{0},{3},{4}','{1}')\" > &nbsp;{0} </input>", 
                ezReader["position_id"],
                txtResult.ClientID,
                ezReader["sub_process_id"],
                ezReader["sub_position_id"],
                ezReader["step_id"]));
                  
                  
              newRow.Cells.Add(newCell);

              newCell = CreateTableCell(String.Format("{0}", ezReader["name"]));
              newCell.HorizontalAlign = HorizontalAlign.Left;
              newRow.Cells.Add(newCell);

              newCell = CreateTableCell(String.Format("{0}", ezReader["description"]));
              newCell.HorizontalAlign = HorizontalAlign.Left;
              newRow.Cells.Add(newCell);


              tbSteps.Rows.Add(newRow);
            }

            if (tbSteps.Rows.Count > 1)
            {
              tbSteps.Visible = true;
            }
            btnDo.Attributes.Add("OnClick", "return checkResult('" + txtResult.ClientID + "')");
          }
          ezReader.Close();
          ezReader.Dispose();
            
          
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
        }
     
        if (ezReader != null)
          ezReader.Dispose();
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }


    protected void btnListForm_Click(object sender, EventArgs e)
    {
      MessagePopupExtender.Hide();
      Server.Transfer("MoveLot.aspx");
    }
    protected void btnMoveForm_Click(object sender, EventArgs e)
    {
      try
      {
        ConnectToDb();

        ezCmd = new EzSqlCommand();
        ezCmd.Connection = ezConn;
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;
      }
      if (lblStartTime.Text.Length > 0)
        //next step auto started
        GoEndStep(Session["lot_id"].ToString(),
                  Session["lot_alias"].ToString(),
                  Session["lot_status"].ToString(),
                  lblStartTime.Text,
                  lblStepStatus.Text,
                  Session["process_id"].ToString(),
                  lblSubProcessId.Text,
                  lblPositionId.Text,
                  lblSubPositionId.Text,
                  lblStepId.Text,
                  null,
                  txtQuantity.Text.Trim(),
                  null);
      else
        //go to start form for next step
        GoNextStep(Session["lot_id"].ToString(),
                   Session["lot_alias"].ToString(),
                   Session["lot_status"].ToString(),
                   lblStepStatus.Text,
                   Session["process_id"].ToString(),
                   Request.QueryString["sub_process"],
                   Request.QueryString["position"],
                   Request.QueryString["sub_position"],
                   Request.QueryString["step"],
                   txtResult.Text,
                   txtQuantity.Text.Trim()
                   );
      ezCmd.Dispose();
      ezConn.Dispose();
    }
    protected void btnDo_Click(object sender, EventArgs e)
    {
      
      string subProcessId, positionId, subPositionId, stepId, locationID="";

      try
      {
        ConnectToDb();

        ezCmd = new EzSqlCommand();

        ezCmd.Connection = ezConn;

        //pull location_id from view
        ezCmd.CommandText = "SELECT location_id from view_lot_in_process where id = " + Request.QueryString["lot_id"];
        ezCmd.CommandType = CommandType.Text;
        ezReader = ezCmd.ExecuteReader();
        if (ezReader.Read())
        {
          locationID = String.Format("{0}", ezReader[0]);
        }
        ezReader.Close();
        ezReader.Dispose();

        ezCmd.CommandText = "pass_lot_step";
        ezCmd.CommandType = CommandType.StoredProcedure;
        ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]));
        ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]);
        ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
        ezCmd.Parameters.AddWithValue("@_quantity", txtQuantity.Text.Trim());
        ezCmd.Parameters.AddWithValue("@_equiment_id", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_device_id", DBNull.Value);
        if (drpApprover.Visible == true)
        {
          ezCmd.Parameters.AddWithValue("@_approver_id", drpApprover.SelectedValue);
          ezCmd.Parameters.AddWithValue("@_approver_password", txtPassword.Text);
        }
        else
        {
          ezCmd.Parameters.AddWithValue("@_approver_id", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_approver_password", DBNull.Value);
        }
        
        ezCmd.Parameters.AddWithValue("@_short_result",txtResult.Text);

        ezCmd.Parameters.AddWithValue("@_comment", txtComment.Text);

        if (locationID.Length > 0)
          ezCmd.Parameters.AddWithValue("@_location_id", Convert.ToInt32(locationID));
        else
          ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);

        ezCmd.Parameters.AddWithValue("@_value1", DBNull.Value);

        ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Request.QueryString["process_id"]), ParameterDirection.InputOutput);

        subProcessId = Request.QueryString["sub_process"];
        if (subProcessId.Length > 0)
          ezCmd.Parameters.AddWithValue("@_sub_process_id", subProcessId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value, ParameterDirection.InputOutput);

        positionId = Request.QueryString["position"];

        ezCmd.Parameters.AddWithValue("@_position_id", (positionId.Length > 0) ? positionId : "1", ParameterDirection.InputOutput);

        subPositionId = Request.QueryString["sub_position"];
        if (subPositionId.Length > 0)
          ezCmd.Parameters.AddWithValue("@_sub_position_id", subPositionId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value, ParameterDirection.InputOutput);

        stepId = Request.QueryString["step"];
        if (stepId.Length > 0)
          ezCmd.Parameters.AddWithValue("@_step_id", stepId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value, ParameterDirection.InputOutput);

        ezCmd.Parameters.AddWithValue("@_lot_status", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_step_status", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_autostart_timecode", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

        ezCmd.ExecuteNonQuery();
        string response = ezCmd.Parameters["@_response"].Value.ToString();
 
        

        if (response.Length > 0)
          lblError.Text = response;
        else
        {
          Session["lot_status"] = ezCmd.Parameters["@_lot_status"].Value.ToString();
          lblStepStatus.Text = ezCmd.Parameters["@_step_status"].Value.ToString();
          lblStartTime.Text = ezCmd.Parameters["@_autostart_timecode"].Value.ToString();
          if (lblStartTime.Text.Length > 0)
          {
            lblSubProcessId.Text = ezCmd.Parameters["@_sub_process_id"].Value.ToString();
            lblPositionId.Text = ezCmd.Parameters["@_position_id"].Value.ToString();
            lblSubPositionId.Text = ezCmd.Parameters["@_sub_position_id"].Value.ToString();
            lblStepId.Text = ezCmd.Parameters["@_step_id"].Value.ToString();
          }
          MessagePopupExtender.Show();
        }
        ezCmd.Dispose();
        ezConn.Dispose();
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;

        if (ezCmd != null)
          ezCmd.Dispose();
        ezConn.Dispose();
      }


    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
      string response;
      ezMES.ITemplate.FormattedTemplate fTemp;

      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "consume_inventory";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Session["lot_id"]));
          ezCmd.Parameters.AddWithValue("@_lot_alias", Session["lot_alias"].ToString());
          ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
          if (Request.QueryString["equipment"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_equipment_id", Request.QueryString["equipment"]);
          else
            ezCmd.Parameters.AddWithValue("@_equipment_id", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_device_id", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_process_id", Session["process_id"].ToString());
          if (Request.QueryString["sub_process"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_sub_process_id", Request.QueryString["sub_process"]);
          else
            ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value);
          if (Request.QueryString["position"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_position_id", Request.QueryString["position"]);
          else
            ezCmd.Parameters.AddWithValue("@_position_id", DBNull.Value);

          if (Request.QueryString["sub_position"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_sub_position_id", Request.QueryString["sub_position"]);
          else
            ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value);

          if (Request.QueryString["step"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_step_id", Request.QueryString["step"]);
          else
            ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value);

          if (Request.QueryString["start_time"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", Request.QueryString["start_time"]);
          else
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", DBNull.Value);

          fTemp =
            (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;

          LoadSqlParasFromTemplate(ezCmd, fTemp);

          ezCmd.Parameters.AddWithValue("@_recipe_uomid", gvTable.SelectedDataKey.Values["uom_id"].ToString());
          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

          ezCmd.ExecuteNonQuery();

          response = ezCmd.Parameters["@_response"].Value.ToString();
          ezCmd.Dispose();
          ezConn.Dispose();
          if (response.Length > 0)
          {
            lblError2.Text = response;
            this.ModalPopupExtender.Show();
          }
          else
          {
            lblError2.Text = "";
            this.FormView1.Visible = false;
            this.ModalPopupExtender.Hide();

            //  add the css class for our yellow fade
            ScriptManager.GetCurrent(this).RegisterDataItem(
              // The control I want to send data to
                this.gvTable,
              //  The data I want to send it (the row that was edited)
                this.gvTable.SelectedIndex.ToString()
            );

            gvTable.DataBind();
            this.gvTablePanel.Update();

          }


        }
        catch (Exception ex)
        {
          lblError2.Text = ex.Message;
          this.ModalPopupExtender.Show();
          ezCmd.Dispose();
          ezConn.Dispose();
        }
      }
      else
      {
        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "return_inventory";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Session["lot_id"]));
          ezCmd.Parameters.AddWithValue("@_lot_alias", Session["lot_alias"].ToString());
          ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
          ezCmd.Parameters.AddWithValue("@_process_id", Session["process_id"].ToString());
          if (Request.QueryString["step"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_step_id", Request.QueryString["step"]);
          else
            ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value);

          if (Request.QueryString["start_time"].Length > 0)
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", Request.QueryString["start_time"]);
          else
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", DBNull.Value);

          DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
          string[] valueArray = ddInventory.SelectedValue.Split(',');
          ezCmd.Parameters.AddWithValue("@_consumption_start_timecode", valueArray[0]);

          ezCmd.Parameters.AddWithValue("@_inventory_id", valueArray[3]);

          fTemp =
            (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

          LoadSqlParasFromTemplate(ezCmd, fTemp);

          ezCmd.Parameters.AddWithValue("@_recipe_uomid", valueArray[2]);
          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

          ezCmd.ExecuteNonQuery();

          response = ezCmd.Parameters["@_response"].Value.ToString();
          ezCmd.Dispose();
          ezConn.Close();
          ezConn.Dispose();
          if (response.Length > 0)
          {
            lblError2.Text = response;
            this.ModalPopupExtender.Show();
          }
          else
          {
            lblError2.Text = "";
            this.FormView1.Visible = false;
            this.ModalPopupExtender.Hide();

            //  add the css class for our yellow fade
            ScriptManager.GetCurrent(this).RegisterDataItem(
              // The control I want to send data to
                this.gvTable,
              //  The data I want to send it (the row that was edited)
                this.gvTable.SelectedIndex.ToString()
            );

            gvTable.DataBind();
            this.gvTablePanel.Update();

          }


        }
        catch (Exception ex)
        {
          lblError2.Text = ex.Message;
          this.ModalPopupExtender.Show();
          ezCmd.Dispose();
          ezConn.Dispose();
        }
      }
    }
    private TableRow CreateTableRow()
    {
      TableRow tableRow = new TableRow();
      return tableRow;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Text"></param>
    /// <returns></returns>
    private TableCell CreateTableCell(string Text)
    {
      TableCell tableCell = new TableCell();
      tableCell.Text = Text;
      return tableCell;
    }



  }
}
