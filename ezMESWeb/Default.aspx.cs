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
using System.Data.Odbc;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
//using MySql.Data.MySqlClient;  
using CommonLib;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb
{
   public partial class _Default : System.Web.UI.Page
   {
      protected Login Login1;
      protected TextBox txtUserId, txtPassword;
      protected Label lblResults;
      protected MembershipUser memUser;

      protected void Page_Load(object sender, EventArgs e)
      {

      }

      protected void btnLogin_Click(object sender, EventArgs e)
      {
         string userName = txtUserId.Text;
         string password = txtPassword.Text;

         string strSQL = "SELECT e.id, e.firstname, e.lastname, s.name " +
           "FROM employee e, system_roles s, users_in_roles u " +
           "WHERE username= \"" + userName + "\" AND password=\""
           + password + "\"" + " and status='active' and e.id = u.userId and u.roleId =  s.id and s.applicationId = 1";

         EzSqlConnection ezConn;
         EzSqlCommand ezCmd=new EzSqlCommand();
         ezDataAdapter ezAdapter=new ezDataAdapter();
         DataSet ds;
         
         string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");

         string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;

         
         DbConnectionType ezType;

         if (dbConnKey.Equals("ODBC"))
         {
           ezType = DbConnectionType.MySqlODBC;

         }
         else if (dbConnKey.Equals("MySql"))
         {
           //ezType = DbConnectionType.MySql;
           ezType = DbConnectionType.MySqlADO;
         }
         else
           ezType = DbConnectionType.Unknown;

         try
         {
           ezConn = new EzSqlConnection(ezType, connStr);
           ezConn.Open();


           ezCmd.Connection = ezConn;
           ezCmd.CommandText = strSQL;
           ezCmd.CommandType = CommandType.Text;
           //System.Data.DataSet ds = dbutil.GetDataSet(strQuery, "temp");
           ds= new DataSet(); 
           ezAdapter.SelectCommand = ezCmd;
           ezAdapter.Fill(ds);

           ezAdapter.Dispose();
           ezCmd.Dispose();
           ezConn.Dispose();
         }
         catch (Exception ex)
         {
           lblResults.Visible = true;
           lblResults.Text = "Failed to log in, due to " + ex.Message;
           return;
         }
     /*    OdbcDataReader sqlReader;
         string DefaultConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
         OdbcConnection conn1 = new OdbcConnection(DefaultConnectionString);
         string strSQL = "SELECT e.id, e.firstname, e.lastname, s.name " +
             "FROM employee e, system_roles s, users_in_roles u " +
             "WHERE username= \"" + userName + "\" AND password=\""
             + password + "\"" + " and e.id = u.userId and u.roleId =  s.id and s.applicationId = 1";

         OdbcCommand cmd1 = new OdbcCommand(strSQL, conn1);
      */
         try
         {

            foreach (DataRow temp in ds.Tables[0].Rows)
            {
               Session["UserID"] = Convert.ToInt32(temp[0]).ToString();
               Session["FirstName"] = Convert.ToString(temp[1]);
               Session["LastName"] = Convert.ToString(temp[2]);
               Session["Role"] = Convert.ToString(temp[3]);
               Session["LoggedIn"] = true;

               if (Session["Role"].ToString().Equals("Admin") ||
                    Session["Role"].ToString().Equals("Manager"))
                  Response.Redirect("~/Configure/configuration.aspx");
               else
                  Response.Redirect("~/Tracking/Tracking.aspx");

               break;
            }
            lblResults.Visible = true;
            lblResults.Text = "Unsuccessful login.  Please re-enter your information and try again.";

    //        if ((Membership.GetUser(userName) != null) && (Membership.GetUser(userName).IsLockedOut == true))
     //           lblResults.Text += "  <b>Your account has been locked out.</b>";

         }
         catch (Exception ex)
         {
           lblResults.Visible = true;
           lblResults.Text = "Fail to log in due to " + ex.Message;
         }
      }

       //protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
       //{
       //    int nFindUser = 0;
       //    MySqlDataReader sqlReader;
       //    string DatabaseType = System.Configuration.ConfigurationManager.AppSettings.Get("DatabaseType");
       //    if (DatabaseType == "MySql")
       //    {
       //        string DefaultConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyMESServer"].ConnectionString;
       //        MySqlConnection conn1 = new MySqlConnection(DefaultConnectionString);
       //        string strSQL = "SELECT id,firstname, lastname FROM employee " +
       //            "WHERE username= \"" + Login1.UserName + "\" AND password=\""
       //            + Login1.Password + "\";";

       //        MySqlCommand cmd1 = new MySqlCommand(strSQL, conn1);
       //        try
       //        {
       //            conn1.Open();
       //            sqlReader = cmd1.ExecuteReader();
       //            while (sqlReader.Read())
       //            {
       //                Session["UserID"] = Convert.ToInt32(sqlReader[0]);
       //                Session["FirstName"] = Convert.ToString(sqlReader[1]);
       //                Session["LastName"] = Convert.ToString(sqlReader[2]);
       //                nFindUser++;
       //            }
       //            sqlReader.Close();
       //        }
       //        catch (Exception ex)
       //        {

       //        }
       //    }
       //    else
       //    {
       //        SqlConnection conn = new SqlConnection(
       //            "Data Source=feixwxp\\SQLExpress;Initial Catalog=ezMES;Integrated Security=True;");
       //        string strSQL = "SELECT id FROM Employee " +
       //            "WHERE LoginName= '" + Login1.UserName + "' AND password='"
       //            + Login1.Password + "';";
       //        SqlCommand cmd = new SqlCommand(strSQL, conn);

       //        try
       //        {
       //            conn.Open();
       //            cmd.ExecuteScalar();
       //        }
       //        catch (Exception ex)
       //        {

       //        }
       //    }
       //    if (nFindUser <= 0)
       //    {
       //        e.Authenticated = false;
       //    }
       //    else
       //        e.Authenticated = true;
       //}
   }
}
