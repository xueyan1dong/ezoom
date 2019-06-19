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


namespace ezMESWeb
{
    
    public class TabConfigTemplate : System.Web.UI.Page
    {
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;

        //protected ezDataAdapter ezAdapter;
        protected DbDataReader ezReader;

        protected global::System.Web.UI.WebControls.SqlDataSource sdsUpdate;
        protected global::System.Web.UI.WebControls.SqlDataSource sdsGrid;
        protected global::System.Web.UI.WebControls.GridView gvTable;

        protected FormView fvUpdate;
        protected Button btnInsert;
        protected ModalPopupExtender mdlPopup;
    protected ModalPopupExtender btnUpdate_ModalPopupExtender;
        protected UpdatePanel insertBufferPanel, updateBufferPanel;
        protected UpdatePanel gvTablePanel;
        protected Panel InsertPanel;
        protected Label lblErrorInsert, lblErrorUpdate;
        protected ToolkitScriptManager ToolkitScriptManager1;

        protected FormView fvMain;
        protected Button btnDo, btnCancel;
        protected TabContainer tcMain;
        protected Label lblMainError;
        protected TextBox txtID;
        protected SqlDataSource sdsMain;
        protected UpdatePanel upMain;



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
                ezType = DbConnectionType.MySqlADO;
                
            }
            else
                ezType = DbConnectionType.Unknown;

            if (ezConn == null)
                ezConn = new EzSqlConnection(ezType, connStr);
            if (ezConn.State != ConnectionState.Open)
                ezConn.Open();
        }

        protected virtual void Page_Load(object sender, EventArgs e)
        {
        }

        protected virtual void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            //  set it to true so it will render
            this.fvUpdate.Visible = true;
            //  force databinding
            this.fvUpdate.DataBind();
            //  update the contents in the detail panel
            this.updateBufferPanel.Update();
            //  show the modal popup
            this.btnUpdate_ModalPopupExtender.Show();
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

  }
}
