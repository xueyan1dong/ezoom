/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : Default.aspx.cs
*    Created By             : Fei Xue
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : 
*
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
using System.Data.SqlClient;
using MySql.Data.MySqlClient;

namespace ezMESWeb
{
   public partial class _Default : System.Web.UI.Page
   {
      protected Login Login1;

      protected void Page_Load(object sender, EventArgs e)
      {

      }

       protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
       {
           Object nFindUser = 0;
           string DatabaseType = System.Configuration.ConfigurationManager.AppSettings.Get("DatabaseType");
           if (DatabaseType == "MySql")
           {
               string DefaultConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyMESServer"].ConnectionString;
               MySqlConnection conn1 = new MySqlConnection(DefaultConnectionString);
               string strSQL = "SELECT count(*) FROM employee " +
                   "WHERE username= \"" + Login1.UserName + "\" AND password=\""
                   + Login1.Password + "\";";

               MySqlCommand cmd1 = new MySqlCommand(strSQL, conn1);
               try
               {
                   conn1.Open();
                   nFindUser = cmd1.ExecuteScalar();
               }
               catch (Exception ex)
               {

               }
           }
           else
           {
               SqlConnection conn = new SqlConnection(
                   "Data Source=feixwxp\\SQLExpress;Initial Catalog=ezMES;Integrated Security=True;");
               string strSQL = "SELECT * FROM Employee " +
                   "WHERE LoginName= '" + Login1.UserName + "' AND password='"
                   + Login1.Password + "';";
               SqlCommand cmd = new SqlCommand(strSQL, conn);

               try
               {
                   conn.Open();
                   nFindUser = cmd.ExecuteScalar();
               }
               catch (Exception ex)
               {

               }
           }
           if (Convert.ToInt32(nFindUser) > 0)
               Response.Redirect("/Configure/Configuration.aspx");
       }
   }
}
