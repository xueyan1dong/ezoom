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
    public partial class LoadOrder : LoadOrderBase
    {
        protected override string[] getHeader(string strFileSrc)
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

        //used to store valid order entries to ensure uniqueness of data entry
        protected List<string> m_lstOrders = new List<string>();

        protected override string verifyEntry(DataRow dataRow)
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
                return "Order Type is invalid. It must be SO, IO, or PO";

            //internal contact is required
            string strInternalContact = dataRow["Internal Contact UserName"].ToString();
            strInternalContact = strInternalContact.Trim();
            if (strInternalContact.Length == 0)
                return "Internal contact cannot be blank";

            int nEmployeeID = this.getEmployeeID(strInternalContact);
            if (nEmployeeID < 0)
                return "Internal contact does not exist";

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

        protected void btn_Click(object sender, EventArgs e)
        {
            //clear error and make some controls hidden
            txtError.Text = "";
            txtError.Visible = false;

            txtContent.Text = "";
            txtContent.Visible = false;
           
            lblUploadNote.Visible = false;
            btnSubmit.Visible = false;

            //verify file header
            bool bOK = true;

            string strResult = this.verifyFileExension(inputFile, "Order file");
            if (strResult.Length > 0)
            {
                this.addToTextBox(txtContent, strResult, false);
                txtContent.Height = 40;
                txtContent.Visible = true;

                bOK = false;
            }

            if (!bOK) return;

            //connect database
            ConnectToDb();

            //upload file
            m_lstOrders.Clear();

            if (!this.loadFile(inputFile, "Order file", lstContent, txtContent)) bOK = false;

            //any issues?
            lblUploadNote.Visible = bOK;
            btnSubmit.Visible = bOK;
            btnInsert.Visible = !bOK;

            ezConn.Dispose();
        }


        //used to stored order to reduce database operation
        protected Dictionary<string, string> m_orderID = new Dictionary<string, string>();
        protected override bool insertEntry(string strData)
        {
            Dictionary<string, string> data = this.convertToDict(strData);

            string strResult = "";
            bool bOK = this.InsertOrder(data, out strResult, ref m_orderID);

            txtError.Text = strResult;
            return bOK;
        }
  
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            txtError.Text = "";
            txtError.Visible = false;

            ConnectToDb();

            bool bOK;
            for (int i = 0; i < lstContent.Items.Count; i++)
            {
                bOK = this.insertEntry(lstContent.Items[i].Text);
            }

            ezConn.Dispose();

            //error?
            bOK = (txtError.Text.Length == 0);

            //go back to loading page
            if (bOK)
                Server.Transfer("LoadOrder.aspx");
            else
            {
                txtError.Visible = !bOK;
                btnInsert.Visible = !bOK;
                lblUploadNote.Visible = bOK;
                btnSubmit.Visible = bOK;
            }
        }
    }
}
