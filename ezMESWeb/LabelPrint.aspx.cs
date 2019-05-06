/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : LbelPrint.aspx.cs
*    Created By             : Junlu Luo
*    Date Created           : 2018
*    Platform Dependencies  : .NET 2.0
*    Description            : UI for print batch/product packaging label. Currently invoked from Move Product Page or Dispatch page
*    Log: 
*    ?/?/2018: Junlu Luo: First created
*    05/06/2019: Xueyan Dong: Remove barcode for PO line # and move it to be the same line as PO number. Added Batch # and barcode of Batch #                     
----------------------------------------------------------------*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ezMESWeb
{
    public partial class LabelPrint : System.Web.UI.Page
    {
        protected global::System.Web.UI.HtmlControls.HtmlForm form1;
        protected global::System.Web.UI.WebControls.Label lblAddress1;
        protected global::System.Web.UI.WebControls.Label lblAddress2;
        protected global::System.Web.UI.WebControls.Label lblDate;
        protected global::System.Web.UI.WebControls.Label lblPONumber;
        protected global::System.Web.UI.WebControls.Image imgPONumber;
        protected global::System.Web.UI.WebControls.Label lblPOLine;
        protected global::System.Web.UI.WebControls.Label lblPieceCount;
        protected global::System.Web.UI.WebControls.Label lblItemNumber;
        protected global::System.Web.UI.WebControls.Image imgItemNumber;
        protected global::System.Web.UI.WebControls.Label lblFinish;
        protected global::System.Web.UI.WebControls.Button btnPrint;
        protected global::System.Web.UI.WebControls.Label lblSpace;
        protected global::System.Web.UI.WebControls.Button btnCancel;
        protected global::System.Web.UI.WebControls.Label lblBatch;
        protected global::System.Web.UI.WebControls.Image imgBatch;

    protected virtual void Page_Load(object sender, EventArgs e)
        {
            //add javascript for printing
            string strScript = this.getPrintJS();
            ClientScript.RegisterClientScriptBlock(this.GetType(),
                "PrintScript", strScript, true);

            strScript = this.getCancelJS();
            ClientScript.RegisterClientScriptBlock(this.GetType(),
                "CancelScript", strScript, true);

            //retrieve information
            string strAddress1 = Request.QueryString["address1"];
            string strAddress2 = Request.QueryString["address2"];
            string strPONumber = Request.QueryString["PO"];
            string strPOLineNumber = Request.QueryString["POLine"];
            string strPieceCount = Request.QueryString["piececnt"];
            string strItemNumber = Request.QueryString["itemnum"];
            string strFinish = Request.QueryString["finish"];
            string strBatch = Request.QueryString["batch"];

            //testing data
            strAddress1 = "595 Federal Road";
            strAddress2 = "Brookfield, CT 06804";

            //address
            lblAddress1.Text = strAddress1;
            lblAddress2.Text = strAddress2;

            //date
            lblDate.Text = DateTime.Now.ToString("MM/dd/yyyy");

            //po number
            lblPONumber.Text = strPONumber;
            imgPONumber.ImageUrl = this.getBarcodeLink(strPONumber, 250, 30, "Code 128-B");

            //po line number
            lblPOLine.Text = strPOLineNumber.Replace("_", "");

            //piece count
            lblPieceCount.Text = strPieceCount;

            //item number
            lblItemNumber.Text = strItemNumber;
            imgItemNumber.ImageUrl = this.getBarcodeLink(strItemNumber, 250, 30, "Code 128-B");

            //strFinish
            lblFinish.Text = strFinish;

            //batch number
            lblBatch.Text = strBatch;
            imgBatch.ImageUrl = this.getBarcodeLink(strBatch, 250, 30, "Code 128-B");
    }

        protected string getPrintJS()
        {
            string strScript = "function printHTMLString() {\r\n";
            strScript += "  var origDoc = document.body.innerHTML;\r\n";
            strScript += "  var newDoc = origDoc;\r\n";
            strScript += "  document.body.innerHTML = newDoc;\r\n";
            strScript += "  document.getElementById(\"blankLine1\").innerHTML = \"\";\r\n";
            strScript += "  document.getElementById(\"blankLine2\").innerHTML = \"\";\r\n";
            strScript += "  document.getElementById(\"blankLine3\").innerHTML = \"\";\r\n";
            strScript += "  window.print();\r\n";
            strScript += "  document.body.innerHTML = origDoc;\r\n";
            strScript += "}";

            return strScript;
        }

        protected string getCancelJS()
        {
            string strScript = "\r\n\r\n";
            strScript += "function cancelPrint() {\r\n";
            // strScript += "  window.close();\r\n";
            strScript += "window.history.back();\r\n";
            strScript += "}";

            return strScript;
        }

        protected string getBarcodeLink(string strText, int nWidth, int nHeight, string strBarcodeType)
        {
            string strLink = string.Format("/BarcodeImage.aspx?d={0}&h={1}&w={2}&il=false&t={3}",
                strText,
                nHeight,
                nWidth,
                strBarcodeType);

            return strLink;
        }
    }
}