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

namespace ezMESWeb.Configure.Process
{
    public partial class LoadStep : ConfigTemplate
    {
        protected FileUpload fuLoad1;
        protected TextBox txtContent1;
        protected ListBox lbMaterial1;
        protected ModalPopupExtender MessagePopupExtender1;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

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

                txtContent1.Text += "Insert following step information:\n\n";
                itemContent += "Load following step information:\n\n";

                //lbVendor.Items.Clear();
                lbMaterial1.Items.Clear();
                Int32 materialIndex = 0;
                //Step_Name, Step_Type_Id, Equipment, 
                //Employee_Usage, Employee_Group, Recipe, 
                
                try
                {
                    //connect to DB
                    ConnectToDb();
                    ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                    ezCmd.Connection = ezConn;

                    for (int j = 0; j < csvTable.Rows.Count; j++)
                    {
                        //check source_type is empty
                        field = csvTable.Rows[j]["Step_Name"].ToString();
                        if (field.Length != 0)
                        {
                            ezCmd.CommandText = "Select id from step where name = '" + field + "'";
                            ezCmd.CommandType = CommandType.Text;
                            exist = ezCmd.ExecuteScalar();
                            if (exist == null)
                            {
                                //add Step_Name
                                lbMaterial1.Items.Add(field);
                                itemContent += "Step_Name:" + field + "\n";

                                //Step_Type
                                field = csvTable.Rows[j]["Step_Type"].ToString();
                                if (field.Length != 0)
                                {
                                    ezCmd.CommandText = "Select id from step_type where name = '" + field + "'";
                                    ezCmd.CommandType = CommandType.Text;
                                    exist = ezCmd.ExecuteScalar();
                                    if (exist != null)
                                    {
                                        lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                        itemContent += "Step_Type:" + field + "\n";

                                        //equipment
                                        field = csvTable.Rows[j]["Equipment"].ToString();
                                        if(field.Length != 0)
                                        {
                                            ezCmd.CommandText = "Select id from equipment where name = '" + field + "'";
                                            ezCmd.CommandType = CommandType.Text;
                                            exist = ezCmd.ExecuteScalar();
                                            if(exist == null)
                                            {
                                                lblError.Text = String.Concat("Can not find the equipment in row", j + 1, ". Please verify and upload again.");
                                                break;
                                            }
                                            lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                        }
                                        else
                                        {
                                            lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        }
                                      
                                        itemContent += "Equipment:" + field + "\n";

                                        //employee usage
                                        field = csvTable.Rows[j]["Employee_Usage"].ToString(); 
                                        if (field.Length != 0)
                                        {
                                            if(field.ToLower().Equals("employee group") | field.ToLower().Equals("employee"))
                                            { 
                                                string ep = csvTable.Rows[j]["Employee_Group"].ToString();
                                                if(ep.Length != 0)
                                                {
                                                    //add employee_usage
                                                    lbMaterial1.Items[materialIndex].Text += "||" + field;
                                                    itemContent += "Employee_Usage:" + field + "\n";
                                                    if (field.ToLower().Equals("employee group"))
                                                    {
                                                        ezCmd.CommandText = "Select id from employee_group where name = '" + ep + "'";
                                                    }
                                                    else
                                                    {
                                                        ezCmd.CommandText = "Select id from employee where username = '" + ep + "'";
                                                    }
                                                    ezCmd.CommandType = CommandType.Text;
                                                    exist = ezCmd.ExecuteScalar();
                                                    if(exist != null)
                                                    {
                                                           
                                                        //add employ_group
                                                        lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                                        itemContent += "Employee_Group:" + ep + "\n";
                                                    }
                                                    else
                                                    {
                                                        lblError.Text = String.Concat("Employee_Group in row ", j + 1, " not found. Please verify and upload again.");
                                                        break;
                                                    }
                                                    
                                                }
                                                else
                                                {
                                                    lblError.Text = String.Concat("Employee_Group in row ", j + 1, " is necessary.");
                                                    break;
                                                }
                                                
                                            }
                                            else
                                            {
                                                lblError.Text = String.Concat("Employee_Usage in row ", j + 1, " not found. Employee_Usage should be either 'Employee_Group' or 'Employee'. Please verify and upload again.");
                                                break;
                                            }
                                            
                                        }
                                        else
                                        {
                                            lbMaterial1.Items[materialIndex].Text += "||" + field;
                                            itemContent += "Employee_Usage:" + field + "\n";
                                            field = csvTable.Rows[j]["Employee_Group"].ToString();
                                            if (field.Length != 0)
                                            {
                                                lblError.Text = String.Concat("Employee_Usage in row ", j + 1," is missing. Please fill in an Employee_Usage first.");
                                                break;
                                            }
                                            lbMaterial1.Items[materialIndex].Text += "||" + field;
                                            itemContent += "Employee:" + field + "\n";
                                        }
                                        
                                        //Recipe
                                        field = csvTable.Rows[j]["Recipe"].ToString();
                                        if (field.Length != 0)
                                        {
                                            ezCmd.CommandText = "Select id from recipe where name = '" + field + "'";
                                            ezCmd.CommandType = CommandType.Text;
                                            exist = ezCmd.ExecuteScalar();
                                            if (exist == null)
                                            {
                                                lblError.Text = String.Concat("Can not find the recipe in row", j + 1, ". Please verify and upload again.");
                                                break;
                                            }
                                            lbMaterial1.Items[materialIndex].Text += "||" + exist.ToString();
                                        }
                                        else
                                        {
                                            lbMaterial1.Items[materialIndex].Text += "||" + field;
                                        }
                                        itemContent += "Recipe:" + field + "\n";

                                        //Min_Time, Max_Time, Description, Comment, 
                                        //Parameter 1, Parameter 2, Parameter 3, Parameter 4, Parameter 5, Parameter 6, Parameter 7, Parameter 8, Parameter 9, Parameter 10, .

                                        string[] lis = new string[] { "Min_Time", "Max_Time", "Description", "Comment", "Parameter 1", "Parameter 2", "Parameter 3", "Parameter 4", "Parameter 5", "Parameter 6", "Parameter 7", "Parameter 8", "Parameter 9", "Parameter 10"};

                                        foreach (string r in lis){
                                            field = csvTable.Rows[j][r].ToString();
                                            lbMaterial1.Items[materialIndex].Text += "||" + field;
                                            itemContent += String.Concat(r, ":", field, "\n");
                                        }
                                        
                                        itemContent += "\n";
                                        materialIndex++;
                                    }
                                    else
                                    {
                                        lblError.Text = String.Concat("Can not find the step_type in row", j + 1, ". Please verify and upload again.");
                                        break;
                                    }
                                   
                                }
                                else
                                {
                                    lblError.Text = String.Concat("Step_Type in row ", j + 1, " is necessary");
                                    break;
                                }

                            }
                            else
                            {
                                lblError.Text = String.Concat("Step_name in row ", j + 1, " has been used by another step. Please select a new one.");
                                break;
                            }
                        }
                        else
                        {
                            lblError.Text = String.Concat("Step_Name in row ", j + 1, " is necessary.");
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

                        ezCmd.CommandText = "modify_step";
                        ezCmd.Parameters.Clear();


                        ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value, ParameterDirection.InputOutput);
                        ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));
                        ezCmd.Parameters.AddWithValue("@_version", 1);
                        ezCmd.Parameters.AddWithValue("@_if_default_version", 1);
                        ezCmd.Parameters.AddWithValue("@_state", "production");
                        ezCmd.Parameters.AddWithValue("@_eq_usage", "equipment");
                        ezCmd.Parameters.AddWithValue("@_emp_usage", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_emp_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_name", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_step_type_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_eq_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_recipe_id", DBNull.Value);//today);
                        ezCmd.Parameters.AddWithValue("@_mintime", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_maxtime", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_description", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para1", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para2", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para3", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para4", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para5", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para6", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para7", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para8", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para9", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para10", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_para_count", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                        string[] spliter = { "||" };
                        for (int i = 0; i < lbMaterial1.Items.Count; i++)
                        {
                            //Step_Name, Step_Type_Id, Equipment, 
                            //Employee_Usage, Employee_Group, Recipe, 
                            //Min_Time, Max_Time, Description, Comment, 
                            //Parameter 1, Parameter 2, Parameter 3, Parameter 4, Parameter 5, Parameter 6, Parameter 7, Parameter 8, Parameter 9, Parameter 10,
                            //ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value, ParameterDirection.InputOutput);
                            //ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));
                            //ezCmd.Parameters.AddWithValue("@_version", 1);
                            //ezCmd.Parameters.AddWithValue("@_if_default_version", 1);
                            //ezCmd.Parameters.AddWithValue("@_state", "production");
                            //ezCmd.Parameters.AddWithValue("@_eq_usage", "equipment");
                            ezCmd.Parameters["@_step_id"].Value = DBNull.Value;

                            fields = lbMaterial1.Items[i].Text.Split(spliter, StringSplitOptions.None);
                            if (fields[3].Length != 0)
                            {
                                ezCmd.Parameters["@_emp_usage"].Value = fields[3];
                            }
                            else
                            {
                                ezCmd.Parameters["@_emp_usage"].Value = DBNull.Value;
                            }
                            if (fields[4].Length != 0)
                            {
                                ezCmd.Parameters["@_emp_id"].Value = fields[4];
                            }
                            else
                            {
                                ezCmd.Parameters["@_emp_id"].Value = DBNull.Value;
                            }

                            ezCmd.Parameters["@_name"].Value = fields[0];
                            ezCmd.Parameters["@_step_type_id"].Value = fields[1];
                            if (fields[2].Length != 0)
                            {
                                ezCmd.Parameters["@_eq_id"].Value = fields[2];
                            }
                            else
                            {
                                ezCmd.Parameters["@_eq_id"].Value = DBNull.Value;
                            }
                            if (fields[5].Length != 0)
                            {
                                ezCmd.Parameters["@_recipe_id"].Value = fields[5];
                            }
                            else
                            {
                                ezCmd.Parameters["@_recipe_id"].Value = DBNull.Value;
                            }
                            if (fields[6].Length != 0)
                            {
                                ezCmd.Parameters["@_mintime"].Value = fields[6];
                            }
                            else
                            {
                                ezCmd.Parameters["@_mintime"].Value = DBNull.Value;
                            }

                            if (fields[7].Length != 0)
                            {
                                ezCmd.Parameters["@_maxtime"].Value = fields[7];
                            }
                            else
                            {
                                ezCmd.Parameters["@_maxtime"].Value = DBNull.Value;
                            }

                            if (fields[8].Length != 0)
                            {
                                ezCmd.Parameters["@_description"].Value = fields[8];
                            }
                            else
                            {
                                ezCmd.Parameters["@_description"].Value = DBNull.Value;
                            }
                            if (fields[9].Length != 0)
                            {
                                ezCmd.Parameters["@_comment"].Value = fields[9];
                            }
                            else
                            {
                                ezCmd.Parameters["@_comment"].Value = DBNull.Value;
                            }
                            //string[] li = { "@_para1", "@_para2", "@_para3", "@_para4", "@_para5", "@_para6", "@_para7", "@_para8", "@_para9", "@_para10" };
                            int count = 0;
                            for(int k=10; k<20; k++)
                            {
                                if(fields[k].Length != 0)
                                {
                                    count++;
                                    ezCmd.Parameters[String.Concat("@_para",k-9)].Value = fields[k];
                                }
                                else
                                {
                                    ezCmd.Parameters[String.Concat("@_para", k-9)].Value = DBNull.Value;
                                }
                            }

                            ezCmd.Parameters["@_para_count"].Value = count;
                            ezCmd.Parameters["@_response"].Value = DBNull.Value;
                            ezCmd.ExecuteNonQuery();
                            response = ezCmd.Parameters["@_response"].Value.ToString();
                            if (response.Length > 0)
                            {
                                lblError.Text = response;
                                break;
                            }
                            else
                            {
                                lbMaterial1.Items[i].Value = ezCmd.Parameters["@_step_id"].Value.ToString();
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
            Server.Transfer("ProcessStepConfig.aspx");
        }
    }
}