using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace ezMESWeb.Tracking
{
  public partial class lot : System.Web.UI.UserControl
  {
    protected Label 
      lblName, 
      lblProduct, 
      lblProcess, 
      lblPriority, 
      lblLotStatus,
      lblQuantity,
      lblUom,
      lblStepStatus,
      lblLocation;
    protected void Page_Load(object sender, EventArgs e)
    {
      string stepStatus = Request.QueryString["step_status"];
      if (!IsPostBack)
      {
        lblName.Text = Session["lot_alias"].ToString();
        lblProduct.Text = Session["product"].ToString();
        lblProcess.Text = Session["process"].ToString();
        lblPriority.Text = Session["Priority"].ToString();
        lblLotStatus.Text = Session["lot_status"].ToString();
        lblQuantity.Text = Request.QueryString["quantity"];
        lblUom.Text = Session["uom"].ToString();
        lblLocation.Text = Session["location"].ToString();//Todo: add location to session in movelot.aspx [peiyu]

        if ((stepStatus == null)||!(stepStatus.Equals("shipped")||stepStatus.Equals("scrapped")||stepStatus.Equals("dispatched")))


          lblStepStatus.Text = Request.QueryString["step_status"];
      }
    }

  }
}