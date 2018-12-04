/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : OrderReport.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : Report on the quantity made, in process, shipped and not dispatched of each detail line in a given order
*    Log                    :
*    12/03/2018: Xueyan Dong: Added line_num to the report to account for now orders may contain multiple lines of the same products
*                             enlarged report view area and perfected chart display
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
    public partial class OrderReport : System.Web.UI.Page
    {
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;


        protected Panel pnMain;

        protected DropDownList  dpOrder;


        protected Button btnView;
        protected ReportViewer rvProInvent;
      

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
                ezCmd.CommandText = "SELECT o.id, concat('PO# ', ifnull(o.ponumber, ''),' from ', c.name) FROM order_general o left join client c on o.client_id=c.id where order_type in ('inventory', 'customer')";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                while (ezReader.Read())
                {

                    dpOrder.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    count++;
                }

                string tString = (Request.QueryString.Count > 0) ? Request.QueryString["processid"] : null;
                if (count > 0 && tString != null)
                {
                  dpOrder.SelectedValue = tString;
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
                pnMain.Controls.Add(lc);

                return;
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            rvProInvent.LocalReport.DataSources.Clear();
            
            showOrder(dpOrder.SelectedValue);
            ReportParameter p2 = new ReportParameter("order", dpOrder.SelectedItem.Text);
            rvProInvent.LocalReport.SetParameters(new ReportParameter[] { p2});

            rvProInvent.LocalReport.Refresh();
            rvProInvent.Visible = true;

            ezAdapter.Dispose();
            ezCmd.Dispose();
            ezConn.Dispose();
        }
  
       private void showOrder(string orderid)
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
                ezCmd.CommandText = "report_order_quantity";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_order_id", orderid);

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
                new ReportDataSource("DataSet1_report_order_quantity", outgoingProduct.Tables[0]));
      
            
      

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


 
    }
}
