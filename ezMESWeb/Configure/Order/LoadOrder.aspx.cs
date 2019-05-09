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
                catch (Exception  dtError)
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
                catch(Exception dtError) {
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
