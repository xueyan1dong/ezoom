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
                    csvTable.Columns.Add(headers[i]);

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
                    return "supplier";

                case "IO":
                case "Inventory Order":
                    return "inventory";

                case "PO":
                case "Purchase Order":
                    return "customer";
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
    }
}
