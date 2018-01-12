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

namespace ezMESWeb.Configure
{
   public partial class ProdProcConfig : ConfigTemplate
   {
      protected SqlDataSource sdsClientDocConfig, sdsClientDocConfigGrid;
      public DataColumnCollection colc;
      protected Label lblError;
      protected DropDownList dpProduct;
      protected System.Data.Common.DbDataReader ezReader;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {
            DataView dv = (DataView)sdsClientDocConfigGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;


            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"ProdProc_insert.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"ProdProc_modify.xml"));

            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
         }
         if (!IsPostBack)
         {


           ConnectToDb();
           ezCmd = new EzSqlCommand();
           ezCmd.Connection = ezConn;
           ezCmd.CommandText = "SELECT id, name FROM product";
           ezCmd.CommandType = CommandType.Text;
           ezReader = ezCmd.ExecuteReader();
             while (ezReader.Read())
             {

                 dpProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
             }
             ezReader.Close();
             ezReader.Dispose();

             string tString=(Request.QueryString.Count>0)?Request.QueryString["prodid"]:null;
             if ((tString != null) && tString.Length > 0)
             {
                 dpProduct.SelectedValue = tString;
                 dpProd_SelectedIndexChanged(this, e);
             }
             else
             {
                 if (dpProduct.Items.Count > 0)
                 {
                     dpProduct.SelectedIndex = 0;
                     dpProd_SelectedIndexChanged(this, e);
                 }
             }

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
            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezCmd.CommandText = "associate_product_process";
            ezCmd.CommandType = CommandType.StoredProcedure;
            ezMES.ITemplate.FormattedTemplate fTemp;

             ezCmd.Parameters.AddWithValue("@_product_id", dpProduct.SelectedValue);
            ezCmd.Parameters.AddWithValue("@_recorder", Convert.ToInt32(Session["UserID"]));  

            if (FormView1.CurrentMode == FormViewMode.Insert)
            {

              fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
        
            }
            else
            {

              ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(gvTable.SelectedValue));


              fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
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

      protected void dpProd_SelectedIndexChanged(object sender, EventArgs e)
      {
          gvTable.Caption = "Workflow(s) Associated with Product" + dpProduct.SelectedItem.Text;
          gvTable.DataBind();
          
      }
   }
}
