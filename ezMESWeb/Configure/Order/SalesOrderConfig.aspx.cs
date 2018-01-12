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
using AjaxControlToolkit;

using CommonLib.Data.EzSqlClient;

namespace ezMESWeb.Configure.Order
{

    public partial class SalesOrderConfig : TabConfigTemplate
    {
        protected DropDownList ddProduct, ddUom;

        protected TextBox requestedTextBox, 
            priceTextBox, 
            madeTextBox,
            processTextBox,
            shippedTextBox,
            outputTextBox,
            expectedTextBox,
            actualTextBox,
            commentTextBox;
        protected Label lblUom;

        protected override void OnInit(EventArgs e)
        {
          base.OnInit(e);
          try
          {
            ConnectToDb();
            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;


            ezCmd.CommandText = "SELECT p.id, p.name, u.name as uom_name  FROM product p, uom u WHERE p.uomid = u.id";
            ezCmd.CommandType = CommandType.Text;

            ezReader = ezCmd.ExecuteReader();
            while (ezReader.Read())
            {
              ddProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
              ddUom.Items.Add(new ListItem(String.Format("{0}", ezReader[2]), String.Format("{0}", ezReader[2])));
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


                string id=Request.QueryString["Id"];
                short actTab;
                
                TabPanel temp;
                short count = 0;


                if (!IsPostBack)
                {
                    try
                    {

                        ConnectToDb();
                        ezCmd = new EzSqlCommand();
                        ezCmd.Connection = ezConn;
                        ezCmd.CommandText = "SELECT o.id, ponumber, c.name FROM order_general o LEFT JOIN client c ON o.client_id = c.id WHERE order_type = 'customer'";
                        ezCmd.CommandType = CommandType.Text;
                        if (ezConn.State == ConnectionState.Open)
                        {
                            ezReader = ezCmd.ExecuteReader();
                            while (ezReader.Read())
                            {
                                temp = new TabPanel();
                                temp.ID = String.Format("{0}", ezReader[0]);
                                temp.HeaderText = String.Format("{0}", ezReader[1]);
                                temp.ToolTip = string.Format("order to/from {0}", ezReader[2]);
                                temp.BackColor = System.Drawing.Color.Silver;
                                tcMain.Controls.Add(temp);
                                if ((id != null) && (temp.ID.Equals(id)))
                                {
                                    show_ExistObject(count);

                                }
                                count++;
                            }

                            ezReader.Close();
                            ezReader.Dispose();
                            ezCmd.Dispose();

                            temp = new TabPanel();
                            temp.ID = "newTab";
                            temp.HeaderText = "+";
                            temp.ToolTip = "Add new order.";
                            temp.BackColor = System.Drawing.Color.Silver;
                            temp.TabIndex = count;
                            tcMain.Controls.Add(temp);
                            tcMain.DataBind();
                            if (id == null)
                            {
                                if (Request.QueryString["Tab"] != null)
                                {
                                    actTab = Convert.ToInt16(Request.QueryString["Tab"]);
                                    if (actTab < count)
                                        show_ExistObject(actTab);
                                    else
                                        show_NewObject(count);
                                }
                                else
                                    show_NewObject(count);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMainError.Text = ex.Message;
                    }

                }

              
        }

        protected void show_ExistObject(short tabIndex)
        {
            
            tcMain.ActiveTabIndex = tabIndex;
            txtID.Text = tcMain.ActiveTab.ID;
            fvMain.Caption = "General Sales Order Information";
            fvMain.ChangeMode(FormViewMode.ReadOnly);
            //fvMain.DataBind();
            //upMain.Update();
            btnDo.Text = "Update Order Info";
            btnCancel.Text = "Delete Order";
            btnInsert.Visible = true;
            gvTable.Visible = true;
        }
        protected void show_NewObject(short tabIndex)
        {

            tcMain.ActiveTabIndex = tabIndex;
            
            fvMain.ChangeMode(FormViewMode.Insert);

            fvMain.Caption  = "General Sales Order Information:";
            btnInsert.Visible =false;
            gvTable.Visible = false;
            btnDo.Text = "Submit";
            btnCancel.Text = "Clear";
        }
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {

            this.fvUpdate.Visible = true;
            //  force databinding
            this.fvUpdate.DataBind();
            //  update the contents in the detail panel
            this.updateBufferPanel.Update();
            
            this.btnUpdate_ModalPopupExtender.Show();
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
                ezCmd.Parameters.AddWithValue("@_order_type", "customer");
                ezCmd.Parameters.AddWithValue("@_source_id", ddProduct.SelectedValue);
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
                upMain.Update();
                hide_insertPopup();

            }

        }
        protected override void btnCancelInsert_Click(object sender, EventArgs e)
        {
            hide_insertPopup();

        }

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
                ezCmd.Parameters.AddWithValue("@_order_type", "customer");
                ezCmd.Parameters.AddWithValue("@_source_id", gvTable.SelectedValue.ToString());
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
                upMain.Update();

            }

        }

        protected void btnDo_Click(object sender, EventArgs e)
        {
            string[] arDate;
            string theDate;
            char[] spliter = { '/' };
            string response, theText, newId;

            if (fvMain.CurrentMode==FormViewMode.Insert)
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
                    ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvMain.FindControl("commentTextBox")).Text.Trim());

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
                      Response.Redirect("SalesOrderConfig.aspx?Id=" + newId);

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

                    Response.Redirect("SalesOrderConfig.aspx?Id=" + txtID.Text);
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
                    Response.Redirect("SalesOrderConfig.aspx?Tab=" + tcMain.ActiveTabIndex);
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
                upMain.Update();
            }
        }

        protected void tcMain_ActiveTabChanged(object sender, EventArgs e)
        {
            if (tcMain.ActiveTabIndex+1 == tcMain.Controls.Count)
                show_NewObject((short)tcMain.ActiveTabIndex);
            else
                show_ExistObject((short)tcMain.ActiveTabIndex);
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

        }

            
            



    }
}
