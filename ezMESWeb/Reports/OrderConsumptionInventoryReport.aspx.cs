/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : OrderConsumptionInventoryReport.aspx.cs
*    Created By             : Peiyu Ge
*    Date Created           : 6/10/2019
*    Platform Dependencies  : .NET 
*    Description            : UI for configuring recipes
*    Log                    :    
----------------------------------------------------------------*/

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
    public partial class OrderConsumptionInventoryReport : System.Web.UI.Page
    {

        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd, ezCmd1;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;
        protected Panel pnMain;
        protected DropDownList dpProduct2, dpOrder2;
        protected ReportViewer rvDispatch;
        protected TextBox txStep;

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

            // load all orders not completed
            try
            {
                if (ezConn == null)
                    ezConn = new EzSqlConnection(ezType, connStr);
                if (ezConn.State != ConnectionState.Open)
                    ezConn.Open();

                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                //select open orders
                //ezCmd.CommandText = "select t1.order_id, g.ponumber from " +
                //    "(select order_id, sum(quantity_requested) as r, sum(quantity_made) as m, sum(quantity_in_process) as p, sum(quantity_shipped) as s from order_detail group by  order_id) t1, " +
                //    "order_general g, lot_history h, lot_status l, step s, step_type st " +
                //    "where t1.r > t1.p + t1.s + t1.m " +
                //    "and g.id = t1.order_id " +
                //    "and l.order_id = g.id " +
                //    "and h.lot_id = l.id " +
                //    "and h.start_timecode = (SELECT MAX(start_timecode) FROM lot_history h1 WHERE h1.lot_id = h.lot_id) " +
                //    "and h.step_id = s.id" +
                //    "and s.step_type_id = st.id" +
                //    "and st.id = 8";
                ezCmd.CommandText = "select distinct t1.order_id, g.ponumber from(select order_id, sum(quantity_requested) as r, " +
                    "sum(quantity_made) as m, sum(quantity_in_process) as p, sum(quantity_shipped) as s from order_detail group by order_id) t1, " +
                    "lot_history h, order_general g, lot_status l, step s, step_type st " +
                    "where t1.r > t1.s + t1.m " +
                    "and g.id = t1.order_id " +
                    "and l.order_id = g.id " +
                    "and h.lot_id = l.id " +
                    "and h.step_id = s.id " +
                    "and s.step_type_id = st.id " +
                    "and h.start_timecode = (select MAX(start_timecode) FROM lot_history h1 where h1.lot_id = h.lot_id) " +
                    "and st.id = 8 " +
                    "and l.status != 'done'";

                ezCmd.CommandType =CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                while (ezReader.Read())
                {
                    dpOrder2.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    count++;
                }
                ezReader.Close();


                if (count > 0)
                {
                    if (Request.QueryString["prod"] != null)
                        dpProduct2.SelectedValue = Request.QueryString["prod"];
                    else
                        dpProduct2.SelectedIndex = 0;

                    if (Request.QueryString["order"] != null)
                        dpOrder2.SelectedValue = Request.QueryString["order"];
                    else
                        dpOrder2.SelectedIndex = 0;
                    load_order(dpOrder2.SelectedValue);

                    showHistory(dpProduct2.SelectedValue, dpOrder2.SelectedValue, txStep.Text);

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
            if (ezConn != null)
                ezConn.Dispose();
        }

        //when specif an order, load all products inside the order in product dropdown
        private void load_order(string orderId)
        {

            string dbConnKey, connStr = "";
            DbConnectionType ezType;

            dpProduct2.Items.Clear();
            dpProduct2.Items.Add(new ListItem("All", ""));
            try
            {

                //ezCmd.CommandText = "SELECT null, 'All' UNION SELECT od.order_id, og.ponumber " +
                //"FROM order_detail od, order_general og WHERE source_type = 'product' AND source_id =" +
                //productid + " AND og.id = od.order_id";
                ezCmd.CommandText = "SELECT distinct p.id, p.name from product p, order_detail od, order_general og WHERE p.id = od.source_id and od.order_id = og.id and od.source_type = 'product' and og.id = " + orderId;
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    dpProduct2.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                }
                dpProduct2.SelectedIndex = 0;
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


                showHistory(dpProduct2.SelectedValue, dpOrder2.SelectedValue, txStep.Text);
            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);


            }

            ezCmd.Dispose();
            ezConn.Dispose();

        }

        private void showHistory(String strProductId, String strOrderId, String txtStep)
        {

            DataSet dispatchHistory = new DataSet();
            ezCmd.CommandText = "order_consumption_inventory_report";
            ezCmd.CommandType = CommandType.StoredProcedure;

            ezCmd.Parameters.AddWithValue("@_order_id", strOrderId);
            if (strProductId.Length > 0 && strProductId != "All")
                ezCmd.Parameters.AddWithValue("@_product_id", strProductId);
            else
                ezCmd.Parameters.AddWithValue("@_product_id", DBNull.Value);

            if (txtStep.Length > 0)
                ezCmd.Parameters.AddWithValue("@_lot_step", txtStep);
            else
                ezCmd.Parameters.AddWithValue("@_lot_step", DBNull.Value);

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
                    theRow["batch_link"] = "http://" + Request.ServerVariables["HTTP_HOST"] + "/Reports/LotHistoryReport.aspx?batch=" + theRow["lot_alias"];
                }
                rvDispatch.LocalReport.DataSources.Clear();
                rvDispatch.LocalReport.DataSources.Add(
                //new ReportDataSource("DataSet1_report_product_in_process", dispatchHistory.Tables[0]));
                new ReportDataSource("DataSet1_report_order_consumption_inventory", dispatchHistory.Tables[0]));
            }

            ezAdapter.Dispose();

            //ReportParameter p1 = new ReportParameter("product_name", dpProduct1.SelectedItem.Text);
            //ReportParameter p2 = new ReportParameter("po", dpOrder1.SelectedItem.Text);
            //ReportParameter p3 = new ReportParameter("status", dpStatus1.SelectedItem.Text);

            //rvDispatch.LocalReport.SetParameters(new ReportParameter[] { p1, p2, p3 });

            rvDispatch.LocalReport.Refresh();
            rvDispatch.Visible = true;

        }

        protected void dpOrder_SelectedIndexChanged(object sender, EventArgs e)
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

            load_order(dpOrder2.SelectedValue);
            ezReader.Dispose();
            ezCmd.Dispose();
            ezConn.Dispose();
            //    rvProInvent.Visible = false;
        }


    }

}
        