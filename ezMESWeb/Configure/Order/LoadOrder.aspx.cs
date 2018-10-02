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
    public partial class LoadOrder : ConfigTemplate
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

        protected string[] getHeader(string strFileSrc)
        {
            if (strFileSrc == "Order file")
            {
                string[] strColumns = {
                    "Client",
                    "PO Number",
                    "Order Type",
                    "Order State",
                    "State Date",
                    "Priority",
                    "Net Total",
                    "Tax Percentage",
                    "Tax Amount",
                    "Other Fees",
                    "Total Price",
                    "Expected Delivery Date",
                    "Internal Contact UserName",
                    "External Contact",
                    "Comment"
                };

                return strColumns;
            }

            if (strFileSrc == "Product file")
            {
                string[] strColumns = {
                    "Client",
                    "PO Number",
                    "Order Type",
                    "Line Number",
                    "Item Number",
                    "Requested Quantity",
                    "Unit Price",
                    "Unit of Measure",
                    "Expected Delivery Date",
                    "Comment"
                };

                return strColumns;
            }

            return null;
        }

        protected string verifyOrderFileHeader(DataTable csv, string strFileSrc)
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

                txtBox.Text += "========================================================================================";
            }

            txtBox.Text += strText;
        }

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

        //used to temporarily store invalid data entry
        protected List<string> m_lstInvalidClient = new List<string>();

        //used to temporarily store invalid data entry
        protected Dictionary<string, int> m_lstInvaclidProduct = new Dictionary<string, int>();

        //used to store valid order entries to ensure uniqueness of data entry
        protected List<string> m_lstOrders = new List<string>();

        //used to store valid product entries to ensure uniqueness of data entry
        protected List<string> m_lstProducts = new List<string>();
        protected string verifyOrderEntry(DataRow dataRow)
        {
            string strResult = "";

            string strClient = dataRow["Client"].ToString();
            strClient = strClient.Trim();
            int nClientID = -1;
            strResult = this.verifyClient(strClient, ref nClientID);
            if (strResult.Length > 0) return strResult;
            
            //po number
            string strPONumber = dataRow["PO Number"].ToString();
            strPONumber = strPONumber.Trim();
            if (strPONumber.Length == 0)
                return "PO Number is empty";

            //order type
            string strOrderType = dataRow["Order Type"].ToString();
            strOrderType = strOrderType.Trim();
            string strOrderTypeEx = this.convertOrderType(strOrderType);
            if (strOrderTypeEx.Length == 0)
                return "Order Type is invalid";

            //check uniqueness of the entry
            int nID = this.getOrderID(nClientID, strPONumber, strOrderType);
            if (nID != -1)
            {
                strResult = string.Format("{0} {1} {2} already in database",
                    strClient, 
                    strPONumber,
                    strOrderType);

                return strResult;
            }

            //already in the previous row?
            string strEntry = string.Format("{0}|{1}|{2}", strPONumber, strOrderType, strClient);
            if (m_lstOrders.Contains(strEntry))
            {
                strResult = string.Format("{0} {1} {2} duplicate in file",
                    strClient,
                    strPONumber, 
                    strOrderType);
                return strResult;
            }

            //store entry
            m_lstOrders.Add(strEntry);
            return "";
        }

        protected string verifyProductEntry(DataRow dataRow)
        {
            string strResult = "";

            //Client
            string strClient = dataRow["Client"].ToString();
            strClient = strClient.Trim();
            int nClientID = -1;
            strResult = this.verifyClient(strClient, ref nClientID);
            if (strResult.Length > 0) return strResult;

            //PO number
            string strPONumber = dataRow["PO Number"].ToString();
            strPONumber = strPONumber.Trim();
            if (strPONumber.Length == 0)
            {
                strResult = "PO number is empty";
                return strResult;
            }

            //order type
            string strOrderType, strOrderTypeEx;
            strOrderType = dataRow["Order Type"].ToString();
            strOrderType = strOrderType.Trim();

            strOrderTypeEx = this.convertOrderType(strOrderType);
            if (strOrderTypeEx.Length == 0)
            {
                strResult = "Order type is invalid";
                return strResult;
            }

            //verify product existance
            string strProduct = dataRow["Item Number"].ToString();
            strProduct = strProduct.Trim();
            if (strProduct.Length == 0)
            {
                strResult = "Item number is empty";
                return strResult;
            }

            //retrieve line number
            string strLineNumber = dataRow["Line Number"].ToString();
            strLineNumber = strLineNumber.Trim();

            string strEntry = string.Format("{0}|{1}", strProduct, strOrderType);
            int nProductID = -1;
            bool bInvalid = m_lstInvaclidProduct.TryGetValue(strEntry, out nProductID);
            string strSourceType = "";

            if (!bInvalid)
            {
                nProductID = this.getProductID(strProduct, strOrderType, ref strSourceType);
                bInvalid = (nProductID == -1);
            }
            if (bInvalid)
            {
                strResult = string.Format("Item number \"{0}\" does not exist", strProduct);

                //save for late use to avoid repeat database query
                if (strSourceType.Length > 0)
                {
                    strResult += " (" + strSourceType + ")";

                    m_lstInvaclidProduct.Add(strEntry, nProductID);
                }

                return strResult;
            }

            //check to see if they PO number exists
            strEntry = string.Format("{0}|{1}|{2}", strPONumber, strOrderType, strClient);
            bool bFound = false;
            for (int i = 0; i < m_lstOrders.Count; i++)
            {
                if (m_lstOrders[i].Contains(strEntry))
                {
                    bFound = true;
                    break;
                }
            }

            //if not found in order.csv file, try database
            if (!bFound)
            {
                int nID = this.getOrderID(nClientID, strPONumber, strOrderType);
                bFound = (nID >= 0);

                //now check to see if the item is alredy part of the order
                string strSQL = string.Format("SELECT ORDER_ID FROM ORDER_DETAIL WHERE ORDER_ID={0} AND SOURCE_TYPE=\"{1}\" AND SOURCE_ID={2} AND LINE_NUM={3}",
                    nID,
                    strSourceType,
                    nProductID,
                    strLineNumber);

                nID = this.getID(strSQL);
                if (nID >= 0)
                {
                    strResult = string.Format("Item number \"{0}\" is alredy part of the order", strProduct);
                    return strResult;
                }
            }

            if (!bFound)
            {
                strResult = string.Format("PO number \"{0}\" does not exist in order file", strPONumber);
                return strResult;
            }

            //duplicate
            strEntry = string.Format("{0}|{1}|{2}|{3}{4}",
                strClient,
                strPONumber, 
                strOrderType,
                strProduct,
                strLineNumber);
            if (m_lstProducts.Contains(strEntry))
            {
                strResult = "Duplicate entry found in file";
                return strResult;
            }

            //add to list
            m_lstProducts.Add(strEntry);
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
            m_lstInvaclidProduct.Clear();

            //file name
            this.addToTextBox(txtBox, fileCtrl.PostedFile.FileName, false);

            using (CsvReader csv = new CsvReader(new StreamReader(fileCtrl.PostedFile.InputStream), true))
            {
                //header
                string[] headers = csv.GetFieldHeaders();

                for (int i = 0; i < headers.Length; i++)
                    csvTable.Columns.Add(headers[i]);

                //verify header
                string strResult = this.verifyOrderFileHeader(csvTable, strFileSrc);
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
                strError = "";
                if (strFileSrc == "Order file")
                    strError = this.verifyOrderEntry(csvTable.Rows[i]);
                if (strFileSrc == "Product file")
                    strError = this.verifyProductEntry(csvTable.Rows[i]);

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

        protected int getProductID(string strProduct, string strOrderType, ref string strSourceType)
        {
            strSourceType = "";
            strProduct = strProduct.Trim();
            if (strProduct.Length == 0) return -1;

            //table name
            strSourceType = "product";

            strOrderType = this.convertOrderType(strOrderType);
            if (strOrderType == "supplier") strSourceType = "material";
           
            string strSQL = string.Format("SELECT ID FROM {0} WHERE NAME=\"{1}\"", strSourceType, strProduct);

            return this.getID(strSQL);
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

            string strSQL = string.Format("SELECT ID FROM EMPLOYEE WHERE USERNAME=\"{0}\"", strUserName);

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
        protected void btn_Click(object sender, EventArgs e)
        {
            //clear error and make some controls hidden
            txtError.Text = "";
            txtError.Visible = false;

            txtOrder.Text = "";
            txtOrder.Visible = false;

            txtProduct.Text = "";
            txtProduct.Visible = false;
            
            lblUploadNote.Visible = false;
            btnSubmit.Visible = false;

            //verify file header
            bool bOK = true;

            string strResult = this.verifyFileExension(orderFile, "Order file");
            if (strResult.Length > 0)
            {
                this.addToTextBox(txtOrder, strResult, false);
                txtOrder.Height = 40;
                txtOrder.Visible = true;

                bOK = false;
            }

            strResult = this.verifyFileExension(prodFile, "Product file");
            if (strResult.Length > 0)
            {
                this.addToTextBox(txtProduct, strResult, false);
                txtProduct.Height = 40;
                txtProduct.Visible = true;

                bOK = false;
            }
            if (!bOK) return;

            //connect database
            ConnectToDb();

            //upload file
            m_lstOrders.Clear();

            if (!this.loadFile(orderFile, "Order file", lstOrder, txtOrder)) bOK = false;

            m_lstProducts.Clear();
            if (!this.loadFile(prodFile, "Product file", lstProduct, txtProduct)) bOK = false;

            //any issues?
            lblUploadNote.Visible = bOK;
            btnSubmit.Visible = bOK;
            btnInsert.Visible = !bOK;

            ezConn.Dispose();
        }


        //upload data to database
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
                    return "supplier";

                case "IO":
                    return "inventory";
                case "PO":
                    return "customer";
            }

            return strType;
        }

        //used to stored order to reduce database operation
        protected Dictionary<string, string> m_orderID = new Dictionary<string, string>();
        protected bool insertOrder(string strData)
        {
            Dictionary<string, string> data = this.convertToDict(strData);

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
                DateTime dtValue = Convert.ToDateTime(strValue);
                cmd.Parameters.AddWithValue("@_state_date", dtValue);

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
                dtValue = Convert.ToDateTime(strValue);
                cmd.Parameters.AddWithValue("@_expected_deliver_date", dtValue);

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
                    txtError.Text = response;
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
                }
                cmd.Dispose();

                //keep order ID for product insertion
                string strKey = string.Format("{0}|{1}{2}", strClient, strPONumber, strOrderType);
                m_orderID.Add(strKey, strOrderID);
            }
            catch (Exception ex)
            {
                txtError.Text = ex.Message;
            }

            return true;
        }
        
        protected bool insertProduct(string strData)
        {
            Dictionary<string, string> data = this.convertToDict(strData);

            //retrieve order id from database
            string strPONumber = data["PO Number"];
            string strOrderType = data["Order Type"];
            string strClient = data["Client"];
            string strKey = string.Format("{0}|{1}{2}", strClient, strPONumber, strOrderType);
            string strOrderID = "";
            bool bFound = m_orderID.TryGetValue(strKey, out strOrderID);

            //retrieve from database
            if (!bFound)
            {
                int nClientID = this.getClientID(strClient);
                int nOrderID = this.getOrderID(nClientID, strPONumber, strOrderType);
                strOrderID = string.Format("{0}", nOrderID);

                //add to dictionary for potential later reference
                m_orderID.Add(strKey, strOrderID);
            }

            string strResponse = "";
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
                strOrderType = data["Order Type"];

                //item number
                string strValue = data["Item Number"];
                string strSourceType = "";
                int nProductID = this.getProductID(strValue, strOrderType, ref strSourceType);
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
                if (strValue.Length == 0)
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@_expected_deliver_date", strValue);

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

                strResponse = cmd.Parameters["@_response"].Value.ToString();

                cmd.Dispose();
            }
            catch (Exception exc)
            {
                strResponse = exc.Message;
            }

            if (strResponse.Length > 0)
            {
                txtError.Text = strResponse;
                return false;
            }

            return true;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            txtError.Text = "";
            txtError.Visible = false;

            ConnectToDb();

            bool bOK;
            for (int i = 0; i < lstOrder.Items.Count; i++)
            {
                bOK = this.insertOrder(lstOrder.Items[i].Text);
            }

            for (int i = 0; i< lstProduct.Items.Count; i++)
            {
                bOK = this.insertProduct(lstProduct.Items[i].Text);
            }

            ezConn.Dispose();

            //error?
            bOK = (txtError.Text.Length == 0);
            txtError.Visible = (!bOK);

            //go back to loading page
            Server.Transfer("LoadOrder.aspx");
        }

        protected void txtContent_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnInvForm_Click(object sender, EventArgs e)
        {
    //        MessagePopupExtender.Hide();
    //        Server.Transfer("InventoryConfig.aspx");
        }
    }
}
