using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;


namespace ezMESWeb.Configure.Process
{
   public partial class RecipeConfig : ConfigTemplate
   {
      protected SqlDataSource sdsRecipeGrid;
      public DataColumnCollection colc;
      protected Label lblError;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {
            DataView dv = (DataView)sdsRecipeGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Recipe.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Recipe.xml"));

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
            using (sqlConn =
                new MySql.Data.MySqlClient.MySqlConnection(ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString)) ;
            sqlConn.Open();
            sqlCmd =
                new MySql.Data.MySqlClient.MySqlCommand();
            sqlCmd.Connection = sqlConn;
            sqlCmd.CommandText = "modify_recipe";
            sqlCmd.CommandType = CommandType.StoredProcedure;
            ezMES.ITemplate.FormattedTemplate fTemp;


            if (FormView1.CurrentMode == FormViewMode.Insert)
            {
               sqlCmd.Parameters.AddWithValue("@_recipe_id", null);
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
               sqlCmd.Parameters["@_recipe_id"].Direction = ParameterDirection.Output;
            }
            else
            {
               sqlCmd.Parameters.AddWithValue("@_recipe_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Values["id"]));
               sqlCmd.Parameters["@_recipe_id"].Direction = ParameterDirection.Output;

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
                  if (txtValue != null && txtValue.Length > 0)
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
               else if (name.IndexOf("rbl") == 0) //radio button
               {
                   string param = "@_" + fTemp.Fields[name].ToString();
                   DataColumn _dc = fTemp._dccol[fTemp.Fields[name].ToString()];
                   if (Convert.ToBoolean(((RadioButtonList)FormView1.Row.FindControl(name)).SelectedValue))
                       sqlCmd.Parameters.AddWithValue(param, "1");
                   else
                       sqlCmd.Parameters.AddWithValue(param, "0");
               }
               else // not used in this form
               { }
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


   }
}
