/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : DispatchHistoryReport.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : Report on Dispatch history
*    Log                    :
*    2009: xdong: first created
*    01/29/2019: xdong: turn the EnableHyperLinks property for the report control to be true, in order to show hyper links in the report
----------------------------------------------------------------*/
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using CommonLib.Data.EzSqlClient;
using Microsoft.Reporting.WebForms;

namespace ezMESWeb.Reports
{
   public partial class DispatchHistoryReport : System.Web.UI.Page
   {
      protected EzSqlConnection ezConn;
      protected EzSqlCommand ezCmd;
      protected ezDataAdapter ezAdapter;
      protected System.Data.Common.DbDataReader ezReader;
      protected Panel pnMain;
      protected DropDownList dpStart, dpDuration;
     // protected Button btnView;
      protected ReportViewer rvDispatch;
      //protected TextBox txtStartCal, txtEndCal;
     // protected Calendar calStartDate, calEndDate;

      protected void Page_Load(object sender, EventArgs e)
      {
         if (Session["UserID"] == null)
            Server.Transfer("/Default.aspx");
         if (!IsPostBack)
         {
           if (Request.QueryString["for"] != null)
           {
             string selForValue = Request.QueryString["for"];
             string selStartValue = Request.QueryString["start"];
             dpDuration.SelectedValue = selForValue;
             dpStart.SelectedValue = selStartValue;
             btnViewHistory_Click(sender, e);
           }
         }

      }

      protected void btnViewHistory_Click(object sender, EventArgs e)
      {
         DateTime dtEnd = DateTime.UtcNow;
         DateTime dtStart = DateTime.UtcNow;

         switch (dpDuration.SelectedIndex)
         {
            case 0://1 day
             dtStart = DateTime.UtcNow.AddDays(-1);
               break;
            case 1: //1 week
               dtStart = DateTime.UtcNow.AddDays(-7);
               break;
            case 2: //1 month
               dtStart = DateTime.UtcNow.AddMonths(-1);
               break;
            case 3: //2 month
               dtStart = DateTime.UtcNow.AddMonths(-2);
               break;
            case 4: //6 month
               dtStart = DateTime.UtcNow.AddMonths(-6);
               break;
            case 5: //1 year
               dtStart = DateTime.UtcNow.AddYears(-1);
               break;
            case 6: //All History
               
               break;
         }

         rvDispatch.LocalReport.DataSources.Clear();

         showDispatchHistory(dtStart, dtEnd);

         ReportParameter p1 = new ReportParameter("from_time", dtStart.ToString());
         ReportParameter p2 = new ReportParameter("to_time", dtEnd.ToString());

         rvDispatch.LocalReport.SetParameters(new ReportParameter[] { p1, p2 });

         rvDispatch.LocalReport.Refresh();
         rvDispatch.Visible = true;
      }
  /*    protected void btnView_Click(object sender, EventArgs e)
      {
         DateTime dtStart = Convert.ToDateTime(txtStartCal.Text);
         DateTime dtEnd = Convert.ToDateTime(txtEndCal.Text);
         
         rvDispatch.LocalReport.DataSources.Clear();

         showDispatchHistory(dtStart, dtEnd);

         ReportParameter p1 = new ReportParameter("from_time", dtStart.ToString());
         ReportParameter p2 = new ReportParameter("to_time", dtEnd.ToString());

         rvDispatch.LocalReport.SetParameters(new ReportParameter[] { p1, p2 });

         rvDispatch.LocalReport.Refresh();
         rvDispatch.Visible = true;
     }
      */
      private void showDispatchHistory(DateTime dtStart, DateTime dtEnd)
      {
         DataSet dispatchHistory = new DataSet();
         string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
         string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
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
         {
            Server.Transfer("/Default.aspx");
            return;
         }
     
         int count = 0;
         try
         {
            if (ezConn == null)
               ezConn = new EzSqlConnection(ezType, connStr);
            if (ezConn.State != ConnectionState.Open)
               ezConn.Open();

            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezCmd.CommandText = "report_dispatch_history";
            ezCmd.CommandType = CommandType.StoredProcedure;

            ezCmd.Parameters.AddWithValue("@_from_time", dtStart);
            ezCmd.Parameters.AddWithValue("@_to_time", dtEnd);
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
                    //rvDispatch.LocalReport.DataSources.Add(
                    //new ReportDataSource("DataSet1_report_dispatch_history", dispatchHistory.Tables[0]));
                dispatchHistory.Tables[0].Columns.Add("batch_link");
                foreach (DataRow theRow in dispatchHistory.Tables[0].Rows)
                {
                    theRow["batch_link"] = "http://" + Request.ServerVariables["HTTP_HOST"] + "/Reports/LotHistoryReport.aspx?batch=" + theRow["lot_alias"];
                }
                rvDispatch.LocalReport.DataSources.Clear();
                rvDispatch.LocalReport.DataSources.Add(
                //new ReportDataSource("DataSet1_report_product_in_process", dispatchHistory.Tables[0]));
                new ReportDataSource("DataSet1_report_dispatch_history", dispatchHistory.Tables[0]));

            }
         catch (Exception ex)
         {
            LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
            pnMain.Controls.Add(lc);

            return;
         }
      }

      
   }
}
