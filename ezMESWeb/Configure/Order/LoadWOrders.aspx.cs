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
    public partial class LoadWOrders : LoadOrderBase
    {

        protected override string[] getHeader(string strFileSrc)
        {
            string[] strColumns = {
                "Order Number",
                "Or Ty",
                "Line Number",
                "Business Unit",
                "Vendor Number",
                "Vendor Name",
                "Order Date",
                "Next Stat",
                "Buyer Number",
                "Buyer Name",
                "Item Number",
                "Item Description",
                "Ship To Number",
                "Ln Ty",
                "Last Stat",
                "Quantity Ordered",
                "Unit Cost",
                "Extended Price"
            };

            return strColumns;
        }

        //used to temporarily store invalid data entry
        protected Dictionary<string, int> m_lstInvaclidProduct = new Dictionary<string, int>();

        //used to store valid product entries to ensure uniqueness of data entry
        protected List<string> m_lstProducts = new List<string>();

        //used to store order number to reduce database operatons when verifying order existane
        protected List<string> m_lstOrders = new List<string>();

        protected override string verifyEntry(DataRow dataRow)
        {
            string strResult = "";

            //Client
            string strClient = "Waterworks";
            int nClientID = -1;
            strResult = this.verifyClient(strClient, ref nClientID);
            if (strResult.Length > 0) return strResult;

            //PO number
            string strPONumber = dataRow["Order Number"].ToString();
            strPONumber = strPONumber.Trim();
            if (strPONumber.Length == 0)
            {
                strResult = "Order number is empty";
                return strResult;
            }

            //order type
            string strOrderType, strOrderTypeEx;
            strOrderType = "customer";

            strOrderTypeEx = this.convertOrderType(strOrderType);
            if (strOrderTypeEx.Length == 0)
            {
                strResult = "Order type is invalid";
                return strResult;
            }

            //check to see if the PO number exists
            int nID;
            if (m_lstOrders.Contains(strPONumber) == false)
            {
                m_lstOrders.Add(strPONumber);

                nID = this.getOrderID(nClientID, strPONumber, strOrderType);
                if (nID >= 0)
                {
                    strResult = string.Format("Order number \"{0}\" already existed", strPONumber);
                    return strResult;
                }
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
                nProductID = this.getProductID(strProduct, strOrderType, ref strSourceType, "1");
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

            string strFileDesc = "Orders and ordered products file";
            string strResult = this.verifyFileExension(inputFile, strFileDesc);
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
            m_lstProducts.Clear();
            if (!this.loadFile(inputFile, strFileDesc, lstContent, txtContent)) bOK = false;

            //any issues?
            lblUploadNote.Visible = bOK;
            btnSubmit.Visible = bOK;
            btnInsert.Visible = !bOK;

            ezConn.Dispose();
        }

        //used to store aggragated order cost
        protected Dictionary<string, double> m_cost = new Dictionary<string, double>();
        protected void registCost(string strOrderID, string strPONumber, string strCost)
        {
            string strKey = strOrderID; // string.Format("{0}|{1}", strOrderID, strPONumber);
            double nCost = Convert.ToDouble(strCost);

            double nValue = 0.0;
            bool bOK = m_cost.TryGetValue(strKey, out nValue);
            if (!bOK) nValue = 0.0;

            nValue += nCost;

            if (bOK)
                m_cost[strKey] = nValue;
            else
                m_cost.Add(strKey, nValue);
        }

        protected void updateCost()
        {
            string strOrderID;
            double nValue;
            string strSQL;
            foreach(KeyValuePair<string, double> entry in m_cost)
            {
                strOrderID = entry.Key;
                nValue = entry.Value;

                strSQL = string.Format("UPDATE order_general SET net_total={0}, total_price={1} WHERE id={2}",
                    nValue, nValue,
                    strOrderID);

                try
                {
                    EzSqlCommand cmd = new EzSqlCommand();
                    cmd.Parameters.Clear();
                    cmd.Connection = ezConn;
                    cmd.CommandText = strSQL;
                    cmd.CommandType = CommandType.Text;

                    int nResult = cmd.ExecuteNonQuery();
                    cmd.Dispose();
                }
                catch (Exception ex)
                {
                    continue;
                }
            }
        }

       //used to stored order to reduce database operation
        protected Dictionary<string, string> m_orderID = new Dictionary<string, string>();

        protected override bool insertEntry(string strData)
        {
            Dictionary<string, string> data = this.convertToDict(strData);

            data.Add("Order Type", "customer");
            data.Add("Client", "Waterworks");
            data.Add("PO Number", data["Order Number"]);
            data.Add("Expected Delivery Date", "");
            data.Add("Comment", "");

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
                //insert order entry
                string strResult = "";

                data.Add("Priority", "Normal");
                data.Add("Order State", "POed");
                data.Add("State Date", data["Order Date"]);
                data.Add("Net Total", "0");
                data.Add("Tax Percentage", "0");
                data.Add("Tax Amount", "0");
                data.Add("Other Fees", "0");
                data.Add("Total Price", "0");
                data.Add("Internal Contact UserName", "admin");
                data.Add("External Contact", data["Vendor Name"]);

                data["Comment"] = "Order loaded from Load W Order page";
                this.InsertOrder(data, out strResult, ref m_orderID);

                bFound = m_orderID.TryGetValue(strKey, out strOrderID);
            }

            //register cost
            this.registCost(strOrderID, strPONumber, data["Extended Price"]);

            //prepare to insert product
            string strResponse = "";

            data.Add("Requested Quantity", data["Quantity Ordered"]);
            data.Add("Unit Price", data["Unit Cost"]);
            data.Add("Product Version", "1");
            data["Comment"] = "Order detail loaded from Load W Order page";
            data.Add("Unit of Measure", "Each");
            bool bOK = this.InsertOrderedProducts(data, strOrderID, out strResponse);

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
            for (int i = 0; i < lstContent.Items.Count; i++)
            {
                bOK = this.insertEntry(lstContent.Items[i].Text);
            }

            //update net_total of the newly inserted orders
            this.updateCost();

            ezConn.Dispose();

            //error?
            bOK = (txtError.Text.Length == 0);

            //go back to loading page
            if (bOK)
                Server.Transfer("LoadWOrders.aspx");
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
