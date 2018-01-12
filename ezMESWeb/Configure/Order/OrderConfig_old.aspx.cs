using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace ezMESWeb.Configure
{
   public partial class OrderConfig : ConfigTemplate
   {
      protected global::System.Web.UI.WebControls.SqlDataSource sdsOrder, sdsPDGrid;
      public DataColumnCollection colc;
      protected Label lblError;
      
      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {
            DataView dv = (DataView)sdsPDGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Order.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Modify_Order.xml"));
           
            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
         }
      }

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
         //modify the mode of form view
         FormView1.ChangeMode(FormViewMode.Edit);
         
      }

      protected void gvTable_PageIndexChanged(object sender, EventArgs e)
      {
         gvTable.SelectedIndex = -1;
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
               using (sqlConn =
                   new MySql.Data.MySqlClient.MySqlConnection(ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString)) ;
               sqlConn.Open();
               sqlCmd =
                   new MySql.Data.MySqlClient.MySqlCommand();
               sqlCmd.Connection = sqlConn;
               ezMES.ITemplate.FormattedTemplate fTemp;


               if (FormView1.CurrentMode == FormViewMode.Insert)
               {
                  sqlCmd.CommandText = "insert_order";
                  sqlCmd.CommandType = CommandType.StoredProcedure;
              
                  sqlCmd.Parameters.AddWithValue("@_order_id", null);
                  fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
                  sqlCmd.Parameters["@_order_id"].Direction = ParameterDirection.Output;
      
               }
               else
               {
                  sqlCmd.CommandText = "modify_order";
                  sqlCmd.CommandType = CommandType.StoredProcedure;
              
                  sqlCmd.Parameters.AddWithValue("@_order_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Value));
      
                  fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
               }

               foreach (string name in fTemp.Fields.Keys)
               {
                  if (name.IndexOf("drp") == 0) //dropdown list
                  {
                     DropDownList lst = (DropDownList)FormView1.Row.FindControl(name);

                     string param = "@_" + fTemp.Fields[name].ToString();
                     sqlCmd.Parameters.AddWithValue(param, Convert.ToInt32(((DropDownList)FormView1.Row.FindControl(name)).SelectedItem.Value));
                  }
                  else if (name.IndexOf("txt") == 0) //text box
                  {
                     string param = "@_" + fTemp.Fields[name].ToString();

                     DataColumn _dc = fTemp._dccol[fTemp.Fields[name].ToString()];
                     String txtValue = ((TextBox)FormView1.Row.FindControl(name)).Text;
                     if ( txtValue != null && txtValue.Length > 0 )
                     {
                        switch (_dc.DataType.ToString())
                        {
                           case "System.String":
                              sqlCmd.Parameters.AddWithValue(param, txtValue);
                              break;
                           case "System.UInt32":
                              sqlCmd.Parameters.AddWithValue(param, Convert.ToInt32(txtValue));
                              break;
                           case "System.Int16":
                           case "System.Int32":
                           case "System.Int64":
                           case "int":
                              sqlCmd.Parameters.AddWithValue(param, Convert.ToInt64(txtValue));
                              break;
                           case "System.Decimal":
                              sqlCmd.Parameters.AddWithValue(param, Convert.ToDecimal(txtValue));
                              break;
                           case "System.DateTime":
                              sqlCmd.Parameters.AddWithValue(param, Convert.ToDateTime(txtValue));
                              break;
                           default:
                              sqlCmd.Parameters.AddWithValue(param, txtValue);
                              break;

                        }
                     }
                     else
                        sqlCmd.Parameters.AddWithValue(param, null);

                  }
                  else // not used in this form
                     ;
               }
               sqlCmd.Parameters.Add("@_response", MySql.Data.MySqlClient.MySqlDbType.VarChar, 255);
               sqlCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

               sqlCmd.ExecuteNonQuery();
               response = sqlCmd.Parameters["@_response"].Value.ToString();

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

      protected void Page_Load(object sender, EventArgs e)
      {

      }

   }
}

