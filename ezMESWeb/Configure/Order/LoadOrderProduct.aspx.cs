﻿using System;
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
    public partial class LoadOrderProduct : LoadOrderBase
    {

        protected override string[] getHeader(string strFileSrc)
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

        //used to temporarily store invalid data entry
        protected Dictionary<string, int> m_lstInvaclidProduct = new Dictionary<string, int>();

        //used to store valid product entries to ensure uniqueness of data entry
        protected List<string> m_lstProducts = new List<string>();

        protected override string verifyEntry(DataRow dataRow)
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
            int nID = this.getOrderID(nClientID, strPONumber, strOrderType);
            if (nID < 0)
            {
                strResult = string.Format("PO number \"{0}\" does not exist in order file", strPONumber);
                return strResult;
            }

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

            string strResult = this.verifyFileExension(inputFile, "Product file");
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
            if (!this.loadFile(inputFile, "Product file", lstContent, txtContent)) bOK = false;

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
            bool bOk = this.InsertOrderedProducts(data, strOrderID, out strResponse);

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
            for (int i = 0; i< lstContent.Items.Count; i++)
            {
                bOK = this.insertEntry(lstContent.Items[i].Text);
            }

            ezConn.Dispose();

            //error?
            bOK = (txtError.Text.Length == 0);

            //go back to loading page
            if (bOK)
                Server.Transfer("LoadOrderProduct.aspx");
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
