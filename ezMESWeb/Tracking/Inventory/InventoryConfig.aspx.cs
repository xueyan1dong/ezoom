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
using System.Web.Configuration;
using AjaxControlToolkit;

namespace ezMESWeb.Tracking.Inventory
{
   public partial class InventoryConfig : ConfigTemplate
   {
      protected global::System.Web.UI.WebControls.SqlDataSource sdsInventoryGrid;
      public DataColumnCollection colc;
      protected Label lblError;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

       {
            DataView dv = (DataView)sdsInventoryGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Inventory.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Inventory.xml"));

            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);

         }
      }

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
         //modify the mode of form view
         FormView1.ChangeMode(FormViewMode.Edit);
         FormView1.Caption = "Copy An Inventory";

      }

      protected void btnCancel_Click(object sender, EventArgs e)
      {
         lblError.Text = "";
         ModalPopupExtender.Hide();
      }
      protected void btnSubmit_Click(object sender, EventArgs e)
      {
        string sourceType = "";
         if (Page.IsValid)
         {
            string response;
            ConnectToDb();
            ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezMES.ITemplate.FormattedTemplate fTemp;


            if (FormView1.CurrentMode == FormViewMode.Insert)
            {
               ezCmd.CommandText = "insert_inventory";
               ezCmd.CommandType = CommandType.StoredProcedure;
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

            }
            else  //this code should never been executed.
            {
               ezCmd.CommandText = "insert_inventory";
               ezCmd.CommandType = CommandType.StoredProcedure;

               

               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
            }

            ezCmd.Parameters.AddWithValue("@_recorded_by", Convert.ToInt32(Session["UserID"]));
            sourceType = ((DropDownList)FormView1.FindControl("drpsource_type")).SelectedValue;
            ezCmd.Parameters.AddWithValue("@_source_type", sourceType);
            if (sourceType.Equals("product"))
            {
              ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", ((DropDownList)FormView1.FindControl("drppd_or_mt_id")).SelectedValue);
              ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
            }
            else
            {
              ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", ((DropDownList)FormView1.FindControl("drpmt_id")).SelectedValue);
              //ezCmd.Parameters.AddWithValue("@_supplier_id", ((DropDownList)FormView1.FindControl("drpsupplier_id")).SelectedValue);
              ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
            }
            LoadSqlParasFromTemplate(ezCmd, fTemp);

            ezCmd.Parameters.AddWithValue("@_inventory_id", DBNull.Value);
            ezCmd.Parameters["@_inventory_id"].Direction = ParameterDirection.Output;
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

        FormView1.ChangeMode(FormViewMode.Insert);
        


         this.FormView1.Visible = true;
         
         //  force databinding
         this.FormView1.DataBind();
         //  update the contents in the detail panel


         this.updateRecordPanel.Update();

         this.ModalPopupExtender.Show();
      }

   }
}
