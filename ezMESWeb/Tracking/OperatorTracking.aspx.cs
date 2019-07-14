/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : OperatorTracking.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 07/11/2019
*    Platform Dependencies  : .NET 2.0
*    Description            : Product Batch Tracking module homepage for Operator. it loads in TrackingModule.Master
*
*    Log                    :
*    07/11/2019: Xueyan Dong: First Created
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
   public partial class OperatorTracking : System.Web.UI.Page
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
