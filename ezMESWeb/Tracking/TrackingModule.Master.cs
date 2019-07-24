/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : TrackingModule.Master.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : This is the home page of Tracking module,including the tab menus of tracking module and side bar menus
*
*    Log                    :
*    07/11/2019: Xueyan Dong: Added code to direct user to different tab menu and side bar menu according to role of user
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
   public partial class TrackingModule : System.Web.UI.MasterPage
   {
      protected void Page_Load(object sender, EventArgs e)
      {
         if ((Session["LoggedIn"]==null)||(!(bool)Session["LoggedIn"]))
            Server.Transfer("/Default.aspx");
      }

   }
}
