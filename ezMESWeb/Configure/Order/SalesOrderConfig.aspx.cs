/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : SalesOrderConfig.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for creating/editing sales orders with general order header and detail ordered product lines
*    Log                    :
*    2009: xdong: first created
*   11/01/2018: xdong: adjusted code to adopt line numbers in order detail
*   12/03/2018: xdong: added product description and product group in order detail grid
*   05/30/2019: xdong: Added line number inputbox in the product info popup when adding product to order
*   05/30/2019: xdong: Added delete order line feature and Dispatch Order button and dispatched batch(es) grid
*   06/19/2019: xdong: Added quantity column in the dispatched batch grid
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
using System.Data.Common;
using AjaxControlToolkit;
using CommonLib.Data.EzSqlClient;
using System.Drawing;

namespace ezMESWeb.Configure.Order
{

    public partial class SalesOrderConfig : TabConfigTemplate
    {
    protected ModalPopupExtender mdlDispatch;
    protected DropDownList ddProduct, ddUom,ddBatchPriority, ddBatchLocation, ddContact;
    protected TextBox requestedTextBox,
            priceTextBox,
            madeTextBox,
            processTextBox,
            shippedTextBox,
            outputTextBox,
            expectedTextBox,
            actualTextBox,
            commentTextBox,
            linenumberTextBox,
            txtLineNumbers,
            txtPrefix,
            txtBatchComment;
    protected Label lblUom, lblErrorDispatch, lblGridError, lblDeleteDetailError, lblActiveTab;
    protected Button btnDispatch, btnNewOrder;
    protected UpdatePanel DispatchBufferPanel, MessageUpdatePanel, UpdatePanel3, InsertionUpdate;
    protected ModalPopupExtender MessagePopupExtender, ModalPopupExtender;
    protected System.Data.Common.DbDataReader ezReaderLot;
    protected UpdatePanel tbLotPanel;
    protected GridView gvLotTable, GridView1;
    protected Button btnPrintBatches;
    protected LinkButton  btnCancelUpdate, btnSubmitUpdate;
    protected TabPanel Tp1, Tp2, Tp3;
    protected DataColumnCollection colc;
    protected FormView insertNewOrder;
    protected SqlDataSource SqlDataSource1;

    protected override void OnInit(EventArgs e)
        {
          base.OnInit(e);
            {
                //Insert_New_Order.xml as new Item Template
                DataView dv = (DataView)sdsMain.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;

                insertNewOrder.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Insert_New_Order.xml"));
            }
          try
          {
            ConnectToDb();
            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;


            ezCmd.CommandText = "SELECT p.id, p.name, u.id as uom_id, u.name as uom_name  FROM product p, uom u WHERE p.uomid = u.id";
            ezCmd.CommandType = CommandType.Text;

            ezReader = ezCmd.ExecuteReader();
            while (ezReader.Read())
            {
              ddProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
              ddUom.Items.Add(new ListItem(String.Format("{0}", ezReader[2]), String.Format("{0}", ezReader[3])));
            }
            if (ddUom.Items.Count > 0)
              lblUom.Text = ddUom.Items[0].Value;  
            ezReader.Close();
            ezReader.Dispose();
            ezCmd.Dispose();
            //ezConn.Dispose();
          }
          catch (Exception ex)
          {
            lblMainError.Text = ex.Message;
          }


            

        }

        

    protected override void Page_Load(object sender, EventArgs e)
    {


        string id = Request.QueryString["Id"];
        short actTab;

        TabPanel temp;
        short count = 0;


        if (!IsPostBack)
        {
                
            if (!lblActiveTab.Text.Equals("")) show_activeTab();
            if(lblActiveTab.Text.Equals("")) show_defaultRow();

        }

            //if (!IsPostBack)
            //{
            //    try
            //    {

            //        ConnectToDb();
            //        ezCmd = new EzSqlCommand();
            //        ezCmd.Connection = ezConn;
            //        ezCmd.CommandText = "SELECT o.id, ponumber, c.name FROM order_general o LEFT JOIN client c ON o.client_id = c.id WHERE order_type = 'customer'";
            //        ezCmd.CommandType = CommandType.Text;
            //        if (ezConn.State == ConnectionState.Open)
            //        {
            //            ezReader = ezCmd.ExecuteReader();
            //            while (ezReader.Read())
            //            {
            //                temp = new TabPanel();
            //                temp.ID = String.Format("{0}", ezReader[0]);
            //                temp.HeaderText = String.Format("{0}", ezReader[1]);
            //                temp.ToolTip = string.Format("order to/from {0}", ezReader[2]);
            //                temp.BackColor = System.Drawing.Color.Silver;
            //                tcMain.Controls.Add(temp);
            //                if ((id != null) && (temp.ID.Equals(id)))
            //                {
            //                    show_ExistObject(count,"1", "1");

            //                }
            //                count++;
            //            }

            //            ezReader.Close();
            //            ezReader.Dispose();
            //            ezCmd.Dispose();

            //            temp = new TabPanel();
            //            temp.ID = "newTab";
            //            temp.HeaderText = "+";
            //            temp.ToolTip = "Add new order.";
            //            temp.BackColor = System.Drawing.Color.Silver;
            //            temp.TabIndex = count;
            //            tcMain.Controls.Add(temp);
            //            tcMain.DataBind();
            //            if (id == null)
            //            {
            //                if (Request.QueryString["Tab"] != null)
            //                {
            //                    actTab = Convert.ToInt16(Request.QueryString["Tab"]);
            //                    if (actTab < count)
            //                        show_ExistObject(actTab, "1","1");
            //                    else
            //                        show_NewObject(count);
            //                }
            //                else
            //                    show_NewObject(count);
            //            }
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        lblMainError.Text = ex.Message;
            //    }

            //}
        //GridView1.SelectedIndexChanged += new EventHandler(GridView1_OnSelectedIndexChanged);
        string strScript = this.getPrintJS();
        ClientScript.RegisterClientScriptBlock(this.GetType(), "doPrint", strScript, true);

        //register post back control for printing
        ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
        scriptManager.RegisterPostBackControl(this.gvLotTable);

        this.updateBatchBarcode();
        
    }


    protected void btnInsert_Onclick(object sender, EventArgs e)
    {

        this.insertNewOrder.Visible = true;
   
        this.insertNewOrder.DataBind();
        this.ModalPopupExtender.Show();
    }

    protected void TabContainer_ActiveTabChanged(object sender, EventArgs e)
    {
            
        //tcMain.ActiveTabIndex = Convert.ToInt16(activeTab);
        lblActiveTab.Text = tcMain.ActiveTabIndex.ToString();
        show_activeTab();
        //fvMain.Visible = false;
        //Server.Transfer(string.Format("/Configure/Order/SalesOrderConfig.aspx?Tab={0}", tcMain.ActiveTabIndex));
    }

    protected void show_activeTab()
    {
        //AjaxControlToolkit.TabPanel activeTab = tcMain.ActiveTab;

        //if (activeTab == Tp1)
        if(Convert.ToInt32(lblActiveTab.Text) == 0)
        {
            // first tab i selected
            btnNewOrder.Style["display"] = "";
            SqlDataSource1.SelectCommand = "SELECT distinct g.id, ponumber, p.name as Priority, DATE_FORMAT((SELECT min(h.state_date) FROM order_state_history h WHERE h.order_id = g.id AND h.state = 'POed'),'%m/%d/%Y') AS order_date, get_local_time(g.expected_deliver_date) as Expected_Deliver_Date, t1.r as Quantity_Requested, t1.pr as Quantity_in_Process, (t1.m + t1.s) as Quantity_Made_Or_Shipped FROM order_general g left join priority p on p.id = g.priority left join order_detail d on d.order_id = g.id left join(select order_id, sum(quantity_requested) as r, sum(quantity_in_process) as pr, sum(quantity_made) as m, sum(quantity_shipped) as s from order_detail group by order_id) t1 on t1.order_id = g.id left join(select order_id, max(quantity_requested -quantity_in_process - quantity_made - quantity_shipped) as diff, max(quantity_in_process) as proc from order_detail group by order_id) t2 on t2.order_id = g.id where t2.diff is null or t2.diff > 0";
        }
        //else if (activeTab == Tp2)
        else if(Convert.ToInt32(lblActiveTab.Text) == 1)
        {
            btnNewOrder.Style["display"] = "none";
            SqlDataSource1.SelectCommand = "SELECT distinct g.id, ponumber, p.name as Priority, DATE_FORMAT((SELECT min(h.state_date) FROM order_state_history h WHERE h.order_id = g.id AND h.state = 'POed'),'%m/%d/%Y') AS order_date, get_local_time(g.expected_deliver_date) as Expected_Deliver_Date, t1.r as Quantity_Requested,t1.pr as Quantity_in_Process, (t1.m + t1.s) as Quantity_Made_Or_Shipped FROM order_general g, priority p, order_detail d, (select order_id, sum(quantity_requested) as r, sum(quantity_in_process) as pr, sum(quantity_made) as m, sum(quantity_shipped) as s from order_detail group by order_id) t1, (select order_id, max(quantity_requested - quantity_in_process - quantity_made - quantity_shipped) as diff, max(quantity_in_process) as proc from order_detail group by order_id) t2 where t1.order_id = g.id and t2.order_id = g.id and t2.diff <= 0 and t2.proc > 0 and d.order_id = g.id and p.id = g.priority";
        }
        else
        {
            btnNewOrder.Style["display"] = "none";
            SqlDataSource1.SelectCommand = "SELECT distinct g.id, ponumber, p.name as Priority, DATE_FORMAT((SELECT min(h.state_date) FROM order_state_history h WHERE h.order_id = g.id AND h.state = 'POed'),'%m/%d/%Y') AS order_date, get_local_time(g.expected_deliver_date) as Expected_Deliver_Date, t1.r as Quantity_Requested,t1.pr as Quantity_in_Process, (t1.m + t1.s) as Quantity_Made_Or_Shipped FROM order_general g, priority p, order_detail d, (select order_id, sum(quantity_requested) as r, sum(quantity_in_process) as pr, sum(quantity_made) as m, sum(quantity_shipped) as s from order_detail group by order_id) t1, (select order_id, max(quantity_requested - quantity_in_process - quantity_made - quantity_shipped) as diff, max(quantity_in_process) as proc from order_detail group by order_id) t2 where t1.order_id = g.id and t2.order_id = g.id and t2.diff <= 0 and t2.proc = 0 and d.order_id = g.id and p.id = g.priority";

        }

        SqlDataSource1.DataBind();
        GridView1.DataBind();
        tcMain.DataBind();
        show_defaultRow();

    }

    protected void show_defaultRow()
    {
        if (GridView1.Rows.Count > 0)
        {
            string orderId = GridView1.DataKeys[0].Values[0].ToString();
            string orderPO = GridView1.Rows[0].Cells[2].Text;
            show_ExistObject(orderId, orderPO);
            GridView1.DataBind();
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.RowIndex == 0)
                {
                    row.BackColor = Color.Gray;
                }
            }
            
        }
        else
        {
            fvMain.Caption = "General Sales Order Information";
            fvMain.ChangeMode(FormViewMode.Insert);
        }
    }

    protected void GridView1_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(GridView1, "Select$" + e.Row.RowIndex);
            e.Row.ToolTip = "Click to select this row.";
        }
    }

        protected void GridView1_OnSelectedIndexChanged(object sender, EventArgs e)
        {

            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.RowIndex == GridView1.SelectedIndex)
                {

                    string orderId = GridView1.DataKeys[row.RowIndex].Values[0].ToString();
                    string orderPO = row.Cells[2].Text;

                    Session["rowIndex"] = row.RowIndex;
                    if (!lblActiveTab.Text.Equals("")) show_activeTab();
                    show_ExistObject(orderId, orderPO);
                    GridView1.DataBind();
                }

            }
                if (Session["rowIndex"] != null)
                {
                    //GridView1.SelectedIndex = Convert.ToInt32(Session["rowIndex"]);

                    foreach (GridViewRow row in GridView1.Rows)
                    {
                        if (row.RowIndex == Convert.ToInt32(Session["rowIndex"]))
                        {
                            row.BackColor = Color.Gray;
                        }
                    }
                }   

        }


        protected void show_ExistObject(string orderId, string orderPO)
        {

            txtID.Text = orderId;
            fvMain.Caption = "General Sales Order Information";
            fvMain.ChangeMode(FormViewMode.ReadOnly);
            fvMain.DataBind();
            string strPONumber = orderPO;
            System.Web.UI.WebControls.Image barcode = (System.Web.UI.WebControls.Image)fvMain.FindControl("barcode_image");
            barcode.ImageUrl = "/BarcodeImage.aspx?d=" + strPONumber + "&h=60&w=400&il=true&t=Code 128-B";

            upMain.Update();
            btnDo.Text = "Update Order Info";
            btnCancel.Text = "Delete Order";
            btnInsert.Visible = true;
            btnDispatch.Visible = true;
            gvTable.Visible = true;
            updateUrl();
            refresh_dispatchPopup();
        }
    
    

    protected void btnInsertOrderSubmit_Click(object sender, EventArgs e)
    {
      
            string response, ponum, newId;

            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "insert_order_general";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezMES.ITemplate.FormattedTemplate fTemp;


                ezCmd.Parameters.AddWithValue("@_order_type", "customer");

                fTemp = (ezMES.ITemplate.FormattedTemplate)insertNewOrder.InsertItemTemplate;

                ezMES.ITemplate.FieldItem theItem = ((ezMES.ITemplate.FieldItem)fTemp.Fields[4]);
                TextBox date1 = (TextBox)insertNewOrder.Row.FindControl(theItem.Key);
                string[] date = date1.Text.Split('/');
                string month = date[0];
                if (month.Length == 1) { month = "0" + month; }
                string day = date[1];
                if (day.Length == 1) { day = "0" + day; }
                string year = date[2];
                date1.Text = year + "-" + day + "-" + month;
                theItem = ((ezMES.ITemplate.FieldItem)fTemp.Fields[10]);
                date1 = (TextBox)insertNewOrder.Row.FindControl(theItem.Key);
                date = date1.Text.Split('/');
                month = date[0];
                if (month.Length == 1) { month = "0" + month; }
                day = date[1];
                if (day.Length == 1) { day = "0" + day; }
                year = date[2];
                date1.Text = year + "-" + day + "-" + month;

                LoadSqlParasFromTemplate(ezCmd, insertNewOrder, fTemp);
                ezCmd.Parameters["@_recorder_id"].Value = Convert.ToInt32(Session["UserID"]);
                ezCmd.Parameters.AddWithValue("@_order_id", DBNull.Value);
                ezCmd.Parameters["@_order_id"].Direction = ParameterDirection.Output;
                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                ponum = ezCmd.Parameters["@_ponumber"].Value.ToString(); //if insert successfully, will need po number of update fvmain

                ezCmd.ExecuteNonQuery();
                response = ezCmd.Parameters["@_response"].Value.ToString();

                if (response.Length > 0)
                {
                    lblMainError.Text = response;
                }
                else
                {

                    object result = ezCmd.Parameters["@_order_id"].Value;
                    if (result.GetType().ToString().Contains("System.Byte"))
                    {
                        System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                        newId = asi.GetString((byte[])result);
                    }
                    else
                    {
                        newId = result.ToString();
                    }



                    //Server.Transfer("SalesOrderConfig.aspx?Id=" + txtID.Text, false);

                    //GridView1.SelectedIndex = Convert.ToInt32(newId);
                    //GridView1.Rows[GridView1.SelectedIndex].BackColor = Color.Yellow;
                    //Session["rowIndex"] = GridView1.Rows.Count - 1;

                    GridView1.PageIndex = Int32.MaxValue;

                    GridView1.DataBind();

                    Session["lastrowIndex"] = GridView1.Rows.Count;
                    
                    show_ExistObject(newId, ponum);
                    //GridView1.DataBind();

                    //show_activeTab();
                    GridView1.Rows[Convert.ToInt32(Session["lastrowIndex"]) - 1].BackColor = Color.Gray;


                    InsertionUpdate.Update();

                    GridView1.DataBind();

                    if (Session["lastrowIndex"] != null)
                    {
                        GridView1.SelectedIndex = Convert.ToInt32(Session["lastrowIndex"]) -1;

                        foreach (GridViewRow row in GridView1.Rows)
                        {
                            if (row.RowIndex == GridView1.SelectedIndex)
                            {
                                row.BackColor = Color.Gray;
                            }
                        }
                    }


                    //Server.Transfer(string.Format("/Configure/Order/SalesOrderConfig.aspx?orderId={0}&orderPO={1}", newId, ponum));

                }
                ezCmd.Dispose();
                ezConn.Dispose();
            }
            catch (Exception ex)
            {
                response = ex.Message;
            }
            
            if (response.Length > 0)
            {
                lblMainError.Text = response;
            }
           


        }

    protected void btnInsertOrderCancel_Click(object sender, EventArgs e)
    {
        ModalPopupExtender.Hide(); 
    }

    private void updateUrl()
    {
        HyperLink statusLink = (HyperLink)fvMain.FindControl("hpStatus");
        statusLink.NavigateUrl = "/Reports/OrderReport.aspx?orderid=" + txtID.Text;
        HyperLink batchLink = (HyperLink)fvMain.FindControl("hpBatch");
        batchLink.NavigateUrl = "/Reports/OrderBatchDetail.aspx?order=" + txtID.Text;
    }

    protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
    {

      if (Request.Params["__EVENTTARGET"].Contains("btnDeleteDetail"))
      {
        string response;

        try
        {
          ConnectToDb();
          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "modify_order_detail";
          ezCmd.CommandType = CommandType.StoredProcedure;

          ezCmd.Parameters.AddWithValue("@_operation", "delete");
          ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);
          ezCmd.Parameters.AddWithValue("@_source_type", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_source_id", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_line_num", gvTable.SelectedDataKey[0].ToString());
          ezCmd.Parameters.AddWithValue("@_quantity_requested", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_unit_price", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_quantity_made", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_quantity_in_process", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_quantity_shipped", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_output_date", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_actual_deliver_date", DBNull.Value);

          ezCmd.Parameters.AddWithValue("@_recorder_id", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_uomid", DBNull.Value);
          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
          ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


          ezCmd.ExecuteNonQuery();
          response = ezCmd.Parameters["@_response"].Value.ToString();
          ezCmd.Dispose();
          ezConn.Dispose();
        }
        catch (Exception exc)
        {
          response = exc.Message;
        }
        if (response.Length > 0)
        {
          lblDeleteDetailError.Text = response;
          MessageUpdatePanel.Update();
          MessagePopupExtender.Show();
        }
        else
        {
          gvTable.DataBind();
          gvTablePanel.Update();
          refresh_dispatchPopup();
        }
      }
      else
      {
        this.fvUpdate.Visible = true;
        //  force databinding
        this.fvUpdate.DataBind();
        //  update the contents in the detail panel
        this.updateBufferPanel.Update();

        this.btnUpdate_ModalPopupExtender.Show();
      }
    }


    protected void btnOK_Click(object sender, EventArgs e)
    {
        lblDeleteDetailError.Text = "";
        MessagePopupExtender.Hide();
    }

    protected override void btnSubmitInsert_Click(object sender, EventArgs e)
    {
        string[] arDate;
        string theDate, theText;
        char[] spliter = { '/' };
        string response;
        try
        {
            ConnectToDb();
            ezCmd =new EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezCmd.CommandText = "modify_order_detail";
            ezCmd.CommandType = CommandType.StoredProcedure;
                
            ezCmd.Parameters.AddWithValue("@_operation", "insert");
            ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);
            ezCmd.Parameters.AddWithValue("@_source_type", "product");
            ezCmd.Parameters.AddWithValue("@_source_id", ddProduct.SelectedValue);
            ezCmd.Parameters.AddWithValue("@_line_num", linenumberTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_quantity_requested", requestedTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_unit_price", priceTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_quantity_made", madeTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_quantity_in_process", processTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_quantity_shipped", shippedTextBox.Text.Trim());
            theText = outputTextBox.Text.Trim();
            if (theText.Length > 0)
            {
                arDate = theText.Split(spliter);
                theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                ezCmd.Parameters.AddWithValue("@_output_date", theDate);
            }
            else
                ezCmd.Parameters.AddWithValue("@_output_date", DBNull.Value);

            theText = expectedTextBox.Text.Trim();
            if (theText.Length > 0)
            {
                arDate = theText.Split(spliter);
                theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                ezCmd.Parameters.AddWithValue("@_expected_deliver_date", theDate);
            }
            else
                ezCmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);

            theText = actualTextBox.Text.Trim();
            if (theText.Length > 0)
            {
                arDate = theText.Split(spliter);
                theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                ezCmd.Parameters.AddWithValue("@_actual_deliver_date", theDate);
            }
            else
                ezCmd.Parameters.AddWithValue("@_actual_deliver_date", DBNull.Value);

            ezCmd.Parameters.AddWithValue("@_recorder_id", Convert.ToInt32(Session["UserID"]));
            ezCmd.Parameters.AddWithValue("@_comment", commentTextBox.Text.Trim());
            ezCmd.Parameters.AddWithValue("@_uomid", ddUom.Items[ddProduct.SelectedIndex].Text);
            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
            ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


            ezCmd.ExecuteNonQuery();
            response = ezCmd.Parameters["@_response"].Value.ToString();
            ezCmd.Dispose();
            ezConn.Dispose();
        }
        catch (Exception exc)
        {
            response = exc.Message;
        }
        if (response.Length > 0)
        {
            lblErrorInsert.Text = response;
               
        }
        else
        {
            gvTable.DataBind();
            this.gvTablePanel.Update();

            fvMain.DataBind();
            updateUrl();
            refresh_dispatchPopup();
            upMain.Update();
            hide_insertPopup();

        }

    }
    protected override void btnCancelInsert_Click(object sender, EventArgs e)
    {
        hide_insertPopup();

    }

    //protected override void btnCancelDispatch_Click(object sender, EventArgs e)
    //{
    //}

    protected override void btnSubmitUpdate_Click(object sender, EventArgs args)
        {
            string[] arDate;
            string theDate;
            char[] spliter = { '/'};

            string response, theText;
            try
            {
                ConnectToDb();
                ezCmd =new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "modify_order_detail";
                ezCmd.CommandType = CommandType.StoredProcedure;

                ezCmd.Parameters.AddWithValue("@_operation", "update");
                ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);
                ezCmd.Parameters.AddWithValue("@_source_type", "product");
                ezCmd.Parameters.AddWithValue("@_source_id", ((Label)fvUpdate.FindControl("productIDLabel")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_line_num", ((Label)fvUpdate.FindControl("LineNumber1")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_quantity_requested", ((TextBox)fvUpdate.FindControl("requestedTextBox")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_unit_price", ((TextBox)fvUpdate.FindControl("priceTextBox")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_quantity_made", ((TextBox)fvUpdate.FindControl("madeTextBox")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_quantity_in_process", ((TextBox)fvUpdate.FindControl("processTextBox")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_quantity_shipped", ((TextBox)fvUpdate.FindControl("shippedTextBox")).Text.Trim());

                theText = ((TextBox)fvUpdate.FindControl("outputTextBox")).Text.Trim();
                if (theText.Length > 0)
                {
                    arDate = theText.Split(spliter);
                    theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                    ezCmd.Parameters.AddWithValue("@_output_date", theDate);
                }
                else
                    ezCmd.Parameters.AddWithValue("@_output_date", DBNull.Value);

                theText = ((TextBox)fvUpdate.FindControl("expectedTextBox")).Text.Trim();
                if (theText.Length > 0)
                {
                    arDate = theText.Split(spliter);
                    theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                    ezCmd.Parameters.AddWithValue("@_expected_deliver_date", theDate);
                }
                else
                    ezCmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);

                theText = ((TextBox)fvUpdate.FindControl("actualTextBox")).Text.Trim();
                if (theText.Length > 0)
                {
                    arDate = theText.Split(spliter);
                    theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                    ezCmd.Parameters.AddWithValue("@_actual_deliver_date", theDate);
                }
                else
                    ezCmd.Parameters.AddWithValue("@_actual_deliver_date", DBNull.Value);

                ezCmd.Parameters.AddWithValue("@_recorder_id", Convert.ToInt32(Session["UserID"]));

                ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvUpdate.FindControl("commentTextBox")).Text.Trim());

                ezCmd.Parameters.AddWithValue("@_uomid", ((Label)fvUpdate.FindControl("uomidLabel")).Text.Trim());
                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                ezCmd.ExecuteNonQuery();
                response = ezCmd.Parameters["@_response"].Value.ToString();
                ezCmd.Dispose();
                ezConn.Dispose();
            }
            catch (Exception exc)
            {
                response = exc.Message;
            }
            if (response.Length > 0)
            {
                lblErrorUpdate.Text = response;

                btnUpdate_ModalPopupExtender.Show();
            }
            else
            {
                gvTable.DataBind();
                this.gvTablePanel.Update();
                fvMain.DataBind();
                updateUrl();
                refresh_dispatchPopup();
                upMain.Update();

            }

        }

    protected void btnDo_Click(object sender, EventArgs e)
        {
            string[] arDate;
            string theDate;
            char[] spliter = { '/' };
            string response, theText, newId;

            if (fvMain.CurrentMode == FormViewMode.Insert)
            {
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "insert_order_general";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_order_type", "customer");
                    theText = ((TextBox)fvMain.FindControl("poTextBox")).Text.Trim();
                    if (theText.Length > 0)
                        ezCmd.Parameters.AddWithValue("@_ponumber", theText);
                    else
                    {
                        lblMainError.Text = "The PO number is required field. Please select a date for the field.";
                        return;
                    }
                    ezCmd.Parameters.AddWithValue("@_client_id", ((DropDownList)fvMain.FindControl("ddClient")).SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_priority", ((DropDownList)fvMain.FindControl("ddPriority")).SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_state", ((DropDownList)fvMain.FindControl("ddStatei")).SelectedValue);

                    theText = ((TextBox)fvMain.FindControl("dateTextBox")).Text.Trim();
                    if (theText.Length > 0)
                    {
                        arDate = theText.Split(spliter);
                        theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                        ezCmd.Parameters.AddWithValue("@_state_date", theDate);
                    }
                    else
                    {
                        lblMainError.Text = "The State Date is required field. Please select a date for the field.";
                        return;
                    }
                    ezCmd.Parameters.AddWithValue("@_net_total", ((TextBox)fvMain.FindControl("netTotalTextBox")).Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_tax_percentage", ((TextBox)fvMain.FindControl("taxPTextBox")).Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_tax_amount", ((TextBox)fvMain.FindControl("taxmTextBox")).Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_other_fees", ((TextBox)fvMain.FindControl("feeTextBox")).Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_total_price", ((TextBox)fvMain.FindControl("totalTextBox")).Text.Trim());

                    theText = ((TextBox)fvMain.FindControl("expectedTextBox")).Text.Trim();
                    if (theText.Length > 0)
                    {
                        arDate = theText.Split(spliter);
                        theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                        ezCmd.Parameters.AddWithValue("@_expected_deliver_date", theDate);
                    }
                    else
                        ezCmd.Parameters.AddWithValue("@_expected_deliver_date", null);

                    ezCmd.Parameters.AddWithValue("@_internal_contact", ((DropDownList)fvMain.FindControl("ddInternal")).SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_external_contact", ((TextBox)fvMain.FindControl("externalTextBox")).Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_recorder_id", Convert.ToInt32(Session["UserID"]));
                    ezCmd.Parameters.AddWithValue("@_order_id", DBNull.Value);
                    ezCmd.Parameters["@_order_id"].Direction = ParameterDirection.Output;
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;



                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();

                    if (response.Length > 0)
                    {
                        lblMainError.Text = response;


                    }
                    else
                    {

                        object result = ezCmd.Parameters["@_order_id"].Value;
                        if (result.GetType().ToString().Contains("System.Byte"))
                        {
                            System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                            newId = asi.GetString((byte[])result);
                        }
                        else
                        {
                            newId = result.ToString();
                        }
                        Server.Transfer("SalesOrderConfig.aspx?Id=" + newId, false);

                    }
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
                catch (Exception ex)
                {
                    lblMainError.Text = ex.Message;
                }
            }
            else if (fvMain.CurrentMode == FormViewMode.Edit)
            {
                try
                {

                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "modify_order_general";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);

                    ezCmd.Parameters.AddWithValue("@_ponumber", ((TextBox)fvMain.FindControl("poTextBox")).Text);

                    ezCmd.Parameters.AddWithValue("@_priority", ((DropDownList)fvMain.FindControl("ddPriority")).SelectedValue);


                    ezCmd.Parameters.AddWithValue("@_state", ((DropDownList)fvMain.FindControl("ddStateu")).SelectedValue);


                    arDate = ((TextBox)fvMain.FindControl("dateTextBox")).Text.Trim().Split(spliter);
                    if (arDate.Length > 0)
                    {
                        theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];

                        ezCmd.Parameters.AddWithValue("@_state_date", theDate);
                    }
                    else
                        ezCmd.Parameters.AddWithValue("@_state_date", DBNull.Value);

                    ezCmd.Parameters.AddWithValue("@_net_total", ((TextBox)fvMain.FindControl("netTotalTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_tax_percentage", ((TextBox)fvMain.FindControl("taxpTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_tax_amount", ((TextBox)fvMain.FindControl("taxmTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_other_fees", ((TextBox)fvMain.FindControl("feeTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_total_price", ((TextBox)fvMain.FindControl("totalTextBox")).Text);

                    arDate = ((TextBox)fvMain.FindControl("expectedTextBox")).Text.Trim().Split(spliter);
                    if (arDate.Length > 0)
                    {
                        theDate = arDate[2] + "-" + arDate[0] + "-" + arDate[1];
                        ezCmd.Parameters.AddWithValue("@_expected_deliver_date", theDate);
                    }
                    else
                        ezCmd.Parameters.AddWithValue("@_expected_deliver_date", DBNull.Value);

                    ezCmd.Parameters.AddWithValue("@_internal_contact", ((DropDownList)fvMain.FindControl("ddInternal")).SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_external_contact", ((TextBox)fvMain.FindControl("externalTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_recorder_id", Convert.ToInt32(Session["UserID"]));
                    ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvMain.FindControl("commentTextBox")).Text);
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
                catch (Exception ex)
                {
                    response = ex.Message;
                }

                if (response.Length > 0)
                {
                    lblMainError.Text = response;


                }
                else
                {

                    Server.Transfer("SalesOrderConfig.aspx?Id=" + txtID.Text, false);
                }
            }
            else
            {
                fvMain.ChangeMode(FormViewMode.Edit);
                fvMain.DataBind();
                upMain.Update();
                ((DropDownList)fvMain.FindControl("ddClient")).SelectedValue =
                 ((Label)fvMain.FindControl("lblClient")).Text;
                ((DropDownList)fvMain.FindControl("ddStateu")).SelectedValue =
                    ((Label)fvMain.FindControl("lblState")).Text;
                ((DropDownList)fvMain.FindControl("ddPriority")).SelectedValue =
                    ((Label)fvMain.FindControl("lblPriority")).Text;
                ((DropDownList)fvMain.FindControl("ddInternal")).SelectedValue =
                    ((Label)fvMain.FindControl("lblInternal")).Text;
                btnDo.Text = "Submit";
                btnCancel.Text = "Cancel";
            }

        }

        protected void btnCancel_Click(object sender, EventArgs e)
    {
            if (fvMain.CurrentMode == FormViewMode.Insert)
            {
                clear_generalInsert();
            }
            else if (btnCancel.Text.Equals("Delete Order"))
            {
                try
                {
                    ConnectToDb();

                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "delete_order";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);


                    ezCmd.ExecuteNonQuery();
                    Server.Transfer("SalesOrderConfig.aspx?Tab=" + tcMain.ActiveTabIndex, false);
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
                catch (Exception ex)
                {
                    lblMainError.Text = ex.Message;
                }


            }
            else
            {
                fvMain.ChangeMode(FormViewMode.ReadOnly);
                fvMain.DataBind();
                updateUrl();
                refresh_dispatchPopup();
                upMain.Update();
            }
        }

  
    protected void clear_generalInsert()
        {
            ((DropDownList)fvMain.FindControl("ddClient")).SelectedIndex = -1;

            ((TextBox)fvMain.FindControl("poTextBox")).Text = "";

            ((DropDownList)fvMain.FindControl("ddStatei")).SelectedIndex = -1;

            ((TextBox)fvMain.FindControl("dateTextBox")).Text = "";

            ((DropDownList)fvMain.FindControl("ddPriority")).SelectedIndex = -1;

            ((TextBox)fvMain.FindControl("netTotalTextBox")).Text = "";

            ((TextBox)fvMain.FindControl("taxpTextBox")).Text = "";
            ((TextBox)fvMain.FindControl("taxmTextBox")).Text = "";

            ((TextBox)fvMain.FindControl("feeTextBox")).Text = "";
            ((TextBox)fvMain.FindControl("totalTextBox")).Text = "";
            ((TextBox)fvMain.FindControl("expectedTextBox")).Text = "";

            ((DropDownList)fvMain.FindControl("ddInternal")).SelectedIndex = -1;

            ((TextBox)fvMain.FindControl("externalTextBox")).Text = "";
            ((TextBox)fvMain.FindControl("commentTextBox")).Text = "";

            lblMainError.Text = "";
        }
    protected void hide_insertPopup()
        {
            lblErrorInsert.Text = "";
            mdlPopup.Hide();
            ddProduct.SelectedIndex = -1;
            requestedTextBox.Text = "";
            ddUom.SelectedIndex = -1;
            priceTextBox.Text = "";
            madeTextBox.Text = "";
            processTextBox.Text = "";
            shippedTextBox.Text = "";
            outputTextBox.Text = "";
            expectedTextBox.Text = "";
            actualTextBox.Text = "";
            commentTextBox.Text = "";
      linenumberTextBox.Text = "";

        }
    private void refresh_dispatchPopup()
    {
      //populate the txtLineNumbers 
      string theText;
      txtLineNumbers.Text = "";
      for (int i = 0; i < gvTable.Rows.Count; i++)
      {
        txtLineNumbers.Text += (i == 0 ? "" : ",") + gvTable.Rows[i].Cells[3].Text;  //line number is the third column in the grid
      }

     //set order po as default prefix. Only take the left 22 characters, because 
      theText = ((Label)fvMain.FindControl("ponumberLabel")).Text;
      if (theText.Length <= 22) 
      {
        txtPrefix.Text = theText + "_";
      }
      else
        txtPrefix.Text = ((Label)fvMain.FindControl("ponumberLabel")).Text.Substring(0, 22) + "_";

      string selPriority = ((Label)fvMain.FindControl("priorityLabel")).Text;
      for (int i = 0; i < ddBatchPriority.Items.Count; i++)
      {
        if (ddBatchPriority.Items[i].Text.Equals(selPriority))
        {
          ddBatchPriority.ClearSelection();
          ddBatchPriority.Items[i].Selected = true;
          break;
        }
      }

      //location defaults to the location of the login user/dispatcher, or not set
      if (Session["LocationId"].ToString().Length > 0)
        ddBatchLocation.SelectedValue = Session["LocationId"].ToString();
      else
        ddBatchLocation.SelectedValue = "0";
      txtBatchComment.Text = "";
      DispatchBufferPanel.Update();
    }
    protected virtual void btnCancelDispatch_Click(object sender, EventArgs e)
    {
      refresh_dispatchPopup();
      mdlDispatch.Hide();
    }
    protected virtual void btnSubmitDispatch_Click(object sender, EventArgs args)
    {
      string response;
      try
      {
        ConnectToDb();
        ezCmd = new EzSqlCommand();
        ezCmd.Connection = ezConn;
        ezCmd.CommandText = "dispatch_order";
        ezCmd.CommandType = CommandType.StoredProcedure;


        ezCmd.Parameters.AddWithValue("@_order_id", txtID.Text);
        ezCmd.Parameters.AddWithValue("@_line_numbers", txtLineNumbers.Text.Trim());
        ezCmd.Parameters.AddWithValue("@_alias_prefix", txtPrefix.Text.Trim());
        if (ddBatchLocation.SelectedValue.Equals('0'))
          ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
        else
          ezCmd.Parameters.AddWithValue("@_location_id", ddBatchLocation.SelectedValue);
        ezCmd.Parameters.AddWithValue("@_lot_priority", ddBatchPriority.SelectedValue);

        ezCmd.Parameters.AddWithValue("@_lot_contact", ddContact.SelectedValue);
        ezCmd.Parameters.AddWithValue("@_comment", txtBatchComment.Text);
        ezCmd.Parameters.AddWithValue("@_dispatcher", Convert.ToInt32(Session["UserID"]));
        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
        ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

        ezCmd.ExecuteNonQuery();
        response = ezCmd.Parameters["@_response"].Value.ToString();

        if (response.Length > 0)
        {
          lblErrorDispatch.Text = response;
        }
        else
        {
          gvTable.DataBind();
          this.gvTablePanel.Update();
          gvLotTable.DataBind();
          this.updateBatchBarcode();

          tbLotPanel.Update();
          mdlDispatch.Hide();

        }
        ezCmd.Dispose();
        ezConn.Dispose();
      }
      catch (Exception ex)
      {
        lblErrorDispatch.Text = ex.Message;
      }
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
    protected string[] getPOInfo(string strLotID)
    {
        string strSQL = string.Format(@"
            SELECT vlp.ponumber, vlp.order_line_num, vlp.product, av.attr_value AS finish, vlp.alias 
                FROM view_lot_in_process AS vlp
                JOIN product as p
                ON p.id = vlp.product_id
                JOIN attribute_value av
                ON av.parent_id = p.id
                JOIN attribute_definition ad
                ON ad.attr_name = 'Metal Finish'
                    AND ad.attr_parent_type = 'product'
                    AND av.attr_id = ad.attr_id
                WHERE vlp.ID={0}", strLotID);

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

        protected void updateBatchBarcode()
        {
            for (int i = 0; i < gvLotTable.Rows.Count; i++)
            {
                string batch = gvLotTable.Rows[i].Cells[1].Text;

                System.Web.UI.WebControls.Image img = (System.Web.UI.WebControls.Image)gvLotTable.Rows[i].FindControl("alias_barcode");
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

    //protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    //{
    //    e.Row.Attributes["onmouseover"] = "this.style.cursor='hand';this.style.textDecoration='underline';";
    //    e.Row.Attributes["onmouseout"] = "this.style.textDecoration='none';";
    //    e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink((GridView)sender, "Select$" + e.Row.RowIndex);

    //}

    //protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "view")
    //    {
    //        GridViewRow gvr = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
    //        TextBox tbComments = ((TextBox)gvr.FindControl("txtcomment"));

    //        tbComments.Visible = true;
    //    }
    //} 


    //protected void show_NewObject(short tabIndex)
    //{

    //    tcMain.ActiveTabIndex = tabIndex;

    //    fvMain.ChangeMode(FormViewMode.Insert);

    //    fvMain.Caption = "General Sales Order Information:";
    //    btnInsert.Visible = false;
    //    btnDispatch.Visible = false;
    //    gvTable.Visible = false;
    //    btnDo.Text = "Submit";
    //    btnCancel.Text = "Clear";
    //}

}
