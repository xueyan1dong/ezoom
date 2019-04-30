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

namespace ezMESWeb.Configure.Product
{
    public partial class LoadProduct : ConfigTemplate
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
            txtContent1.Text = "";
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

                try
                {
                    //connect to DB
                    ConnectToDb();
                    ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                    ezCmd.Connection = ezConn;

                    for (int j = 0; j < csvTable.Rows.Count; j++)
                    {
                        //check source_type is empty
                        field = csvTable.Rows[j]["Product_Group"].ToString();
                        if (field.Length != 0)
                        {
                            ezCmd.CommandText = "Select id from product_group where name = '" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            try
                            {
                                count = ezCmd.ExecuteScalar().ToString();

                                //now can store Source Type in lbMaterial
                                lbMaterial1.Items.Add(count);
                                itemContent += "Product_Group:" + field + "\n";

                                //Product name
                                field = csvTable.Rows[j]["Name"].ToString();

                                if (field.Length != 0)
                                {
                                    lbMaterial1.Items[materialIndex].Text += "||" + field;
                                    itemContent += "Name:" + field + "\n";
                                    field = csvTable.Rows[j]["Lot_Size"].ToString();
                                    lbMaterial1.Items[materialIndex].Text += "||" + field;
                                    itemContent += "Lot_Size:" + field + "\n";

                                    field = csvTable.Rows[j]["Unit"].ToString(); //unit is not null
                                    ezCmd.CommandText = "Select id from uom where name = '" + field + "'";
                                    if (field.Length != 0)
                                    {
                                        try
                                        {
                                            count = ezCmd.ExecuteScalar().ToString();
                                            lbMaterial1.Items[materialIndex].Text += "||" + count;
                                            itemContent += "Unit:" + field + "\n";
                                        }
                                        catch (Exception ex)
                                        {
                                            lblError.Text = String.Concat("Unit in row ", j + 1, " not found Please verify and upload again.");
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        lblError.Text = "Unit is necessary.";
                                        break;
                                    }

                                    field = csvTable.Rows[j]["LifeSpan"].ToString();
                                    if(field.Length != 0)
                                    {
                                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        itemContent += "LifeSpan:" + field + "\n";
                                    }
                                    else{
                                        lblError.Text = "LifeSpan is necessary.";
                                        break;
                                    }
                                    
                                    field = csvTable.Rows[j]["Description"].ToString();
                                    lbMaterial1.Items[materialIndex].Text += "||" + field;      
                                    itemContent += "Description:" + field + "\n";

                                    field = csvTable.Rows[j]["Comment"].ToString();
                                    lbMaterial1.Items[materialIndex].Text += "||" + field;
                                    itemContent += "Commmment:" + field + "\n";

                                    itemContent += "\n";
                                    
                                    materialIndex++;
    
                                }
                                else
                                {
                                    lblError.Text = String.Concat("Name in row ", j + 1, " is necessary");
                                    break;
                                }

                            }
                            catch(Exception ex)
                            {
                                lblError.Text = String.Concat("Product_Group in row ", j + 1, " not found. Please verify and upload again.");
                                break;
                            }   
                        }
                        else
                        {
                            lblError.Text = String.Concat("Product_Group in row ", j + 1, " is necessary.");
                            break;
                        }
                    }
                    txtContent1.Text += "\n" + itemContent;
                    ezCmd.Dispose();
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                }

            }

        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string response;
            string[] fields;
            if (Page.IsValid)
            {
                if (lbMaterial1.Items.Count == 0 | lblError.Text.Length != 0)
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

                        string today = DateTime.UtcNow.Year + "-" + DateTime.UtcNow.Month + "-" + DateTime.UtcNow.Day;
                        string datePattern = "MM/dd/yyyy";
                        DateTime parsedDate;

                        ezCmd.CommandText = "modify_product";
                        ezCmd.Parameters.Clear();

                        
                        ezCmd.Parameters.AddWithValue("@_product_id", DBNull.Value, ParameterDirection.InputOutput);
                        ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));
                        ezCmd.Parameters.AddWithValue("@_version", 1);
                        ezCmd.Parameters.AddWithValue("@_state", "production");
                        ezCmd.Parameters.AddWithValue("@_pg_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_name", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_lot_size", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_uomid", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_lifespan", DBNull.Value);//today);
                        ezCmd.Parameters.AddWithValue("@_description", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                        string[] spliter = { "||" };
                        for (int i = 0; i < lbMaterial1.Items.Count; i++)
                        {
                            //Product_Group, Name, Lot_Size, Unit, LifeSpan, Description, Comment.</p><br />

                            fields = lbMaterial1.Items[i].Text.Split(spliter, StringSplitOptions.None);
                            ezCmd.Parameters["@_product_id"].Value = DBNull.Value;
                            ezCmd.Parameters["@_pg_id"].Value = fields[0];
                            ezCmd.Parameters["@_name"].Value = fields[1];
                            if(fields[2].Length != 0)
                            {
                                ezCmd.Parameters["@_lot_size"].Value = fields[2];
                            }
                            else
                            {
                                ezCmd.Parameters["@_lot_size"].Value = DBNull.Value;
                            }
                           
                            ezCmd.Parameters["@_uomid"].Value = fields[3];
                            ezCmd.Parameters["@_lifespan"].Value = fields[4];
                            if (fields[5].Length != 0)
                            {
                                ezCmd.Parameters["@_description"].Value = fields[5];
                            }
                            else
                            {
                                ezCmd.Parameters["@_description"].Value = DBNull.Value;
                            }
                            if (fields[6].Length != 0)
                            {
                                ezCmd.Parameters["@_comment"].Value = fields[6];
                            }
                            else
                            {
                                ezCmd.Parameters["@_comment"].Value = DBNull.Value;
                            }

                            ezCmd.ExecuteNonQuery();
                            response = ezCmd.Parameters["@_response"].Value.ToString();
                            if (response.Length > 0)
                            {
                                lblError.Text = response;
                                break;
                            }
                            else
                            {
                                lbMaterial1.Items[i].Value = ezCmd.Parameters["@_product_id"].Value.ToString();
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
            Server.Transfer("ProductConfig.aspx");
        }
    }

}