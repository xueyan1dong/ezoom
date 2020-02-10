/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : AddProductToInventory.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2008
*    Platform Dependencies  : .NET 
*    Description            : UI for Display Message step
*    Log                    :
*    06/06/2018: xdong: Add _location parameter to call to db stored procedure pass_lot_step
*    12/04/2018: xdong: update the call to pass_lot_step to take in _location_id parameter instead of _location
*    02/11/2019: xdong: update the call to pass_lot_step to take in _value1 parameter, which is newly added to pass_lot_step
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

namespace ezMESWeb.Tracking
{
  public partial class PassDisplayStep : TrackTemplate
  {
    protected Label lblStep, lblUom,  lblEquipment;
    protected TextBox txtQuantity, txtComment;
    protected DropDownList drpEquipment;
    private string subProcessId, positionId, subPositionId, stepId;
    protected Button btnDo;
    protected System.Web.UI.UserControl newStep;
    protected lot eLot;

    protected override void Page_Load(object sender, EventArgs e)
    {
      string response;
      base.Page_Load(sender, e);

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
          //ezCmd.CommandText = "SELECT comment, 1 FROM lot_status WHERE id = " + Session["lot_id"].ToString();
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
                lblError.Text = "You are not allowed to access the next step.";

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
                //lblEquipment.Visible = false;
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
              }
            }
          }
          else
            ezReader.Dispose();
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;

        }
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }

    protected void btnDo_Click(object sender, EventArgs e)
    {
      string response, lotStatus, stepStatus, startTime, locationID="";

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
        ezCmd.Parameters.AddWithValue("@_equipment_id", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_device_id", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_approver_id", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_approver_password", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_short_result", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_comment", txtComment.Text);
        if (locationID.Length > 0)
          ezCmd.Parameters.AddWithValue("@_location_id",  Convert.ToInt32(locationID));
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
        response = ezCmd.Parameters["@_response"].Value.ToString();
        if (response.Length > 0)
          lblError.Text = response;
        else
        {
          lotStatus = ezCmd.Parameters["@_lot_status"].Value.ToString();
          Session["lot_status"] = lotStatus;
          stepStatus = ezCmd.Parameters["@_step_status"].Value.ToString();
          startTime = ezCmd.Parameters["@_autostart_timecode"].Value.ToString();
          if ((startTime != null) && (startTime.Length > 0))
          {
            subProcessId = ezCmd.Parameters["@_sub_process_id"].Value.ToString();
            positionId = ezCmd.Parameters["@_position_id"].Value.ToString();
            subPositionId = ezCmd.Parameters["@_sub_position_id"].Value.ToString();
            stepId = ezCmd.Parameters["@_step_id"].Value.ToString();

            GoEndStep(Session["lot_id"].ToString(),
                      Session["lot_alias"].ToString(),
                      lotStatus,
                      startTime,
                      stepStatus,
                      Session["process_id"].ToString(),
                      subProcessId,
                      positionId,
                      subPositionId,
                      stepId,
                      null,
                      txtQuantity.Text.Trim(),
                      null);
          }
          else
          {
  
            GoNextStep(Session["lot_id"].ToString(),
                                    Session["lot_alias"].ToString(),
                                    lotStatus,
                                    stepStatus,
                                    Session["process_id"].ToString(),
                                    subProcessId,
                                    positionId,
                                    subPositionId,
                                    stepId,
                                    null,
                                    txtQuantity.Text.Trim());
          }
          }
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;

      }

      ezCmd.Dispose();
      ezConn.Dispose();


    }
  }
}
