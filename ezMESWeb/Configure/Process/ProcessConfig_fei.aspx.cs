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
//using System.Data.Odbc;

namespace ezMESWeb
{

   public partial class ProcessConfig : ConfigTabTemplate
    {
       String strMName = "Workflow";
        protected DropDownList ddProcess_group, 
            ddOwner, 
            ddStep, 
            ddSubProcess, 
            ddApproval;
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

        public DataColumnCollection colc;

        protected override void OnInit(EventArgs e)
        {
           base.OnInit(e);

           {
              DataView dv = (DataView)sdsMain.Select(DataSourceSelectArguments.Empty);
              colc = dv.Table.Columns;

              //Initial insert template  
              fvMain.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Process_insert.xml"), "TabPage");

              //Initial Edit template           
              fvMain.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Process_insert.xml"), "TabPage");

              //Display only template
              fvMain.ItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.Item, colc, false, Server.MapPath(@"Process_display.xml"), "TabPage");

              //Event happens before the select index changed clicked.
              gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
           }
        }

        protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
        {
           //modify the mode of form view
           fvMain.ChangeMode(FormViewMode.Edit);

        }

        protected override void Page_Load(object sender, EventArgs e)
        {
           String sqlText = "SELECT id, name FROM process";
           base.LoadMainTabPanel(sqlText, strMName);
        }

        protected override void show_Exist(short tabIndex, string name)
        {
           base.show_Exist(tabIndex, strMName);
           HyperLink bomLink = (HyperLink)fvMain.FindControl("urlhpBOM");
           bomLink.NavigateUrl += txtID.Text;
           HyperLink travLink = (HyperLink)fvMain.FindControl("urlhpTraveler");
           travLink.NavigateUrl += txtID.Text;
        }
  
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            string stepId, stepChoice;
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

   //         toggle_dropdowns(stepChoice, approveChoice, false);
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

                    theText = reworklimitTextBox.Text.Trim();
                    
                  if (theText.Length>0)
                    ezCmd.Parameters.AddWithValue("@_rework_limit", theText );
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
                    gvTable.DataBind();
                    this.gvTablePanel.Update();
                    fvMain.DataBind();
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
        //            toggle_dropdowns(((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue,
                //        ((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked, false);
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
            else
            {
           //     toggle_dropdowns(((RadioButtonList)fvUpdate.FindControl("rblStepOrProcess2")).SelectedValue,
           //         ((CheckBox)fvUpdate.FindControl("chkApproval2")).Checked, false);
                btnUpdate_ModalPopupExtender.Show();
            }
        }

        protected void btnDo_Click(object sender, EventArgs e)
        {
           string newId;
         
           if (Page.IsValid)
           {
              string response;

              try
              {
                 ConnectToDb();
                 ezCmd = new EzSqlCommand();
                 ezCmd.Connection = ezConn;
                
                 ezCmd.CommandType = CommandType.StoredProcedure;
                 ezMES.ITemplate.FormattedTemplate fTemp;
                 if (fvMain.CurrentMode == FormViewMode.Insert)
                 {
                    ezCmd.CommandText = "insert_process";
                    fTemp = (ezMES.ITemplate.FormattedTemplate)fvMain.InsertItemTemplate;
                 }
                 else if (fvMain.CurrentMode == FormViewMode.Edit)
                 {
                    ezCmd.CommandText = "modify_process";
                    fTemp = (ezMES.ITemplate.FormattedTemplate)fvMain.EditItemTemplate;
                 }
                 else
                 {
                    base.Show_Update();
                    return;
                 }

                 LoadSqlParasFromTemplate(ezCmd, fTemp);

                 if (fvMain.CurrentMode == FormViewMode.Edit)
                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);

                 //Save values into parameters
                 for (int i = 0; i < paras.Count; i++)
                 {
                    sqlParameter sPara = (sqlParameter)paras[i];
                    ezCmd.Parameters.AddWithValue(sPara.Key, sPara.Value);

                    //In this special case,we need insert some default values. So 
                    //specially handle them.
                    if (i == 1)//after "name" field
                    {
                       ezCmd.Parameters.AddWithValue("@_version", 1);
                       ezCmd.Parameters.AddWithValue("@_state", "production");
                    }

                    if (i == 2) //after "owner_id" field
                    {
                       ezCmd.Parameters.AddWithValue("@_if_default_version", 1);
                       ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
                    }
                 }

                 ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                 ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                 if (fvMain.CurrentMode == FormViewMode.Insert)
                 {
                    ezCmd.Parameters.AddWithValue("@_process_id", DBNull.Value);
                    ezCmd.Parameters["@_process_id"].Direction = ParameterDirection.Output;

                 }
                 ezCmd.ExecuteNonQuery();
                 response = ezCmd.Parameters["@_response"].Value.ToString();

                 if (response.Length > 0)
                 {
                    lblMainError.Text = response;
                 }
                 else
                 {
                    if (fvMain.CurrentMode == FormViewMode.Insert)
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

                       Response.Redirect("ProcessConfig.aspx?Id=" + newId);
                    }
                    if (fvMain.CurrentMode == FormViewMode.Edit)
                       Response.Redirect("ProcessConfig.aspx?Id=" + txtID.Text);

                 }
                 ezCmd.Dispose();
                 ezConn.Dispose();

                
                 /*     else
                      {
                         lblMainError.Text = "";
                         this.fvMain.Visible = false;
                         this.ModalPopupExtender.Hide();

                         if (Session["Role"] != null && !Session["Role"].ToString().Equals("Admin"))
                         {
                            ScriptManager.GetCurrent(this).RegisterDataItem(
                               // The control I want to send data to
                                this.gvTable1,
                               //  The data I want to send it (the row that was edited)
                                this.gvTable1.SelectedIndex.ToString()
                            );

                            gvTable1.DataBind();
                            this.gvTablePanel.Update();
                         }
                         else
                         {
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
                   */
              }
              catch (Exception ex)
              {
                 lblMainError.Text = ex.Message;
              }
           }


        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
           if (fvMain.CurrentMode != FormViewMode.ReadOnly)
               base.btnCancel_Click(sender, e);
           else
           {
               //need delete the item
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "delete_process";
                    ezCmd.CommandType = CommandType.StoredProcedure;


                    ezCmd.Parameters.AddWithValue("@_process_id", txtID.Text);
                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));


                    ezCmd.ExecuteNonQuery();
                    Response.Redirect("ProcessConfig.aspx?Tab=" + tcMain.ActiveTabIndex);
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
                catch (Exception ex)
                {
                    lblMainError.Text = ex.Message;
                }
            }
            
        }

        protected void tcMain_ActiveTabChanged(object sender, EventArgs e)
        {
            if (tcMain.ActiveTabIndex+1 == tcMain.Controls.Count)
               show_New((short)tcMain.ActiveTabIndex, strMName);
            else
               show_Exist((short)tcMain.ActiveTabIndex, strMName);
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
     //       toggle_dropdowns(rblStepOrProcess.SelectedValue, chkApproval.Checked, true);
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
