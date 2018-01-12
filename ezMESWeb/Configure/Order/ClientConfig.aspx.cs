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

namespace ezMESWeb.Configure.Client
{
   public partial class ClientConfig : ConfigTemplate
   {
      protected SqlDataSource sdsClientConfig, sdsClientConfigGrid;
      public DataColumnCollection colc;
      protected Label lblError;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {
            DataView dv = (DataView)sdsClientConfigGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Client_Insert.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Client_Modify.xml"));

            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
         }
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
            ConnectToDb();
            ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezCmd.CommandText = "modify_client";
            ezCmd.CommandType = CommandType.StoredProcedure;
            ezMES.ITemplate.FormattedTemplate fTemp;


            if (FormView1.CurrentMode == FormViewMode.Insert)
            {
               ezCmd.Parameters.AddWithValue("@_client_id", DBNull.Value);
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
               ezCmd.Parameters["@_client_id"].Direction = ParameterDirection.InputOutput;
            }
            else
            {
               ezCmd.Parameters.AddWithValue("@_client_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Values["id"]));
               ezCmd.Parameters["@_client_id"].Direction = ParameterDirection.InputOutput;
       
               ezCmd.Parameters.AddWithValue("@_name", Convert.ToString(gvTable.SelectedPersistedDataKey.Values["name"]));
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
            }

            LoadSqlParasFromTemplate(ezCmd, fTemp);
            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
            ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

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
               this.FormView1.Visible = false;
               this.ModalPopupExtender.Hide();

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
