using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using CommonLib.Data.EzSqlClient;
using Microsoft.Reporting.WebForms;

namespace ezMESWeb.Reports
{
   public partial class ProductInProcessReport : System.Web.UI.Page
   {
      protected EzSqlConnection ezConn;
      protected EzSqlCommand ezCmd, ezCmd1;
      protected ezDataAdapter ezAdapter;
      protected System.Data.Common.DbDataReader ezReader;
      protected Panel pnMain;
      protected DropDownList dpProduct, dpOrder, dpStatus;
      protected ReportViewer rvDispatch;

      protected void Page_Load(object sender, EventArgs e)
      {
         if (Session["UserID"] == null)
            Server.Transfer("/Default.aspx");
         if (!IsPostBack)
         {
            InitializePage();
         }
      }

      private void InitializePage()
      {
         string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
         string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
         DbConnectionType ezType;

         if (dbConnKey.Equals("ODBC"))
         {
            ezType = DbConnectionType.MySqlODBC;

         }
         else if (dbConnKey.Equals("MySql"))
         {
            ezType = DbConnectionType.MySqlADO;

         }
         else
            ezType = DbConnectionType.Unknown;

         if (Session["UserID"] == null)
            Server.Transfer("/Default.aspx");
      
         int count = 0;
         try
         {
            if (ezConn == null)
               ezConn = new EzSqlConnection(ezType, connStr);
            if (ezConn.State != ConnectionState.Open)
               ezConn.Open();

            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezCmd.CommandText = "SELECT id, name FROM product";
            ezCmd.CommandType = CommandType.Text;

            ezCmd1 = new EzSqlCommand();
            ezCmd1.Connection = ezConn;
            ezCmd1.CommandText = " show columns from lot_status like 'status'";
            ezCmd1.CommandType = CommandType.Text;


            ezReader = ezCmd.ExecuteReader();

            while (ezReader.Read())
            {
               dpProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
               count++;
            }
            ezReader.Close();

            ezReader = ezCmd1.ExecuteReader();
            dpStatus.Items.Add(new ListItem("All", ""));
            if(ezReader.Read())          
            {
              string raw = ezReader["Type"].ToString();
              string[] rawValues = raw.Substring(5, raw.Length - 6).Split(',');
              for (int i = 0; i < rawValues.Length; i++)
              {
                dpStatus.Items.Add(rawValues[i].Substring(1, rawValues[i].Length - 2));
              }
            }
            ezReader.Close();

            if (count > 0)
            {
              if (Request.QueryString["prod"]!=null)
                dpProduct.SelectedValue = Request.QueryString["prod"];
              else
                dpProduct.SelectedIndex = 0;
              load_order(dpProduct.SelectedValue);

              if (Request.QueryString["order"]!=null)
                dpOrder.SelectedValue = Request.QueryString["order"];
              
              if (Request.QueryString["status"]!=null)
                dpStatus.SelectedValue = Request.QueryString["status"];
              
              showHistory(dpProduct.SelectedValue, dpOrder.SelectedValue, dpStatus.SelectedValue);
             
            }

       
            ezReader.Dispose();


         }
         catch (Exception ex)
         {
            LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
            pnMain.Controls.Add(lc);
         }
         if (ezCmd != null)
           ezCmd.Dispose();
         if (ezCmd1 != null)
            ezCmd1.Dispose();
         if (ezConn != null)
           ezConn.Dispose();
      }

      private void load_order(string productid)
      {

         string dbConnKey, connStr = "";
         DbConnectionType ezType;

         dpOrder.Items.Clear();
         try
         {

            //if (ezConn == null)
            //{
            //   dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
            //   if (dbConnKey.Equals("ODBC"))
            //   {
            //      ezType = DbConnectionType.MySqlODBC;
            //      connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
            //   }
            //   else if (dbConnKey.Equals("MySql"))
            //   {
            //      ezType = DbConnectionType.MySqlADO;
            //      connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
            //   }
            //   else
            //      ezType = DbConnectionType.Unknown;
            //   ezConn = new EzSqlConnection(ezType, connStr);
            //}
            //if (ezConn.State != ConnectionState.Open)
            //   ezConn.Open();

            //ezCmd = new EzSqlCommand();
            //ezCmd.Connection = ezConn;
            ezCmd.CommandText = "SELECT null, 'All' UNION SELECT od.order_id, og.ponumber " + 
            "FROM order_detail od, order_general og WHERE source_type = 'product' AND source_id ="+
            productid + " AND og.id = od.order_id";

            ezCmd.CommandType = CommandType.Text;
            ezReader = ezCmd.ExecuteReader();
            while (ezReader.Read())
            {
               dpOrder.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
            }
            dpOrder.SelectedIndex = 0;
            ezReader.Close();
            //ezReader.Dispose();
            //ezCmd.Dispose();


         }
         catch (Exception ex)
         {
            LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
            pnMain.Controls.Add(lc);

            return;
         }
      }

      protected void btnRunReport_Click(object sender, EventArgs e)
      {
        if (Session["UserID"] == null)
        {
          Server.Transfer("/Default.aspx");
          return;
        }



         
         string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
         string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
         DbConnectionType ezType;
         try
         {
           if (dbConnKey.Equals("ODBC"))
           {
             ezType = DbConnectionType.MySqlODBC;

           }
           else if (dbConnKey.Equals("MySql"))
           {
             ezType = DbConnectionType.MySqlADO;

           }
           else
             ezType = DbConnectionType.Unknown;
           if (ezConn == null)
             ezConn = new EzSqlConnection(ezType, connStr);
           if (ezConn.State != ConnectionState.Open)
             ezConn.Open();

           if (ezCmd == null)
           {
             ezCmd = new EzSqlCommand();
             ezCmd.Connection = ezConn;
           }


           showHistory(dpProduct.SelectedValue, dpOrder.SelectedValue, dpStatus.SelectedValue);
         }
         catch (Exception ex)
         {
           LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
           pnMain.Controls.Add(lc);


         }
         
         ezCmd.Dispose();
         ezConn.Dispose();

      }

      private void showHistory(String strProductId, String strOrderId, String strStatusId)
      {

        DataSet dispatchHistory = new DataSet();
            ezCmd.CommandText = "report_product";
            ezCmd.CommandType = CommandType.StoredProcedure;

            ezCmd.Parameters.AddWithValue("@_product_id", strProductId);
            if (strOrderId.Length > 0)
              ezCmd.Parameters.AddWithValue("@_order_id", strOrderId);
            else
              ezCmd.Parameters.AddWithValue("@_order_id", DBNull.Value);

            
            if (strStatusId.Length > 0 && strStatusId != "All")
               ezCmd.Parameters.AddWithValue("@_lot_status", strStatusId);
            else
               ezCmd.Parameters.AddWithValue("@_lot_status", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
            ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


            ezAdapter = new ezDataAdapter();
            ezAdapter.SelectCommand = ezCmd;
            ezAdapter.Fill(dispatchHistory);

            String response = ezCmd.Parameters["@_response"].Value.ToString();
            if (response.Length > 0)
            {
              LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>" + response + "</li></ul><hr width=100% size=1 color=silver />");
              pnMain.Controls.Add(lc);
            }
            else
            {
              dispatchHistory.Tables[0].Columns.Add("batch_link");
              foreach (DataRow theRow in dispatchHistory.Tables[0].Rows)
              {
                theRow["batch_link"] = "http://"+ Request.ServerVariables["HTTP_HOST"] + "/Reports/LotHistoryReport.aspx?batch=" + theRow["lot_alias"];
              }
              rvDispatch.LocalReport.DataSources.Clear();
              rvDispatch.LocalReport.DataSources.Add(
               new ReportDataSource("DataSet1_report_product_in_process", dispatchHistory.Tables[0]));
            }

            ezAdapter.Dispose();

            ReportParameter p1 = new ReportParameter("product_name", dpProduct.SelectedItem.Text);
            ReportParameter p2 = new ReportParameter("po", dpOrder.SelectedItem.Text);
            ReportParameter p3 = new ReportParameter("status", dpStatus.SelectedItem.Text);

            rvDispatch.LocalReport.SetParameters(new ReportParameter[] { p1, p2, p3 });

            rvDispatch.LocalReport.Refresh();
            rvDispatch.Visible = true;

      }

      protected void dpProduct_SelectedIndexChanged(object sender, EventArgs e)
      {
        string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
        string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
        DbConnectionType ezType;
        if (ezConn == null)
        {
          dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
          if (dbConnKey.Equals("ODBC"))
          {
            ezType = DbConnectionType.MySqlODBC;
            connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
          }
          else if (dbConnKey.Equals("MySql"))
          {
            ezType = DbConnectionType.MySqlADO;
            connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
          }
          else
            ezType = DbConnectionType.Unknown;
          ezConn = new EzSqlConnection(ezType, connStr);
        }
        if (ezConn.State != ConnectionState.Open)
          ezConn.Open();

        ezCmd = new EzSqlCommand();
        ezCmd.Connection = ezConn;

         load_order(dpProduct.SelectedValue);
        ezReader.Dispose();
        ezCmd.Dispose();
        ezConn.Dispose();
     //    rvProInvent.Visible = false;
      }
   }
}
