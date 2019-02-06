/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : SalesOrderConfig.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for display report of batch geneology
*    Log                    :
*    2009: xdong: first created
*   02/05/2019: xdong: added location and Tracking No. column to lot history grid. Adjust the height of some cells in lot status area.
----------------------------------------------------------------*/
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Microsoft.Reporting.WebForms;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb.Reports
{
    public partial class LotHistoryReport : System.Web.UI.Page
    {
        protected ezDataAdapter ezAdapter;
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;
        protected EzSqlDataReader ezReader;
        

        protected Panel pnMain;

        protected TextBox tbLotAlias;

        protected Button btnView;
        protected ReportViewer rvLot;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Server.Transfer("/Default.aspx");
            else
            {
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
                if (!IsPostBack)
                {
                  if (Request.QueryString["batch"] != null)
                  {

                    tbLotAlias.Text = Request.QueryString["batch"];
                    btnView_Click(sender, e);
                  }
                }
            }

        }
        protected void btnView_Click(object sender, EventArgs e)
        {
            String lotAlias = tbLotAlias.Text;
            rvLot.LocalReport.DataSources.Clear();

            showLotStatus(lotAlias);
            showLotHistory(lotAlias);
            ReportParameter p1 = new ReportParameter("lot_name", lotAlias);

            rvLot.LocalReport.SetParameters(new ReportParameter[] { p1 });

            rvLot.LocalReport.Refresh();
            rvLot.Visible = true;
        }
        private void showLotStatus(String lotAlias)
        {
            DataSet lotStatus = new DataSet();
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

            if (ezConn == null)
                ezConn = new EzSqlConnection(ezType, connStr);
            if (ezConn.State != ConnectionState.Open)
                ezConn.Open();

            ezCmd = new EzSqlCommand();

            ezCmd.Connection = ezConn;

            ezCmd.CommandText = "report_lot_status";

            ezCmd.CommandType = CommandType.StoredProcedure;

            ezCmd.Parameters.AddWithValue("@_lot_id", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_lot_alias", lotAlias);

            ezAdapter = new ezDataAdapter();
            ezAdapter.SelectCommand = ezCmd;
            ezAdapter.Fill(lotStatus);

            rvLot.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_report_lot_status", lotStatus.Tables[0]));
        }

        private void showLotHistory(String lotAlias)
        {
            DataSet lotHistory = new DataSet();


            ezCmd.Parameters.Clear();
            ezCmd.CommandText = "report_lot_history";
            ezCmd.CommandType = CommandType.StoredProcedure;
            ezCmd.Parameters.AddWithValue("@_lot_id", DBNull.Value);
            ezCmd.Parameters.AddWithValue("@_lot_alias", lotAlias);

            ezAdapter.SelectCommand = ezCmd;
            ezAdapter.Fill(lotHistory);

            ezAdapter.Dispose();
            ezCmd.Dispose();
            ezConn.Dispose();
            rvLot.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_report_lot_history", lotHistory.Tables[0]));
        }
    }
}
