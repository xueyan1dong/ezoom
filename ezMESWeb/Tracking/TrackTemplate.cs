/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : TrackTemplate.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 
*    Description            : Basic features for tracking
*    Log                    :
*    6/1/2018: sdong: added disassemble to the GoNextStep adn GoEndStep to handle moving a new step type: disassemble
*   
*
----------------------------------------------------------------*/
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using AjaxControlToolkit;
using CommonLib.Data.EzSqlClient;


namespace ezMESWeb.Tracking
{
  public class TrackTemplate : System.Web.UI.Page
  {
    protected Label lblError;
    protected System.Data.Common.DbDataReader ezReader;
    protected DbConnectionType ezType;
    protected EzSqlConnection ezConn;
    protected EzSqlCommand ezCmd;



       protected global::System.Web.UI.WebControls.SqlDataSource sdsUpdate;
       protected global::System.Web.UI.WebControls.SqlDataSource sdsGrid;
       protected global::System.Web.UI.WebControls.GridView gvTable;

       protected FormView FormView1;
       protected global::System.Web.UI.WebControls.Button btnInsert;
       protected ModalPopupExtender mdlPopup;
       protected ModalPopupExtender ModalPopupExtender;
        
       protected UpdatePanel updateRecordPanel;
        protected UpdatePanel gvTablePanel;
         protected Panel RecordPanel;
        protected Label lblErrorInsert, lblErrorUpdate;
        protected Label lblName;
        //protected Label lblErrorUpdate;

  
        protected void LoadSqlParasFromTemplate(EzSqlCommand ezCmd, ezMES.ITemplate.FormattedTemplate fTemp)
        {
          ezMES.ITemplate.FieldItem theItem;  
          string name, value;
          for (int i = 0; i < fTemp.Fields.Count; i++)  
          {

            theItem = (ezMES.ITemplate.FieldItem)fTemp.Fields[i];

            if (!theItem.AutoCollect)
              continue;

            name = theItem.Key; 
            if (name.IndexOf("drp") == 0) //dropdown list
            {
              DropDownList lst = (DropDownList)FormView1.Row.FindControl(name);

              string param = "@_" + theItem.Value;
              value = ((DropDownList)FormView1.Row.FindControl(name)).SelectedItem.Value;
              if (value.Length > 0)
                ezCmd.Parameters.AddWithValue(param, value);
              else
                ezCmd.Parameters.AddWithValue(param, DBNull.Value);
            }
            else if (name.IndexOf("txt") == 0) //text box
            {
              string param = "@_" + theItem.Value;
              DataColumn _dc = fTemp._dccol[theItem.Value];

              String txtValue = ((TextBox)FormView1.Row.FindControl(name)).Text;
              if (txtValue != null && txtValue.Length > 0)
              {
                switch (_dc.DataType.ToString())
                {
                  case "System.String":
                    ezCmd.Parameters.AddWithValue(param, txtValue);
                    break;
                  case "System.UInt32":
                    ezCmd.Parameters.AddWithValue(param, Convert.ToInt32(txtValue));
                    break;
                  case "System.Int16":
                  case "System.Int32":
                  case "System.Int64":
                  case "int":
                    ezCmd.Parameters.AddWithValue(param, Convert.ToInt64(txtValue));
                    break;
                  case "System.Decimal":
                    ezCmd.Parameters.AddWithValue(param, txtValue);
                    break;
                  case "System.DateTime":
                    ezCmd.Parameters.AddWithValue(param, Convert.ToDateTime(txtValue));
                    break;
                  default:
                    ezCmd.Parameters.AddWithValue(param, txtValue);
                    break;

                }
              }
              else
                ezCmd.Parameters.AddWithValue(param, DBNull.Value);

            }
            else if (name.IndexOf("rbl") == 0) //radio button
            {
              string param = "@_" + theItem.Value;
              DataColumn _dc = fTemp._dccol[theItem.Value];
              if (Convert.ToBoolean(((RadioButtonList)FormView1.Row.FindControl(name)).SelectedValue))
                ezCmd.Parameters.AddWithValue(param, "1");
              else
                ezCmd.Parameters.AddWithValue(param, "0");
            }
            else // not used in this form
            { }
          }
        }
        protected virtual void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("/Default.aspx");
            else
            {
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
            }
        }

        protected virtual void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
          //if (FormView1.CurrentMode != FormViewMode.Edit)
          //  FormView1.ChangeMode(FormViewMode.Edit);
            //  set it to true so it will render
           this.FormView1.Visible = true;
            //  force databinding
           this.FormView1.DataBind();
            //  update the contents in the detail panel
           this.updateRecordPanel.Update();
            //  show the modal popup
           this.ModalPopupExtender.Show();
        }

  


        protected void fvUpdate_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            gvTable.DataBind();
            this.gvTablePanel.Update();
        }



        protected void gvTable_PageIndexChanged(object sender, EventArgs e)
        {
            gvTable.SelectedIndex = -1;
        }
        protected virtual void btnSubmitInsert_Click(object sender, EventArgs e)
        {
        }
        protected virtual void btnCancelInsert_Click(object sender, EventArgs e)
        {
            lblErrorInsert.Text = "";
            mdlPopup.Hide();
        }
        protected void btnCancelUpdate_Click(object sender, EventArgs e)
        {
            lblErrorUpdate.Text = "";
        }
        protected virtual void btnSubmitUpdate_Click(object sender, EventArgs args)
        {
        }
    
    protected void ConnectToDb() //does not handle exception here
    {
       string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
       string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
       DbConnectionType ezType;

       if (dbConnKey.Equals("ODBC"))
       {
          ezType = DbConnectionType.MySqlODBC;

       }
       else if (dbConnKey.Equals("MySql"))
       {
          ezType = DbConnectionType.MySqlADO;

       }
       else
          ezType = DbConnectionType.Unknown;

       if (ezConn == null)
          ezConn = new EzSqlConnection(ezType, connStr);
       if (ezConn.State != ConnectionState.Open)
          ezConn.Open();
    }

    //use last step information to find next step 
    // and go to the tracking form of next step
    protected void GoNextStep(string lotId, 
                                string lotAlias, 
                                string lotStatus, 
                                string stepStatus,
                                string processId,
                                string lastSubProcessId,
                                string lastPositionId,
                                string lastSubPositionId,
                                string lastStepId,
                                string lastResult,
                                string quantity)
    {
      string stepType;
      string response;

      try
      {
        //ConnectToDb();

        //ezCmd = new EzSqlCommand();
        //ezCmd.Connection = ezConn;
        ezCmd.Parameters.Clear();
        ezCmd.CommandText = "get_next_step_for_lot";
        ezCmd.CommandType = CommandType.StoredProcedure;

        
        ezCmd.Parameters.AddWithValue("@_lot_id", lotId);
        ezCmd.Parameters.AddWithValue("@_lot_alias", lotAlias);
        ezCmd.Parameters.AddWithValue("@_lot_status", lotStatus);
        ezCmd.Parameters.AddWithValue("@_process_id", processId);
        if ((lastSubProcessId == null) || (lastSubProcessId.Length == 0))
          ezCmd.Parameters.AddWithValue("@_sub_process_id_p", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_sub_process_id_p", lastSubProcessId);

        ezCmd.Parameters.AddWithValue("@_position_id_p", lastPositionId);
        if ((lastSubPositionId == null) || (lastSubPositionId.Length == 0))
          ezCmd.Parameters.AddWithValue("@_sub_position_id_p", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_sub_position_id_p", lastSubPositionId);

        if ((lastStepId == null) || (lastStepId.Length == 0))
          ezCmd.Parameters.AddWithValue("@_step_id_p", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_step_id_p", lastStepId);

        if ((lastResult == null) || (lastResult.Length == 0))
          ezCmd.Parameters.AddWithValue("@_result", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_result", lastResult);

        ezCmd.Parameters.AddWithValue("@_sub_process_id_n", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_position_id_n", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_sub_position_id_n", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_step_id_n", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_step_type", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_rework_limit", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_if_autostart", DBNull.Value, ParameterDirection.Output);
        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

        ezCmd.ExecuteNonQuery();
        stepType = ezCmd.Parameters["@_step_type"].Value.ToString();

        response = ezCmd.Parameters["@_response"].Value.ToString();
        if (response.Length > 0)
          lblError.Text = response;
        else
        {

          object result;
          System.Text.ASCIIEncoding asi;
          string subProcessId, position, subPosition, step, reworkLimit;
          result = ezCmd.Parameters["@_sub_process_id_n"].Value;
          if (result.GetType().ToString().Contains("System.Byte"))
          {
            asi = new System.Text.ASCIIEncoding();
            subProcessId = asi.GetString((byte[])result);
          }
          else
            subProcessId = result.ToString();

          result = ezCmd.Parameters["@_position_id_n"].Value;
          if (result.GetType().ToString().Contains("System.Byte"))
          {
            asi = new System.Text.ASCIIEncoding();
            position = asi.GetString((byte[])result);
          }
          else
            position = result.ToString();

          result = ezCmd.Parameters["@_sub_position_id_n"].Value;
          if (result.GetType().ToString().Contains("System.Byte"))
          {
            asi = new System.Text.ASCIIEncoding();
            subPosition = asi.GetString((byte[])result);
          }
          else
            subPosition = result.ToString();

          result = ezCmd.Parameters["@_step_id_n"].Value;
          if (result.GetType().ToString().Contains("System.Byte"))
          {
            asi = new System.Text.ASCIIEncoding();
            step = asi.GetString((byte[])result);
          }
          else
            step = result.ToString();

          result = ezCmd.Parameters["@_rework_limit"].Value;
          if (result.GetType().ToString().Contains("System.Byte"))
          {
            asi = new System.Text.ASCIIEncoding();
            reworkLimit = asi.GetString((byte[])result);
          }
          else
            reworkLimit = result.ToString();

          switch (stepType)
          {
            case "consume material":
            Response.Redirect("StartConsumeMaterial.aspx?step_status=" + stepStatus +
              "&sub_process=" + subProcessId
              + "&position=" + position
              + "&sub_position=" + subPosition
              + "&step=" + step
              + "&quantity=" + quantity
              + "&rework_limit=" + reworkLimit
              + "&step_type=" + stepType);
            break;
            case "disassemble":
            Response.Redirect("StartConsumeMaterial.aspx?step_status=" + stepStatus +
                "&sub_process=" + subProcessId
                + "&position=" + position
                + "&sub_position=" + subPosition
                + "&step=" + step
                + "&quantity=" + quantity
                + "&rework_limit=" + reworkLimit
                + "&step_type=" + stepType);
            break;
            case "display message":
            Response.Redirect("PassDisplayStep.aspx?step_status=" + stepStatus +
              "&sub_process=" + subProcessId
              + "&position=" + position
              + "&sub_position=" + subPosition
              + "&step=" + step
              + "&quantity=" + quantity);
            break;
            case "deliver to customer":
            Response.Redirect("CustomerDeliver.aspx?step_status=" + stepStatus +
              "&sub_process=" + subProcessId
              + "&position=" + position
              + "&sub_position=" + subPosition
              + "&step=" + step
              + "&quantity=" + quantity);

            break;
            case "condition":
              Response.Redirect("StartConsumeMaterial.aspx?step_status=" + stepStatus +
                "&sub_process=" + subProcessId
                + "&position=" + position
                + "&sub_position=" + subPosition
                + "&step=" + step
                + "&quantity=" + quantity
                + "&rework_limit=" + reworkLimit
                + "&step_type=" + stepType);
              break;
            case "reposition":
              Response.Redirect("Reposition.aspx?step_status=" + stepStatus 
                + "&sub_process=" + subProcessId
                + "&position=" + position
                + "&sub_position=" + subPosition
                + "&step=" + step
                + "&quantity=" + quantity
                + "&rework_limit=" + reworkLimit
                +  "&step_type=" + stepType);
              break;
            case "ship to warehouse":
              //Response.Redirect("StartConsumeMaterial.aspx?step_status=" + stepStatus +
              //   "&sub_process=" + subProcessId
              //   + "&position=" + position
              //   + "&sub_position=" + subPosition
              //   + "&step=" + step
              //   + "&quantity=" + quantity
              //   + "&rework_limit=" + reworkLimit
              //   + "&step_type=" + stepType);
              Response.Redirect("ToWarehouseStep.aspx?step_status=" + stepStatus +
                "&sub_process=" + subProcessId
                + "&position=" + position
                + "&sub_position=" + subPosition
                + "&step=" + step
                + "&quantity=" + quantity
                + "&rework_limit=" + reworkLimit
                + "&step_type=" + stepType);
              break;
            case "scrap":
              Response.Redirect("UnholdLot.aspx?step_status=" + stepStatus
                + "&sub_process=" + subProcessId
                + "&position=" + position
                + "&sub_position=" + subPosition
                + "&step=" + step
                + "&quantity=" + quantity
                + "&equipment=&step_type=" + stepType);
              break;
          }
        }
      }
      catch (Exception ex)
      {
        lblError.Text = ex.Message;
      }
      //ezCmd.Dispose();
      //ezConn.Dispose();
    }
    protected void GoEndStep(
                        string lotId, 
                        string lotAlias, 
                        string lotStatus, 
                        string startTime,
                        string stepStatus,
                        string processId,
                        string subProcessId,
                        string positionId,
                        string subPositionId,
                        string stepId,
                        string result,
                        string quantity,
                        string equipmentId
                                
                        )
    {
      string stepType;


      try
      {
        //ConnectToDb();

        //ezCmd = new EzSqlCommand();
        //ezCmd.Connection = ezConn;

        if (lblError.Text.Length == 0)
        {
          ezCmd.Parameters.Clear();
          ezCmd.CommandText = "SELECT st.name FROM step s, step_type st WHERE s.id='" + stepId
                        + "' AND st.id = s.step_type_id ";
          ezCmd.CommandType = CommandType.Text;

          stepType = ezCmd.ExecuteScalar().ToString();
          switch (stepType)
          {
            case "consume material":
            case "condition":
              Response.Redirect("EndConsumeMaterial.aspx?step_status=" + stepStatus +
                "&start_time=" + startTime
                + "&sub_process=" + subProcessId
                + "&position=" + positionId
                + "&sub_position=" + subPositionId
                + "&step=" + stepId
                + "&quantity=" + quantity
                + "&equipment=" + equipmentId+"&step_type="+stepType);
              break;
            case "disassemble":
              Response.Redirect("EndDisassemble.aspx?step_status=" + stepStatus +
                "&start_time=" + startTime
                + "&sub_process=" + subProcessId
                + "&position=" + positionId
                + "&sub_position=" + subPositionId
                + "&step=" + stepId
                + "&quantity=" + quantity
                + "&equipment=" + equipmentId + "&step_type=" + stepType);
              break;

            case "hold lot":
              Response.Redirect("UnholdLot.aspx?step_status=" + stepStatus +
                "&start_time=" + startTime
                + "&sub_process=" + subProcessId
                + "&position=" + positionId
                + "&sub_position=" + subPositionId
                + "&step=" + stepId
                + "&quantity=" + quantity
                + "&equipment=" + equipmentId + "&step_type=" + stepType);
              break;
          
          }
          

        }
        return;
      }
      catch (Exception ex)
      {
        lblError.Text = "Error when going to End Form:" + ex.Message;
      }
      //ezCmd.Dispose();
      //ezConn.Dispose();
    }
  }
}