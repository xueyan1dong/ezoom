using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using AjaxControlToolkit;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb
{
    
    public partial class ConfigTemplate : System.Web.UI.Page
    {
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
                //ezType = DbConnectionType.MySql;
              ezType = DbConnectionType.MySqlADO;
            }
            else
                ezType = DbConnectionType.Unknown;

            if (ezConn == null)
                ezConn = new EzSqlConnection(ezType, connStr);
            if (ezConn.State != ConnectionState.Open)
                ezConn.Open();
        }
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
            else if (name.IndexOf("cbx") == 0)
            {
              string param = "@_" + theItem.Value;
              DataColumn _dc = fTemp._dccol[theItem.Value];
              if (_dc != null)
              {
                CheckBox cbxTemp = (CheckBox)FormView1.Row.FindControl(name);
              if (cbxTemp.Checked)
                ezCmd.Parameters.AddWithValue(param, "1");
              else
                ezCmd.Parameters.AddWithValue(param, "0");
              }

            }
          }
        }
        protected virtual void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Server.Transfer("/Default.aspx");
            else
            {
                //Label tLabel = (Label)Page.Master.FindControl("lblName");
                //if (!tLabel.Text.StartsWith("Welcome"))
                //    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
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
            //mdlPopup.Hide();
        }
        protected void btnCancelUpdate_Click(object sender, EventArgs e)
        {
            lblErrorUpdate.Text = "";
        }
        protected virtual void btnSubmitUpdate_Click(object sender, EventArgs args)
        {
        }
    }
}
