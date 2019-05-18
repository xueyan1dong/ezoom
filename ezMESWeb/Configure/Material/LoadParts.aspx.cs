/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : LoadParts.aspx.cs
*    Created By             : Peiyu Ge
*    Date Created           : 5/13/2009
*    Platform Dependencies  : .NET 
*    Description            : Report on Dispatch history
*    Log                    :
*    
*    
----------------------------------------------------------------*/
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

namespace ezMESWeb.Configure.Material
{
    public partial class LoadParts : ConfigTemplate//System.Web.UI.Page
    {

        string[] cols = {"Part_No", "Vender", "Group", "Form", "Status", "If_Persistent", "Alert_Quantity_Level", "Lot_Size", "Unit_of_Measure", "Description", "Comment" };

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
            Object exist = null;

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

                txtContent1.Text += "Insert following parts information:\n\n";
                itemContent += "Load following parts information:\n\n";

                //lbVendor.Items.Clear();
                lbMaterial1.Items.Clear();
                Int32 materialIndex = 0;

                try
                {
                    //connect to DB
                    ConnectToDb();
                    ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                    ezCmd.Connection = ezConn;
                   // "Part_No", "Vender", "Group", "Form", "Status", "If_Persistent", "Alert_Quantity_Level", "Lot_Size", "Unit_of_Measure", "Description", "Comment"
                    for (int j = 0; j < csvTable.Rows.Count; j++)
                    {
                        //check vender
                        field = csvTable.Rows[j]["Vender"].ToString();
                        if (field.Length != 0)
                        {
                            ezCmd.CommandText = "Select id from client where name = '" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            exist = ezCmd.ExecuteScalar();
                            if (exist == null)
                            {
                                lblError.Text += String.Concat("Venor in row ", j + 1, " doesn't exist, please verify and upload again. ");
                            }else
                            {
                                
                                lbMaterial1.Items.Add(exist.ToString());
                                itemContent += "Vender: " + field + "\n";
                            }
                        }
                        else
                        {
                            lblError.Text += String.Concat("Venor in row ", j + 1, " is necessary. ");
                        }

                        //Material group
                        field = csvTable.Rows[j]["Group"].ToString();
                        if(field.Length != 0)
                        {
                            ezCmd.CommandText = "Select id from material_group where name = '" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            exist = ezCmd.ExecuteScalar();
                            if (exist == null)
                            {
                                lblError.Text += String.Concat("Group in row ", j + 1, " doesn't exist, please verify and upload again. ");
                            }
                            else
                            {
                                
                                lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                itemContent += "Group: " + field + "\n";
                            }
                        }
                        else
                        {
                            lblError.Text += String.Concat("Group in row ", j + 1, " is necessary. ");
                        }

                        //Material name
                        string part_no = csvTable.Rows[j]["Part_No"].ToString();
                        if (part_no.Length != 0)
                        {
                            ezCmd.CommandText = "Select id from material where name = '" + part_no + "' and mg_id = '" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            exist = ezCmd.ExecuteScalar();
                            if (exist == null)
                            {
                               
                                lbMaterial1.Items[materialIndex].Text += "||" + part_no;
                                itemContent += "Part_NO: " + part_no + "\n";
                            }
                            else
                            {
                                lblError.Text += String.Concat("Part_No in row ", j + 1, " already exists, please select a new Part_No. ");
                            }
                        }
                        else
                        {
                            lblError.Text += String.Concat("Part_NO in row ", j + 1, " is necessary. ");
                        }


                        //Material form
                        field = csvTable.Rows[j]["Form"].ToString();
                        if (field.Length != 0)
                        {
                           
                            if(field.Equals("solid") || field.Equals("liquid") || field.Equals("gas"))
                            {
                                
                                lbMaterial1.Items[materialIndex].Text += "||" + field;
                                itemContent += "Form: " + field + "\n";
                            }
                            else
                            {
                                lblError.Text += String.Concat("Material form in row ", j + 1, " should be solid, liquid or gas. Please verify and upload again. ");
                            }
                                
                        }
                        else
                        {
                            lblError.Text += String.Concat("Material form in row ", j + 1, " is necessary. ");
                        }

                        //Material status
                        field = csvTable.Rows[j]["Status"].ToString();
                        if (field.Length != 0)
                        {
                            if (field.Equals("inactive") || field.Equals("production") || field.Equals("frozen"))
                            {
                                
                                lbMaterial1.Items[materialIndex].Text += "||" + field;
                                itemContent += "Status: " + field + "\n";
                            }
                            else
                            {
                                lblError.Text += String.Concat("Material status in row ", j + 1, " should be inactive, production or frozen. Please verify and upload again. ");
                            }
                        }
                        else
                        {
                            lblError.Text += String.Concat("Material status in row ", j + 1, " is necessary. ");
                        }

                        //Material if persistent
                        field = csvTable.Rows[j]["If_Persistent"].ToString();
                        
                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                        itemContent += "If_Persistent: " + field + "\n";
                        


                        //Material alert quantity level
                        field = csvTable.Rows[j]["Alert_Quantity_Level"].ToString();
                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                        itemContent += "Alert_Quantity_Level: " + field + "\n";
                        

                        //Material lot size
                        field = csvTable.Rows[j]["Lot_Size"].ToString();
                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                        itemContent += "Lot_Size: " + field + "\n";

                        //Material unit of measure
                        field = csvTable.Rows[j]["Unit_of_Measure"].ToString();
                        if (field.Length != 0)
                        {

                            ezCmd.CommandText = "Select id from uom where name ='" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            exist = ezCmd.ExecuteScalar();
                            if (exist != null)
                            {
                                lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                itemContent += "Unit_of_Measure: " + field + "\n";
                            }
                            else
                            {
                                lblError.Text += String.Concat("Material Unit_of_Measure in row ", j + 1, " doesn't exist. Please verify and upload again. ");
                            }
                        }
                        else
                        {
                            lblError.Text += String.Concat("Material Unit_of_Measure in row ", j + 1, " is necessary. ");
                        }

                        //Material description
                        field = csvTable.Rows[j]["Description"].ToString();
                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                        itemContent += "Description: " + field + "\n";

                        //Material comment
                        field = csvTable.Rows[j]["Comment"].ToString();
                        lbMaterial1.Items[materialIndex].Text += "||" + field;
                        itemContent += "Comment: " + field + "\n";

                        itemContent += "\n";
                        materialIndex++;
                    }
                    txtContent1.Text += "\n" + itemContent;
                    ezCmd.Dispose();
                }
                catch (Exception ex)
                {
                    lblError.Text += ex.Message;
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

                        ezCmd.CommandText = "modify_material";
                        ezCmd.Parameters.Clear();
                        
                        ezCmd.Parameters.AddWithValue("@_material_id", DBNull.Value, ParameterDirection.InputOutput);
                        ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
                        ezCmd.Parameters.AddWithValue("@_name", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_alias", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_mg_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_material_form", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_status", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_if_persistent", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_alert_quantity", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_lot_size", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_uomid", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_description", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                        string[] spliter = { "||" };
                        for (int i = 0; i < lbMaterial1.Items.Count; i++)
                        {
                            // Vender, Group, Part_No,Form, Status, If_Persistent, Alert_Quantity_Level, Lot_Size, Unit_of_Measure, Description, Comment

                            fields = lbMaterial1.Items[i].Text.Split(spliter, StringSplitOptions.None);
                            ezCmd.Parameters["@_material_id"].Value = DBNull.Value;
                            ezCmd.Parameters["@_name"].Value = fields[2];
                            ezCmd.Parameters["@_alias"].Value = fields[0];
                            ezCmd.Parameters["@_mg_id"].Value = fields[1];
                            ezCmd.Parameters["@_material_form"].Value = fields[3];
                            ezCmd.Parameters["@_status"].Value = fields[4];

                            if (fields[5].Length != 0)
                            {
                                ezCmd.Parameters["@_if_persistent"].Value = fields[5];
                            }
                            else
                            {
                                ezCmd.Parameters["@_if_persistent"].Value = DBNull.Value;
                            }
                            if (fields[6].Length != 0)
                            {
                                ezCmd.Parameters["@_alert_quantity"].Value = fields[6];
                            }
                            else
                            {
                                ezCmd.Parameters["@_alert_quantity"].Value = DBNull.Value;
                            }
                            if (fields[7].Length != 0)
                            {
                                ezCmd.Parameters["@_lot_size"].Value = fields[7];
                            }
                            else
                            {
                                ezCmd.Parameters["@_lot_size"].Value = DBNull.Value;
                            }
                            ezCmd.Parameters["@_uomid"].Value = fields[8];
                            if (fields[9].Length != 0)
                            {
                                ezCmd.Parameters["@_description"].Value = fields[9];
                            }
                            else
                            {
                                ezCmd.Parameters["@_description"].Value = DBNull.Value;
                            }


                            if (fields[10].Length != 0)
                            {
                                ezCmd.Parameters["@_comment"].Value = fields[10];
                            }
                            else
                            {
                                ezCmd.Parameters["@_comment"].Value = DBNull.Value;
                            }


                            ezCmd.ExecuteNonQuery();
                            response = ezCmd.Parameters["@_response"].Value.ToString();
                            if (response.Length > 0)
                            {
                                lblError.Text += response;
                                break;
                            }
                            //else
                            //{
                            //    lbMaterial1.Items[i].Value = ezCmd.Parameters["@_material_id"].Value.ToString();
                            //}
                        }
                    }
                    catch (Exception ex)
                    {
                        lblError.Text += ex.Message;
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

        protected void btnPartForm_Click(object sender, EventArgs e)
        {
            MessagePopupExtender1.Hide();
            Server.Transfer("MaterialConfig.aspx");
        }
    }
}