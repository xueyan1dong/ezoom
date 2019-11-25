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

namespace ezMESWeb.Configure.User
{
    public partial class ConfigOrganization : ConfigTemplate
    {
        protected global::System.Web.UI.WebControls.SqlDataSource sdsOrgConfig, sdsOrgConfigGrid;
        public DataColumnCollection colc;
        protected Label lblError;
        protected GridView gvTable1;
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            {
                DataView dv = (DataView)sdsOrgConfigGrid.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;

                //Initial insert template  
                FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"HostOrganization_insert.xml"));

                //Initial Edit template           
                FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"HostOrganization_modify.xml"));
                if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                    FormView1.DataSourceID = "sdsOrgConfig1";
                //Event happens before the select index changed clicked.
                gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);

            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
            {
                for (int i = 0; i < gvTable1.Rows.Count; i++)
                {
                    if (gvTable1.Rows[i].Cells[2].Text.Equals("removed"))
                        gvTable1.Rows[i].Enabled = false;
                }
            };
        }

        protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
        {
            //modify the mode of form view
            FormView1.ChangeMode(FormViewMode.Edit);

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            ModalPopupExtender.Hide();
        }

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


                    if (FormView1.CurrentMode == FormViewMode.Insert)
                    {

                        ezCmd.Parameters.AddWithValue("@_id", DBNull.Value, ParameterDirection.InputOutput);

                        fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
                    }
                    else
                    {
                        if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                            ezCmd.Parameters.AddWithValue("@_id", Convert.ToInt32(gvTable1.SelectedPersistedDataKey.Values["id"]), ParameterDirection.InputOutput);
                        else
                            ezCmd.Parameters.AddWithValue("@_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Values["id"]), ParameterDirection.InputOutput);
                        fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
                        ezCmd.Parameters.AddWithValue("@_username", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_password", DBNull.Value);
                    }


                    LoadSqlParasFromTemplate(ezCmd, fTemp);

                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();

                    ezCmd.Dispose();
                    ezConn.Dispose();

                    if (response.Length > 0)
                    {
                        lblError.Text = response;
                        this.ModalPopupExtender.Show();
                    }
                    else
                    {
                        lblError.Text = "";
                        this.FormView1.Visible = false;
                        this.ModalPopupExtender.Hide();

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
                    lblError.Text = ex.Message;
                }
            }

        }

        protected void btn_Click(object sender, EventArgs e)
        {
            //  set it to true so it will render
            this.FormView1.Visible = true;
            FormView1.ChangeMode(FormViewMode.Insert);
            //  force databinding
            this.FormView1.DataBind();
            //  update the contents in the detail panel
            this.updateRecordPanel.Update();
            //  show the modal popup
            this.ModalPopupExtender.Show();
        }
    }
}