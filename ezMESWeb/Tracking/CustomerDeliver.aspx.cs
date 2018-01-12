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
  public partial class CustomerDeliver : TrackTemplate
  {
    protected Label lblStep, lblUom, lblEquipment, lblApprover;
    protected TextBox txtQuantity, txtComment, txtDeliveryDate, txtPassword, txtName, txtAddress, txtContact;
    protected DropDownList drpEquipment;
    private string subProcessId, positionId, subPositionId, stepId;
    protected Button btnDo;
    protected System.Web.UI.UserControl newStep;
    protected DropDownList drpHour, drpMinute, drpAP,drpApprover;
    protected ModalPopupExtender MessagePopupExtender;

    protected  override void Page_Load(object sender, EventArgs e)
    {
      DateTime toDay;
      string response;
      base.Page_Load(sender, e);

      if (!IsPostBack)
      {
        stepId = Request.QueryString["step"];
        lblUom.Text = Session["uom"].ToString();
        txtQuantity.Text = Request.QueryString["quantity"];

        toDay = DateTime.Now;
        txtDeliveryDate.Text = toDay.ToShortDateString();
        for (int i = 0; i < 13; i++)
        {
          drpHour.Items.Add(i.ToString().PadLeft(2, '0'));
        }
        drpHour.SelectedValue = string.Format("{0:00}", (toDay.Hour<13?toDay.Hour:toDay.Hour%12));

        for (int i = 0; i < 60; i++)
        {
          drpMinute.Items.Add(i.ToString().PadLeft(2, '0'));
        }
        drpMinute.SelectedValue = toDay.Minute.ToString().PadLeft(2, '0');

        drpAP.SelectedValue = toDay.Hour < 12 ? "AM" : "PM";

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "SELECT comment, 1 FROM lot_status WHERE id = " + Session["lot_id"].ToString();
          ezCmd.CommandType = CommandType.Text;
          txtComment.Text = ezCmd.ExecuteScalar().ToString();

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
                lblUom.Visible = false;
                newStep.Visible = false;
                txtQuantity.Visible = false;
                txtComment.Visible = false;
                lblEquipment.Visible = false;
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
              }
            }
          }

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
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }

    protected void btnDo_Click(object sender, EventArgs e)
    {
      string response, lotStatus;
      lblError.Text = "";
      try
      {
        ConnectToDb();

        ezCmd = new EzSqlCommand();

        ezCmd.Connection = ezConn;

        ezCmd.CommandText = "deliver_lot";
        ezCmd.CommandType = CommandType.StoredProcedure;
        ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Session["lot_id"]));
        ezCmd.Parameters.AddWithValue("@_lot_alias", Session["lot_alias"].ToString());
        ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
        ezCmd.Parameters.AddWithValue("@_quantity", txtQuantity.Text.Trim());
        
        if (txtDeliveryDate.Text.Trim().Length>0)
        {
        string[] strAry= txtDeliveryDate.Text.Split(new char[]{'/'} );
        string deliverTime = strAry[2]+"-"+strAry[0]+"-"+strAry[1]+" ";
          if (drpAP.SelectedValue.Equals("PM") && (!drpHour.SelectedValue.Equals("12")))
            deliverTime=deliverTime + (Convert.ToInt32(drpHour.SelectedValue)+12)+":"+drpMinute.SelectedValue;
          else
            deliverTime=deliverTime + drpHour.SelectedValue+":"+  drpMinute.SelectedValue;
        ezCmd.Parameters.AddWithValue("@_deliver_datetime",deliverTime);
        }
        else
ezCmd.Parameters.AddWithValue("@_deliver_datetime", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_approver_id", drpApprover.SelectedValue);
        ezCmd.Parameters.AddWithValue("@_approver_password", txtPassword.Text);
        ezCmd.Parameters.AddWithValue("@_delivery_address", txtAddress.Text);
        ezCmd.Parameters.AddWithValue("@_recipient", txtName.Text);
        ezCmd.Parameters.AddWithValue("@_recipient_contact", txtContact.Text);
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
        response = ezCmd.Parameters["@_response"].Value.ToString();
        if (response.Length > 0)
          lblError.Text = response;
        else
        {
          lotStatus = ezCmd.Parameters["@_lot_status"].Value.ToString();
          Session["lot_status"] = lotStatus;
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
    protected void btnListForm_Click(object sender, EventArgs e)
    {
      MessagePopupExtender.Hide();
      Response.Redirect("MoveLot.aspx");
    }
  }
}
