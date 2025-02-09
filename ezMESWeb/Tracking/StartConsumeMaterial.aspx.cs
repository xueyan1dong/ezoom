/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : StartConsumeMaterial.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET
*    Description            : UI for ending disassemble step
*    Log                    :
*    6/1/2018: xdong: adding code to handle new step type disassemble, which has the same start step UI as ComsumeMaterial
*    7/8/2018: peiyu added DropDownList drpLocation and fed with data from location table.
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

namespace ezMESWeb.Tracking
{
  public partial class StartConsumeMaterial : System.Web.UI.Page
  {
    protected Label lblStep, lblUom, lblError;
    protected TextBox txtQuantity, txtComment;
    protected DropDownList drpEquipment;
    protected DropDownList drpLocation;
    private string subProcessId, positionId, subPositionId, stepId, stepStatus, stepType;
    protected Button btnDo;
    protected ConsumptionStep newStep;
    protected string locationID;

        protected void Page_Load(object sender, EventArgs e)
    {
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
        newStep.ShowRecipe = true;
        stepId = Request.QueryString["step"];
        //lblUom.Text = Session["uom"].ToString();
        txtQuantity.Text = Request.QueryString["quantity"];
                
        string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
        string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
        DbConnectionType ezType;
        EzSqlConnection ezConn;
        EzSqlCommand ezCmd;
        System.Data.Common.DbDataReader ezReader;

        if (dbConnKey.Equals("ODBC"))
        {
            ezType = DbConnectionType.MySqlODBC;

        }
        else if (dbConnKey.Equals("MySql"))
        {
            //ezType = DbConnectionType.MySql;
            ezType = DbConnectionType.MySqlADO;
        }
        else
            ezType = DbConnectionType.Unknown;

        ezConn = new EzSqlConnection(ezType, connStr);
        ezConn.Open();
        ezCmd = new EzSqlCommand();
        try
        {
            ezCmd.Connection = ezConn;
            //ezCmd.CommandText = "SELECT comment FROM lot_status WHERE id = " + Session["lot_id"].ToString();
            //ezCmd.CommandType = CommandType.Text;
            //txtComment.Text = ezCmd.ExecuteScalar().ToString();

            
            //query location talbe, prepare query statement, get commandtype and get ezReader
            ezCmd.CommandText = "(SELECT null, 'N/A') UNION (SELECT id, name from location)";
            ezCmd.CommandType = CommandType.Text;
            ezReader = ezCmd.ExecuteReader();
            //iterate through ezReader to populate location dropdown list
            while (ezReader.Read())
            {
                drpLocation.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
            }
   
          ezReader.Dispose();

          //ezCmd.CommandText = "SELECT l.name from lot_status s inner join lot_history h on h.lot_id = s.id and h.process_id = s.process_id and h.start_timecode = (select max(h1.start_timecode) from lot_history h1 where h1.lot_id = h.lot_id) and (h.end_timecode is null or (not exists(select * from lot_history h2 where h2.lot_id = h.lot_id and h2.start_timecode = h.start_timecode and h2.end_timecode is null) and h.end_timecode = (select max(h3.end_timecode) from lot_history h3 where h3.lot_id = h.lot_id))) left join location l on l.id = h.location_id where s.status not in ('shipped', 'scrapped') and s.id =" + Request.QueryString["lot_id"];
          // query view view_lot_in_process for most recent location name and uom
          
          ezCmd.CommandText = "SELECT location_id, uom from view_lot_in_process where id = " + Request.QueryString["lot_id"];
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();

          if (ezReader.Read())
          {
              locationID = String.Format("{0}", ezReader[0]);
              lblUom.Text = String.Format("{0}", ezReader[1]);
              drpLocation.SelectedValue = locationID;
              //if (locationID == null) drpLocation.SelectedItem.Text = "N/A";
              //else drpLocation.SelectedValue = locationID;//drpLocation.Items.FindByText(String.Format("{0}", ezReader[0])).Value; //set default value as previous location value= value;   
          }
          ezReader.Dispose();

          ezCmd.CommandText = "SELECT name, eq_usage, eq_id, emp_usage, emp_id  FROM step where id=" + stepId;
          ezCmd.CommandType = CommandType.Text;
          ezReader = ezCmd.ExecuteReader();

          if (ezReader.Read())
          {
            lblStep.Text = String.Format("{0}", ezReader[0]);


            string eqUsage = String.Format("{0}", ezReader[1]);
            string eqId = String.Format("{0}", ezReader[2]);
            string empUsage = String.Format("{0}", ezReader[3]);
            string empId = String.Format("{0}", ezReader[4]);
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
                drpEquipment.Visible = false;
                drpLocation.Visible = false; //[Peiyu 7/15]
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
              }

            }
            if (lblError.Text.Length==0 && eqId.Length > 0)
            {
              if (eqUsage.Equals("equipment group"))
                ezCmd.CommandText = "SELECT id,name FROM equipment WHERE eg_id = " + eqId;
              else
                ezCmd.CommandText = "SELECT id,name FROM equipment WHERE id = " + eqId;

              ezReader = ezCmd.ExecuteReader();

              while (ezReader.Read())
              {
                drpEquipment.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
              }
              ezReader.Dispose();
            }

          }
          else
            ezReader.Dispose();

          ezCmd.Parameters.Clear();
          ezCmd.CommandText = "get_rework_count_for_lot";
          ezCmd.CommandType = CommandType.StoredProcedure;

          ezCmd.Parameters.AddWithValue("@_lot_id", Request.QueryString["lot_id"]);//Session["lot_id"].ToString());
          ezCmd.Parameters.AddWithValue("@_process_id", Request.QueryString["process_id"]);//Session["process_id"].ToString());
                    ezCmd.Parameters.AddWithValue("@_step_id", stepId);
          subProcessId = Request.QueryString["sub_process"];
          if (subProcessId.Length > 0)
            ezCmd.Parameters.AddWithValue("@_sub_process_id", subProcessId);
          else
            ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value);

          positionId = Request.QueryString["position"];
          ezCmd.Parameters.AddWithValue("@_position_id", (positionId.Length > 0) ? positionId : "1");

          subPositionId = Request.QueryString["sub_position"];
          if (subPositionId.Length > 0)
            ezCmd.Parameters.AddWithValue("@_sub_position_id", subPositionId);
          else
            ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value);

          ezCmd.Parameters.AddWithValue("@_rework_count", DBNull.Value, ParameterDirection.Output);
          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

          ezCmd.ExecuteNonQuery();

          string reworkCount = ezCmd.Parameters["@_rework_count"].Value.ToString();
          Int32 reworkLimit = (Request.QueryString["rework_limit"].Length > 0) ? Convert.ToInt32(Request.QueryString["rework_limit"]) : 0;

          if ((reworkCount.Length > 0) && (reworkLimit > 0) && (Convert.ToInt32(reworkCount) >= reworkLimit))
          {
            lblError.Text = "The batch has gone through the step " + reworkCount
              + " time(s), which reach or over the rework limit of "
              + reworkLimit;
          }
          ezCmd.Dispose();
          ezConn.Dispose();
                    
         }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
          ezCmd.Dispose();
          ezConn.Dispose();
        }
                
      }
            

   }

        protected void btnDo_Click(object sender, EventArgs e)
    {
      string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
      string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
      DbConnectionType ezType;
      EzSqlConnection ezConn;
      EzSqlCommand ezCmd;
      //System.Data.Common.DbDataReader ezReader; 

      if (dbConnKey.Equals("ODBC"))
      {
        ezType = DbConnectionType.MySqlODBC;

      }
      else if (dbConnKey.Equals("MySql"))
      {
        //ezType = DbConnectionType.MySql;
        ezType = DbConnectionType.MySqlADO;
      }
      else
        ezType = DbConnectionType.Unknown;


      ezConn = new EzSqlConnection(ezType, connStr);
      ezConn.Open();
      ezCmd = new EzSqlCommand();

      ezCmd.Connection = ezConn;
      try
      {
       
        ezCmd.CommandText = "start_lot_step";
        ezCmd.CommandType = CommandType.StoredProcedure;


        ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]));//Session["lot_id"]));
        ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]);//Session["lot_alias"].ToString());
        ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
        ezCmd.Parameters.AddWithValue("@_check_autostart", 0);
        ezCmd.Parameters.AddWithValue("@_start_quantity", txtQuantity.Text.Trim());
        if (drpEquipment.SelectedValue.Length == 0)
          ezCmd.Parameters.AddWithValue("@_equipment_id", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_equipment_id", drpEquipment.SelectedValue);
        ezCmd.Parameters.AddWithValue("@_device_id", DBNull.Value);
        ezCmd.Parameters.AddWithValue("@_comment", txtComment.Text);
        ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Request.QueryString["process_id"]), ParameterDirection.InputOutput);

        subProcessId = Request.QueryString["sub_process"];
        if(subProcessId.Length > 0)
          ezCmd.Parameters.AddWithValue("@_sub_process_id", subProcessId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value, ParameterDirection.InputOutput);

        positionId = Request.QueryString["position"];
        ezCmd.Parameters.AddWithValue("@_position_id", (positionId.Length > 0) ? positionId : "1", ParameterDirection.InputOutput);

        subPositionId = Request.QueryString["sub_position"];
        if (subPositionId.Length>0)
          ezCmd.Parameters.AddWithValue("@_sub_position_id", subPositionId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value, ParameterDirection.InputOutput);

        stepId = Request.QueryString["step"];

        if(stepId.Length>0)
          ezCmd.Parameters.AddWithValue("@_step_id", stepId, ParameterDirection.InputOutput);
        else
          ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value, ParameterDirection.InputOutput);

        if (drpLocation.SelectedValue.Length > 0)
            ezCmd.Parameters.AddWithValue("@_location_id", drpLocation.SelectedValue, ParameterDirection.InputOutput);
        else
            ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value, ParameterDirection.InputOutput);
        //ezCmd.Parameters.AddWithValue("@_location_id", drpLocation.SelectedValue, ParameterDirection.InputOutput);

        ezCmd.Parameters.AddWithValue("@_lot_status", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_step_status", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_start_timecode", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

    
        ezCmd.ExecuteNonQuery();
        string response = ezCmd.Parameters["@_response"].Value.ToString();
        if (response.Length > 0)
          lblError.Text = response;
        else
        {
          Session["lot_status"] = ezCmd.Parameters["@_lot_status"].Value.ToString(); 
          stepStatus = ezCmd.Parameters["@_step_status"].Value.ToString();
                    
        if (Request.QueryString["step_type"].Equals("disassemble"))
          Server.Transfer("EndDisassemble.aspx?step_status=" + stepStatus
        + "&start_time=" + ezCmd.Parameters["@_start_timecode"].Value.ToString()
        + "&sub_process=" + subProcessId
        + "&position=" + positionId
        + "&sub_position=" + subPositionId
        + "&step=" + stepId
        + "&quantity=" + txtQuantity.Text.Trim()
        + "&equipment=" + drpEquipment.SelectedValue
        + "&step_type=" + Request.QueryString["step_type"]
        + "&lot_id=" + Request.QueryString["lot_id"]
        //+ "&location_id=" + drpLocation.SelectedValue added 8/1/2018
        + "&process_id=" + Request.QueryString["process_id"]
        + "&lot_alias=" + Request.QueryString["lot_alias"]
        + "&lot_status=" + ezCmd.Parameters["@_lot_status"].Value.ToString()
        , true);
        else
            Server.Transfer("EndConsumeMaterial.aspx?step_status=" + stepStatus
      + "&start_time="+ezCmd.Parameters["@_start_timecode"].Value.ToString()
      + "&sub_process=" + subProcessId
      + "&position=" + positionId
      + "&sub_position=" + subPositionId
      + "&step=" + stepId
      + "&quantity=" + txtQuantity.Text.Trim()
      + "&equipment=" + drpEquipment.SelectedValue
      + "&step_type=" + Request.QueryString["step_type"]
      + "&lot_id=" + Request.QueryString["lot_id"]
      + "&process_id=" + Request.QueryString["process_id"]
      + "&lot_alias=" + Request.QueryString["lot_alias"]
      + "&lot_status=" + ezCmd.Parameters["@_lot_status"].Value.ToString()
      //+ "&location_id=" + drpLocation.SelectedValue
      , true);
          ezCmd.Dispose();
          ezConn.Dispose();
        }
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;
        ezCmd.Dispose();
        ezConn.Dispose();
      }
    }
  }
}
