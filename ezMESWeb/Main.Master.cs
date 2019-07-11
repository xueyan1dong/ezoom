/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : Main.Master.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 
*    Description            : Main file for the homepage
*    Log                    :
*    ?/?/2009: Xueyan Dong: First Created
*    07/11/2019: Xueyan Dong: Added code in Main.Master to present different menus according to the role of logged in user
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

namespace ezMESWeb
{
   
   public partial class Main : System.Web.UI.MasterPage
   {
       protected Label lblUserName;
      protected void Page_Load(object sender, EventArgs e)
      {
         if (!(bool)Session["LoggedIn"])
            Server.Transfer("/Default.aspx");

      }
   }
}
