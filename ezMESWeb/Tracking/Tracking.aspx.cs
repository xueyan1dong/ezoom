/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : Tracking.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : Product Batch Tracking module homepage for Admin, Manager, and Engineer. it loads in TrackingModule.Master
*
*    Log                    :
----------------------------------------------------------------*/
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
              Server.Transfer("/Default.aspx");
          else
          {
              Label tLabel = (Label)Page.Master.FindControl("lblName");
              if (!tLabel.Text.StartsWith("Welcome"))
                  tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
          }
      }
   }
}
