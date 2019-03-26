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
using LumenWorks.Framework.IO.Csv;
using System.IO;
using System.Globalization;

namespace ezMESWeb.Tracking.Inventory
{
    public partial class LoadInventoryGeneral : TrackTemplate
    {
        protected FileUpload fuLoad1;
        protected TextBox txtContent1;
        protected ListBox lbMaterial1;
        protected ModalPopupExtender MessagePopupExtender1;

        protected void btn_Click(object sender, EventArgs e)
        {
            load_csv();
        }

        protected void load_csv()
        { 
        
            DataRow newRow;
            string field;
            string itemContent = "";
            string count = "";
            txtContent1.Text ="";
            lblError.Text = "";

            Int32 fileLen = fuLoad1.PostedFile.ContentLength;

            using (CsvReader csv = new CsvReader(new StreamReader(fuLoad1.PostedFile.InputStream), true))
            {
                string[] headers = csv.GetFieldHeaders();

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

                txtContent1.Text += "Insert following inventory information:\n\n";
                itemContent += "Load following item information:\n\n";

                //lbVendor.Items.Clear();
                lbMaterial1.Items.Clear();
                Int32 materialIndex = 0;

                //connect to DB
                ConnectToDb();
                ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                ezCmd.Connection = ezConn;


                //1. Code doesn't check empty fields. When db gives errors, show in the UI.
                for (int j = 0; j < csvTable.Rows.Count; j++)
                {
                    //check source_type in inventory
                    field = csvTable.Rows[j]["Source_Type"].ToString();
                    if (field.Length != 0)
                    {
                        ezCmd.CommandText = "Select count(*) from inventory where source_type = '" + field+ "'";
                        ezCmd.CommandType = CommandType.Text;
                        count = ezCmd.ExecuteScalar().ToString();

                        if (count != null && Convert.ToInt32(count) > 0)
                        {
                            //store Source Type in lbMaterial
                            lbMaterial1.Items.Add(field);
                            itemContent += "Source_Type:" + field + "\n";

                            //check name in product or material table
                            string name = csvTable.Rows[j]["Name"].ToString();
                            
                            ezCmd.CommandText = "Select Count(*) from " + field + " where id = '" + name + "'";
                            ezCmd.CommandType = CommandType.Text;
                            //Int32 count1 = (Int32)ezCmd.ExecuteScalar();
                            count  = ezCmd.ExecuteScalar().ToString();
                            
                            if (count!= null && Convert.ToInt32(count) > 0)
                            {
                                lbMaterial1.Items[materialIndex].Text += "||" + name;
                                itemContent += "Name:" + name + "\n";

                                //check supplier in client table and supplier type in ("supplier", "both")
                                field = csvTable.Rows[j]["Supplier"].ToString();
                                if (field.Length != 0)
                                {
                                    ezCmd.CommandText = "Select count(*) from client c where c.id = '" + field + "' and c.type in ('supplier', 'both')";
                                    count = ezCmd.ExecuteScalar().ToString();
                                    if (count!= null && Convert.ToInt32(count) > 0)
                                    {
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Supplier:" + field + "\n";

                                        //parse other columns: Contact, Comment.
                                        field = csvTable.Rows[j]["Batch_Number"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Batch_Number:" + field + "\n";

                                        field = csvTable.Rows[j]["Serial_Number"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Serial_Number:" + field + "\n";

                                        field = csvTable.Rows[j]["Purchase_PO"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Purchase_PO:" + field + "\n";

                                        field = csvTable.Rows[j]["Sales_PO"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Sales_PO:" + field + "\n";

                                        field = csvTable.Rows[j]["Original_Quantity"].ToString();
                                        if (field.Length == 0)
                                        {
                                            field = "0";
                                        }
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Original_Quantity:" + field + "\n";

                                        field = csvTable.Rows[j]["Actual_Quantity"].ToString();
                                        if (field.Length == 0)
                                        {
                                            field = "0";
                                        }
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Actual_Quantity:" + field + "\n";

                                        field = csvTable.Rows[j]["Location"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Location:" + field + "\n";

                                        field = csvTable.Rows[j]["Unit"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Unit:" + field + "\n";

                                        field = csvTable.Rows[j]["Manufacture_Date"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Manufacture_Date:" + field + "\n";

                                        field = csvTable.Rows[j]["Expiration_Date"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Expiration_Date:" + field + "\n";

                                        field = csvTable.Rows[j]["Arrive_Date"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Arrive_Date:" + field + "\n";

                                        field = csvTable.Rows[j]["Contact"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Contact:" + field + "\n";

                                        field = csvTable.Rows[j]["Comment"].ToString();
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "Comment:" + field + "\n";

                                        itemContent += "\n";
                                        //an item in lbMaterial is: Material Name|| Quantity||Preferred Vendor||Price||MPN||Description||Location
                                        materialIndex++;
                                    }
                                    else
                                    {
                                        lblError.Text = String.Concat("Supplier in row ", j + 1, " not found or in wrong type.");
                                    }
                                }
                            }
                            else
                            {
                                lblError.Text = String.Concat("Name in row", j + 1, " not found.");
                            }
                        }
                        else
                        {
                            lblError.Text = String.Concat("Source_Type in row ", j + 1, " not found");
                        }

                        
                    }
                }
                txtContent1.Text += "\n" + itemContent;
            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string response;
            string[] fields;
            if (Page.IsValid)
            {
                if (lbMaterial1.Items.Count == 0)
                {
                    load_csv();
                }
                if (lblError.Text.Length == 0)
                {

                    try
                    {

                        ConnectToDb();
                        ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                        ezCmd.Connection = ezConn;

                        //load inventory
                        if (lblError.Text.Length == 0)
                        {
                            //an item in lbMaterial is: Material Name|| Quantity||Preferred Vendor||Price||MPN||Description||Location
                            string today = DateTime.UtcNow.Year + "-" + DateTime.UtcNow.Month + "-" + DateTime.UtcNow.Day;
                            string datePattern = "MM/dd/yyyy";
                            DateTime parsedDate;

                            ezCmd.CommandText = "insert_inventory";
                            ezCmd.Parameters.Clear();

                            ezCmd.Parameters.AddWithValue("@_recorded_by", Convert.ToInt32(Session["UserID"]));
                            ezCmd.Parameters.AddWithValue("@_source_type", "material");
                            ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
                            ezCmd.Parameters.AddWithValue("@_lot_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_serial_no", today);
                            ezCmd.Parameters.AddWithValue("@_out_order_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_in_order_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_original_quantity", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_actual_quantity", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_uom_id", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_manufacture_date", today);
                            ezCmd.Parameters.AddWithValue("@_expiration_date", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_arrive_date", today);
                            ezCmd.Parameters.AddWithValue("@_contact_employee", DBNull.Value);
                            ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
                            

                            string[] spliter = { "||" };
                            for (int i = 0; i < lbMaterial1.Items.Count; i++)
                            {
                                //Source_Type (0), Name, Supplier, Batch_Number, Serial_Number, Purchase_PO, Sales_PO, Original_Quantity, Actual_Quantity, Location, Unit, Manufacture_Date, Expiration_Date, Arrive_Date, Contact, Comment

                                fields = lbMaterial1.Items[i].Text.Split(spliter, StringSplitOptions.None);
                                ezCmd.Parameters["@_source_type"].Value = fields[0];//lbMaterial1.Items[i].Value;
                                ezCmd.Parameters["@_pd_or_mt_id"].Value = fields[1];
                                ezCmd.Parameters["@_supplier_id"].Value = fields[2];
                                ezCmd.Parameters["@_lot_id"].Value = fields[3];
                                ezCmd.Parameters["@_serial_no"].Value = fields[4];
                                ezCmd.Parameters["@_out_order_id"].Value = fields[5];
                                ezCmd.Parameters["@_in_order_id"].Value = fields[6];
                                ezCmd.Parameters["@_original_quantity"].Value = fields[7];
                                ezCmd.Parameters["@_actual_quantity"].Value = fields[8];
                                ezCmd.Parameters["@_location_id"].Value = fields[9];
                                ezCmd.Parameters["@_uom_id"].Value = fields[10];

                                if(DateTime.TryParseExact(fields[11], datePattern, null, DateTimeStyles.None, out parsedDate))
                                    ezCmd.Parameters["@_manufacture_date"].Value = parsedDate;
                                if(DateTime.TryParseExact(fields[12], datePattern, null, DateTimeStyles.None, out parsedDate))
                                    ezCmd.Parameters["@_expiration_date"].Value = parsedDate; //fields[11];
                                if(DateTime.TryParseExact(fields[13], datePattern, null, DateTimeStyles.None, out parsedDate))
                                    ezCmd.Parameters["@_arrive_date"].Value = parsedDate; //fields[12];
                                ezCmd.Parameters["@_contact_employee"].Value = fields[14];
                                ezCmd.Parameters["@_comment"].Value = fields[15];
                                ezCmd.Parameters.AddWithValue("@_inventory_id", DBNull.Value, ParameterDirection.Output);
                                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);
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
                    catch (Exception ex)
                    {
                        lblError.Text = ex.Message;
                    }
                    ezCmd.Dispose();
                    ezConn.Dispose();
                    if (lblError.Text.Length == 0)
                    {
                        MessagePopupExtender1.Show();
                    }

                }
            }
        }

        protected void txtContent_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnInvForm_Click(object sender, EventArgs e)
        {
            MessagePopupExtender1.Hide();
            Server.Transfer("InventoryConfig.aspx");
        }
    }
}