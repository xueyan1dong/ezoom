﻿using System;
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
//using System.Data.Odbc;

namespace ezMESWeb
{

    public partial class ProcessConfig : TabConfigTemplate
    {
        protected DropDownList ddProcess_group, 
            ddOwner, 
            ddStep, 
            ddSubProcess, 
            ddApproval,
            drpSegment2;
        protected RadioButtonList rblUsage, rblStepOrProcess;
        protected TextBox nameTextBox, 
            descriptionTextBox, 
            commentTextBox,
            positionTextBox,
            prevpositionTextBox,
            nextpositionTextBox,
            falsepositionTextBox,
            reworklimitTextBox,
            promptTextBox;
        protected CheckBox chkApproval, chkIfAutoStart;

        protected LinkButton LinkButton1;
        protected TableRow tbrApprove;

        protected override void Page_Load(object sender, EventArgs e)
        {


                string id=Request.QueryString["Id"];
                short actTab;
                
                //MySqlDataReader sqlReader;
                TabPanel temp;
                short count = 0;


                if (!IsPostBack)
                {
                    try
                    {
                        ConnectToDb();
                        ezCmd = new EzSqlCommand();
                        ezCmd.Connection = ezConn;

                        //using (sqlConn =
                        //    new MySqlConnection(ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString)) ;
                        //sqlConn.Open();
                        //sqlCmd = new MySqlCommand();
                        //sqlCmd.Connection = sqlConn;
                        ezCmd.CommandText = "SELECT id, name FROM process";
                        ezCmd.CommandType = CommandType.Text;
                        ezReader = ezCmd.ExecuteReader();
                    }
                    catch (Exception ex)
                    {
                    }
                    //while (sqlReader.Read())
                    while (ezReader.Read())
                    {
                        temp = new TabPanel();
                        temp.ID = String.Format("{0}", ezReader[0]);
                        temp.HeaderText = String.Format("{0}", ezReader[1]);
                        temp.BackColor = System.Drawing.Color.Silver;
                        tcMain.Controls.Add(temp);
                        if ((id != null) && (temp.ID.Equals(id)))
                        {
                            show_ExistProcess(count);

                        }
                        count++;
                    }

                    temp = new TabPanel();
                    temp.ID = "newTab";
                    temp.HeaderText = "+";
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
                                show_ExistProcess(actTab);
                            else
                                show_NewProcess(count);
                        }
                        else
                            show_NewProcess(count);
                    }
                    //toggle the step or sub process dropdownlist on Step Insertion popup form
                    rblStepOrProcess.Attributes.Add("OnClick", "showDropDown('" +
                        rblStepOrProcess.ClientID + "','"
                        + ddStep.ClientID + "','" + ddSubProcess.ClientID + "','" + 
                        chkIfAutoStart.ClientID+"')");
                    //toggle "approved by" on Step Insertion popup form
                    chkApproval.Attributes.Add("OnClick", "showApprovedBy('" + chkApproval.ClientID
                        + "','" + tbrApprove.ClientID + "')");

                    ezReader.Dispose();
                    ezCmd.Dispose();
                    //ezConn.Dispose();
                }
                else
                {
                    toggle_dropdowns(rblStepOrProcess.SelectedValue, chkApproval.Checked, true);


                }
              
        }
        private void updateUrl()
        {
          HyperLink bomLink = (HyperLink)fvMain.FindControl("hpBom");
          bomLink.NavigateUrl = "/Reports/BoMReport.aspx?processid=" + txtID.Text;
          HyperLink travelerLink = (HyperLink)fvMain.FindControl("hpTraveler");
          travelerLink.NavigateUrl = "/Reports/WorkflowReport.aspx?processid=" + txtID.Text;
        }
        protected void show_ExistProcess(short tabIndex)
        {
            
            tcMain.ActiveTabIndex = tabIndex;
            txtID.Text = tcMain.ActiveTab.ID;
            fvMain.Caption = "General Workflow Information";
            fvMain.ChangeMode(FormViewMode.ReadOnly);
            //fvMain.DataBind();
            //upMain.Update();
            HyperLink segmentLink = (HyperLink)fvMain.FindControl("hpSegments");
            segmentLink.NavigateUrl = "ProcessSegmentConfig.aspx?processid=" + txtID.Text;
            HyperLink bomLink = (HyperLink)fvMain.FindControl("hpBom");
            bomLink.NavigateUrl = "/Reports/BoMReport.aspx?processid=" + txtID.Text;
            HyperLink travelerLink = (HyperLink)fvMain.FindControl("hpTraveler");
            travelerLink.NavigateUrl = "/Reports/WorkflowReport.aspx?processid=" + txtID.Text;
            btnDo.Text = "Update Workflow Info";
            btnCancel.Text = "Delete Workflow";
            btnInsert.Visible = true;
            gvTable.Visible = true;
        }
        protected void show_NewProcess(short tabIndex)
        {
            tcMain.ActiveTabIndex = tabIndex;
            fvMain.ChangeMode(FormViewMode.Insert);
            fvMain.Caption  = "Define New Workflow:";
            btnInsert.Visible =false;
            gvTable.Visible = false;
            btnDo.Text = "Submit";
            btnCancel.Text = "Clear";
        }
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            string stepId, stepChoice, segmentId;
            bool approveChoice, autostartChoice;


            //toggle_dropdowns(rblStepOrProcess2.SelectedValue, chkApproval2.Checked, false);

            this.fvUpdate.Visible = true;
            //  force databinding
            this.fvUpdate.DataBind();
            //  update the contents in the detail panel
            this.updateBufferPanel.Update();

            stepId = ((TextBox)fvUpdate.FindControl("step_idTextBox")).Text;

            if (((TextBox)fvUpdate.FindControl("if_sub_processTextBox")).Text.Equals("1"))
            {
                stepChoice="sub process";
                ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).SelectedValue = stepId;
            }
            else
            {
                stepChoice = "step";
                ((DropDownList)fvUpdate.FindControl("ddStep2")).SelectedValue = stepId;
            }

            

            ((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue = stepChoice;

            segmentId = ((TextBox)fvUpdate.FindControl("txtSegment")).Text;
            ((DropDownList)fvUpdate.FindControl("drpSegment")).SelectedValue = segmentId;

            if (((TextBox)fvUpdate.FindControl("if_autostartTextBox")).Text.Equals("1"))
            {
                autostartChoice = true;
            }
            else
                autostartChoice = false;
            ((CheckBox)fvUpdate.FindControl("chkIfAutoStart2")).Checked = autostartChoice;

            if (((TextBox)fvUpdate.FindControl("need_approvalTextBox")).Text.Equals("1"))
            {
                approveChoice = true;
                ((DropDownList)fvUpdate.FindControl("ddApproval2")).SelectedValue = ((TextBox)fvUpdate.FindControl("approve_emp_idTextBox")).Text;
            }
            else
                approveChoice = false;
            ((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked = approveChoice;
            //  show the modal popup
            ((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).Attributes.Add(
                "OnClick", 
                "showDropDown('" +
                    ((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).ClientID + "','"
                    + ((DropDownList)fvUpdate.FindControl("ddStep2")).ClientID + "','"
                    + ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).ClientID + "','"
                    + ((CheckBox)fvUpdate.FindControl("chkIfAutoStart2")).ClientID + "')");
        
            ((CheckBox)fvUpdate.FindControl("chkApproval2")).Attributes.Add(
                "OnClick",
                "showApprovedBy('" + ((CheckBox)fvUpdate.FindControl("chkApproval2")).ClientID
                + "','" + ((TableRow)fvUpdate.FindControl("tbrApprove2")).ClientID + "')");

            toggle_dropdowns(stepChoice, approveChoice, false);
            this.btnUpdate_ModalPopupExtender.Show();
        }


 

        protected override void btnSubmitInsert_Click(object sender, EventArgs e)
        {
            int if_sub_process = 0;
          string theText;
            positionTextBox.Text = positionTextBox.Text.Trim();
            nextpositionTextBox.Text = nextpositionTextBox.Text.Trim();
            prevpositionTextBox.Text = prevpositionTextBox.Text.Trim();
            falsepositionTextBox.Text = falsepositionTextBox.Text.Trim();
            if (validate_position(positionTextBox.Text, "Position", true, lblErrorInsert) &&
                validate_position(prevpositionTextBox.Text, "Previous Step Position", false, lblErrorInsert) &&
                validate_position(nextpositionTextBox.Text, "Next Step Position", false, lblErrorInsert)&&
                validate_position(falsepositionTextBox.Text, "Step Position for False Result", false, lblErrorInsert))
            {
                string response;

                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    //sqlCmd =
                    //    new MySql.Data.MySqlClient.MySqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "add_step_to_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;

                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);
                    ezCmd.Parameters.AddWithValue("@_position_id", positionTextBox.Text);
                    if(rblStepOrProcess.SelectedValue.Equals("step"))
                    {
                        ezCmd.Parameters.AddWithValue("@_step_id", ddStep.SelectedValue);
                        if_sub_process = 0;
                        
                    }
                    else{
                        ezCmd.Parameters.AddWithValue("@_step_id", ddSubProcess.SelectedValue);
                        if_sub_process = 1;
                        
                    }

                    if (prevpositionTextBox.Text.Length > 0)
                        ezCmd.Parameters.AddWithValue("@_prev_step_pos", prevpositionTextBox.Text);
                    else
                        ezCmd.Parameters.AddWithValue("@_prev_step_pos", DBNull.Value);

                    if (nextpositionTextBox.Text.Length>0)
                        ezCmd.Parameters.AddWithValue("@_next_step_pos", nextpositionTextBox.Text);
                    else
                        ezCmd.Parameters.AddWithValue("@_next_step_pos", DBNull.Value);

                    if (falsepositionTextBox.Text.Length>0)
                        ezCmd.Parameters.AddWithValue("@_false_step_pos", falsepositionTextBox.Text);
                    else
                        ezCmd.Parameters.AddWithValue("@_false_step_pos", DBNull.Value);

                    theText = drpSegment2.SelectedValue;
                    if (theText.Length > 0)
                      ezCmd.Parameters.AddWithValue("@_segment_id", theText);
                    else
                      ezCmd.Parameters.AddWithValue("@_segment_id", DBNull.Value);
                   
                    theText = reworklimitTextBox.Text.Trim();

                    if (theText.Length > 0)
                      ezCmd.Parameters.AddWithValue("@_rework_limit", theText);
                    else
                      ezCmd.Parameters.AddWithValue("@_rework_limit", 0);

                    ezCmd.Parameters.AddWithValue("@_if_sub_process", if_sub_process);

                    ezCmd.Parameters.AddWithValue("@_prompt", promptTextBox.Text);

                    if (chkIfAutoStart.Checked)
                    {
                        ezCmd.Parameters.AddWithValue("@_if_autostart", 1);
                    }
                    else
                        ezCmd.Parameters.AddWithValue("@_if_autostart", 0);

                    if (chkApproval.Checked)
                    {
                        ezCmd.Parameters.AddWithValue("@_need_approval", 1);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_usage", "employee");
                        ezCmd.Parameters.AddWithValue("@_approve_emp_id", ddApproval.SelectedValue);
                    }
                    else
                    {
                        ezCmd.Parameters.AddWithValue("@_need_approval", 0);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_usage", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_id", DBNull.Value);
                    }
                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

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
                  lblErrorInsert.Text = "";
                    gvTable.DataBind();
                    this.gvTablePanel.Update();
                    fvMain.DataBind();
                    updateUrl();
                    upMain.Update();
                    hide_insertPopup();

                }
                
            }

        }
        protected override void btnCancelInsert_Click(object sender, EventArgs e)
        {
            hide_insertPopup();

        }

        protected override void btnSubmitUpdate_Click(object sender, EventArgs args)
        {
            int if_sub_process = 0;
            string theText;
            String position = ((Label)fvUpdate.FindControl("position_idLabel1")).Text.Trim();
            String prevPosition = ((TextBox)fvUpdate.FindControl("prev_step_posTextBox")).Text.Trim();
            String nextPosition = ((TextBox)fvUpdate.FindControl("next_step_posTextBox")).Text.Trim();
            String falsePosition = ((TextBox)fvUpdate.FindControl("false_step_posTextBox")).Text.Trim();

            if (validate_position(prevPosition, "Previous Step Position", false, lblErrorUpdate) &&
                validate_position(nextPosition, "Next Step Position", false, lblErrorUpdate) &&
                validate_position(falsePosition, "Step Position for False Result", false, lblErrorUpdate))
            {
                string response;

                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    //sqlCmd =
                    //    new MySql.Data.MySqlClient.MySqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "modify_step_in_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;

                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);
                    ezCmd.Parameters.AddWithValue("@_position_id", position);
                    if (((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue.Equals("step"))
                    {
                        ezCmd.Parameters.AddWithValue("@_step_id", ((DropDownList)fvUpdate.FindControl("ddStep2")).SelectedValue);
                        if_sub_process = 0;
                    }
                    else
                    {
                        ezCmd.Parameters.AddWithValue("@_step_id", ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).SelectedValue);
                        if_sub_process = 1;
                        
                    }

                    if (prevPosition.Length > 0)
                        ezCmd.Parameters.AddWithValue("@_prev_step_pos", prevPosition);
                    else
                        ezCmd.Parameters.AddWithValue("@_prev_step_pos", DBNull.Value);

                    if (nextPosition.Length > 0)
                        ezCmd.Parameters.AddWithValue("@_next_step_pos", nextPosition);
                    else
                        ezCmd.Parameters.AddWithValue("@_next_step_pos", DBNull.Value);

                    if (falsePosition.Length > 0)
                        ezCmd.Parameters.AddWithValue("@_false_step_pos", falsePosition);
                    else
                        ezCmd.Parameters.AddWithValue("@_false_step_pos", DBNull.Value);

                    theText = ((DropDownList)fvUpdate.FindControl("drpSegment")).SelectedValue;
                    if (theText.Length > 0)
                      ezCmd.Parameters.AddWithValue("@_segment_id", theText);
                    else
                      ezCmd.Parameters.AddWithValue("@_segment_id", DBNull.Value);

                  theText = ((TextBox)fvUpdate.FindControl("rework_limitTextBox")).Text.Trim();
                  if (theText.Length>0)
                    ezCmd.Parameters.AddWithValue("@_rework_limit", theText);
                  else
                    ezCmd.Parameters.AddWithValue("@_rework_limit", 0);

                    ezCmd.Parameters.AddWithValue("@_if_sub_process", if_sub_process);
                    ezCmd.Parameters.AddWithValue("@_prompt", ((TextBox)fvUpdate.FindControl("promptTextBox")).Text.Trim());

                    if (((CheckBox)fvUpdate.FindControl("chkIfAutoStart2")).Checked)
                    {
                        ezCmd.Parameters.AddWithValue("@_if_autostart", 1);
                    }
                    else
                        ezCmd.Parameters.AddWithValue("@_if_autostart", 0);

                    if (((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked)
                    {
                        ezCmd.Parameters.AddWithValue("@_need_approval", 1);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_usage", "employee");
                        ezCmd.Parameters.AddWithValue("@_approve_emp_id",
                            ((DropDownList)fvUpdate.FindControl("ddApproval2")).SelectedValue);
                    }
                    else
                    {
                        ezCmd.Parameters.AddWithValue("@_need_approval", 0);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_usage", DBNull.Value);
                        ezCmd.Parameters.AddWithValue("@_approve_emp_id", DBNull.Value);
                    }
                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

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
                    toggle_dropdowns(((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue,
                        ((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked, false);
                    btnUpdate_ModalPopupExtender.Show();
                }
                else
                {
                  lblErrorUpdate.Text = "";
                    gvTable.DataBind();
                    this.gvTablePanel.Update();
                    fvMain.DataBind();
                    updateUrl();
                    upMain.Update();

                }
            }
            else
            {
                toggle_dropdowns(((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue,
                    ((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked, false);
                btnUpdate_ModalPopupExtender.Show();
            }
        }

        protected void btnDo_Click(object sender, EventArgs e)
        {
            string response, process_name, newId;
            if (fvMain.CurrentMode==FormViewMode.Insert)
            {
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "insert_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;



                    ezCmd.Parameters.AddWithValue("@_prg_id", ((DropDownList)fvMain.FindControl("ddProccess_group")).SelectedValue);

                    process_name = ((TextBox)fvMain.FindControl("nameTextBox")).Text;
                    ezCmd.Parameters.AddWithValue("@_name", process_name);

                    ezCmd.Parameters.AddWithValue("@_version", 1);

                    ezCmd.Parameters.AddWithValue("@_state", "production");

                    ezCmd.Parameters.AddWithValue("@_owner_id", ((DropDownList)fvMain.FindControl("ddOwner")).SelectedValue);

                    ezCmd.Parameters.AddWithValue("@_if_default_version", 1);

                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

                    ezCmd.Parameters.AddWithValue("@_usage", ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedValue);

                    ezCmd.Parameters.AddWithValue("@_description", ((TextBox)fvMain.FindControl("descriptionTextBox")).Text);

                    ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvMain.FindControl("commentTextBox")).Text);

                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                    ezCmd.Parameters.AddWithValue("@_process_id", DBNull.Value);
                    ezCmd.Parameters["@_process_id"].Direction = ParameterDirection.Output;

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();

                    if (response.Length > 0)
                    {
                        lblMainError.Text = response;


                    }
                    else
                    {
                      //this code is because on server the result is System.byte[] type
                      //but on my computer it is System.Decimal type. Can't find root cause. XD 9/3/10
                      object result = ezCmd.Parameters["@_process_id"].Value;
                      if (result.GetType().ToString().Contains("System.Byte"))
                      {
                        System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                        newId = asi.GetString((byte[])result);
                      }
                      else
                      {
                        newId = result.ToString();
                      }
                        Response.Redirect(Request.CurrentExecutionFilePath+"?Id=" + newId);

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
                    ezCmd.CommandText = "modify_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);

                    ezCmd.Parameters.AddWithValue("@_prg_id", ((DropDownList)fvMain.FindControl("ddProccess_group")).SelectedValue);

                    process_name = ((TextBox)fvMain.FindControl("nameTextBox")).Text;
                    ezCmd.Parameters.AddWithValue("@_name", process_name);

                    ezCmd.Parameters.AddWithValue("@_version", 1);

                    ezCmd.Parameters.AddWithValue("@_state", "production");

                    ezCmd.Parameters.AddWithValue("@_owner_id", ((DropDownList)fvMain.FindControl("ddOwner")).SelectedValue);

                    ezCmd.Parameters.AddWithValue("@_if_default_version", 1);

                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

                    ezCmd.Parameters.AddWithValue("@_usage", ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedValue);

                    ezCmd.Parameters.AddWithValue("@_description", ((TextBox)fvMain.FindControl("descriptionTextBox")).Text);

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

                    Response.Redirect(Request.CurrentExecutionFilePath+"?Id=" + txtID.Text);
                }
            }
            else
            {
                fvMain.ChangeMode(FormViewMode.Edit);
                fvMain.DataBind();
                upMain.Update();
                ((DropDownList)fvMain.FindControl("ddProccess_group")).SelectedValue =
                 ((Label)fvMain.FindControl("lblPrg_id")).Text;
                ((DropDownList)fvMain.FindControl("ddOwner")).SelectedValue =
                    ((Label)fvMain.FindControl("lblOwner_id")).Text;
                switch (((Label)fvMain.FindControl("lblUsage")).Text)
                {
                   case "sub process only":
                        ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedIndex = 0;
                        break;
                    case "main process only":
                        ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedIndex = 1;
                        break;
                    default:
                        ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedIndex = 2;
                        break;
                }
                
                btnDo.Text = "Submit";
                btnCancel.Text = "Cancel";
            }

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            if (fvMain.CurrentMode == FormViewMode.Insert)
            {
                ((DropDownList)fvMain.FindControl("ddProccess_group")).SelectedIndex = -1;

                ((TextBox)fvMain.FindControl("nameTextBox")).Text = "";

                ((DropDownList)fvMain.FindControl("ddOwner")).SelectedIndex = -1;

                ((RadioButtonList)fvMain.FindControl("rblUsage")).SelectedIndex = -1;

                ((TextBox)fvMain.FindControl("descriptionTextBox")).Text="";

                ((TextBox)fvMain.FindControl("commentTextBox")).Text="";
                lblMainError.Text = "";
            }
            else if (btnCancel.Text.Equals("Delete Workflow"))
            {
                try
                {
                    //using (sqlConn =
                    //                    new MySql.Data.MySqlClient.MySqlConnection(ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString)) ;
                    //sqlConn.Open();

                    //sqlCmd =
                    //    new MySql.Data.MySqlClient.MySqlCommand();
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "delete_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);
                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));


                    ezCmd.ExecuteNonQuery();
                    Response.Redirect(Request.CurrentExecutionFilePath+"?Tab=" + tcMain.ActiveTabIndex);
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
                upMain.Update();
            }
        }

        protected void tcMain_ActiveTabChanged(object sender, EventArgs e)
        {
            if (tcMain.ActiveTabIndex+1 == tcMain.Controls.Count)
                show_NewProcess((short)tcMain.ActiveTabIndex);
            else
                show_ExistProcess((short)tcMain.ActiveTabIndex);
        }
        protected void hide_insertPopup()
        {
            lblErrorInsert.Text = "";
            mdlPopup.Hide();
            ddStep.SelectedIndex = -1;
            ddSubProcess.SelectedIndex = -1;
            ddApproval.SelectedIndex = -1;
            positionTextBox.Text = "";
            prevpositionTextBox.Text = "";
            nextpositionTextBox.Text = "";
            falsepositionTextBox.Text = "";
            reworklimitTextBox.Text = "";
            promptTextBox.Text = "";
            rblStepOrProcess.SelectedValue = "step";
            chkIfAutoStart.Checked = false;
            chkApproval.Checked = false;
            toggle_dropdowns(rblStepOrProcess.SelectedValue, chkApproval.Checked, true);
        }
        protected void toggle_dropdowns(string substep, bool approve, bool IfInsertForm)
        {
            if (IfInsertForm)
            {
                ddStep.Attributes.Remove("style");
                ddSubProcess.Attributes.Remove("style");
                tbrApprove.Attributes.Remove("style");

                if (substep.Equals("sub process"))
                {
                    ddStep.Attributes.Add("style", "display:none");
                    ddSubProcess.Attributes.Add("style", "display:block");
                }
                else
                {
                    ddStep.Attributes.Add("style", "display:block");
                    ddSubProcess.Attributes.Add("style", "display:none");
                }

                if (approve)
                {
                    tbrApprove.Attributes.Add("style", "display:block");
                }
                else
                    tbrApprove.Attributes.Add("style", "display:none");
            }
            else //Update Popup Form
            {
                ((DropDownList)fvUpdate.FindControl("ddStep2")).Attributes.Remove("style");
                ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).Attributes.Remove("style");
                ((TableRow)fvUpdate.FindControl("tbrApprove2")).Attributes.Remove("style");
                if (substep.Equals("sub process"))
                {
                    ((DropDownList)fvUpdate.FindControl("ddStep2")).Attributes.Add("style", "display:none");
                    ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).Attributes.Add("style", "display:block");
                }
                else
                {
                    ((DropDownList)fvUpdate.FindControl("ddStep2")).Attributes.Add("style", "display:block");
                    ((DropDownList)fvUpdate.FindControl("ddSubProcess2")).Attributes.Add("style", "display:none");
                }

                if (approve)
                {
                    ((TableRow)fvUpdate.FindControl("tbrApprove2")).Attributes.Add("style", "display:block");
                }
                else
                    ((TableRow)fvUpdate.FindControl("tbrApprove2")).Attributes.Add("style", "display:none");
            }


        }
        //validate the text in position boxes
        protected bool validate_position(string posText, string name, bool checkLength, Label errorLabel)
        {
            int positionNum;
            
            
            if (checkLength && (posText.Length < 1))
            {
                //lblErrorInsert.Text = name+" number is required, please fill and try again.";
                errorLabel.Text = name + " number is required, please fill and try again.";
                return false;
            }
            if ((posText.Length>0) && (!int.TryParse(posText, out positionNum)))
            {
                //lblErrorInsert.Text = name+" field requires an integer number. Please correct and try again.";
                errorLabel.Text = name + " field requires an integer number. Please correct and try again.";
                return false;
            }
            return true;
        }


    }
}
