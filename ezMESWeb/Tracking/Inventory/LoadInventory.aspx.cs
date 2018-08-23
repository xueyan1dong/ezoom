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
//using System.Text;
using LumenWorks.Framework.IO.Csv;
using System.IO;

namespace ezMESWeb.Tracking.Inventory
{
   public partial class LoadInventory : TrackTemplate
   {
      protected FileUpload fuLoad;
      protected TextBox txtContent;
      protected ListBox lbVendor, lbMaterial;
      protected ModalPopupExtender MessagePopupExtender;

      protected void btn_Click(object sender, EventArgs e)
      {
        DataRow newRow;
        //Hashtable vendors;
        string field;
        string itemContent="";

        Int32 fileLen = fuLoad.PostedFile.ContentLength;

        using (CsvReader csv= new CsvReader(new StreamReader(fuLoad.PostedFile.InputStream), true))
        {
          string[] headers=csv.GetFieldHeaders();

          DataTable csvTable = new DataTable();
          for (int i = 0; i < headers.Length; i++)
            csvTable.Columns.Add(headers[i]);


          while (csv.ReadNextRecord())
          {
            newRow = csvTable.NewRow();
            for (int i = 0; i < headers.Length; i++)
            {
              newRow[i] = csv[i];//default is trimmed.
              
            }
            csvTable.Rows.Add(newRow);
          }



          txtContent.Text += "Insert following vendor information:\n\n";
          itemContent += "Load following item information:\n\n";

          lbVendor.Items.Clear();
          lbMaterial.Items.Clear();
          Int32 materialIndex = 0;

          //vendors = new Hashtable();
          for (int j = 0; j < csvTable.Rows.Count; j++)
          {
            //only load Type: Inventory Part 
            if (csvTable.Rows[j]["Type"].ToString().Equals("Inventory Part"))
            {

              field = csvTable.Rows[j]["Item"].ToString();
              if (field.Length > 0)
              {
                
                //store Material name in lbMaterial
                lbMaterial.Items.Add(field);
                itemContent += "Item:" + field + "\n";

                //store quantity in lbMaterial
                field = csvTable.Rows[j]["Quantity On Hand"].ToString();
                if (field.Length == 0)
                  field = "0";
                lbMaterial.Items[materialIndex].Text += "||" + field;
                itemContent += "Quantity:" + field + "\n";

                if (csvTable.Columns.Contains("Preferred Vendor"))
                {
                  //store vendor not only with material, but also on a separate list
                  field = csvTable.Rows[j]["Preferred Vendor"].ToString();
                  if ((field.Length > 0) && (lbVendor.Items.FindByText(field) == null))
                  {
                    lbVendor.Items.Add(field);
                    txtContent.Text += field + "\n";
                  }
                  lbMaterial.Items[materialIndex].Text += "||" + field;
                  itemContent += "Preferred Vendor:" + field + "\n";
                }
                else
                  lbMaterial.Items[materialIndex].Text += "||";

                //store price in lbMaterial
                field = csvTable.Rows[j]["Price"].ToString();
                lbMaterial.Items[materialIndex].Text += "||" + field;
                itemContent += "Price:" + field + "\n";

                //store MPN in lbMaterial
                field = csvTable.Rows[j]["MPN"].ToString();
                lbMaterial.Items[materialIndex].Text += "||" + field;
                itemContent += "MPN:" + field + "\n";

                //store description in lbMaterial
                if (csvTable.Columns.Contains("Description"))
                {
                  field = csvTable.Rows[j]["Description"].ToString();
                  lbMaterial.Items[materialIndex].Text += "||" + field;
                  itemContent += "Description:" + field + "\n";
                }
                else
                  lbMaterial.Items[materialIndex].Text += "||";

                //store location in lbMaterial
                if (csvTable.Columns.Contains("Location"))
                {
                    field = csvTable.Rows[j]["Location"].ToString();
                    lbMaterial.Items[materialIndex].Text += "||" + field;
                    itemContent += "Location:" + field + "\n";
                }
                else
                    lbMaterial.Items[materialIndex].Text += "||";
                itemContent += "\n";
                //an item in lbMaterial is: Material Name|| Quantity||Preferred Vendor||Price||MPN||Description||Location
                materialIndex++;
              }
            }
          }

          txtContent.Text += "\n" + itemContent;

        }
        
      }

      protected void btnSubmit_Click(object sender, EventArgs e)
      {
        string response;
        string[] fields;
        if (Page.IsValid)
        {
          lblError.Text = "";
          try
          {
           
            ConnectToDb();
            ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            ezCmd.Connection = ezConn;

            //load preferred vendors
            ezCmd.CommandText = "autoload_client";
            ezCmd.CommandType = CommandType.StoredProcedure;
            ezCmd.Parameters.AddWithValue("@_client_id", DBNull.Value, ParameterDirection.Output);
            ezCmd.Parameters.AddWithValue("@_name", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_type", "supplier");
            ezCmd.Parameters.AddWithValue("@_internal_contact_id", Convert.ToInt32(Session["UserID"]));
            ezCmd.Parameters.AddWithValue("@_company_phone", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_address", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_city", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_state", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_zip", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_country", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_address2", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_city2", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_state2", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_zip2", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_contact_person1", "N/A");
            ezCmd.Parameters.AddWithValue("@_contact_person2", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_person1_workphone", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_person1_cellphone", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_person1_email", "N/A");
            ezCmd.Parameters.AddWithValue("@_person2_workphone", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_person2_cellphone", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_person2_email", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_ifactive", 1);
            ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

            for (int i = 0; i < lbVendor.Items.Count; i++)
            {
              ezCmd.Parameters["@_name"].Value = lbVendor.Items[i].Text;
              ezCmd.ExecuteNonQuery();
              response = ezCmd.Parameters["@_response"].Value.ToString();
              if (response.Length > 0)
              {
                lblError.Text = response;
                break;
              }
              else
                lbVendor.Items[i].Value = ezCmd.Parameters["@_client_id"].Value.ToString();
            }

            //load materials
            if (lblError.Text.Length == 0)
            {
              
              ezCmd.CommandText = "autoload_material";
              ezCmd.Parameters.Clear();
              ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
              ezCmd.Parameters.AddWithValue("@_name", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_alias", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_mg_id", 1);
              ezCmd.Parameters.AddWithValue("@_material_form", "solid");
              ezCmd.Parameters.AddWithValue("@_status", "production");
              ezCmd.Parameters.AddWithValue("@_lot_size", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_uom_name", "unit");
              ezCmd.Parameters.AddWithValue("@_supplier_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_preference", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_mpn", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_price", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_lead_days", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_description", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_material_id", DBNull.Value, ParameterDirection.Output);
              ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

              string[] spliter = {"||"};
              for (int i = 0; i < lbMaterial.Items.Count; i++)
              {
                //an item in lbMaterial is: Material Name|| Quantity||Preferred Vendor||Price||MPN||Description||Location
                fields = lbMaterial.Items[i].Text.Split(spliter, StringSplitOptions.None );
                ezCmd.Parameters["@_name"].Value = fields[0];
                if (fields[2].Length > 0)
                  ezCmd.Parameters["@_supplier_id"].Value=lbVendor.Items.FindByText(fields[2]).Value;
                else
                  ezCmd.Parameters["@_supplier_id"].Value= DBNull.Value;

                if (fields[4].Length > 0)
                  ezCmd.Parameters["@_mpn"].Value=fields[4];
                else
                  ezCmd.Parameters["@_mpn"].Value=DBNull.Value;

                if (fields[3].Length > 0)
                  ezCmd.Parameters["@_price"].Value =fields[3].Replace(",", "");
                else
                  ezCmd.Parameters["@_price"].Value= DBNull.Value;

                if (fields[5].Length > 0)
                  ezCmd.Parameters["@_description"].Value =fields[5];
                else
                  ezCmd.Parameters["@_description"].Value = DBNull.Value;
                
                ezCmd.ExecuteNonQuery();
                response = ezCmd.Parameters["@_response"].Value.ToString();
                if (response.Length > 0)
                {
                  lblError.Text = response;
                  break;
                }
                else
                  lbMaterial.Items[i].Value = ezCmd.Parameters["@_material_id"].Value.ToString();
              }
            }

            //load inventory
            if (lblError.Text.Length == 0)
            {
              //an item in lbMaterial is: Material Name|| Quantity||Preferred Vendor||Price||MPN||Description||Location
              string today =DateTime.UtcNow.Year + "-" + DateTime.UtcNow.Month + "-" + DateTime.UtcNow.Day;
              ezCmd.CommandText = "autoload_inventory";
              ezCmd.Parameters.Clear();
              ezCmd.Parameters.AddWithValue("@_recorder_by", Convert.ToInt32(Session["UserID"]));
              ezCmd.Parameters.AddWithValue("@_source_type", "material");
              ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
              ezCmd.Parameters.AddWithValue("@_lot_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_serial_no", today);
              ezCmd.Parameters.AddWithValue("@_out_order_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_in_order_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_original_quantity", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_uom_name", "unit");
              ezCmd.Parameters.AddWithValue("@_manufacture_date",today);
              ezCmd.Parameters.AddWithValue("@_expiration_date", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_arrive_date", today);
              ezCmd.Parameters.AddWithValue("@_contact_employee", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
              ezCmd.Parameters.AddWithValue("@_inventory_id", DBNull.Value, ParameterDirection.Output);
              ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

              string[] spliter = {"||"};
              for (int i = 0; i < lbMaterial.Items.Count; i++)
              {

                  fields = lbMaterial.Items[i].Text.Split(spliter, StringSplitOptions.None );
                  fields[1] = fields[1].Replace(",", "");
                  if(System.Double.Parse(fields[1])>0)
                  {
                    ezCmd.Parameters["@_pd_or_mt_id"].Value = lbMaterial.Items[i].Value;

                    if (fields[2].Length > 0)
                      ezCmd.Parameters["@_supplier_id"].Value= lbVendor.Items.FindByText(fields[2]).Value;
                    else
                      ezCmd.Parameters["@_supplier_id"].Value= 0;

                    ezCmd.Parameters["@_lot_id"].Value = fields[4].Length>0? 
                      (fields[4].Length>20?fields[4].Substring(0, 20):fields[4]):
                      (fields[0].Length>20?fields[0].Substring(0, 20):fields[0]);

                    ezCmd.Parameters["@_original_quantity"].Value = fields[1];

                    if (fields[6].Length > 0)
                        ezCmd.Parameters["@_location_id"].Value = fields[6];

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    if (response.Length > 0)
                    {
                      lblError.Text = response;
                      break;
                    }
                  }
              }
            }
          }
          catch (Exception ex)
          {
            lblError.Text = ex.Message;
          }
          ezCmd.Dispose();
          ezConn.Dispose();
          if (lblError.Text.Length == 0)
          {
            MessagePopupExtender.Show();
          }
        }
       }

        protected void txtContent_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnInvForm_Click(object sender, EventArgs e)
      {
        MessagePopupExtender.Hide();
        Server.Transfer("InventoryConfig.aspx");
      }
   }
}
