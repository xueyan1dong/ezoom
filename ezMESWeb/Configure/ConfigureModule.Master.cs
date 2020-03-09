/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : ConfigureModule.Master.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : This is the home page of the Configuration module, including the tab menu and side bar of the configuration module
*    Log                    :
*    2009: xdong: first created    
----------------------------------------------------------------*/
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
//using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace ezMESWeb.Configure
{
   public partial class ConfigureModule : System.Web.UI.MasterPage
   {
      protected void Page_Load(object sender, EventArgs e)
      {
        //if (!(bool)Session["LoggedIn"])
        if ((Session["LoggedIn"] == null)||!(bool)Session["LoggedIn"])
                Response.Redirect("~/Default.aspx");
      }
   }
}
