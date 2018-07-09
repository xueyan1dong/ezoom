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

namespace ezMESWeb.Report
{
   public partial class ReportModule : System.Web.UI.MasterPage
   {
       public Label lblName;
      protected void Page_Load(object sender, EventArgs e)
      {
         if (!(bool) Session["LoggedIn"] )
            Server.Transfer("/Default.aspx");

      }
    
   }
}
