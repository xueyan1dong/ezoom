/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : NewOrderDemandPrediction.aspx.cs
*    Created By             : Peiyu Ge
*    Date Created           : 2018
*    Platform Dependencies  : .NET 
*    Description            : Report page for showing the persistent parts required for producing the unique products in an order within all possible workflow/processes
*                             Thus, the report list the quantities of unique products and unique processes of each product, then unique persistent parts requested in
*                             each processes and their inventory and how many final products the inventory can produce. Also, list if a part is the one determine the
*                             maximum final products that current inventory can produce with the process.
*    Log                    :
*    10/2018: Peiyu Ge: first created
*    11/18/2018: Xueyan Dong: rewrote this report with more accurate data and columns
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
using CommonLib.Data.EzSqlClient;
using Microsoft.Reporting.WebForms;

namespace ezMESWeb.Reports
{
    public partial class NewOrderDemandPrediction: System.Web.UI.Page
    {
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;
        protected TextBox txtNumProduct1;

        protected Panel pnMain1;

        protected DropDownList dpOrder1;


        protected Button btnView;
        protected ReportViewer rvProInvent1;


        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                InitializePage(sender, e);
            }
        }
        private void InitializePage(object sender, EventArgs e)
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
            else
            {
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
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
                ezCmd.CommandText = "SELECT o.id, concat('PO# ', ifnull(o.ponumber, ''),' from ', c.name) FROM order_general o left join client c on o.client_id=c.id where order_type in ('inventory', 'customer')";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                while (ezReader.Read())
                {

                    dpOrder1.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    count++;
                }

                string tString = (Request.QueryString.Count > 0) ? Request.QueryString["processid"] : null;
                if (count > 0 && tString != null)
                {
                    dpOrder1.SelectedValue = tString;
                    btnView_Click(sender, e);
                }

                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();


            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain1.Controls.Add(lc);

                return;
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            rvProInvent1.LocalReport.DataSources.Clear();

            showOrder(dpOrder1.SelectedValue);

            //ReportParameter p2 = new ReportParameter("order", dpOrder.SelectedItem.Text);
            //ReportParameter p2 = new ReportParameter("order_id", dpOrder1.SelectedItem.Value);
            //rvProInvent1.LocalReport.SetParameters(new ReportParameter[] { p2 });
            //ReportParameter p2 = new ReportParameter("num_finalProduct", txtNumProduct1.Text.Length == 0 ? "1" : txtNumProduct1.Text);
            //rvProInvent1.LocalReport.SetParameters(new ReportParameter[] { p2 });

            rvProInvent1.LocalReport.Refresh();
            rvProInvent1.Visible = true;

            ezAdapter.Dispose();
            ezCmd.Dispose();
            ezConn.Dispose();
        }

        private void showOrder(string orderid)
        {
            DataSet outgoingProduct = new DataSet();

            string dbConnKey;
            string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
            DbConnectionType ezType;


            if (Session["UserID"] == null)
                Server.Transfer("/Default.aspx");
            else
            {
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
            }

            try
            {

                if (ezConn == null)
                {
                    dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
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
                    ezConn = new EzSqlConnection(ezType, connStr);
                }
                if (ezConn.State != ConnectionState.Open)
                    ezConn.Open();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "new_order_demand_prediction";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_order_id", orderid);

                ezAdapter = new ezDataAdapter();
                ezAdapter.SelectCommand = ezCmd;
                ezAdapter.Fill(outgoingProduct);

            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain1.Controls.Add(lc);
            }
            rvProInvent1.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_new_order_demand_prediction", outgoingProduct.Tables[0]));


        }
        private TableRow CreateTableRow(string CssClass)
        {
            TableRow tableRow = new TableRow();
            tableRow.CssClass = CssClass;
            return tableRow;
        }

        private TableCell CreateTableCell(string CssClass, string Text)
        {
            TableCell tableCell = new TableCell();
            tableCell.CssClass = CssClass;
            tableCell.Text = Text;
            return tableCell;
        }



    }
}
