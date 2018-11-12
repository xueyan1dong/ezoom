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
----------------------------------------------------------------*/
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using CommonLib.Data.EzSqlClient;

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

   }
}

