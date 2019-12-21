/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : ConfigOrganization.aspx.cs
*    Created By             : Shelby Simpson
*    Date Created           : 12/4/2019
*    Platform Dependencies  : .NET 
*    Description            : This file contains the definition of the ConfigOrganization class.  
*    Log                    :
----------------------------------------------------------------*/

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
    public partial class ConfigOrganization : TabConfigTemplate
    {
        protected global::System.Web.UI.WebControls.SqlDataSource sdsOrgConfig, sdsOrgConfigGrid;
        public DataColumnCollection colc;
        protected Label lblError;
        protected GridView gvTable1;
        protected Label lblActiveTab;
        protected Button btnNewOrganization1, btnNewOrganization2;
        protected Dictionary<string, string> dict;
        protected string serializedDict;
        protected string query;
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            {
                /*if (!IsPostBack && !IsCallback) // Only run the following code when the page is first initialized
                {
                    DataView dv = (DataView)sdsOrgConfigGrid.Select(DataSourceSelectArguments.Empty);
                    colc = dv.Table.Columns;

                    //Initial insert template
                    this.fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"HostOrganization_insert.xml"));

                    //Initial Edit template
                    this.fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"HostOrganization_modify.xml"));
                }*/

                if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                    fvUpdate.DataSourceID = "sdsOrgConfig1";
                //Event happens before the select index changed clicked.
                //gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanged);
                serializedDict = "";
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
            //if (!lblActiveTab.Text.Equals("")) show_activeTab();
            show_activeTab();
            AddJSFunction();
            this.dict = new Dictionary<string, string>();
            GetRootCompanyIDs();
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

            AddJSFunction();
        }

        // Hide the popup modal when cancel is clicked.
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            btnUpdate_ModalPopupExtender.Hide();
        }

        // Called when submit button is clicked on popup modal for either insertion or modification.
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string response;

                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand
                    {
                        Connection = ezConn,
                        CommandText = "modify_organization",
                        CommandType = CommandType.StoredProcedure
                    };
                    ezMES.ITemplate.FormattedTemplate fTemp;


                    if (fvUpdate.CurrentMode == FormViewMode.Insert)
                    {
                        // No id exists yet for the new organization being created. Id creation is handled by the DBMS
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
                    }


                    LoadSqlParasFromTemplate(ezCmd, fvUpdate, fTemp);

                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();

                    ezCmd.Dispose();
                    ezConn.Dispose();

                    // This should pop up when a response is returned but isn't
                    if (response.Length > 0)
                    {
                        lblError.Text = response;
                        btnUpdate_ModalPopupExtender.Show();
                    }
                    else
                    {
                        lblError.Text = "";
                        fvUpdate.Visible = false;
                        btnUpdate_ModalPopupExtender.Hide();

                        if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                        {
                            ScriptManager.GetCurrent(this).RegisterDataItem(
                                // The control I want to send data to
                                gvTable1,
                                //  The data I want to send it (the row that was edited)
                                gvTable1.SelectedIndex.ToString()
                            );

                            gvTable1.DataBind();
                            gvTablePanel.Update();
                        }
                        else
                        {
                            //  add the css class for our yellow fade
                            ScriptManager.GetCurrent(this).RegisterDataItem(
                                // The control I want to send data to
                                gvTable,
                                //  The data I want to send it (the row that was edited)
                                gvTable.SelectedIndex.ToString()
                            );

                            gvTable.DataBind();
                            gvTablePanel.Update();
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                }
            }

        }

        protected void btn_Click(object sender, EventArgs e)
        {
            //  set it to true so it will render
            fvUpdate.Visible = true;
            fvUpdate.ChangeMode(FormViewMode.Insert);
            //  force databinding
            fvUpdate.DataBind();
            AddJSFunction(true);
            //  update the contents in the detail panel
            updateBufferPanel.Update();
            //  show the modal popup
            btnUpdate_ModalPopupExtender.Show();
        }


        protected void TabContainer_ActiveTabChanged(object sender, EventArgs e)
        {

            //tcMain.ActiveTabIndex = Convert.ToInt16(activeTab);
            lblActiveTab.Text = tcMain.ActiveTabIndex.ToString();
            show_activeTab();
            //fvMain.Visible = false;
            //Server.Transfer(string.Format("/Configure/Order/SalesOrderConfig.aspx?Tab={0}", tcMain.ActiveTabIndex));
        }

        protected void tcMain_Load(object sender, EventArgs e)
        {

        }

        protected void show_activeTab()
        {
            //AjaxControlToolkit.TabPanel activeTab = tcMain.ActiveTab;

            //if (activeTab == Tp1)
            DataView dv = (DataView)sdsOrgConfigGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            lblActiveTab.Text = tcMain.ActiveTabIndex.ToString();
            if (Convert.ToInt32(lblActiveTab.Text) == 1)
            {
                btnNewOrganization2.Style["display"] = "";
                btnNewOrganization1.Style["display"] = "none";
                // Show client organizations when Client Organizations is clicked
                sdsOrgConfigGrid.SelectCommand = "SELECT o.id, o.name, o.status, concat(e.firstname,' ',e.lastname) as lead_employee, o.phone, o.email, o.description, c.name as root_company, o1.name as parent_organization, o.root_org_type FROM Organization o LEFT JOIN Employee e ON e.id = o.lead_employee LEFT JOIN Organization o1 ON o1.id = o.parent_organization LEFT JOIN Client c ON c.id = o.root_company WHERE o.root_org_type = 'client' ";
                gvTable.Caption = "Client Organizations";

                
                //Initial insert template  
                fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"ClientOrganization_insert.xml"));

                //Initial Edit template           
                fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"ClientOrganization_modify.xml"));

                query = "SELECT id, root_company FROM organization WHERE root_org_type = 'client';";
            }
            else // Host Organization is the default tab
            {
                // first tab i selected
                btnNewOrganization1.Style["display"] = "";
                btnNewOrganization2.Style["display"] = "none";
                // Show host organizations when Host Organizations tab is clicked
                sdsOrgConfigGrid.SelectCommand = "SELECT o.id, o.name, o.status, concat(e.firstname,' ',e.lastname) as lead_employee, o.phone, o.email, o.description, c.name as root_company, o1.name as parent_organization, o.root_org_type FROM Organization o LEFT JOIN Employee e ON e.id = o.lead_employee LEFT JOIN Organization o1 ON o1.id = o.parent_organization LEFT JOIN Company c ON c.id = o.root_company WHERE o.root_org_type = 'host' ";
                gvTable.Caption = "Host Organizations";
                //Initial insert template  
                fvUpdate.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"HostOrganization_insert.xml"));
                
                //Initial Edit template           
                fvUpdate.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"HostOrganization_modify.xml"));

                query = "SELECT id, root_company FROM organization WHERE root_org_type = 'host';";
            }

            //Update the GridView
            fvUpdate.DataBind();
            sdsOrgConfigGrid.DataBind();
            gvTable.DataBind();
            tcMain.DataBind();
        }

        // Adds an onchange event to the Root Company dropdown that calls a JS function to dynamically generate
        // the parent organizations under that root company.
        protected void AddJSFunction(bool insert = false)
        {
            // Get copy of drproot_company DropDownList
            DropDownList lst = (DropDownList)(fvUpdate.Row.Controls[0].Controls[0].Controls[7].Controls[1].Controls[0]);
            // Remove the original DropDownList
            fvUpdate.Row.Controls[0].Controls[0].Controls[7].Controls[1].Controls.RemoveAt(0);
            // Add the onchange event to the copy
            lst.Attributes.Add("onfocus","generateParentOrganizations()");
            // Add the new DropDownList into the same position as the original
            fvUpdate.Row.Controls[0].Controls[0].Controls[7].Controls[1].Controls.Add(lst);

            lst = (DropDownList)(fvUpdate.Row.Controls[0].Controls[0].Controls[1].Controls[1].Controls[0]);
            fvUpdate.Row.Controls[0].Controls[0].Controls[1].Controls[1].Controls.RemoveAt(0);
            if (insert)
            {
                lst.SelectedValue = "active";
            }
            lst.Attributes.Add("onfocus", "orderStatusDropdown()");
            fvUpdate.Row.Controls[0].Controls[0].Controls[1].Controls[1].Controls.Add(lst);
        }

        // Creates JSON serialized dictionary of parent organizations and their root_company ids.
        protected void GetRootCompanyIDs()
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