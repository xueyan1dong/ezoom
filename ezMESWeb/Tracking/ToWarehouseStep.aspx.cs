/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : EndDisassemble.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 06/05/2018
*    Platform Dependencies  : .NET 
*    Description            : UI for shipping product to a new location
*    Log                    :
*    06/05/2018: xdong: first created
*    06/06/2018: xdong: fixed the issue that step name now showing
*                       Add _location parameter to call to db stored procedure pass_lot_step
*    09/27/2018: xdong: change ui wording so that this step is not limited to warehouse locations
*    11/29/2018: xdong: Changed ui layout and do button from showing "Ship to Warehouse" to "Ship
*    12/04/2018: xdong: Added logic to change the popup message and button display if at the last step of workflow
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
  public partial class ToWarehouseStep : TrackTemplate
  {
    protected Label lblStep, lblUom,  lblEquipment, lblStepStatus, lblApprover,lblStartTime, lblSubProcessId, lblPositionId, lblSubPositionId, lblStepId, lblMessage;
    protected TextBox txtComment, txtPassword;
    protected DropDownList drpEquipment, drpApprover, drpLocation;
    private string subProcessId, positionId, subPositionId, stepId;
    protected Button btnDo, btnMoveForm;
    protected ModalPopupExtender MessagePopupExtender;
    protected Panel MessagePanel;
    protected Label lblLotStatus2;

    
    protected override void OnInit(EventArgs e)
    {
      base.OnInit(e);
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
        //txtLocation.Text = Request.QueryString["quantity"];

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "SELECT comment, 1 FROM lot_status WHERE id = " + Session["lot_id"].ToString();
          ezCmd.CommandType = CommandType.Text;
          txtComment.Text = ezCmd.ExecuteScalar().ToString();

          //populate location dropdown
          ezCmd.CommandText = "SELECT id, name FROM location";
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();
          while (ezReader.Read())
          {
            drpLocation.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
          }
          ezReader.Dispose();

          // set location dropdown default to last step's location
          ezCmd.CommandText = "SELECT location_id from view_lot_in_process where id = " + Request.QueryString["lot_id"];
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();

          if (ezReader.Read())
          {
            drpLocation.SelectedValue = String.Format("{0}", ezReader[0]);             
          }
          ezReader.Dispose();

          ezCmd.CommandText = "SELECT name, emp_usage, emp_id  FROM step where id=" + stepId;
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();

          if (ezReader.Read())
          {
            lblStep.Text = String.Format("{0}", ezReader[0]);

            string empUsage = String.Format("{0}", ezReader[1]);
            string empId = String.Format("{0}", ezReader[2]);
            ezReader.Dispose();

            if (empId.Length > 0)
            {
              ezCmd.CommandText = "check_emp_access";
              ezCmd.CommandType = CommandType.StoredProcedure;
              ezCmd.Parameters.AddWithValue("@_emp_id", Convert.ToInt32(Session["UserID"]));
              ezCmd.Parameters.AddWithValue("@_emp_usage", empUsage);
              ezCmd.Parameters.AddWithValue("@_allow_emp_id", Convert.ToInt32(empId));
              ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

              if (Convert.ToInt32(ezCmd.ExecuteScalar()) == 0)
                lblError.Text = "You are not allowed to access next step.";

              response = ezCmd.Parameters["@_response"].Value.ToString();
              if (response.Length > 0)
              {
                lblError.Text = response;
              }

              if (lblError.Text.Length > 0)
              {
                btnDo.Visible = false;
                lblStep.Visible = false;
                //lblUom.Visible = false;
                //newStep.Visible = false;
                drpLocation.Visible = false;
                txtComment.Visible = false;
                lblEquipment.Visible = false;
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
              }
            }
          }
          else
          {
            if ((ezReader != null) && (!ezReader.IsClosed))
              ezReader.Close();
            //ezReader.Dispose();
          }
          //toggle approval controls depending whether the step needs approval
          ezCmd.Dispose();
          ezReader.Dispose();

          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText =
            "SELECT need_approval, approve_emp_usage, approve_emp_id FROM process_step WHERE process_id= "
            + Session["process_id"].ToString()
            + " AND position_id = "
            + Request.QueryString["position"]
            + " AND step_id = " + Request.QueryString["step"];
          ezCmd.CommandType = CommandType.Text;

          //manipulate the approval dropdown list and password input. populate the dropdown or hide the whole block, if not needed
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
        ezCmd.Dispose();
        ezConn.Dispose();
        ezReader.Dispose();
      }
    }
    protected void btnListForm_Click(object sender, EventArgs e)
    {
      MessagePopupExtender.Hide();
      Server.Transfer("MoveLot.aspx");
    }
    protected void btnDo_Click(object sender, EventArgs e)
    {
      string response, lotStatus, stepStatus, startTime;
      try
      {
        ConnectToDb();

        ezCmd = new EzSqlCommand();

        ezCmd.Connection = ezConn;

        ezCmd.CommandText = "pass_lot_step";
        ezCmd.CommandType = CommandType.StoredProcedure;
        ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]));//Session["lot_id"]));
        ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]);//Session["lot_alias"].ToString());
        ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
        ezCmd.Parameters.AddWithValue("@_quantity", Request.QueryString["quantity"]);
        ezCmd.Parameters.AddWithValue("@_equipment_id", DBNull.Value);
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
        ezCmd.Parameters.AddWithValue("@_short_result", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_comment", txtComment.Text);
        if(drpLocation.SelectedValue.Length == 0)
        {
            ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
        }
        else
        {
            ezCmd.Parameters.AddWithValue("@_location_id", drpLocation.SelectedValue);
        }
                ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Request.QueryString["process_id"]/*Session["process_id"]*/), ParameterDirection.InputOutput);

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
        response = ezCmd.Parameters["@_response"].Value.ToString();
        if (response.Length > 0)
          lblError.Text = response;
        else
        {
         /* Session["lot_status"]*/ lblLotStatus2.Text = ezCmd.Parameters["@_lot_status"].Value.ToString();
          lblStepStatus.Text = ezCmd.Parameters["@_step_status"].Value.ToString();
          lblStartTime.Text = ezCmd.Parameters["@_autostart_timecode"].Value.ToString();
          if (lblStartTime.Text.Length > 0)
          {
            lblSubProcessId.Text = ezCmd.Parameters["@_sub_process_id"].Value.ToString();
            lblPositionId.Text = ezCmd.Parameters["@_position_id"].Value.ToString();
            lblSubPositionId.Text = ezCmd.Parameters["@_sub_position_id"].Value.ToString();
            lblStepId.Text = ezCmd.Parameters["@_step_id"].Value.ToString();

          }
          if (lblLotStatus2.Text.Equals("done")) //already at the last step
          {
            lblMessage.Text = "You just completed the last step of the process. Please click below button to go back to Move Product form in order to process other batches.";
            btnMoveForm.Visible = false;
          }

          MessagePopupExtender.Show();
        }
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;

      }

      ezCmd.Dispose();
      ezConn.Dispose();


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
                  Request.QueryString["lot_alias"],//Session["lot_alias"].ToString(),
                  lblLotStatus2.Text,//Session["lot_status"].ToString(),
                  lblStartTime.Text,
                  lblStepStatus.Text,
                  Request.QueryString["process_id"],//Session["process_id"].ToString(),
                  lblSubProcessId.Text,
                  lblPositionId.Text,
                  lblSubPositionId.Text,
                  lblStepId.Text,
                  null,
                  Request.QueryString["quantity"],
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
                 Request.QueryString["quantity"]
                 );
      ezCmd.Dispose();
      ezConn.Dispose();
    }
  }
}
