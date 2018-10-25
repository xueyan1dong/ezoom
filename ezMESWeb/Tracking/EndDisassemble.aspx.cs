/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : EndDisassemble.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 06/01/2018
*    Platform Dependencies  : .NET 
*    Description            : UI for ending disassemble step
*    Log                    :
*    6/1/2018: sdong: first created
*   6/13/2018: sdong: fixed bug the the "To Inventory" popup do not show the inventory list to return parts to
*   6/17/2018: sdong: fixed values sent to db sp "return_inventory" when submit button in return popup is clicked
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
  public partial class EndDisassemble : TrackTemplate
  {
    protected Label lblStep, lblUom,  lblError2, lblEquipment, lblStartTime, lblStepStatus, lblMessage, lblProcess, stepStatus;
    protected Label lblSubProcessId, lblPositionId, lblSubPositionId, lblStepId, lblApprover, lblResult;
    protected TextBox txtQuantity, txtComment, txtPassword;
    protected DropDownList drpEquipment, drpApprover;
    private string  stepId, stepType;
    protected Button btnDo;
    protected ConsumptionStep newStep;
    protected SqlDataSource sdsPDGrid;
    public DataColumnCollection colc;
    protected ModalPopupExtender MessagePopupExtender;
    protected RadioButtonList rbResult;
    //protected Panel MessagePanel;
    protected Label lblLotStatus2; //record lotstatus in a label separately 8/12

     protected override void OnInit(EventArgs e)
     {
      base.OnInit(e);

      {
        DataView dv = (DataView)sdsPDGrid.Select(DataSourceSelectArguments.Empty);
        colc = dv.Table.Columns;

        //Initial insert template  
        FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"EndReturnDisassemble.xml"));
        //Initial Edit template           
        FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"EndConsumeMaterial.xml"));

        //Event happens before the select index changed clicked.
        //gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
      }

      string response;
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
        //lblUom.Text = Session["uom"].ToString();
        txtQuantity.Text = Request.QueryString["quantity"];
        
        if(Request.QueryString["step_type"].Equals("condition"))
        {
          lblResult.Visible = true;
          rbResult.Visible = true;
        }

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          if (Request.QueryString["equipment"].Length > 0)
          {
            ezCmd.CommandText = "SELECT name FROM equipment WHERE id= " + Request.QueryString["equipment"];
            ezCmd.CommandType = CommandType.Text;
            lblEquipment.Text = ezCmd.ExecuteScalar().ToString();
          }
          ezCmd.CommandText = "SELECT comment FROM lot_status WHERE id = " + Request.QueryString["lot_id"];//Session["lot_id"].ToString();
          ezCmd.CommandType = CommandType.Text;
          txtComment.Text = ezCmd.ExecuteScalar().ToString();

          ezCmd.CommandText = "SELECT uom from view_lot_in_process where id = "+ Request.QueryString["lot_id"];
          ezCmd.CommandType = CommandType.Text;
          lblUom.Text = ezCmd.ExecuteScalar().ToString();//replaced session['uom'] with querying from view 

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
                newStep.Visible = false;
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
            + Request.QueryString["process_id"]//Session["process_id"].ToString()
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
        newStep.ShowRecipe = false;
        if (ezReader != null)
          ezReader.Dispose();
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }
    //protected override void Page_Load(object sender, EventArgs e)
    //{

    //}
    protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
    {
      string partName = gvTable.SelectedDataKey.Values["name"].ToString();
      
      //this.FormView1.DataBind();


      lblError2.Text = "";
      if (Request.Params["__EVENTTARGET"].Contains("btnConsume"))
      {
        FormView1.ChangeMode(FormViewMode.Edit);
        this.FormView1.DataBind();
        //  update the contents in the detail panel
        DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
        ddInventory.Width = 280;
        ddInventory.Items.Clear();
        Label lblRequired = (Label)FormView1.FindControl("lblrequired_quantity");
        TextBox txtActual = (TextBox)FormView1.FindControl("txtused_quantity");
        Decimal defaultQuantity =
                  Convert.ToDecimal(gvTable.SelectedDataKey.Values["required_quantity"])
          - Convert.ToDecimal(gvTable.SelectedDataKey.Values["used_quantity"]);
        txtActual.Text = lblRequired.Text = string.Format("{0:N0}", defaultQuantity);
        FormView1.Caption = "Consume More '" + partName + "' from Inventory";
        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText =
            " SELECT concat(i.lot_id, IF(i.serial_no IS NULL ,'', CONCAT('(',i.serial_no,')')), ', ', CAST(i.actual_quantity AS UNSIGNED INTEGER),' ', u.name), i.id FROM inventory i, uom u WHERE i.source_type ='"
          + gvTable.SelectedDataKey.Values["source_type"].ToString()
          + "' AND i.pd_or_mt_id = " + gvTable.SelectedDataKey.Values["ingredient_id"].ToString()
          + " AND i.actual_quantity>0 AND u.id = i.uom_id";

          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();
          while (ezReader.Read())
          {
            ddInventory.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
          }
          ezReader.Close();
          ezReader.Dispose();
          ezCmd.Dispose();
          ezConn.Dispose();
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
          if(ezReader != null)
            ezReader.Dispose();
          ezCmd.Dispose();
          ezConn.Dispose();
          return;
        }
      }
      else
      {
        FormView1.ChangeMode(FormViewMode.Insert);
        FormView1.Caption = "Return Some '" + partName + "' to Inventory";
        FormView1.DataBind();
        DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
        ddInventory.Width = 280;
        ddInventory.Items.Clear();
        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;


          ezCmd.CommandText = "SELECT CONCAT( CAST(i.lot_id AS CHAR)" +
              ", IF(i.serial_no IS NULL ,'', CONCAT('(',i.serial_no,')')), ', ', CAST(i.actual_quantity AS UNSIGNED INTEGER), ' ', u.name, ' in stock'), " 
              + "CONCAT(CAST(r.uom_id AS CHAR), ',', CAST(i.id AS CHAR))  FROM inventory i, uom u,  step s, ingredients r WHERE i.source_type = '"
              + gvTable.SelectedDataKey.Values["source_type"].ToString() +
              "' AND i.pd_or_mt_id = " + gvTable.SelectedDataKey.Values["ingredient_id"].ToString() +
              " AND u.id = i.uom_id AND s.id = " + Request.QueryString["step"] +
              " AND r.recipe_id = s.recipe_id AND r.ingredient_id = i.pd_or_mt_id AND r.source_type = i.source_type"; 
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();
          while (ezReader.Read())
          {
            ddInventory.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
          }
          if (ddInventory.Items.Count > 0)
          {
           ddInventory.SelectedIndex = 0;
           string[] dataValues = ddInventory.Items[0].Text.Split(',');
           Label lblRequired = (Label)FormView1.FindControl("lblrequired_quantity");
           Decimal defaultQuantity =
                      Convert.ToDecimal(gvTable.SelectedDataKey.Values["required_quantity"])
              - Convert.ToDecimal(gvTable.SelectedDataKey.Values["used_quantity"]);
           lblRequired.Text = string.Format("{0:N0}", defaultQuantity);
           Label lblUom = (Label)FormView1.FindControl("lbluom_name");
           lblUom.Text = dataValues[1].Split(' ')[2];
          }
          ezReader.Close();
          ezReader.Dispose();
          ezCmd.Dispose();
          ezConn.Dispose();
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
          if (ezReader != null)
            ezReader.Dispose();
          ezCmd.Dispose();
          ezConn.Dispose();
          return;
        }
      }
      FormView1.Visible = true;
      this.updateRecordPanel.Update();
      //  show the modal popup
      this.ModalPopupExtender.Show();
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
        GoEndStep(Request.QueryString["lot_id"],//Session["lot_id"].ToString(),
                  Request.QueryString["lot_alias"], //Session["lot_alias"].ToString(),
                   lblLotStatus2.Text,//Session["lot_status"].ToString(),
                  lblStartTime.Text,
                  lblStepStatus.Text,
                  Request.QueryString["process_id"],//Session["process_id"].ToString(),
                  lblSubProcessId.Text,
                  lblPositionId.Text,
                  lblSubPositionId.Text,
                  lblStepId.Text,
                  null,
                  txtQuantity.Text.Trim(),
                  null);
      else
        //go to start form for next step
        GoNextStep(Request.QueryString["lot_id"],//Session["lot_id"].ToString(),
                   Request.QueryString["lot_alias"],//Session["lot_alias"].ToString(),                   
                   lblLotStatus2.Text,//Session["lot_status"].ToString(),
                   lblStepStatus.Text,
                   Request.QueryString["process_id"],//Session["process_id"].ToString(),
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

        ezCmd.CommandText = "end_lot_step";
        ezCmd.CommandType = CommandType.StoredProcedure;
        ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]));//Session["lot_id"]));
        ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]);//Session["lot_alias"].ToString());
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
        if (Request.QueryString["step_type"].Equals("condition") && rbResult.Visible == true)
          ezCmd.Parameters.AddWithValue("@_short_result", rbResult.SelectedValue);
        else
          ezCmd.Parameters.AddWithValue("@_short_result", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_result_comment", txtComment.Text);
        if (Request.QueryString["location_id"] == null)
            ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
        else
            ezCmd.Parameters.AddWithValue("@_location_id", Request.QueryString["location_id"]); //added 8/2/2018 peiyu

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
          /*Session["lot_status"]*/ lblLotStatus2.Text = ezCmd.Parameters["@_lot_status"].Value.ToString(); //replace session['lot_status'] with a label variable lblLotStatus2
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
          //this chunk of code was copied from EndConsumeMaterial and won't be used logically in this form
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

          // for consumption step, send step start_timecode as consumption_start_timecode 
          if (Request.QueryString["start_time"].Length > 0)
          {
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", Request.QueryString["start_time"]);
            ezCmd.Parameters.AddWithValue("@_consumption_start_timecode", Request.QueryString["start_time"]);
          }

          else
          {
            ezCmd.Parameters.AddWithValue("@_step_start_timecode", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_consumption_start_timecode", DBNull.Value);
          }
          DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
          string[] valueArray = ddInventory.SelectedValue.Split(',');
          
          if (ddInventory.SelectedItem.Value.Length > 0)
            ezCmd.Parameters.AddWithValue("@_inventory_id", valueArray[1]);
          else
            ezCmd.Parameters.AddWithValue("@_inventory_id", DBNull.Value);

          fTemp =
            (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

          LoadSqlParasFromTemplate(ezCmd, fTemp);

          ezCmd.Parameters.AddWithValue("@_recipe_uomid", valueArray[0]);
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
    protected void btnCancel_Click(object sender, EventArgs e)
    {
    }

    }
}
