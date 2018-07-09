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
    public partial class ProductInventoryReport : System.Web.UI.Page
    {
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;


        protected Panel pnMain;

        protected DropDownList dpProduct, dpProcess;


        protected Button btnView;
        protected ReportViewer rvProInvent;
      

        protected void Page_Load(object sender, EventArgs e)
        {

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
            else { 
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text ="Welcome " + (string)(Session["FirstName"]) + "!";
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
                ezCmd.CommandText = "SELECT id, name FROM product";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                while (ezReader.Read())
                {

                    dpProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    count++;
                }

                if (count > 0)
                    load_Process(dpProduct.Items[0].Value);

                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();

            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);

                return;
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            rvProInvent.LocalReport.DataSources.Clear();
            
            showProductInventory(dpProduct.SelectedValue);
            showProcessCycleTime(dpProcess.SelectedValue, dpProduct.SelectedValue);
            showProcessBom(dpProcess.SelectedValue);
            ReportParameter p1 = new ReportParameter("product_name", dpProduct.SelectedItem.Text);
            ReportParameter p2 = new ReportParameter("process_name", dpProcess.SelectedItem.Text);
            rvProInvent.LocalReport.SetParameters(new ReportParameter[] { p1, p2});

            rvProInvent.LocalReport.Refresh();
            rvProInvent.Visible = true;

            ezAdapter.Dispose();
            ezCmd.Dispose();
            ezConn.Dispose();
        }

        private void showProductInventory(string productid)
        {
            DataSet outgoingProduct = new DataSet();

            string dbConnKey ;
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
                    dbConnKey= ConfigurationManager.AppSettings.Get("DatabaseType");
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
                ezCmd.CommandText = "report_product_quantity";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_product_id", productid);

                ezAdapter = new ezDataAdapter();
                ezAdapter.SelectCommand = ezCmd;
                ezAdapter.Fill(outgoingProduct);

            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);
            }
            rvProInvent.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_DataTable2", outgoingProduct.Tables[0]));
      
            
            
        }
        private void showProcessCycleTime(string processid, string productid)
        {
            DataSet cycletime = new DataSet();
            try
            {
                ezCmd.Parameters.Clear();
                ezCmd.CommandText = "report_process_cycletime";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_process_id", processid);
                ezCmd.Parameters.AddWithValue("@_product_id", productid);
                ezAdapter.SelectCommand = ezCmd;
                ezAdapter.Fill(cycletime);

            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);
            }

            rvProInvent.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_report_process_cycletime", cycletime.Tables[0]));



        }
        private void showProcessBom(string processid)
        {
            DataSet processbom = new DataSet();
            try
            {
                ezCmd.Parameters.Clear();
                ezCmd.CommandText = "report_process_bom";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_process_id", processid);


                ezAdapter.SelectCommand = ezCmd;
                ezAdapter.Fill(processbom);
            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);
            }

            rvProInvent.LocalReport.DataSources.Add(
                new ReportDataSource("DataSet1_report_process_bom", processbom.Tables[0]));

           

        }
        private TableRow CreateTableRow(string CssClass)
        {
            TableRow tableRow = new TableRow();
            tableRow.CssClass = CssClass;
            return tableRow;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CssClass"></param>
        /// <param name="Text"></param>
        /// <returns></returns>
        private TableCell CreateTableCell(string CssClass, string Text)
        {
            TableCell tableCell = new TableCell();
            tableCell.CssClass = CssClass;
            tableCell.Text = Text;
            return tableCell;
        }

        protected void dpProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            load_Process(dpProduct.SelectedValue);
            rvProInvent.Visible = false;
        }

        private void load_Process (string productid)
        {

            string dbConnKey, connStr = "";
            DbConnectionType ezType;
            
            dpProcess.Items.Clear();
            try
            {

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
                ezCmd.CommandText = "SELECT p.id, p.name FROM product_process pp, process p WHERE pp.product_id=" +
                    productid + " AND p.id=pp.process_id";
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    dpProcess.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                }
                //ezReader.Close();
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
    }
}
