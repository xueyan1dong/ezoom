/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : EndConsumeMaterial.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : UI for ending the consume material step
*    Log: 
*    12/04/2018: Xueyan Dong: Fixed issue with condition step not going to Failed branch
*    02/11/2019: Xueyan Dong: For "return to inventory popup”, change from only listing inventory that were just consumed from, 
*                             to listing not only inventory that were just consumed from, but also inventory that were not consumed from 
*                             — so that the parts can be returned to any inventory as long as it is the same parts.
*                             In Condition step, hide consume inventory quick access controls, which is implemented for using scan gun to 
*                             quickly consume materials
*   04/19/2019: Xueyan Dong: Changed quantity display format in ingredients to decimal with 1 decimal for non-integer quantity   
*   05/06/2019: Xueyan Dong: Corrected the PO Line # value sent to "Print Package Label". Also added batch # to the label content
----------------------------------------------------------------*/

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommonLib.Data.EzSqlClient;
using AjaxControlToolkit;
using System.Data.Common;

namespace ezMESWeb.Tracking
{
    public partial class EndConsumeMaterial : TrackTemplate
    {
        protected Label lblStep, lblUom, lblError2, lblEquipment, lblStartTime, lblStepStatus, lblMessage, lblLotStatus2, stepPrint, lblProcess;
        protected Label lblSubProcessId, lblPositionId, lblSubPositionId, lblStepId, lblApprover, lblResult, lblPartName;
        protected TextBox txtQuantity, txtComment, txtPassword, txtPartName;
        protected DropDownList drpEquipment, drpApprover;
        private string stepId, stepType;

        protected Button btnDo, btnPrintLabel, btnPrintList, btnMove;

        protected ConsumptionStep newStep;
        protected SqlDataSource sdsPDGrid;
        public DataColumnCollection colc;
        protected ModalPopupExtender MessagePopupExtender;
        protected RadioButtonList rbResult;
        //protected Panel MessagePanel;
        protected Image po_barcode, name_barcode, product_barcode;

        protected override void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);

            this.Form.DefaultButton = btnMove.UniqueID;
        }

        protected override void OnInit(EventArgs e)

        {
            base.OnInit(e);

            {
                DataView dv = (DataView)sdsPDGrid.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;

                //Initial insert template  
                FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"EndReturnMaterial.xml"));
                //Initial Edit template           
                FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"EndConsumeMaterial.xml"));

                //Event happens before the select index changed clicked.
                //gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
            }

            string response;
            if (Session["UserID"] == null)
                Server.Transfer("/Default.aspx");
            else
            {
                Label tLabel = (Label)Page.Master.FindControl("lblName");
                if (!tLabel.Text.StartsWith("Welcome"))
                    tLabel.Text = "Welcome " + (string)(Session["FirstName"]) + "!";
            }

            if (!IsPostBack)
            {
                stepId = Request.QueryString["step"];
                //lblUom.Text = Session["uom"].ToString();
                txtQuantity.Text = Request.QueryString["quantity"];
         
                if (Request.QueryString["step_type"].Equals("condition"))
                {
                    lblResult.Visible = true;
                    rbResult.Visible = true;
                }

                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    if (Request.QueryString["equipment"].Length > 0)
                    {
                        ezCmd.CommandText = "SELECT name FROM equipment WHERE id= " + Request.QueryString["equipment"];
                        ezCmd.CommandType = CommandType.Text;
                        lblEquipment.Text = ezCmd.ExecuteScalar().ToString();
                    }
                    ezCmd.CommandText = "SELECT comment FROM lot_status WHERE id = " + Request.QueryString["lot_id"];/*Session["lot_id"].ToString();*/
                    ezCmd.CommandType = CommandType.Text;
                    txtComment.Text = ezCmd.ExecuteScalar().ToString();

                    ezCmd.CommandText = "SELECT uom from view_lot_in_process where id = " + Request.QueryString["lot_id"];
                    ezCmd.CommandType = CommandType.Text;
                    lblUom.Text = ezCmd.ExecuteScalar().ToString();

                    ezCmd.CommandText = "SELECT name, emp_usage, emp_id  FROM step where id=" + stepId;
                    ezCmd.CommandType = CommandType.Text;
                    ezReader = ezCmd.ExecuteReader();

                    if (ezReader.Read())
                    {
                        lblStep.Text = String.Format("{0}", ezReader[0]);
                        stepPrint.Text = String.Format("{0}", ezReader[0]);//load step for print
                        string empUsage = String.Format("{0}", ezReader[1]);
                        string empId = String.Format("{0}", ezReader[2]);
                        ezReader.Close();
                        //ezReader.Dispose();

                        if (empId.Length > 0)
                        {
                            ezCmd.CommandText = "check_emp_access";
                            ezCmd.CommandType = CommandType.StoredProcedure;
                            ezCmd.Parameters.AddWithValue("@_emp_id", Convert.ToInt32(Session["UserID"]));
                            ezCmd.Parameters.AddWithValue("@_emp_usage", empUsage);
                            ezCmd.Parameters.AddWithValue("@_allow_emp_id", Convert.ToInt32(empId));
                            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                            if (Convert.ToInt32(ezCmd.ExecuteScalar()) == 0)
                                lblError.Text = "You are not allowed to access this step.";

                            response = ezCmd.Parameters["@_response"].Value.ToString();
                            if (response.Length > 0)
                            {
                                lblError.Text = response;
                            }

                            if (lblError.Text.Length > 0)
                            {
                                btnDo.Visible = false;
                                lblStep.Visible = false;
                                lblUom.Visible = false;
                                newStep.Visible = false;
                                txtQuantity.Visible = false;
                                txtComment.Visible = false;
                                lblEquipment.Visible = false;
                                ezReader.Dispose();
                                ezCmd.Dispose();
                                ezConn.Dispose();
                                return;
                            }
                        }
                    }
                    else
                    {
                        if ((ezReader != null) && (!ezReader.IsClosed))
                            ezReader.Close();
                        //ezReader.Dispose();
                    }
                    //toggle approval controls depending whether the step needs approval
                    ezCmd.Dispose();
                    ezReader.Dispose();
                    // if not reinitialize an new ezCmd,
                    // for some reason, there is an error saying Reader is not closed with the command. -- x.d.
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText =
                      "SELECT need_approval, approve_emp_usage, approve_emp_id FROM process_step WHERE process_id= "
                      + Request.QueryString["process_id"]/*Session["process_id"].ToString()*/
                      + " AND position_id = "
                      + Request.QueryString["position"]
                      + " AND step_id = " + Request.QueryString["step"];
                    ezCmd.CommandType = CommandType.Text;


                    ezReader = ezCmd.ExecuteReader();
                    if (ezReader.Read())
                    {
                        if (ezReader[0].ToString().Equals("1"))
                        {
                            switch (ezReader[1].ToString())
                            {
                                case "employee group":
                                    ezCmd.CommandText = "SELECT CONCAT(firstname, ' ', lastname), id FROM employee WHERE eg_id = "
                                      + ezReader[2].ToString();
                                    break;
                                case "employee":
                                    ezCmd.CommandText = "SELECT CONCAT(firstname, ' ', lastname), id FROM employee WHERE id = "
                                      + ezReader[2].ToString();
                                    break;
                                    //didn't deal with "employee category"
                            }
                            ezCmd.CommandType = CommandType.Text;
                            ezReader.Close();
                            ezReader = ezCmd.ExecuteReader();
                            if (ezReader.Read())
                            {
                                drpApprover.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
                                lblApprover.Visible = true;
                                drpApprover.Visible = true;
                                txtPassword.Visible = true;
                            }
                            ezReader.Dispose();
                        }
                    }

                    //determine whether to display print buttons
                    this.verifyPrint(stepId);

                    //determine whether to display input box for handheld scanner
                    this.verifyMoveConsumeButton(Request.QueryString["step_type"]);
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                }
                //newStep don't need to show Recipe grid, because the End form has one already.
                newStep.ShowRecipe = false;
                if (ezReader != null)
                    ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
            }
        }
        //protected override void Page_Load(object sender, EventArgs e)
        //{

        //}
        private void LotLocalPrintEvent(object sender, EventArgs e)
        {


        }
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            string partName = gvTable.SelectedDataKey.Values["name"].ToString();

            //this.FormView1.DataBind();

            if (Request.Params["__EVENTTARGET"].Contains("btnConsume"))
                this.fromInventory(partName);
            else
                this.toInventory(partName);
        }

        protected void fromInventory(string partName)
        {
            lblError2.Text = "";

            FormView1.ChangeMode(FormViewMode.Edit);
            this.FormView1.DataBind();
            //  update the contents in the detail panel
            DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
            ddInventory.Width = 280;
            ddInventory.Items.Clear();
            Label lblRequired = (Label)FormView1.FindControl("lblrequired_quantity");
            TextBox txtActual = (TextBox)FormView1.FindControl("txtused_quantity");
            Decimal defaultQuantity =
                      Convert.ToDecimal(gvTable.SelectedDataKey.Values["required_quantity"])
              - Convert.ToDecimal(gvTable.SelectedDataKey.Values["used_quantity"]);
            txtActual.Text = lblRequired.Text = string.Format("{0:F1}", defaultQuantity);
            FormView1.Caption = "Consume More '" + partName + "' from Inventory";
            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText =
                  " SELECT concat(i.lot_id, IF(i.serial_no IS NULL ,'', CONCAT('(',i.serial_no,')')), ', ', CAST(i.actual_quantity AS DECIMAL(16,1)),' ', u.name), i.id FROM inventory i, uom u WHERE i.source_type ='"
                + gvTable.SelectedDataKey.Values["source_type"].ToString()
                + "' AND i.pd_or_mt_id = " + gvTable.SelectedDataKey.Values["ingredient_id"].ToString()
                + " AND i.actual_quantity>0 AND u.id = i.uom_id";

                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    ddInventory.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
                }
                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                if (ezReader != null)
                    ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
            }


            FormView1.Visible = true;
            this.updateRecordPanel.Update();
            //  show the modal popup
            this.ModalPopupExtender.Show();
        }

        protected void toInventory(string partName)
        {
            lblError2.Text = "";

            FormView1.ChangeMode(FormViewMode.Insert);
            FormView1.Caption = "Return Some '" + partName + "' to Inventory";
            FormView1.DataBind();
            DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
            ddInventory.Width = 280;
            ddInventory.Items.Clear();
            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;


        ezCmd.CommandText = "SELECT CONCAT( CAST(i.lot_id AS CHAR)" +
            ", IF(i.serial_no IS NULL ,'', CONCAT('(',i.serial_no,')')), ' consumed at ', date_format(str_to_date(c.start_timecode, '%Y%m%d%H%i%s0' ), '%m/%d/%Y %I:%i%p')) as c1," +
            " CONCAT(c.start_timecode,',', CAST(c.quantity_used AS DECIMAL(16,1)), ',', CAST(i.uom_id AS CHAR),',', CAST(c.inventory_id AS CHAR), ',', u.name) as c2" +
            " FROM inventory_consumption c, inventory i, uom u WHERE c.lot_id ="
            + /*Session["lot_id"].ToString()*/ Request.QueryString["lot_id"] +
            " AND c.start_timecode > '" + Request.QueryString["start_time"] +
            "' AND i.id = c.inventory_id " +
            " AND i.source_type = '" + gvTable.SelectedDataKey.Values["source_type"].ToString() +
            "' AND i.pd_or_mt_id = " + gvTable.SelectedDataKey.Values["ingredient_id"].ToString() +
            " AND u.id = c.uom_id " +
            " UNION SELECT CONCAT(CAST(i.lot_id AS CHAR) " +
            ", IF(i.serial_no IS NULL, '', CONCAT('(', i.serial_no, ')')), 'not consummed by this batch'), " +
            " CONCAT('1999-01-01,0,', CAST(i.uom_id AS CHAR),',', CAST(i.id AS CHAR),',',u.name) " +
            " FROM inventory i, uom u WHERE i.source_type = '" + gvTable.SelectedDataKey.Values["source_type"].ToString() +
            "' AND i.pd_or_mt_id = " + gvTable.SelectedDataKey.Values["ingredient_id"].ToString() +
            " AND u.id = i.uom_id AND NOT EXISTS(SELECT c.inventory_id FROM inventory_consumption c WHERE c.inventory_id = i.id AND c.lot_id =" +
            Request.QueryString["lot_id"] + " AND c.start_timecode > '" + Request.QueryString["start_time"] + "') ";
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    ddInventory.Items.Add(new ListItem(String.Format("{0}", ezReader[0]), String.Format("{0}", ezReader[1])));
                }
                if (ddInventory.Items.Count > 0)
                {
                    ddInventory.SelectedIndex = 0;
                    string[] dataValues = ddInventory.Items[0].Value.Split(',');
                    Label lblRequired = (Label)FormView1.FindControl("lblrequired_quantity");
                    lblRequired.Text = dataValues[1];
                    Label lblUom = (Label)FormView1.FindControl("lbluom_name");
                    lblUom.Text = dataValues[4];
                }
                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                if (ezReader != null)
                    ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();
                return;
            }

            FormView1.Visible = true;
            this.updateRecordPanel.Update();
            //  show the modal popup
            this.ModalPopupExtender.Show();
        }

        protected void btnListForm_Click(object sender, EventArgs e)
        {
            MessagePopupExtender.Hide();
            Server.Transfer("MoveLot.aspx");
        }
        protected void btnMoveForm_Click(object sender, EventArgs e)
        {
            try
            {
                ConnectToDb();

                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
            }
            if (lblStartTime.Text.Length > 0)
                //next step auto started
                GoEndStep(Request.QueryString["lot_id"],//Session["lot_id"].ToString(),
                          Request.QueryString["lot_alias"], //Session["lot_alias"].ToString(),
                          lblLotStatus2.Text,//Session["lot_status"].ToString(),
                          lblStartTime.Text,
                          lblStepStatus.Text,
                          Request.QueryString["process_id"],//Session["process_id"].ToString(),
                          lblSubProcessId.Text,
                          lblPositionId.Text,
                          lblSubPositionId.Text,
                          lblStepId.Text,
                          null,
                          txtQuantity.Text.Trim(),
                          null);
            else
                //go to start form for next step
                GoNextStep(Request.QueryString["lot_id"],//Session["lot_id"].ToString(),
                           Request.QueryString["lot_alias"], //Session["lot_alias"].ToString(),
                           lblLotStatus2.Text,//Session["lot_status"].ToString(),
                           lblStepStatus.Text,
                           Request.QueryString["process_id"],//Session["process_id"].ToString(),
                           Request.QueryString["sub_process"],
                           Request.QueryString["position"],
                           Request.QueryString["sub_position"],
                           Request.QueryString["step"],
                           rbResult.SelectedValue,
                           txtQuantity.Text.Trim()
                           );
            ezCmd.Dispose();
            ezConn.Dispose();
        }
        protected void btnDo_Click(object sender, EventArgs e)
        {

            string subProcessId, positionId, subPositionId, stepId;
            string locationID = "";
            try
            {
                ConnectToDb();

                ezCmd = new EzSqlCommand();

                ezCmd.Connection = ezConn;

                //pull location_id from view
                ezCmd.CommandText = "SELECT location_id from view_lot_in_process where id = " + Request.QueryString["lot_id"];
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                if (ezReader.Read())
                {
                    locationID = String.Format("{0}", ezReader[0]);
                }
                ezReader.Dispose();
                ezCmd.CommandText = "end_lot_step";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]/*Session["lot_id"]*/));
                ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]/*Session["lot_alias"].ToString()*/);
                ezCmd.Parameters.AddWithValue("@_start_timecode", Request.QueryString["start_time"]);
                ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
                ezCmd.Parameters.AddWithValue("@_end_quantity", txtQuantity.Text.Trim());
                if (drpApprover.Visible == true)
                {
                    ezCmd.Parameters.AddWithValue("@_approver_id", drpApprover.SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_approver_password", txtPassword.Text);
                }
                else
                {
                    ezCmd.Parameters.AddWithValue("@_approver_id", DBNull.Value);
                    ezCmd.Parameters.AddWithValue("@_approver_password", DBNull.Value);
                }
                if (Request.QueryString["step_type"].Equals("condition") && rbResult.Visible == true)
                    ezCmd.Parameters.AddWithValue("@_short_result", rbResult.SelectedValue);
                else
                    ezCmd.Parameters.AddWithValue("@_short_result", DBNull.Value);
                ezCmd.Parameters.AddWithValue("@_result_comment", txtComment.Text);
                if (locationID.Length == 0)
                    ezCmd.Parameters.AddWithValue("@_location_id", DBNull.Value); //added 8/7/2018
                else
                    ezCmd.Parameters.AddWithValue("@_location_id", locationID); //added 8/2/2018 peiyu

                ezCmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(Request.QueryString["process_id"]/*Session["process_id"]*/), ParameterDirection.InputOutput);

                subProcessId = Request.QueryString["sub_process"];
                if (subProcessId.Length > 0)
                    ezCmd.Parameters.AddWithValue("@_sub_process_id", subProcessId, ParameterDirection.InputOutput);
                else
                    ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value, ParameterDirection.InputOutput);

                positionId = Request.QueryString["position"];

                ezCmd.Parameters.AddWithValue("@_position_id", (positionId.Length > 0) ? positionId : "1", ParameterDirection.InputOutput);

                subPositionId = Request.QueryString["sub_position"];
                if (subPositionId.Length > 0)
                    ezCmd.Parameters.AddWithValue("@_sub_position_id", subPositionId, ParameterDirection.InputOutput);
                else
                    ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value, ParameterDirection.InputOutput);

                stepId = Request.QueryString["step"];
                if (stepId.Length > 0)
                    ezCmd.Parameters.AddWithValue("@_step_id", stepId, ParameterDirection.InputOutput);
                else
                    ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value, ParameterDirection.InputOutput);

                ezCmd.Parameters.AddWithValue("@_lot_status", DBNull.Value, ParameterDirection.Output);
                ezCmd.Parameters.AddWithValue("@_step_status", DBNull.Value, ParameterDirection.Output);
                ezCmd.Parameters.AddWithValue("@_autostart_timecode", DBNull.Value, ParameterDirection.Output);
                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                ezCmd.ExecuteNonQuery();
                string response = ezCmd.Parameters["@_response"].Value.ToString();



                if (response.Length > 0)
                    lblError.Text = response;
                else
                {
                    /*Session["lot_status"]*/
                    lblLotStatus2.Text = ezCmd.Parameters["@_lot_status"].Value.ToString();
                    lblStepStatus.Text = ezCmd.Parameters["@_step_status"].Value.ToString();
                    lblStartTime.Text = ezCmd.Parameters["@_autostart_timecode"].Value.ToString();
                    if (lblStartTime.Text.Length > 0)
                    {
                        lblSubProcessId.Text = ezCmd.Parameters["@_sub_process_id"].Value.ToString();
                        lblPositionId.Text = ezCmd.Parameters["@_position_id"].Value.ToString();
                        lblSubPositionId.Text = ezCmd.Parameters["@_sub_position_id"].Value.ToString();
                        lblStepId.Text = ezCmd.Parameters["@_step_id"].Value.ToString();
                    }
                    if (Request.QueryString["step_type"].Equals("condition"))
                    {
                        if (rbResult.SelectedValue.Equals("True"))
                            lblMessage.Text = "The test has passed. Please click a button to go back to Move Product form or go to next step.";
                        else
                            lblMessage.Text = "The test has failed. Please click a button to go back to Move Product form or go to next step for failed test.";
                    }
                    MessagePopupExtender.Show();
                }
                ezCmd.Dispose();
                ezConn.Dispose();
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;

                if (ezCmd != null)
                    ezCmd.Dispose();
                ezConn.Dispose();
            }


        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string response;
            ezMES.ITemplate.FormattedTemplate fTemp;

            if (FormView1.CurrentMode == FormViewMode.Edit)
            {
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "consume_inventory";
                    ezCmd.CommandType = CommandType.StoredProcedure;
                    ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(Request.QueryString["lot_id"]/*Session["lot_id"]*/));
                    ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]/*Session["lot_alias"].ToString()*/);
                    ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
                    if (Request.QueryString["equipment"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_equipment_id", Request.QueryString["equipment"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_equipment_id", DBNull.Value);
                    ezCmd.Parameters.AddWithValue("@_device_id", DBNull.Value);
                    ezCmd.Parameters.AddWithValue("@_process_id", Request.QueryString["process_id"]/*Session["process_id"].ToString()*/);
                    if (Request.QueryString["sub_process"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_sub_process_id", Request.QueryString["sub_process"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_sub_process_id", DBNull.Value);
                    if (Request.QueryString["position"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_position_id", Request.QueryString["position"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_position_id", DBNull.Value);

                    if (Request.QueryString["sub_position"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_sub_position_id", Request.QueryString["sub_position"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_sub_position_id", DBNull.Value);

                    if (Request.QueryString["step"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_step_id", Request.QueryString["step"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value);

                    if (Request.QueryString["start_time"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_step_start_timecode", Request.QueryString["start_time"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_step_start_timecode", DBNull.Value);

                    fTemp =
                      (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;

                    LoadSqlParasFromTemplate(ezCmd, fTemp);

                    ezCmd.Parameters.AddWithValue("@_recipe_uomid", gvTable.SelectedDataKey.Values["uom_id"].ToString());
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                    ezCmd.ExecuteNonQuery();

                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    ezCmd.Dispose();
                    ezConn.Dispose();
                    if (response.Length > 0)
                    {
                        lblError2.Text = response;
                        this.ModalPopupExtender.Show();
                    }
                    else
                    {
                        lblError2.Text = "";
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
                catch (Exception ex)
                {
                    lblError2.Text = ex.Message;
                    this.ModalPopupExtender.Show();
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
            }
            else
            {
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "return_inventory";
                    ezCmd.CommandType = CommandType.StoredProcedure;
                    ezCmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(/*Session["lot_id"]*/Request.QueryString["lot_id"]));
                    ezCmd.Parameters.AddWithValue("@_lot_alias", Request.QueryString["lot_alias"]/*Session["lot_alias"].ToString()*/);
                    ezCmd.Parameters.AddWithValue("@_operator_id", Convert.ToInt32(Session["UserID"]));
                    ezCmd.Parameters.AddWithValue("@_process_id", /*Session["process_id"].ToString()*/Request.QueryString["process_id"]);
                    if (Request.QueryString["step"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_step_id", Request.QueryString["step"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value);

                    if (Request.QueryString["start_time"].Length > 0)
                        ezCmd.Parameters.AddWithValue("@_step_start_timecode", Request.QueryString["start_time"]);
                    else
                        ezCmd.Parameters.AddWithValue("@_step_start_timecode", DBNull.Value);

                    DropDownList ddInventory = (DropDownList)FormView1.FindControl("drpingredient_id");
                    string[] valueArray = ddInventory.SelectedValue.Split(',');
                    ezCmd.Parameters.AddWithValue("@_consumption_start_timecode", valueArray[0]);

                    ezCmd.Parameters.AddWithValue("@_inventory_id", valueArray[3]);

                    fTemp =
                      (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

                    LoadSqlParasFromTemplate(ezCmd, fTemp);

                    ezCmd.Parameters.AddWithValue("@_recipe_uomid", valueArray[2]);
                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);

                    ezCmd.ExecuteNonQuery();

                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    ezCmd.Dispose();
                    ezConn.Close();
                    ezConn.Dispose();
                    if (response.Length > 0)
                    {
                        lblError2.Text = response;
                        this.ModalPopupExtender.Show();
                    }
                    else
                    {
                        lblError2.Text = "";
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
                catch (Exception ex)
                {
                    lblError2.Text = ex.Message;
                    this.ModalPopupExtender.Show();
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
            }
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //load user control lot
            var lotControl = Page.LoadControl("lot.ascx") as lot;
            lblProcess.Text = lotControl.process;
            po_barcode.ImageUrl = lotControl.po_barcode;
            name_barcode.ImageUrl = lotControl.name_barcode;
            product_barcode.ImageUrl = lotControl.product_barcode;
        }

        protected void verifyPrint(string strStepID)
        {
            //ConnectToDb();
            string strSQL = string.Format("SELECT COUNT(*) FROM step WHERE ID={0} AND para1=\"{1}\"",
                strStepID,
                "print packing docs");

            EzSqlCommand cmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            cmd.Parameters.Clear();
            cmd.Connection = ezConn;
            cmd.CommandText = strSQL;
            cmd.CommandType = CommandType.Text;

            int nCount = 0;
            DbDataReader reader = cmd.ExecuteReader();
            bool bOK = reader.Read();
            if (bOK) nCount = reader.GetInt32(0);
            reader.Close();
            cmd.Dispose();
            //ezConn.Dispose();

            btnPrintLabel.Visible = (nCount > 0);
            btnPrintList.Visible = (nCount > 0);
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

            reader.Close();
            cmd.Dispose();

            string[] strResult = new string[] { strPONumber, strPOLine, strItemNumber, strFinish };
            return strResult;
        }

        /*
        protected string getComponent(string strLotID, string strLotAlias, string strProcessID, string strStepID)
        {
            EzSqlCommand cmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
            cmd.Parameters.Clear();

            cmd.Connection = ezConn;
            cmd.CommandText = "report_consumption_for_step_ex";
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@_lot_id", Convert.ToInt32(strLotID));
            cmd.Parameters.AddWithValue("@_lot_alias", strLotAlias);
            cmd.Parameters.AddWithValue("@_process_id", Convert.ToInt32(strProcessID));
            cmd.Parameters.AddWithValue("@_step_id", Convert.ToInt32(strStepID));
            cmd.Parameters.AddWithValue("@_start_timecode", "201201010000000");

            string strComponent = "";
            DbDataReader reader = cmd.ExecuteReader();
            bool bOK = reader.Read();
            if (bOK)
                strComponent = reader.GetString(2);

            reader.Close();
            cmd.Dispose();

            return strComponent;
        }
        */

        protected void btnPrintLabel_Click(object sender, EventArgs e)
        {
            string strLotID = Request.QueryString["lot_id"];
            string strPosition = Request.QueryString["position"];
            string strStep = Request.QueryString["step"];
            string strQuantity = Request.QueryString["quantity"];
            string strProcessID = Request.QueryString["process_id"];
            string strLotAlias = Request.QueryString["lot_alias"];

            //aggregate quantity
            int nQuantity = 0;
            for (int i = 0; i < gvTable.Rows.Count; i++)
            {
                gvTable.SelectedIndex = i;

                string strText = gvTable.SelectedDataKey.Values["required_quantity"].ToString();
                nQuantity += Convert.ToInt32(Convert.ToDecimal(strText));
            }
            strQuantity = string.Format("{0}", nQuantity);

            //retrieve info from database
            ConnectToDb();
            string[] strPOInfo = this.getPOInfo(strLotID);
            ezConn.Dispose();

            //get compoments
            string strComponent = this.gvTable.Rows[0].Cells[4].Text;


      string strUrl = string.Format("/LabelPrint.aspx?PO={0}&POLine={1}&piececnt={2}&itemnum={3}&finish={4}&batch={5}",
          strPOInfo[0],
          strPOInfo[1],
          strQuantity,
          strPOInfo[2],
          strPOInfo[3],
          strLotAlias);

            Server.Transfer(strUrl);

        }

        protected void verifyMoveConsumeButton(string stepType)
        {
            bool bVisible = false;
   
            bVisible = !(stepType.Equals ("condition"));
            btnMove.Visible = bVisible;
            lblPartName.Visible = bVisible;
            txtPartName.Visible = bVisible;
        }
        protected void btnMove_Click(object sender, EventArgs e)
        {
            int nIndex = gvTable.SelectedIndex;

            string strPartName = txtPartName.Text.Trim();
            if (strPartName.Length == 0)
            {
                lblError.Text = "No part number";
                lblError.Visible = true;
                return;
            }

            for (int i = 0; i < gvTable.Rows.Count; i++)
            {
                gvTable.SelectedIndex = i;

                string strText = gvTable.SelectedDataKey.Values["name"].ToString();
                if (strText == strPartName)
                {
                    this.fromInventory(strPartName);
                    return;
                }
            }

            //not found in the list
            lblError.Text = string.Format("{0} is not in the list", strPartName);
            lblError.Visible = true;

        }
    }

}
