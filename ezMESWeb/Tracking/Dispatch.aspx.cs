/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : SalesOrderConfig.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for dispatching work from order detail lines (products) into workflow
*    Log                    :
*    2009: xdong: first created
*   11/06/2018: xdong: add line number of order details into the dispatch logics
*   11/11/2018: xdong: added line number in dispatch popup and action
*   12/03/2018: xdong: replaced the CoolGridView control used for presenting dispatch grid with GridView in
*                      order to gain flexible column width. As a result, do loose column adjustability
*                      <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
*                      but now the columns can have different width in the grid, which allowed all columns show up
*   01/21/2019: xdong: modified the query behind dispatch popup, so that the batch size is either the number of products still need to make for the order line
*                      or the maximum batch size allowed, taking the smaller number among the two.
*   02/05/2019: xdong: widen the text length limit for "alias prefix" of batch from 10 to 20 to accomodate longer prefix
*	05/05/2019: peiyu: added print button for each dispatched order. the information on printing label include dispatched date, ponumber, po line_num, item number and description of finish
*	05/06/2019: xdong: Added batch # to the label printed out
*	06/14/2019: Junlu: added print batch list button to print dispatched batch list fromt he dispatched batch grid
*	06/19/2019: xdong: add quantity column to the dispatched batch grid
----------------------------------------------------------------*/
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using CommonLib.Data.EzSqlClient;
using System.Data.Common;



namespace ezMESWeb.Tracking
{
   public partial class Dispatch : ConfigTemplate
   {
      protected global::System.Web.UI.WebControls.SqlDataSource sdsOrder, sdsPDGrid;
      public DataColumnCollection colc;
      protected Label lblError;
      protected Table tblLots;
      protected TableCell tcHeader;
      protected ezDataAdapter ezAdapter;
      protected System.Data.Common.DbDataReader ezReader;
      protected UpdatePanel tbLotPanel;
      protected GridView gvLotTable;
      protected Button btnPrintBatches;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {

                DataView dv = (DataView)sdsPDGrid.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;
                while (colc.Count > 1)
                    colc.RemoveAt(colc.Count - 1);
                colc.Add(new DataColumn("line_num"));
                colc.Add(new DataColumn("ProductName"));
                colc.Add(new DataColumn("process_id"));
                colc.Add(new DataColumn("lot_size"));
                colc.Add(new DataColumn("uom"));
                colc.Add(new DataColumn("num_lots"));
                colc.Add(new DataColumn("alias_prefix"));
                colc.Add(new DataColumn("location_id"));//[peiyu]
                colc.Add(new DataColumn("lot_contact"));
                colc.Add(new DataColumn("lot_priority"));
                //colc.Add(new DataColumn("dispatcher"));
                colc.Add(new DataColumn("comment"));


                //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Dispatch.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Dispatch_Order.xml"));

            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);

         }

      }
    /*
     * correspond to the dispatch link button on the grid
     */

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
         //modify the mode of form view
         FormView1.ChangeMode(FormViewMode.Edit);
         //((DropDownList)FormView1.FindControl("drpprocess_id")).Items.Clear();
         FormView1.DataBind();
         updateRecordPanel.Update();
         // need to take care the product and process relationship.
      }

      protected override void  gvTable_SelectedIndexChanged(object sender, EventArgs e)
      {

        base.gvTable_SelectedIndexChanged(sender, e);
        DropDownList dpProcess =((DropDownList)FormView1.FindControl("drpprocess_id"));
       // string selVal = dpProcess.SelectedValue;

        dpProcess.Items.Clear();

        ConnectToDb();
        ezCmd = new EzSqlCommand();
        ezCmd.Connection = ezConn;
        ezCmd.CommandText = "SELECT id, name FROM process p, product_process pp WHERE pp.product_id="
          +gvTable.SelectedDataKey.Values["source_id"].ToString()
          +" AND p.id=pp.process_id ORDER BY pp.priority desc";
        ezCmd.CommandType = CommandType.Text;
        ezReader = ezCmd.ExecuteReader();
        while (ezReader.Read())
        {

          dpProcess.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
        }
      dpProcess.SelectedIndex = 0;
        //dpProcess.SelectedValue = selVal;
        ezReader.Close();
        ezReader.Dispose();
        ezCmd.Dispose();

        updateRecordPanel.Update();
        this.ModalPopupExtender.Show();
        // need to take care the product and process relationship.
      }

      protected void btnCancel_Click(object sender, EventArgs e)
      {
         lblError.Text = "";
         ModalPopupExtender.Hide();
      }

      protected void btnSubmit_Click(object sender, EventArgs e)
      {
            DataSet newLots = new DataSet();
            TableRow tRow;
            TableCell tCell;
            DataTable tTable;
            if (Page.IsValid)
            {
              string response;
              try
              {
                
                ConnectToDb();
                ezCmd = new EzSqlCommand(); ;
                ezCmd.Connection = ezConn;
                ezMES.ITemplate.FormattedTemplate fTemp;

                ezCmd.CommandText = "dispatch_multi_lots";
                ezCmd.CommandType = CommandType.StoredProcedure;

                ezCmd.Parameters.AddWithValue("@_order_id", Convert.ToInt32(gvTable.SelectedDataKey.Values["id"]));
                ezCmd.Parameters.AddWithValue("@_line_num", Convert.ToInt32(gvTable.SelectedDataKey.Values["line_num"]));
                ezCmd.Parameters.AddWithValue("@_product_id", Convert.ToInt32(gvTable.SelectedDataKey.Values["source_id"]));

                fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;

                LoadSqlParasFromTemplate(ezCmd, fTemp);


                ezCmd.Parameters.AddWithValue("@_dispatcher", Convert.ToInt32(Session["UserID"]));
                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                ezAdapter = new ezDataAdapter();
                ezAdapter.SelectCommand = ezCmd;
                ezAdapter.Fill(newLots);

                response = ezCmd.Parameters["@_response"].Value.ToString();
                ezAdapter.Dispose();
                ezCmd.Dispose();
              }
              catch (Exception ex)
              {
                response = ex.Message;
                
              }
                if (response.Length > 0)
                {
                  lblError.Text = response;
                  this.ModalPopupExtender.Show();
                }
                else
                {
                  lblError.Text = "";
                  this.FormView1.Visible = false;
                  this.ModalPopupExtender.Hide();

                  //  add the css class for our yellow fade
                  ScriptManager.GetCurrent(this).RegisterDataItem(
                    // The control I want to send data to
                      this.gvTable,
                    //  The data I want to send it (the row that was edited)
                      this.gvTable.SelectedIndex.ToString()
                  );

                  gvTable.DataBind();
                  gvTablePanel.Update();
     
                   gvLotTable.DataBind();
                    this.updateBatchBarcode();

                    //tcHeader.Text = "New Lot(s) Information:";
                    //tRow = new TableRow();
                    //tCell = new TableCell();
                    //tCell.Text = "Batch Id";
                    //tRow.Cells.Add(tCell);
                    //tCell = new TableCell();
                    //tCell.Text = "Batch Name";
                    //tRow.Cells.Add(tCell);
                    //tblLots.Rows.Add(tRow);
                    //tTable = newLots.Tables[0];
                    //foreach (DataRow tDrow in tTable.Rows)
                    //{
                    //  tRow = new TableRow();
                    //  tCell = new TableCell();
                    //  tCell.Text = tDrow.ItemArray[0].ToString();
                    //  tRow.Cells.Add(tCell);
                    //  tCell = new TableCell();
                    //  tCell.Text = tDrow.ItemArray[1].ToString();
                    //  tRow.Cells.Add(tCell);
                    //  tblLots.Rows.Add(tRow);
                    //}
                  this.tbLotPanel.Update();

                }

            }
        
      }

     

      protected void sdsPDGrid_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
       {

        }

      protected void btn_Click(object sender, EventArgs e)
      {
         //  set it to true so it will render
         this.FormView1.Visible = true;
         
         FormView1.ChangeMode(FormViewMode.Insert);
         //  force databinding
         this.FormView1.DataBind();
         //  update the contents in the detail panel
         this.updateRecordPanel.Update();
         //  show the modal popup
         this.ModalPopupExtender.Show();
      }

      protected string[] getPOInfo(string strLotID)
      {
            string strSQL = string.Format("SELECT ponumber, order_line_num, product, finish, alias FROM view_lot_in_process WHERE ID={0}", strLotID);

            EzSqlCommand cmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            cmd.Parameters.Clear();
            cmd.Connection = ezConn;
            cmd.CommandText = strSQL;
            cmd.CommandType = CommandType.Text;

            int nCount = 0;
            DbDataReader reader = cmd.ExecuteReader();
            bool bOK = reader.Read();
            string strPONumber = reader.GetString(0);
            string strPOLine = reader.GetString(1);
            string strItemNumber = reader.GetString(2);
            string strFinish = reader.GetString(3);
            string strBatch = reader.GetString(4);

            reader.Close();
            cmd.Dispose();

            string[] strResult = new string[] { strPONumber, strPOLine, strItemNumber, strFinish, strBatch };
            return strResult;
      }

      protected void btnPrintLabel_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "OrderPrint") return;
            //retrieve info from database
            ConnectToDb();
            string[] strPOInfo = this.getPOInfo(e.CommandArgument.ToString());
            ezConn.Dispose();

            //get compoments
            //string strComponent = this.gvTable.Rows[0].Cells[4].Text;

            string strUrl = string.Format("/LabelPrint.aspx?PO={0}&POLine={1}&piececnt={2}&itemnum={3}&finish={4}&batch={5}",
                strPOInfo[0],
                strPOInfo[1],
                "",
                strPOInfo[2],
                strPOInfo[3],
                strPOInfo[4]);

            Server.Transfer(strUrl);

        }

      protected void Page_Load(object sender, EventArgs e)
      {
        string strScript = this.getPrintJS();
        ClientScript.RegisterClientScriptBlock(this.GetType(),
            "doPrint", strScript, true);

        //register post back control for printing
        ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
        scriptManager.RegisterPostBackControl(this.gvLotTable);

        this.updateBatchBarcode();
      }

        protected void updateBatchBarcode()
        {
            for (int i = 0; i < gvLotTable.Rows.Count; i++)
            {
                string batch = gvLotTable.Rows[i].Cells[1].Text;

                Image img = (Image)gvLotTable.Rows[i].FindControl("alias_barcode");
                img.ImageUrl = string.Format("/BarcodeImage.aspx?d={0}&h=60&w=400&il=true&t=Code 128-B", batch);
            }

            btnPrintBatches.Visible = (gvLotTable.Rows.Count > 0);
        }

        protected string getPrintJS()
        {
            string strScript = @"
            function doPrint() {
                var panel = document.getElementById(""" + gvLotTable.ClientID + @""");

                //var pageLink = ""about: blank"";
                var pwa = window.open("""", ""_blank"");
                pwa.document.write('<html><head>');
                pwa.document.write('</head><body >');
                pwa.document.write(panel.outerHTML);
                pwa.document.write('</body></html>');
                pwa.document.close();

                //hide print label icons
                var inputs = pwa.document.getElementsByTagName('input');
                for (var i = 0; i < inputs.length; i++)
                    inputs[i].style.display = ""none"";

                //document title
                pwa.document.title = 'Print Batches';
                pwa.focus();

                return false;
            }";

            return strScript;
        }
    }
}

