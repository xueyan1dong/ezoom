using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LumenWorks.Framework.IO.Csv;
using System.IO;
using System.Data;

namespace ezMESWeb.Configure.Location
{
    public partial class LoadLocation : ConfigTemplate//System.Web.UI.Page
    {

        string[] cols = { "name", "parent_loc_id", "contact_employee", "adjacent_loc_id1", "adjacent_loc_id2", "adjacent_loc_id3", "adjacent_loc_id4", "description", "comment" };

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Click(object sender, EventArgs e)
        {
            DataRow newRow;
            string field = "";
            string itemContent = "";
            string loaded = "";
            lblError.Text = "";
            using (CsvReader csv = new CsvReader(new StreamReader(fuLoad.PostedFile.InputStream), true))
            {
                string[] headers = csv.GetFieldHeaders();
                DataTable csvTable = new DataTable();
                for(int i=0; i<headers.Length; i++)
                {
                    csvTable.Columns.Add(headers[i]);
                }
                while (csv.ReadNextRecord())
                {
                    newRow = csvTable.NewRow();
                    for(int i=0; i<headers.Length; i++)
                    {
                        newRow[i] = csv[i];
                    }
                    csvTable.Rows.Add(newRow);
                }
                //preview
                for(int j=0; j < csvTable.Rows.Count; j++)
                {
                    itemContent += "Location " + (j+1) + ":\n";
                    for(int k=0; k<cols.Length; k++)
                    {
                        try
                        {
                            field = csvTable.Rows[j][cols[k].ToString()].ToString();
                        }catch(Exception ex)
                        {
                            lblError.Text = ex.Message;
                        }
                        itemContent += cols[k].ToString() + ": " + field + "\n";
                        loaded += cols[k].ToString() + ":" + field + ";";
                    }
                 
                    itemContent += "\n";
                    loaded += "|";
                    
                }
                txtContent.Text = itemContent;
                lblLoaded.Text = loaded;
            }

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string response;
            try
            {
                lblErrorSubmit.Text = "";
                ConnectToDb();
                ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "modify_location";
                ezCmd.CommandType = CommandType.StoredProcedure;
                
                //name:x;parent_loc_id:x;...|name:x; ;
                string[] locations = lblLoaded.Text.Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries);
                int n = locations.Length;
                for (int i = 0; i < locations.Length; i++)
                {
                    ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value, ParameterDirection.InputOutput);
                    string[] fields = locations[i].Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                    for (int j = 0; j < fields.Length; j++)
                    {
                        string[] field = fields[j].Split(new string[] { ":" }, StringSplitOptions.RemoveEmptyEntries);
                        string key = "@_"+ field[0];
                        string val = field[1];
                        if (val.Length == 0)
                        {
                            ezCmd.Parameters.AddWithValue(key, DBNull.Value, ParameterDirection.Input);
                            //ezCmd.Parameters[key.ToString()].Value = DBNull.Value;
                        }
                        else
                        {
                            ezCmd.Parameters.AddWithValue(key, val, ParameterDirection.Input);
                            //ezCmd.Parameters[key.ToString()].Value = val;
                        }
                    }
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);
                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    if (response.Length > 0)
                    {
                        lblErrorSubmit.Text = response;
                        break;
                    }
                    ezCmd.Parameters.Clear();
                }

            }
            catch(Exception ex)
            {
                lblErrorSubmit.Text = ex.Message;
            }
            ezCmd.Dispose();
            ezConn.Dispose();
            if (lblErrorSubmit.Text.Length == 0)
            {
                MessagePopupExtender.Show();
            }
        }


        protected void txtContent_TextChanged(object sender, EventArgs e)
        {

        }
        protected void btnLocForm_Click(object sender, EventArgs e)
        {
            MessagePopupExtender.Hide();
            Server.Transfer("LocationConfigure.aspx");
        }
    }
}