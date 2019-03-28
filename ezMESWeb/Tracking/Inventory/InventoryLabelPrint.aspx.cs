using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ezMESWeb
{
    public partial class InventoryLabelPrint : LabelPrint
    {
        protected global::System.Web.UI.WebControls.Label lblInventoryID;
        protected global::System.Web.UI.WebControls.Image imgInventoryID;
        protected global::System.Web.UI.WebControls.Label lblType;
        protected global::System.Web.UI.WebControls.Label lblName;
        protected global::System.Web.UI.WebControls.Label lblSupplier;
        protected global::System.Web.UI.WebControls.Label lblBatchID;
        protected global::System.Web.UI.WebControls.Image imgBatchID;
        protected global::System.Web.UI.WebControls.Label lblSerialNumber;
        protected global::System.Web.UI.WebControls.Image imgSerialNumber;
		
        protected override void Page_Load(object sender, EventArgs e)
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
            string strInventoryID = Request.QueryString["InventoryID"];
            string strType = Request.QueryString["Type"];
            string strName = Request.QueryString["Name"];
            string strSupplier = Request.QueryString["Supplier"];
            string strBatchID = Request.QueryString["BatchID"];
            string strSerialNumber = Request.QueryString["SerialNumber"];

            //testing data
            strAddress1 = "595 Federal Road";
            strAddress2 = "Brookfield, CT 06804";

            //address
            lblAddress1.Text = strAddress1;
            lblAddress2.Text = strAddress2;

            //date
            lblDate.Text = DateTime.Now.ToString("MM/dd/yyyy");

            //inventoryID
            lblInventoryID.Text = strInventoryID;
            imgInventoryID.ImageUrl = this.getBarcodeLink(strInventoryID, 250, 30, "Code 128-B");
            
            //name and type
            lblName.Text = strName;
            lblType.Text = strType;

            //supplier
            lblSupplier.Text = strSupplier;

            //batch id
            lblBatchID.Text = strBatchID;
            imgBatchID.ImageUrl = this.getBarcodeLink(strBatchID, 350, 30, "Code 128-B");
            if (strBatchID.Length == 0) imgBatchID.Visible = false;

            //serial number
            lblSerialNumber.Text = strSerialNumber;
            imgSerialNumber.ImageUrl = this.getBarcodeLink(strSerialNumber, 250, 30, "Code 128-B");
            if (strSerialNumber.Length == 0) imgSerialNumber.Visible = false;
        }
    }
}