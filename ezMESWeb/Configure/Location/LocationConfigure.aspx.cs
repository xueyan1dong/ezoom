/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : LocationConfigure.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : 
*    Log:
*    02/04/2019: xdong: Adjusted some display factors. Reveal ID and contact employee columns again.
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

namespace ezMESWeb.Configure
{
   public partial class LocationConfigure : ConfigTemplate
   {
        protected global::System.Web.UI.WebControls.SqlDataSource sdsLocGrid;
        public DataColumnCollection cols;
        protected Label lblError, lblError1;
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            {
                DataView dv = (DataView)sdsLocGrid.Select(DataSourceSelectArguments.Empty);
                cols = dv.Table.Columns;
                //initialize insert template
                FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, cols, false, Server.MapPath(@"Location.xml"));
                //initialize edit template
                FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, cols, false, Server.MapPath(@"Location.xml"));
                //Event happens before the select index changed clicked.
                //gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);

            }
        }

        public void btn_Click(Object sender, EventArgs e)
        {
            FormView1.ChangeMode(FormViewMode.Insert);
            //FormView1.Visible = true;
            //FormView1.DataBind();
            ModalPopupExtender.Show();
        }

        protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
        {
            //modify the mode of form view
            FormView1.ChangeMode(FormViewMode.Edit);
            //FormView1.Caption = "Copy An Inventory";
            FormView1.DataBind();
        }

        public void btnSubmit_Click(Object sender, EventArgs e)
        {
            // Hit Submit Button for 1) insert a new location, 2) edit the current location
            if (Page.IsValid) //CauseValidation Property is true
            {

                try
                {
                    String response;
                    ConnectToDb();
                    ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "modify_location"; //modify_location sp: performs both insertion and update of a location
                    ezCmd.CommandType = CommandType.StoredProcedure;
                    ezMES.ITemplate.FormattedTemplate fTemp;

                    if (FormView1.CurrentMode == FormViewMode.Insert) //insert a new location
                    {
                        ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value, ParameterDirection.InputOutput);
                        fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
                    }
                    else
                    {
                        ezCmd.Parameters.AddWithValue("@_location_id", gvTable.SelectedDataKey.Value.ToString(), ParameterDirection.InputOutput);
                        fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
                    }
                    LoadSqlParasFromTemplate(ezCmd, fTemp);
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);
                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    if (response.Length > 0)
                    {
                        lblError.Text = response;
                        this.ModalPopupExtender.Show();
                    }
                    else
                    {
                        lblError.Text = "";
                        //ModalPopupExtender.Hide();
                    }
                }catch(Exception ex)
                {
                    lblError1.Text = ex.Message;
                }
                gvTable.DataBind();
                gvTablePanel.Update();
            }
        }

        public void btnCancel_Click(Object sender, EventArgs e)
        {
            lblError.Text = "";
            ModalPopupExtender.Hide();
        }


   }
}
