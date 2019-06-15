/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : LoadOrderBase.aspx.cs
*    Created By             : Junlu Luo
*    Date Created           : 2019
*    Platform Dependencies  : .NET 
*    Description            : UI for loading order header from csv file
*    Log                    :
*    ??/??/2019: Junlu Luo: first created
*    05/10/2019: Xueyan Dong: Corrected order_type translation
----------------------------------------------------------------*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;
using System.Data;
using CommonLib.Data.EzSqlClient;
using System.Data.Common;
using LumenWorks.Framework.IO.Csv;
using System.IO;


namespace ezMESWeb.Configure.Order
{
    public abstract class LoadOrderBase : ConfigTemplate
    {
        protected string verifyFileExension(FileUpload fileCtrl, string fileSrc)
        {
            string strResult = "";

            string strFileName = fileCtrl.PostedFile.FileName;
            string strExt = System.IO.Path.GetExtension(strFileName);
            if (strExt != ".csv")
                strResult = string.Format("{0} requires a csv file.",
                    fileCtrl.PostedFile.FileName);

            return strResult;
        }

        protected string verifyFileHeader(DataTable csv, string strFileSrc)
        {
            string strResult = "";

            string[] strColumns = this.getHeader(strFileSrc);

            //compare columns count
            if (csv.Columns.Count != strColumns.Length)
            {
                strResult = string.Format("{0} has {1} columns, but expects {2}.",
                    strFileSrc,
                    csv.Columns.Count,
                    strColumns.Length);

                return strResult;
            }

            for (int i = 0; i < strColumns.Length; i++)
            {
                if (csv.Columns.Contains(strColumns[i])) continue;

                strResult = string.Format("Column {0} is not found in {1}.",
                    strColumns[i],
                    strFileSrc);

                return strResult;
            }

            return "";
        }

        protected void addToTextBox(TextBox txtBox, string strText, bool bSeparatorNeeded)
        {
            strText = strText.Trim();

            if (txtBox.Text.Length > 0) txtBox.Text += "\r\n";

            //separator needed
            if (bSeparatorNeeded)
            {
                //add two empty lines if there is content alread
                if (txtBox.Text.Length > 0) txtBox.Text += "\r\n";

                txtBox.Text += "========================================================================================\r\n";
            }

            txtBox.Text += strText;
        }

        //used to temporarily store invalid data entry
        protected List<string> m_lstInvalidClient = new List<string>();

        protected string verifyClient(string strClient, ref int nClientID)
        {
            nClientID = -1;
            string strResult = "";

            if (strClient.Length == 0)
            {
                strResult = "Client is empty";
                return strResult;
            }

            //check existance of the client
            bool bInvalid = m_lstInvalidClient.Contains(strClient);

            //get client id from database
            if (!bInvalid)
            {
                nClientID = this.getClientID(strClient);
                bInvalid = (nClientID == -1);
            }

            if (bInvalid)
            {
                strResult = string.Format("Client \"{0}\" does not exist", strClient);

                //save for late use to avoid repeat database query
                m_lstInvalidClient.Add(strClient);

                return strResult;
            }

            return "";
        }

        protected bool loadFile(FileUpload fileCtrl, string strFileSrc, ListBox lstData, TextBox txtBox)
        {
            DataRow newRow;
            DataTable csvTable = new DataTable();

            //clear data holders
            txtBox.Text = "";
            lstData.Items.Clear();
            m_lstInvalidClient.Clear();

            //file name
            this.addToTextBox(txtBox, fileCtrl.PostedFile.FileName, false);

            using (CsvReader csv = new CsvReader(new StreamReader(fileCtrl.PostedFile.InputStream), true))
            {
                //header
                string[] headers = csv.GetFieldHeaders();

                for (int i = 0; i < headers.Length; i++)
                {
                    //double white spaces
                    headers[i] = headers[i].Replace("  ", " ");

                    csvTable.Columns.Add(headers[i]);
                }
                //verify header
                string strResult = this.verifyFileHeader(csvTable, strFileSrc);
                if (strResult.Length > 0)
                {
                    this.addToTextBox(txtBox, strResult, false);
                    txtBox.Height = 40;
                    txtBox.Visible = true;
                    return false;
                }

                //read content one at a time
                while (csv.ReadNextRecord())
                {
                    newRow = csvTable.NewRow();
                    for (int i = 0; i < headers.Length; i++)
                    {
                        newRow[i] = csv[i];
                    }
                    csvTable.Rows.Add(newRow);
                }
            }

            //
            bool bResult = true;
            lstData.Items.Clear();

            //use a list to store invalid client to avoid repeated querying database

            string strValue, strField, strText;
            string strData, strDisplayRow, strError;
            string[] header = this.getHeader(strFileSrc);
            bool bValid;
            for (int i = 0; i < csvTable.Rows.Count; i++)
            {
                //start a new row for data passing
                strError = this.verifyEntry(csvTable.Rows[i]);
                bValid = (strError.Length == 0);

                //process data               
                strData = "";
                strDisplayRow = "";

                for (int j = 0; j < header.Length; j++)
                {
                    strField = header[j];
                    strValue = csvTable.Rows[i][strField].ToString();
                    strValue = strValue.Trim();

                    //for display
                    strText = strField + ": " + strValue;
                    if (j > 0) strDisplayRow += "\r\n";
                    strDisplayRow += strText;

                    //for data passing to next stage
                    if (j > 0) strData += "||";
                    strData += strText;

                }

                //display text
                if (strError.Length > 0)
                {
                    strDisplayRow = string.Format("ERROR: {0}\r\n\r\n{1}", strError, strDisplayRow);

                    //result
                    bResult = false;
                }
                this.addToTextBox(txtBox, strDisplayRow, true);

                //skip if entry is invalid
                if (bValid)
                    lstData.Items.Add(strData);
            }

            //preview file content
            txtBox.Height = 300;
            txtBox.Visible = true;

            return bResult;
        }

        protected int getID(string strSQL)
        {
            //ConnectToDb();
            EzSqlCommand cmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            cmd.Parameters.Clear();
            cmd.Connection = ezConn;
            cmd.CommandText = strSQL;
            cmd.CommandType = CommandType.Text;

            int nID = -1;
            DbDataReader reader = cmd.ExecuteReader();
            bool bOK = reader.Read();
            if (bOK) nID = reader.GetInt32(0);
            reader.Close();

            cmd.Dispose();
            //ezConn.Dispose();

            return nID;
        }

        protected int getOrderID(int nClientID, string strPONumber, string strOrderType)
        {
            strOrderType = this.convertOrderType(strOrderType);

            //check uniqueness of the entry
            string strSQL = string.Format("SELECT ID FROM ORDER_GENERAL WHERE ORDER_TYPE=\"{0}\" AND CLIENT_ID={1} AND PONUMBER=\"{2}\"",
                strOrderType,
                nClientID,
                strPONumber);

            int nID = this.getID(strSQL);
            return nID;
        }

        //
        protected int getClientID(string strClient)
        {
            strClient = strClient.Trim();
            if (strClient.Length == 0) return -1;

            string strSQL = string.Format("SELECT ID FROM CLIENT WHERE NAME=\"{0}\"", strClient);

            int nID = this.getID(strSQL);
            return nID;
        }

        //convert row data to dictionary for random access
        protected Dictionary<string, string> convertToDict(string strData)
        {
            Dictionary<string, string> dict = new Dictionary<string, string>();

            string[] delimiter = { "||", ":" };
            string[] strFields = strData.Split(delimiter, StringSplitOptions.None);

            string strField, strValue;
            for (int i = 0; i < strFields.Length; i = i + 2)
            {
                strField = strFields[i];
                strValue = strFields[i + 1];

                dict.Add(strField, strValue.Trim());
            }

            return dict;
        }

        protected string convertOrderType(string strType)
        {
            switch (strType)
            {
                case "SO":
                case "Sales Order":
                case "customer":
                    return "customer";

                case "IO":
                case "Inventory Order":
                case "inventory":
                    return "inventory";

                case "PO":
                case "Purchase Order":
                case "supplier":
                    return "supplier";
            }

            return "";
        }


        //abstract methods that child classes must implement
        protected abstract string[] getHeader(string strFileSrc);
        protected abstract string verifyEntry(DataRow dataRow);
        protected abstract bool insertEntry(string strData);

        protected void txtContent_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnInvForm_Click(object sender, EventArgs e)
        {
            //        MessagePopupExtender.Hide();
            //        Server.Transfer("InventoryConfig.aspx");
        }

        protected int getPriorityID(string strPriority)
        {
            if (strPriority.Length == 0) return 1;

            string strSQL = string.Format("SELECT ID FROM PRIORITY WHERE NAME=\"{0}\"", strPriority);

            return this.getID(strSQL);
        }

        protected int getEmployeeID(string strUserName)
        {
            if (strUserName.Length == 0) return -1;

            string strSQL = string.Format("SELECT ID FROM EMPLOYEE WHERE USERNAME=\"{0}\" OR CONCAT(FIRSTNAME, \" \", LASTNAME) = \"{0}\"", strUserName);

            return this.getID(strSQL);
        }

        protected bool InsertOrder(Dictionary<string, string> data, out string strResult, ref Dictionary<string, string> orders)
        {
            strResult = "";

            try
            {
                EzSqlCommand cmd = new EzSqlCommand();
                cmd.Parameters.Clear();
                cmd.Connection = ezConn;
                cmd.CommandText = "insert_order_general";
                cmd.CommandType = CommandType.StoredProcedure;

                //order type
                string strValue = data["Order Type"];
                string strOrderType = strValue;
                strValue = this.convertOrderType(strValue);
                cmd.Parameters.AddWithValue("@_order_type", strValue);

                //po number
                string strPONumber = data["PO Number"];
                cmd.Parameters.AddWithValue("@_ponumber", strPONumber);

                //client id
                strValue = data["Client"];
                string strClient = strValue;
                int nClientID = this.getClientID(strValue);
                cmd.Parameters.AddWithValue("@_client_id", nClientID);

                //priority
                strValue = data["Priority"];
                int nPriorityID = this.getPriorityID(strValue);
                cmd.Parameters.AddWithValue("@_priority", nPriorityID);

                //order state
                strValue = data["Order State"];
                cmd.Parameters.AddWithValue("@_state", strValue);


                //state date
                strValue = data["State Date"];
                DateTime dtValue;
                try
                {
                    dtValue = Convert.ToDateTime(strValue);
                    cmd.Parameters.AddWithValue("@_state_date", dtValue);
                }
                catch (Exception dtError)
                {
                    cmd.Parameters.AddWithValue("@_state_date", DBNull.Value);
                }

                //net total
                strValue = data["Net Total"];
                Decimal dValue = Convert.ToDecimal(strValue);
                cmd.Parameters.AddWithValue("@_net_total", strValue);

                //tax percentage
                strValue = data["Tax Percentage"];
                int nTaxPercentage = Convert.ToInt16(strValue);
                cmd.Parameters.AddWithValue("@_tax_percentage", strValue);

                //tax amount
                strValue = data["Tax Amount"];
                dValue = Convert.ToDecimal(strValue);
                cmd.Parameters.AddWithValue("@_tax_amount", strValue);

                //other fees
                strValue = data["Other Fees"];
                dValue = Convert.ToDecimal(strValue);
                cmd.Parameters.AddWithValue("@_other_fees", strValue);

                //total price
                strValue = data["Total Price"];
                dValue = Convert.ToDecimal(strValue);
                cmd.Parameters.AddWithValue("@_total_price", strValue);

                //expected delivery date
                strValue = data["Expected Delivery Date"];
                try
                {
                    dtValue = Convert.ToDateTime(strValue);
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", dtValue);
                }
                catch (Exception dtError)
                {
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);
                }

                //internal contact
                strValue = data["Internal Contact UserName"];
                int nEmployeeID = this.getEmployeeID(strValue);
                if (nEmployeeID < 0)
                    cmd.Parameters.AddWithValue("@_internal_contact", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@_internal_contact", nEmployeeID);

                //external contact
                strValue = data["External Contact"];
                cmd.Parameters.AddWithValue("@_external_contact", strValue);

                //current user
                int nUserID = Convert.ToInt32(Session["UserID"]);
                cmd.Parameters.AddWithValue("@_recorder_id", nUserID);

                //comment
                strValue = data["Comment"];
                cmd.Parameters.AddWithValue("@_comment", strValue);

                //output parameters
                cmd.Parameters.AddWithValue("@_order_id", DBNull.Value);
                cmd.Parameters["@_order_id"].Direction = ParameterDirection.Output;
                cmd.Parameters.AddWithValue("@_response", DBNull.Value);
                cmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                cmd.ExecuteNonQuery();
                string response = cmd.Parameters["@_response"].Value.ToString();

                string strOrderID = "";
                if (response.Length > 0)
                {
                    strResult = response;
                }
                else
                {
                    object result = cmd.Parameters["@_order_id"].Value;
                    if (result.GetType().ToString().Contains("System.Byte"))
                    {
                        System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                        strOrderID = asi.GetString((byte[])result);
                    }
                    else
                    {
                        strOrderID = result.ToString();
                    }

                    //keep order ID for product insertion
                    string strKey = string.Format("{0}|{1}{2}", strClient, strPONumber, strOrderType);
                    orders.Add(strKey, strOrderID);
                }
                cmd.Dispose();
            }
            catch (Exception ex)
            {
                strResult = ex.Message;
                return false;
            }

            return true;
        }

        protected int getProductID(string strProduct, string strOrderType, ref string strSourceType, string strProductVersion = "")
        {
            strSourceType = "";
            strProduct = strProduct.Trim();
            if (strProduct.Length == 0) return -1;

            //table name
            strSourceType = "product";
            string strClause = "";
            if (strProductVersion.Length > 0)
                strClause = string.Format(" AND VERSION = {0}", strProductVersion);

            strOrderType = this.convertOrderType(strOrderType);
            if (strOrderType == "supplier")
            {
                strSourceType = "material";
                strClause = "";
            }

            string strSQL = string.Format("SELECT ID FROM {0} WHERE NAME=\"{1}\"{2}",
                strSourceType,
                strProduct,
                strClause);

            return this.getID(strSQL);
        }

        protected int getUOMID(string strUOM)
        {
            if (strUOM.Length == 0) return 1;

            string strSQL = string.Format("SELECT ID FROM UOM WHERE NAME=\"{0}\"", strUOM);
            int nID = this.getID(strSQL);
            if (nID < 0) nID = 1;

            return nID;
        }

        protected bool InsertOrderedProducts(Dictionary<string, string> data, string strOrderID, out string strResult)
        {
            strResult = "";
            try
            {
                EzSqlCommand cmd = new EzSqlCommand();
                cmd.Parameters.Clear();

                cmd.Connection = ezConn;
                cmd.CommandText = "modify_order_detail";
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@_operation", "insert");

                //order id
                cmd.Parameters.AddWithValue("@_order_id", strOrderID);

                //order type
                string strOrderType = data["Order Type"];

                //item number
                string strValue = data["Item Number"];
                string strProductVersion = "";
                if (!data.TryGetValue("Product Version", out strProductVersion)) strProductVersion = "";

                string strSourceType = "";
                int nProductID = this.getProductID(strValue, strOrderType, ref strSourceType, strProductVersion);
                cmd.Parameters.AddWithValue("@_source_type", strSourceType);
                cmd.Parameters.AddWithValue("@_source_id", nProductID);

                //line number
                strValue = data["Line Number"];
                cmd.Parameters.AddWithValue("@_line_num", strValue);

                //requested quantity
                strValue = data["Requested Quantity"];
                cmd.Parameters.AddWithValue("@_quantity_requested", strValue);

                //unit price
                strValue = data["Unit Price"];
                cmd.Parameters.AddWithValue("@_unit_price", strValue);

                //quantity made
                cmd.Parameters.AddWithValue("@_quantity_made", 0);

                //quantity in progress
                cmd.Parameters.AddWithValue("@_quantity_in_process", 0);

                //quantity shipped
                cmd.Parameters.AddWithValue("@_quantity_shipped", 0);

                //output date
                cmd.Parameters.AddWithValue("@_output_date", DBNull.Value);

                //expected delivery date
                strValue = data["Expected Delivery Date"];
                try
                {
                    DateTime dtValue;
                    dtValue = Convert.ToDateTime(strValue);
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", dtValue);
                }
                catch (Exception dtError)
                {
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);
                }

                //actually delivery date
                cmd.Parameters.AddWithValue("@_actual_deliver_date", DBNull.Value);

                //recorder id
                cmd.Parameters.AddWithValue("@_recorder_id", Convert.ToInt32(Session["UserID"]));

                //comment
                strValue = data["Comment"];
                cmd.Parameters.AddWithValue("@_comment", strValue);

                //uomid
                strValue = data["Unit of Measure"];
                int nUOMID = this.getUOMID(strValue);
                cmd.Parameters.AddWithValue("@_uomid", nUOMID);

                //output parameters
                cmd.Parameters.AddWithValue("@_response", DBNull.Value);
                cmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                //execute query
                cmd.ExecuteNonQuery();

                strResult = cmd.Parameters["@_response"].Value.ToString();

                cmd.Dispose();
            }
            catch (Exception exc)
            {
                strResult = exc.Message;
                return false;
            }

            return true;
        }
    }
}
