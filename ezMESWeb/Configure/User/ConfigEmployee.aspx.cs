using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb.Configure.User
{
   public partial class ConfigEmployee : TabConfigTemplate
   {
        protected global::System.Web.UI.WebControls.SqlDataSource sdsEmpConfig, sdsEmpConfigGrid;
        public DataColumnCollection colc;
        protected Label lblError;
        protected GridView gvTable1;
        protected Label lblActiveTab;
        protected Button btnNewUser1, btnNewUser2;
        protected Dictionary<string, string> dict;
        protected string serializedDict;
        protected string query;
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            {
                /*DataView dv = (DataView)sdsEmpConfigGrid.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;

                //Initial insert template  
                fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Employee_insert.xml"));

                //Initial Edit template           
                fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Employee_modify.xml"));
               if (Session["Role"]!=null && !Session["Role"].ToString().Equals("Admin"))
                    fvUpdate.DataSourceID = "sdsEmpConfig1";
                //Event happens before the select index changed clicked.
                gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
                */
            }
        }

        protected override void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            /*if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
            {
                for (int i = 0; i < gvTable1.Rows.Count; i++)
                {
                if (gvTable1.Rows[i].Cells[2].Text.Equals("removed"))
                    gvTable1.Rows[i].Enabled = false;
                }
            };*/

            show_activeTab();
            if (!IsPostBack)
                AddJSFunctions(true);
            this.dict = new Dictionary<string, string>();
            GetOrganizationIDs();
        }
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            //modify the mode of form view
            fvUpdate.ChangeMode(FormViewMode.Edit);

            //  set it to true so it will render
            fvUpdate.Visible = true;
            //  force databinding
            fvUpdate.DataBind();
            //  update the contents in the detail panel
            updateBufferPanel.Update();
            //  show the modal popup
            btnUpdate_ModalPopupExtender.Show();

            AddJSFunctions();
        }



        protected void btnCancel_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            btnUpdate_ModalPopupExtender.Hide();
        }

      protected void btnSubmit_Click(object sender, EventArgs e)
      {
         if (Page.IsValid)
         {
            string response;

            try
            {
              ConnectToDb();
              ezCmd = new EzSqlCommand();
              ezCmd.Connection = ezConn;
              ezCmd.CommandText = "modify_employee";
              ezCmd.CommandType = CommandType.StoredProcedure;
              ezMES.ITemplate.FormattedTemplate fTemp;


              if (fvUpdate.CurrentMode == FormViewMode.Insert)
              {

                ezCmd.Parameters.AddWithValue("@_id", DBNull.Value, ParameterDirection.InputOutput);

                fTemp = (ezMES.ITemplate.FormattedTemplate)fvUpdate.InsertItemTemplate;
              }
              else
              {
                if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                  ezCmd.Parameters.AddWithValue("@_id", Convert.ToInt32(gvTable1.SelectedPersistedDataKey.Values["id"]), ParameterDirection.InputOutput);
                else
                  ezCmd.Parameters.AddWithValue("@_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Values["id"]), ParameterDirection.InputOutput);
                fTemp = (ezMES.ITemplate.FormattedTemplate)fvUpdate.EditItemTemplate;
                ezCmd.Parameters.AddWithValue("@_username", DBNull.Value);
                ezCmd.Parameters.AddWithValue("@_password", DBNull.Value);
              }


              LoadSqlParasFromTemplate(ezCmd, fvUpdate, fTemp);

              ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
              ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

              ezCmd.ExecuteNonQuery();
              response = ezCmd.Parameters["@_response"].Value.ToString();

              ezCmd.Dispose();
              ezConn.Dispose();

              if (response.Length > 0)
              {
                lblError.Text = response;
                this.btnUpdate_ModalPopupExtender.Show();
              }
              else
              {
                lblError.Text = "";
                this.fvUpdate.Visible = false;
                this.btnUpdate_ModalPopupExtender.Hide();

                if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                {
                  ScriptManager.GetCurrent(this).RegisterDataItem(
                    // The control I want to send data to
                      this.gvTable1,
                    //  The data I want to send it (the row that was edited)
                      this.gvTable1.SelectedIndex.ToString()
                  );

                  gvTable1.DataBind();
                  this.gvTablePanel.Update();
                }
                else
                {
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
            }
            catch (Exception ex)
            {
                //lblError.Text = ex.Message;
                lblError.Text = "An error occurred.";
                this.btnUpdate_ModalPopupExtender.Show();
            }
         }

      }

        protected void btn_Click(object sender, EventArgs e)
        {
            //  set it to true so it will render
            this.fvUpdate.Visible = true;
            fvUpdate.ChangeMode(FormViewMode.Insert);
            //  force databinding
            this.fvUpdate.DataBind();
            AddJSFunctions(true);
            //  update the contents in the detail panel
            this.updateBufferPanel.Update();
            //  show the modal popup
            this.btnUpdate_ModalPopupExtender.Show();
        }

        protected void TabContainer_ActiveTabChanged(object sender, EventArgs e)
        {

            //tcMain.ActiveTabIndex = Convert.ToInt16(activeTab);
            lblActiveTab.Text = tcMain.ActiveTabIndex.ToString();
            show_activeTab();
            //fvMain.Visible = false;
            //Server.Transfer(string.Format("/Configure/Order/SalesOrderConfig.aspx?Tab={0}", tcMain.ActiveTabIndex));
        }

        protected void show_activeTab()
        {
            //AjaxControlToolkit.TabPanel activeTab = tcMain.ActiveTab;

            //if (activeTab == Tp1)
            DataView dv = (DataView)sdsEmpConfigGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            lblActiveTab.Text = tcMain.ActiveTabIndex.ToString();
            if (Convert.ToInt32(lblActiveTab.Text) == 1)
            {
                btnNewUser2.Style["display"] = "";
                btnNewUser1.Style["display"] = "none";
                // Show client organizations when Client Organizations is clicked
                sdsEmpConfigGrid.SelectCommand = "SELECT e.id, e.company_id, e.username, e.password, e.status, e.user_type, e.or_id, o.name as o_name, e.eg_id, eg.name as eg_name, e.firstname, e.lastname, e.middlename, e.email, e.phone, ur.roleId as role_id, sr.name as role, concat(e1.firstname, ' ', e1.lastname) as report_to, e.comment FROM Employee e LEFT JOIN Employee_group eg ON eg.id = e.eg_id LEFT JOIN Organization o ON o.id = e.or_id LEFT JOIN employee e1 ON e1.id = e.report_to LEFT JOIN users_in_roles ur ON ur.userId = e.id LEFT JOIN system_roles sr ON sr.id = ur.roleId WHERE e.user_type = 'client' ";
                gvTable.Caption = "Client User List";


                //Initial insert template  
                fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"ClientEmployee_insert.xml"));

                //Initial Edit template           
                fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"ClientEmployee_modify.xml"));

                query = "SELECT id, or_id FROM employee;";
            }
            else // Host Organization is the default tab
            {
                // first tab i selected
                btnNewUser1.Style["display"] = "";
                btnNewUser2.Style["display"] = "none";
                
                // Show host organizations when Host Organizations tab is clicked
                sdsEmpConfigGrid.SelectCommand = "SELECT e.id, e.company_id, e.username, e.password, e.status, e.user_type, e.or_id, o.name as o_name, e.eg_id, eg.name as eg_name, e.firstname, e.lastname, e.middlename, e.email, e.phone, ur.roleId as role_id, sr.name as role, concat(e1.firstname, ' ', e1.lastname) as report_to, e.comment FROM Employee e LEFT JOIN Employee_group eg ON eg.id = e.eg_id LEFT JOIN Organization o ON o.id = e.or_id LEFT JOIN employee e1 ON e1.id = e.report_to LEFT JOIN users_in_roles ur ON ur.userId = e.id LEFT JOIN system_roles sr ON sr.id = ur.roleId WHERE e.user_type = 'host' ";
                gvTable.Caption = "Host User List";
                //Initial insert template  
                fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"HostEmployee_insert.xml"));

                //Initial Edit template           
                fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"HostEmployee_modify.xml"));

                query = "SELECT id, or_id FROM employee;";
            }

            //Update the GridView
            fvUpdate.DataBind();
            sdsEmpConfigGrid.DataBind();
            gvTable.DataBind();
            tcMain.DataBind();
        }

        protected void AddJSFunctions(bool insert = false)
        {
            int index = 1;
            if (insert)
                index = 2;

            // Get copy of drproot_company DropDownList
            DropDownList lst = (DropDownList)(fvUpdate.Row.Controls[0].Controls[0].Controls[index+10].Controls[1].Controls[0]);
            // Remove the original DropDownList
            fvUpdate.Row.Controls[0].Controls[0].Controls[index + 10].Controls[1].Controls.RemoveAt(0);
            // Add the onchange event to the copy
            lst.Attributes.Add("onfocus", "generateReportToEmployees()");
            // Add the new DropDownList into the same position as the original
            fvUpdate.Row.Controls[0].Controls[0].Controls[index + 10].Controls[1].Controls.Add(lst);

            lst = (DropDownList)(fvUpdate.Row.Controls[0].Controls[0].Controls[index].Controls[1].Controls[0]);
            fvUpdate.Row.Controls[0].Controls[0].Controls[index].Controls[1].Controls.RemoveAt(0);
            if (insert)
            {
                lst.SelectedValue = "active";
            }
            lst.Attributes.Add("onfocus", "orderStatusDropdown()");
            fvUpdate.Row.Controls[0].Controls[0].Controls[index].Controls[1].Controls.Add(lst);

            // Enforce constraint where organization dropdown depends on selection of user_type.
            /*lst = (DropDownList)(fvUpdate.Row.Controls[0].Controls[0].Controls[index+2].Controls[1].Controls[0]);
            fvUpdate.Row.Controls[0].Controls[0].Controls[index+2].Controls[1].Controls.RemoveAt(0);
            lst.Attributes.Add("onfocus", "orderOrganizationDropdown()");
            fvUpdate.Row.Controls[0].Controls[0].Controls[index+2].Controls[1].Controls.Add(lst);*/
        }

        // Creates JSON serialized dictionary of parent organizations and their root_company ids.
        protected void GetOrganizationIDs()
        {
            ConnectToDb();
            ezCmd = new EzSqlCommand
            {
                Connection = ezConn,
                CommandText = query,
                CommandType = CommandType.Text
            };
            ezDataAdapter ezAdapter = new ezDataAdapter();
            DataSet ds;
            ds = new DataSet();
            ezAdapter.SelectCommand = ezCmd;
            ezAdapter.Fill(ds);
            // Place returned root_company ids into a dictionary indexed on parent organization ids.
            DataRowCollection rows = ds.Tables[0].Rows;
            IEnumerator rowEnumerator = rows.GetEnumerator();
            dict = new Dictionary<string, string>();
            while (rowEnumerator.MoveNext())
            {
                DataRow row = (DataRow)(rowEnumerator.Current);
                dict[row.ItemArray.GetValue(0).ToString()] = row.ItemArray.GetValue(1).ToString();
            }
            var serializer = new JavaScriptSerializer();
            serializedDict = serializer.Serialize(dict);

        }
    }
}
