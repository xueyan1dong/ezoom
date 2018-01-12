/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : TrackProduct.aspx.cs
*    Created By             : Fei Xue
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : 
*
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
  public partial class UnholdLot : TrackTemplate
  {
    protected Label lblStep, lblUom,  lblError2, lblEquipment, lblStartTime, lblStepStatus, lblMessage;
    protected Label lblSubProcessId, lblPositionId, lblSubPositionId, lblStepId, lblApprover, lblResult;
    protected TextBox txtQuantity, txtComment, txtPassword;
    protected DropDownList drpEquipment, drpApprover;
    private string  stepId, stepType;
    protected Button btnDo, btnMoveForm;
    protected Email emailHold;
    protected SqlDataSource sdsPDGrid;
    public DataColumnCollection colc;
    protected ModalPopupExtender MessagePopupExtender;
    protected RadioButtonList rbResult;
    //protected Panel MessagePanel;

    protected override void OnInit(EventArgs e)
    {
      base.OnInit(e);

      {
        //DataView dv = (DataView)sdsPDGrid.Select(DataSourceSelectArguments.Empty);
        //colc = dv.Table.Columns;

        ////Initial insert template  
        //FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"EndReturnMaterial.xml"));
        ////Initial Edit template           
        //FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"EndConsumeMaterial.xml"));

        //Event happens before the select index changed clicked.
        //gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
      }

      string response;
      if (Session["UserID"] == null)
        Response.Redirect("/Default.aspx");
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
        
        switch(Request.QueryString["step_type"])
        {
          case "scrap":
            Page.Title = "Scrap Batch -- ezOMM";
            btnDo.Text = "Scrap Batch";
            break;
          case "hold lot":
            Page.Title = "Unhold Batch -- ezOMM";
            btnDo.Text = "Unhold Batch";
            break;
        }

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          //if (Request.QueryString["equipment"].Length > 0)
          //{
          //  ezCmd.CommandText = "SELECT name FROM equipment WHERE id= " + Request.QueryString["equipment"];
          //  ezCmd.CommandType = CommandType.Text;
          //  lblEquipment.Text = ezCmd.ExecuteScalar().ToString();
          //}
        switch(Request.QueryString["step_type"])
        {
          case "scrap":
            emailHold.Subject = "Batch " + Session["lot_alias"].ToString() + " is about to be scrapped.";
            emailHold.Introduction = "To send email regarding the batch to be scrapped, please fill in neccessary information below and click the Send Email button (separate email addresses with commas)";
            break;
          case "hold lot":
            ezCmd.CommandText = "SELECT comment FROM lot_status WHERE id = " + Session["lot_id"].ToString();
          ezCmd.CommandType = CommandType.Text;
          txtComment.Text = ezCmd.ExecuteScalar().ToString();
          emailHold.MailContent = txtComment.Text;
          emailHold.Subject = "Batch " + Session["lot_alias"].ToString() + " was put on hold. Please check.";
          emailHold.Introduction = "To send email regarding the held batch, please fill in neccessary information below and click the Send Email button (separate email addresses with commas)";
          break;
        }

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
                emailHold.Visible = false;
                txtQuantity.Visible = false;
                txtComment.Visible = false;
                lblEquipment.Visible = false;
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
              ezReader.Dispose();
            }
          }
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
        }
        //newStep don't need to show Recipe grid, because the End form has one already.
        //newStep.ShowRecipe = false;
        if (ezReader != null)
          ezReader.Dispose();
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }
 
    protected void btnListForm_Click(object sender, EventArgs e)
    {
      MessagePopupExtender.Hide();
      Response.Redirect("MoveLot.aspx");
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
                   null,
                   txtQuantity.Text.Trim()
                   );
      ezCmd.Dispose();
      ezConn.Dispose();
    }
    protected void btnDo_Click(object sender, EventArgs e)
    {
      
      string subProcessId, positionId, subPositionId, stepId;
      try
      {
        ConnectToDb();

        ezCmd = new EzSqlCommand();

        ezCmd.Connection = ezConn;

        if (btnDo.Text.Equals("Unhold Batch"))
        {
          ezCmd.CommandText = "end_lot_step";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Session["lot_id"]));
          ezCmd.Parameters.AddWithValue("@_lot_alias", Session["lot_alias"].ToString());
          ezCmd.Parameters.AddWithValue("@_start_timecode", Request.QueryString["start_time"]);
          ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
          ezCmd.Parameters.AddWithValue("@_end_quantity", txtQuantity.Text.Trim());
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

          ezCmd.Parameters.AddWithValue("@_short_result", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_result_comment", txtComment.Text);
          ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Session["process_id"]), ParameterDirection.InputOutput);

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
            if (Request.QueryString["step_type"].Equals("condition"))
            {
              if (rbResult.SelectedValue.Equals("True"))
                lblMessage.Text = "The test has passed. Please click a button to go back to Move Product form or go to next step.";
              else
                lblMessage.Text = "The test has failed. Please click a button to go back to Move Product form or go to next step for failed test.";
            }
            MessagePopupExtender.Show();
          }
          ezCmd.Dispose();
          ezConn.Dispose();
        }
        else if (btnDo.Text.Equals("Scrap Batch"))
        {
          ezCmd.CommandText = "scrap_lot";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Session["lot_id"]));
          ezCmd.Parameters.AddWithValue("@_lot_alias", Session["lot_alias"].ToString());
          ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
          ezCmd.Parameters.AddWithValue("@_quantity", txtQuantity.Text.Trim());
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
          ezCmd.Parameters.AddWithValue("@_comment", txtComment.Text);
          ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Session["process_id"]), ParameterDirection.InputOutput);

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
          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

          ezCmd.ExecuteNonQuery();
          string response = ezCmd.Parameters["@_response"].Value.ToString();



          if (response.Length > 0)
            lblError.Text = response;
          else
          {
            lblMessage.Text = "The batch has been scrapped. Please remember to update inventory if there is any recycled parts.";
            btnMoveForm.Visible = false;
            MessagePopupExtender.Show();
          }
          ezCmd.Dispose();
          ezConn.Dispose();
        }
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;

        if (ezCmd != null)
          ezCmd.Dispose();
        ezConn.Dispose();
      }


    }
   
  }
}
