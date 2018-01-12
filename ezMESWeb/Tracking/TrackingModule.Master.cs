using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace ezMESWeb.Tracking
{
   public partial class TrackingModule : System.Web.UI.MasterPage
   {
      protected void Page_Load(object sender, EventArgs e)
      {
         if ((Session["LoggedIn"]==null)||(!(bool)Session["LoggedIn"]))
            Response.Redirect("/Default.aspx");
      }

   }
}
