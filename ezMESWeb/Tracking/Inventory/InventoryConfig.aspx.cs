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
using System.Web.Configuration;
using AjaxControlToolkit;
using System.Globalization;
namespace ezMESWeb.Tracking.Inventory
{
   public partial class InventoryConfig : ConfigTemplate
   {
      protected global::System.Web.UI.WebControls.SqlDataSource sdsInventoryGrid;
      public DataColumnCollection colc;
      protected Label lblError;
      protected Label lblError1;
      protected FormView FormView2;
      protected ModalPopupExtender ModalPopupExtender1;
      protected global::System.Web.UI.WebControls.SqlDataSource SqlDataSource1;
      protected UpdatePanel UpdatePanel1;
      
        protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

       {
            DataView dv = (DataView)sdsInventoryGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;
                
                //while (colc.Count > 1)
                //    colc.RemoveAt(colc.Count - 1);
                //colc.Add(new DataColumn("source_type"));
                //colc.Add(new DataColumn("pd_or_mt_id"));
                //colc.Add(new DataColumn("lot_id"));
                //colc.Add(new DataColumn("serial_no"));
                //colc.Add(new DataColumn("out_order_id"));
                //colc.Add(new DataColumn("in_order_id"));
                //colc.Add(new DataColumn("original_quantity"));//[peiyu]
                //colc.Add(new DataColumn("actual_quantity"));
                //colc.Add(new DataColumn("location_id"));
                //colc.Add(new DataColumn("uom_id"));
                //colc.Add(new DataColumn("manufacture_date"));
                //colc.Add(new DataColumn("expiration_date"));
                //colc.Add(new DataColumn("arrive_date"));
                //colc.Add(new DataColumn("contact_employee"));
                //colc.Add(new DataColumn("comment"));

                //Initial insert template  
                FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Inventory.xml"));

                //Initial Edit template           
                FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Inventory.xml"));

                FormView2.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Inventory_Relocate.xml"));
                //Event happens before the select index changed clicked.
                gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);

         }
      }

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
         //modify the mode of form view
         FormView1.ChangeMode(FormViewMode.Edit);
         FormView1.Caption = "Copy An Inventory";
         FormView1.DataBind();
      }

      protected void btnCancel_Click(object sender, EventArgs e)
      {
         lblError.Text = "";
         ModalPopupExtender.Hide();
      }
      protected void btnSubmit_Click(object sender, EventArgs e)
      {
        string sourceType = "";
         if (Page.IsValid)
         {
            string response;
            ConnectToDb();
            ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            ezCmd.Connection = ezConn;
            ezMES.ITemplate.FormattedTemplate fTemp;


            if (FormView1.CurrentMode == FormViewMode.Insert)
            {
               ezCmd.CommandText = "insert_inventory";
               ezCmd.CommandType = CommandType.StoredProcedure;
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

            }
            else  //this code should never been executed.
            {
               ezCmd.CommandText = "insert_inventory";
               ezCmd.CommandType = CommandType.StoredProcedure;
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
            }

            ezCmd.Parameters.AddWithValue("@_recorded_by", Convert.ToInt32(Session["UserID"]));
            sourceType = ((DropDownList)FormView1.FindControl("drpsource_type")).SelectedValue;
            ezCmd.Parameters.AddWithValue("@_source_type", sourceType);
            if (sourceType.Equals("product"))
            {
              ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", ((DropDownList)FormView1.FindControl("drppd_or_mt_id")).SelectedValue);
              ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
            }
            else
            {
              ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", ((DropDownList)FormView1.FindControl("drpmt_id")).SelectedValue);
              //ezCmd.Parameters.AddWithValue("@_supplier_id", ((DropDownList)FormView1.FindControl("drpsupplier_id")).SelectedValue);
              ezCmd.Parameters.AddWithValue("@_supplier_id", 0);
            }
            LoadSqlParasFromTemplate(ezCmd, fTemp);

            ezCmd.Parameters.AddWithValue("@_inventory_id", DBNull.Value);
            ezCmd.Parameters["@_inventory_id"].Direction = ParameterDirection.Output;
            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
            ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

            ezCmd.ExecuteNonQuery();
            response = ezCmd.Parameters["@_response"].Value.ToString();
            ezCmd.Dispose();
            ezConn.Dispose();

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
               this.gvTablePanel.Update();

            }
         }

      }

        protected void GridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
            if (e.CommandName == "EditLocation")
            {
                this.FormView2.Visible = true;
                Label id = FormView2.FindControl("lblid") as Label;
                Label name = FormView2.FindControl("lblname") as Label;
                Label uom_id = FormView2.FindControl("lbluom_id") as Label;
                TextBox actual_quantity = FormView2.FindControl("txtactual_quantity") as TextBox;
                GridViewRow selectedRow = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
                id.Text = selectedRow.Cells[3].Text;
                name.Text = selectedRow.Cells[5].Text;
                actual_quantity.Text = selectedRow.Cells[14].Text;
                uom_id.Text = selectedRow.Cells[16].Text;
                this.UpdatePanel1.Update();
                this.ModalPopupExtender1.Show();
            }
            
        }
        protected void btnSubmitRelo_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                TextBox quantity = this.FormView2.FindControl("txtactual_quantity") as TextBox;
                Label id = this.FormView2.FindControl("lblid") as Label;
                DropDownList location = this.FormView2.FindControl("drplocation_id") as DropDownList;
                TextBox comment = this.FormView2.FindControl("txtcomment") as TextBox;
                //Label uom_id = this.FormView2.FindControl("lbluom_id") as Label;
                string response = "";

                try
                {
                    System.Data.Common.DbDataReader ezReader;
                    ConnectToDb();
                    ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
                    ezCmd.Connection = ezConn; //revise from below + connect with commented
                    ezCmd.CommandText = "Select source_type, pd_or_mt_id, supplier_id, lot_id, serial_no, out_order_id, in_order_id, original_quantity, actual_quantity," +
                                    "uom_id, manufacture_date, expiration_date, arrive_date, recorded_by, contact_employee, comment, location_id from inventory WHERE id= " + id.Text;
                    ezCmd.CommandType = CommandType.Text;
                    ezReader = ezCmd.ExecuteReader();
                    if (ezReader.Read())
                    {
                        ezCmd.CommandText = "relocate_inventory";
                        ezCmd.CommandType = CommandType.StoredProcedure;
                        ezCmd.Parameters.AddWithValue("@_source_type", String.Format("{0}", ezReader[0]));
                        ezCmd.Parameters.AddWithValue("@_pd_or_mt_id", String.Format("{0}", ezReader[1]));
                        ezCmd.Parameters.AddWithValue("@_supplier_by", String.Format("{0}", ezReader[2]));
                        ezCmd.Parameters.AddWithValue("@_lot_id", String.Format("{0}", ezReader[3]));
                        ezCmd.Parameters.AddWithValue("@_serial_no", String.Format("{0}", ezReader[4]));
                        ezCmd.Parameters.AddWithValue("@_out_order_id", String.Format("{0}", ezReader[5]));
                        ezCmd.Parameters.AddWithValue("@_in_order_id", String.Format("{0}", ezReader[6]));
                        if(String.Format("{0}", ezReader[7]).Length != 0) ezCmd.Parameters.AddWithValue("@_original_quantity", String.Format("{0}", ezReader[7]));
                        else ezCmd.Parameters.AddWithValue("@_original_quantity", DBNull.Value);
                        if (String.Format("{0}", ezReader[8]).Length != 0) ezCmd.Parameters.AddWithValue("@_actual_quantity", String.Format("{0}", ezReader[8]));
                        else ezCmd.Parameters.AddWithValue("@_actual_quantity", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_uom_id", String.Format("{0}", ezReader[9]));
                        if(String.Format("{0}", ezReader[10]).Length != 0) ezCmd.Parameters.AddWithValue("@_manufacture_date", DateTime.ParseExact(String.Format("{0}", ezReader[10]), "M/d/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture));
                        else ezCmd.Parameters.AddWithValue("@_manufacture_date", DBNull.Value);
                        if(String.Format("{0}", ezReader[11]).Length != 0) ezCmd.Parameters.AddWithValue("@_expiration_date", DateTime.ParseExact(String.Format("{0}", ezReader[11]), "M/d/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture));
                        else ezCmd.Parameters.AddWithValue("@_expiration_date", DBNull.Value);
                        if (String.Format("{0}", ezReader[12]).Length != 0) ezCmd.Parameters.AddWithValue("@_arrive_date", DateTime.ParseExact(String.Format("{0}", ezReader[12]), "M/d/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture));
                        else ezCmd.Parameters.AddWithValue("@_arrive_date", DBNull.Value);
                        if (String.Format("{0}", ezReader[13]).Length != 0) ezCmd.Parameters.AddWithValue("@_recorded_by", String.Format("{0}", ezReader[13]));
                        else ezCmd.Parameters.AddWithValue("@_recorded_by", DBNull.Value);
                        if (String.Format("{0}", ezReader[14]).Length != 0) ezCmd.Parameters.AddWithValue("@_contact_employee", String.Format("{0}", ezReader[14]));
                        else ezCmd.Parameters.AddWithValue("@_contact_employee", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_comment", String.Format("{0}", ezReader[15]));
                        if (String.Format("{0}", ezReader[16]).Length != 0) ezCmd.Parameters.AddWithValue("@_location_id", String.Format("{0}", ezReader[16]));
                        else ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_inventory_id", id.Text);
                        if (quantity.Text.Length != 0) ezCmd.Parameters.AddWithValue("@_quantity_relocate", quantity.Text);
                        else ezCmd.Parameters.AddWithValue("@_quantity_relocate", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_location_id_relocate", location.SelectedValue);
                        ezCmd.Parameters.AddWithValue("@_new_comment", comment.Text);
                        //ezCmd.Parameters.AddWithValue("@_new_uom_id", uom_id.Text);
                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                        ezCmd.ExecuteNonQuery();
                        response = ezCmd.Parameters["@_response"].Value.ToString();
                        ezCmd.Dispose();
                        ezConn.Dispose();

                        if (response.Length > 0)
                        {
                            lblError1.Text = response;    
                        }
                        else
                        {
                            lblError1.Text = "";
                
                            //  add the css class for our yellow fade
                            ScriptManager.GetCurrent(this).RegisterDataItem(
                                // The control I want to send data to
                                this.gvTable,
                                //  The data I want to send it (the row that was edited)
                                this.gvTable.SelectedIndex.ToString()
                            );

                            //gvTable.DataBind();
                            //this.gvTablePanel.Update();
                        }
                    }
                }catch (Exception ex)
                {
                    lblError1.Text = ex.Message;
                }
                gvTable.DataBind();
                this.gvTablePanel.Update();
               
            }
            
        }


      protected void btn_Click(object sender, EventArgs e)
      {
         //  set it to true so it will render

        FormView1.ChangeMode(FormViewMode.Insert);
        


         this.FormView1.Visible = true;
         //this.FormView2.Visible = false;
         //  force databinding
         this.FormView1.DataBind();
         //  update the contents in the detail panel


         this.updateRecordPanel.Update();

         this.ModalPopupExtender.Show();
      }

   }
}
