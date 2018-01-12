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
   public partial class Tracking : System.Web.UI.Page
   {
      protected void Page_Load(object sender, EventArgs e)
      {
          if (Session["UserID"] == null)
              Response.Redirect("/Default.aspx");
          else
          {
              Label tLabel = (Label)Page.Master.FindControl("lblName");
              if (!tLabel.Text.StartsWith("Welcome"))
                  tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
          }
      }
   }
}
