/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : RecipeConfig.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for configuring recipes
*    Log                    :
*    2009: xdong: first created
  *  09/26/2018: xdong: attempt to solve problem related to server.transfer call in btnDo_Click, but no result
  *  02/10/2019: xdong: following the same fix that Junlu did in SalesOrderConfig.aspx.cs, change the call to Server.Transfer
  *                     and fixed UI issue when btnDo_Click is triggered.
	*  04/19/2019: xdong: modified RecipeConfig.aspx to display quantity in ingredients in decimal with 1 decimal for non-integer quantity                   
	*  6/6/2019: peiyu: added scrollbars to receipt tab containers; added search box that allows to search receipts with keywords             
----------------------------------------------------------------*/
using System;
using System.IO;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using AjaxControlToolkit;
using CommonLib.Data.EzSqlClient;


namespace ezMESWeb.Configure.Process
{

    public partial class RecipeConfig : TabConfigTemplate
    {
        protected DropDownList ddOwner,
            ddProduct,
            ddMaterial,
            ddPUom, ddMUom;
      
        protected RadioButtonList rblMorP, rbExec;
        protected TextBox qtyTextBox, 
            orderTextBox,
            mintimeTextBox,
            maxtimeTextBox,
            commentTextBox,
            qtyTextBoxu,
            orderTextBoxu,
            mintimeTextBoxu,
            maxtimeTextBoxu,
            commentTextBoxu,
            receipt;
        protected Label lblUom,
            sourceLabel,
            ingredientLabel,
            orderLabelu,
            uomLabelu,
            ifTcLoaded;
           
        protected Button btnDuplicate;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "SELECT m.id, m.name, u.name as uom_name  FROM material m, uom u WHERE m.uom_id = u.id";
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    ddMaterial.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    ddMUom.Items.Add(new ListItem(String.Format("{0}", ezReader[2]), String.Format("{0}", ezReader[2])));
                }
                ezReader.Close();


                ezCmd.CommandText = "SELECT p.id, p.name, u.name as uom_name  FROM product p, uom u WHERE p.uomid = u.id";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    ddProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    ddPUom.Items.Add(new ListItem(String.Format("{0}", ezReader[2]), String.Format("{0}", ezReader[2])));
                }
                if (ddMUom.Items.Count>0)
                  lblUom.Text = ddMUom.Items[0].Value;
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
                string error = Request.QueryString["Error"];
               
                short actTab;
                
                //MySqlDataReader sqlReader;
                
                DbDataReader ezReader;
                TabPanel temp;
                short count = 0;
                string recip = "";

            // The value of ifTclLoaded Label will be changed to loaded if initial page load is done. 
            // This prevents the following steps in page_load() when calling btnSearch_click()
            if ((!IsPostBack || fvMain.CurrentMode == FormViewMode.ReadOnly)&& ifTcLoaded.Text.Equals("notLoaded"))
            {
              
                try
                {
                    ConnectToDb();

                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    //when clicking on one of the receipt tabs in the search results to view details, the page will be reloaded, Request.QueryString["receipt"] recorded the searching keyword
                    if (Request.QueryString["receipt"] != null)
                    {
                        recip = Request.QueryString["receipt"];
                        //after clicking on one of the search result, the search box becomes blank, 
                        // need to reset the search textbox to the searching keyword, so we don't lose track of the keyword, 
                        // remembering the keyword will allow the user check every tabs in the list.
                        receipt.Text = recip; 
                    }
                    //when page loading, the tabcontainer will display tabs with name matching the value of recip
                    //scenario 1, normal page loading, then recip is "", all tabs will be displayed
                    //scenario 2, searching with keyword recip, then only names contain recip will be displayed
                    ezCmd.CommandText = "SELECT id, name FROM recipe where name like '%" + recip + "%'";
                    ezCmd.CommandType = CommandType.Text;
                    ezReader = ezCmd.ExecuteReader();

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
                    ezReader.Close();
                    ezReader.Dispose();
                    ezCmd.Dispose();
                    //ezConn.Dispose();
                    ifTcLoaded.Text = "Loaded";
                }
                catch (Exception ex)
                {
                    lblMainError.Text = ex.Message;
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
                if (error != null && error.Length > 0)
                {
                    lblMainError.Text = error;
                }
                //toggle the product or material dropdownlist on Ingredient insertion form
                rblMorP.Attributes.Add("OnClick", "showDropDown('" +
                    rblMorP.ClientID + "','"
                    + ddMaterial.ClientID + "','" + ddProduct.ClientID + "')");

            }
           
            else
            {
                toggle_dropdowns(rblMorP.SelectedValue, true);
            }
              
        }

        protected void show_ExistProcess(short tabIndex)
        {
            
            tcMain.ActiveTabIndex = tabIndex;
            txtID.Text = tcMain.ActiveTab.ID;
            fvMain.Caption = "General Recipe Information";
            fvMain.ChangeMode(FormViewMode.ReadOnly);
            HyperLink fileLink = (HyperLink)fvMain.FindControl("fileLink");
            string theFileDir = System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir");

            fileLink.NavigateUrl = theFileDir + txtID.Text + "_" + fileLink.Text;
            //fileLink.NavigateUrl = txtID.Text + "_" + fileLink.Text;
            btnDo.Text = "Update Recipe Info";

            
            btnCancel.Text = "Delete Recipe";
            btnInsert.Visible = true;
            gvTable.Visible = true;
        }
        protected void show_NewProcess(short tabIndex)
        {
            tcMain.ActiveTabIndex = tabIndex;
            fvMain.ChangeMode(FormViewMode.Insert);
            fvMain.Caption  = "Define New Recipe:";
            btnInsert.Visible =false;
            gvTable.Visible = false;
            btnDo.Text = "Submit";
            btnCancel.Text = "Clear";
        }
        protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            string response;
            string[] qtys;
           
            //bool approveChoice, autostartChoice;
            if (Request.Params["__EVENTTARGET"].Contains("btnDeleteRow"))
            {
                try
                {
                    ConnectToDb();
                    if (ezConn.State == ConnectionState.Open)
                    {
                        ezCmd = new EzSqlCommand();
                        ezCmd.Connection = ezConn;
                        ezCmd.CommandText = "remove_ingredient_from_recipe";
                        ezCmd.CommandType = CommandType.StoredProcedure;

                        
                        ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

                        ezCmd.Parameters.AddWithValue("@_recipe_id", txtID.Text);

                        ezCmd.Parameters.AddWithValue("@_ingredient_id", gvTable.SelectedDataKey[1].ToString());

                        ezCmd.Parameters.AddWithValue("@_source_type", gvTable.SelectedDataKey[0].ToString());
                        ezCmd.Parameters.AddWithValue("@_order", gvTable.SelectedDataKey[2].ToString());
                        ezCmd.Parameters.AddWithValue("@_comment", "");

                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                        ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


                        ezCmd.ExecuteNonQuery();
                        response = ezCmd.Parameters["@_response"].Value.ToString();
                        ezCmd.Dispose();
                        ezConn.Dispose();

                        if (response.Length > 0)
                            lblMainError.Text = response;
                        else
                        {
                            gvTable.DataBind();
                            gvTablePanel.Update();
                        }


                    }
                }
                catch (Exception ex)
                {
                    lblMainError.Text = ex.Message;
                }
            }
            else
            {
                sourceLabel.Text = gvTable.SelectedDataKey[0].ToString();
            
                ingredientLabel.Text = gvTable.SelectedRow.Cells[4].Text;

                qtys =  gvTable.SelectedRow.Cells[5].Text.Split(' ') ;

                qtyTextBoxu.Text = qtys[0];
                uomLabelu.Text = qtys[1];

                orderTextBoxu.Text = gvTable.SelectedDataKey[2].ToString();
                orderLabelu.Text = gvTable.SelectedDataKey[2].ToString();

                mintimeTextBoxu.Text = gvTable.SelectedRow.Cells[7].Text;
                maxtimeTextBoxu.Text = gvTable.SelectedRow.Cells[8].Text;
                commentTextBoxu.Text = gvTable.SelectedRow.Cells[9].Text.Replace("&nbsp;", "");
                

                this.updateBufferPanel.Update();


                this.btnUpdate_ModalPopupExtender.Show();
            }
        }

        //search receipts with names contain the keywords and display in the tabcontainer
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            

            DbDataReader ezReader;
            TabPanel temp;
            short count = 0;

            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "SELECT id, name FROM recipe where name like '%" + receipt.Text + "%'";
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    temp = new TabPanel();

                    temp.ID = String.Format("{0}", ezReader[0]);
                    temp.HeaderText = String.Format("{0}", ezReader[1]);

                    temp.BackColor = System.Drawing.Color.Silver;
                    tcMain.Controls.Add(temp);
                    count++;
                    
                }
                tcMain.ActiveTabIndex = count;
                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();

            }
            catch (Exception ex)
            {
                lblMainError.Text = ex.Message;
            }
        }




        protected override void btnSubmitInsert_Click(object sender, EventArgs e)
        {
            

            string response;
            string theValue;
            try
            {
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "add_ingredient_to_recipe";
                ezCmd.CommandType = CommandType.StoredProcedure;

                ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
                ezCmd.Parameters.AddWithValue("@_recipe_id", txtID.Text);
                if (rblMorP.SelectedValue.Equals("material"))
                {
                    ezCmd.Parameters.AddWithValue("@_ingredient_id", ddMaterial.SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_source_type", "material");
                }
                else
                {
                    ezCmd.Parameters.AddWithValue("@_ingredient_id", ddProduct.SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_source_type", "product");
                }
                ezCmd.Parameters.AddWithValue("@_quantity", qtyTextBox.Text.Trim());

                theValue = orderTextBox.Text.Trim();
                if (theValue.Length > 0)
                  ezCmd.Parameters.AddWithValue("@_order", theValue);
                else
                  ezCmd.Parameters.AddWithValue("@_order", 0);

                theValue = mintimeTextBox.Text.Trim();
                if(theValue.Length>0)
                  ezCmd.Parameters.AddWithValue("@_mintime", theValue);
                else
                  ezCmd.Parameters.AddWithValue("@_mintime", DBNull.Value);

                theValue = maxtimeTextBox.Text.Trim();
                if(theValue.Length>0)
                  ezCmd.Parameters.AddWithValue("@_maxtime", theValue);
                else
                  ezCmd.Parameters.AddWithValue("@_maxtime", DBNull.Value);

                theValue = commentTextBox.Text.Trim();
                if (theValue.Length > 0)
                  ezCmd.Parameters.AddWithValue("@_comment", theValue);
                else
                  ezCmd.Parameters.AddWithValue("@_comment", DBNull.Value);

                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                ezCmd.ExecuteNonQuery();
                response = ezCmd.Parameters["@_response"].Value.ToString();
                ezCmd.Dispose();
                ezConn.Dispose();

                if (response.Length > 0)
                {
                    lblErrorInsert.Text = response;
                    insertBufferPanel.Update();
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
            catch (Exception exc)
            {
                lblErrorInsert.Text = exc.Message;
                insertBufferPanel.Update();
            }            

        }
        protected override void btnCancelInsert_Click(object sender, EventArgs e)
        {
            hide_insertPopup();

        }

        protected override void btnSubmitUpdate_Click(object sender, EventArgs args)
        {
  
            string response;
            try
            {
                ConnectToDb();
                if (ezConn.State == ConnectionState.Open)
                {
                    ezCmd = new EzSqlCommand();
                    ezCmd.Connection = ezConn;
                    ezCmd.CommandText = "modify_ingredient_in_recipe";
                    ezCmd.CommandType = CommandType.StoredProcedure;

                    ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
                    ezCmd.Parameters.AddWithValue("@_recipe_id", txtID.Text);
                    
                    ezCmd.Parameters.AddWithValue("@_ingredient_id", gvTable.SelectedDataKey[1].ToString());
                    ezCmd.Parameters.AddWithValue("@_source_type", gvTable.SelectedDataKey[0].ToString());
                    ezCmd.Parameters.AddWithValue("@_quantity", qtyTextBoxu.Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_old_order", orderLabelu.Text);
                    ezCmd.Parameters.AddWithValue("@_new_order", orderTextBoxu.Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_mintime", mintimeTextBoxu.Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_maxtime", maxtimeTextBoxu.Text.Trim());
                    ezCmd.Parameters.AddWithValue("@_comment", commentTextBoxu.Text.Trim());




                    ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                    ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                    ezCmd.ExecuteNonQuery();
                    response = ezCmd.Parameters["@_response"].Value.ToString();
                    ezCmd.Dispose();
                    ezConn.Dispose();

                    if (response.Length > 0)
                    {
                        lblErrorUpdate.Text = response;
                        updateBufferPanel.Update();
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
                    lblErrorUpdate.Text = "Failed to establish connection with database. Please try again.";
                    updateBufferPanel.Update();
                    btnUpdate_ModalPopupExtender.Show();
                }
            }
                
            catch (Exception exc)
            {
                lblErrorUpdate.Text = exc.Message;
                updateBufferPanel.Update();
            }
        }

        protected void btnDo_Click(object sender, EventArgs e)
        {
            string response="";
            FileUpload theFC;
            string  theFile="";
            string oldFile = "";
            string theFileDir;
            string recipeId="0";
            string fileAction = "nochange";

            if (fvMain.CurrentMode==FormViewMode.Insert)
            {

                theFC = ((FileUpload)fvMain.FindControl("flInstruction"));
                theFile = theFC.FileName;
                try
                {
                    ConnectToDb();
                    ezCmd = new EzSqlCommand();
                    if (ezConn.State == ConnectionState.Open)
                    {
                        ezCmd.Connection = ezConn;
                        ezCmd.CommandType = CommandType.StoredProcedure;
                        ezCmd.CommandText = "modify_recipe";
                        ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));
                        ezCmd.Parameters.AddWithValue("@_recipe_id", DBNull.Value);
                        ezCmd.Parameters["@_recipe_id"].Direction = ParameterDirection.InputOutput;                      
                        ezCmd.Parameters.AddWithValue("@_name", ((TextBox)fvMain.FindControl("nameTextBox")).Text.Trim());
                        ezCmd.Parameters.AddWithValue("@_exec_method", ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedValue);
                        ezCmd.Parameters.AddWithValue("@_contact_employee", ((DropDownList)fvMain.FindControl("ddContact")).SelectedValue);
                        ezCmd.Parameters.AddWithValue("@_instruction", ((TextBox)fvMain.FindControl("instructionTextBox")).Text.Trim());
                        ezCmd.Parameters.AddWithValue("@_file_action", fileAction);
                      ezCmd.Parameters.AddWithValue("@_diagram_filename", theFile);
                        ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvMain.FindControl("commentTextBox")).Text.Trim());

                      ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);




                        ezCmd.ExecuteNonQuery();
                        response = ezCmd.Parameters["@_response"].Value.ToString();
                        if (response.Length > 0)
                        {

                            lblMainError.Text = response;

                        }
                        else
                        {
                          lblMainError.Text = "";
                            object result = ezCmd.Parameters["@_recipe_id"].Value;
                            if (result.GetType().ToString().Contains("System.Byte"))
                            {
                              System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                              recipeId = asi.GetString((byte[])result);
                            }
                            else
                            {
                              recipeId = result.ToString();
                            }
                            if (theFile.Length > 0)
                            {
                                try
                                {
                                    theFileDir = Server.MapPath(System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir"));
                                    theFC.SaveAs(theFileDir+ recipeId + "_" + theFile);
                                }
                                catch (Exception ex)
                                {
                                    lblMainError.Text = "Could not save file " + theFile + ": " + ex.Message;
                                    upMain.Update();
                                }
                            }


                        }

                        ezCmd.Dispose();
                        ezConn.Dispose();

                    }
                    else
                    {
                        lblMainError.Text = "Database connection is lost";
                        upMain.Update();
                    }
                }
                catch (Exception ex)
                {
                    lblMainError.Text = "Failed adding new recipe:" + ex.Message;
                    upMain.Update();
                }
                if (lblMainError.Text.Length > 0)
                {
                  if (Int32.Parse(recipeId) > 0)
                    Server.Transfer("RecipeConfig.aspx?Id=" + recipeId + "&Error=" + lblMainError.Text, false);
                  else
                    Server.Transfer("RecipeConfig.aspx?Error=" + lblMainError.Text, false);
                }
                else  //*****09/26/2018 xdong: this call cause error, comment out for now
                  Server.Transfer("RecipeConfig.aspx?Id=" + recipeId, false);              
            }
            else if (fvMain.CurrentMode == FormViewMode.Edit)
            {
                recipeId = txtID.Text;
                fileAction = ((RadioButtonList)fvMain.FindControl("rbDiagram")).SelectedValue;
                theFC = ((FileUpload)fvMain.FindControl("flInstruction"));
                if (fileAction.Equals("replace"))
                {
                    theFile = theFC.FileName;
                    if (theFile.Length == 0)
                        response = "No new diagram file selected to replace current file. Please select a new file.";
                }
                if (response.Length == 0)
                {
                    ConnectToDb();

                    try
                    {
                        if (ezConn.State == ConnectionState.Open)
                        {
                            ezCmd = new EzSqlCommand();
                            ezCmd.Connection = ezConn;
                            ezCmd.CommandText = "modify_recipe";
                            ezCmd.CommandType = CommandType.StoredProcedure;


                            ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));

                            ezCmd.Parameters.AddWithValue("@_recipe_id", recipeId, ParameterDirection.InputOutput);
                            

                            ezCmd.Parameters.AddWithValue("@_name", ((TextBox)fvMain.FindControl("nameTextBox")).Text.Trim());

                            ezCmd.Parameters.AddWithValue("@_exec_method", ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedValue);

                            ezCmd.Parameters.AddWithValue("@_contact_employee", ((DropDownList)fvMain.FindControl("ddContact")).SelectedValue);
                            ezCmd.Parameters.AddWithValue("@_instruction", ((TextBox)fvMain.FindControl("instructionTextBox")).Text.Trim());
                            ezCmd.Parameters.AddWithValue("@_file_action", ((RadioButtonList)fvMain.FindControl("rbDiagram")).SelectedValue);
                            ezCmd.Parameters.AddWithValue("@_diagram_filename", theFile);
                            ezCmd.Parameters.AddWithValue("@_comment", ((TextBox)fvMain.FindControl("commentTextBox")).Text);

                            ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                            ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


                            ezCmd.ExecuteNonQuery();
                            response = ezCmd.Parameters["@_response"].Value.ToString();
                            ezCmd.Dispose();
                            ezConn.Dispose();

                        }
                        else
                            response = "Database connection is lost.";
                    }
                    catch (Exception ex)
                    {
                        response = ex.Message;
                    }
                }
                if (response.Length > 0)
                {
                    lblMainError.Text = response;


                }
                else
                {
                  lblMainError.Text = "";
                    //process file update  delete old file, upload new file if replacing.
                    theFileDir = Server.MapPath(System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir"));
                    if (!fileAction.Equals("nochange"))
                    {
                        oldFile = ((Label)fvMain.FindControl("lblFile")).Text;
                        if (oldFile.Length > 0)
                        {
                            try
                            {
                                File.Delete(theFileDir + recipeId + "_" + oldFile);
                            }
                            catch (Exception ex)
                            {
                                lblMainError.Text = ex.Message;
                            }

                        }
                    }
                  if (lblMainError.Text.Length == 0)
                  {
                    if (fileAction.Equals("replace"))
                    {
                      try
                      {
                        theFC.SaveAs(theFileDir + recipeId + "_" + theFile);
                      }
                      catch (Exception ex)
                      {
                        lblMainError.Text = ex.Message;
                      }
                    }

                    //*** xdong 9/24/2018: this cause error, comment out for now
                    if (lblMainError.Text.Length == 0)
                      Server.Transfer("RecipeConfig.aspx?Id=" + txtID.Text, false);
                  }
                }
            }
            else
            {
                fvMain.ChangeMode(FormViewMode.Edit);
                fvMain.DataBind();
                
                ((DropDownList)fvMain.FindControl("ddContact")).SelectedValue =
                 ((Label)fvMain.FindControl("lblContact")).Text;
                switch (((Label)fvMain.FindControl("lblExec")).Text)
                {
                    case "ordered":
                        ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedIndex = 0;
                        break;
                    case "random":
                        ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedIndex = 1;
                        break;
                    default:
                        ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedIndex = 0;
                        break;
                }
                
                btnDo.Text = "Submit";
                btnCancel.Text = "Cancel";
                //upMain.Update();
            }

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            string response="";
            string oldFile = "";
            string theFileDir = "";
            if (fvMain.CurrentMode == FormViewMode.Insert)
            {
                clear_generalInsert();

            }
            else if (btnCancel.Text.Equals("Delete Recipe"))
            {
                
                //first delete old file
                oldFile = ((HyperLink)fvMain.FindControl("fileLink")).Text;
                if (oldFile.Length > 0)
                {
                    theFileDir = Server.MapPath(System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir"));
                    try
                    {
                        File.Delete(theFileDir + txtID.Text + "_" + oldFile);
                    }
                    catch (Exception ex)
                    {
                        response = ex.Message;
                    }

                }

                //if no error, delete recipe
                if (response.Length == 0)
                {
                    //using (sqlConn =
                    //                    new MySql.Data.MySqlClient.MySqlConnection(ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString)) ;
                    //sqlConn.Open();
                    try
                    {
                        ConnectToDb();
                        ezCmd =new EzSqlCommand();
                        ezCmd.Connection = ezConn;
                        ezCmd.CommandText = "delete_recipe";
                        ezCmd.CommandType = CommandType.StoredProcedure;


                        ezCmd.Parameters.AddWithValue("@_recipe_id", txtID.Text);
                        ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
                        ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                        ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;


                        ezCmd.ExecuteNonQuery();
                        response = ezCmd.Parameters["@_response"].Value.ToString();

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
                        Server.Transfer("RecipeConfig.aspx?Tab=" + tcMain.ActiveTabIndex, false);
                    }
                }
                else
                    lblMainError.Text = response;

            }
            else
            {
               
                fvMain.ChangeMode(FormViewMode.ReadOnly);
                fvMain.DataBind();
                HyperLink fileLink = (HyperLink)fvMain.FindControl("fileLink");
                theFileDir = System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir");

                fileLink.NavigateUrl = theFileDir + txtID.Text + "_" + fileLink.Text;

                upMain.Update();

                btnDo.Text = "Update Recipe Info";
                btnCancel.Text = "Delete Recipe";
 
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

            ddMaterial.SelectedIndex = -1;
            ddProduct.SelectedIndex = -1;
            qtyTextBox.Text = ""; 
            orderTextBox.Text = "";
            mintimeTextBox.Text = "";
            maxtimeTextBox.Text = "";
            commentTextBox.Text = "";
            rblMorP.SelectedValue = "material";
            toggle_dropdowns("material", true);
            

        }
        protected void toggle_dropdowns(string sourceType, bool IfInsertForm)
        {
            if (IfInsertForm)
            {
                ddProduct.Attributes.Remove("style");
                ddMaterial.Attributes.Remove("style");
                //tbrApprove.Attributes.Remove("style");

                if (sourceType.Equals("material"))
                {
                    ddProduct.Attributes.Add("style", "display:none");
                    ddMaterial.Attributes.Add("style", "display:block");
                  if (ddMUom.Items.Count > 0)
                    lblUom.Text = ddMUom.Items[ddMaterial.SelectedIndex>-1?ddMaterial.SelectedIndex:0].Value;
                }
                else
                {
                    ddProduct.Attributes.Add("style", "display:block");
                    ddMaterial.Attributes.Add("style", "display:none");
                  if (ddPUom.Items.Count > 0)
                    lblUom.Text = ddPUom.Items[ddProduct.SelectedIndex>-1?ddProduct.SelectedIndex:0].Value;
                }


            }



        }
 
        protected void clear_generalInsert()
        {

            ((TextBox)fvMain.FindControl("nameTextBox")).Text = "";
            ((RadioButtonList)fvMain.FindControl("rbExec")).SelectedIndex = -1;

            ((DropDownList)fvMain.FindControl("ddContact")).SelectedIndex = -1;

            ((TextBox)fvMain.FindControl("commentTextBox")).Text = "";
            ((TextBox)fvMain.FindControl("instructionTextBox")).Text = "";
            lblMainError.Text = "";
        }

        protected void btnDuplicate_Click(object sender, EventArgs e)
        {
            string strRecipeID = txtID.Text;
            if (strRecipeID == null || strRecipeID.Length == 0) return;

            try
            {
                //duplicate process
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "duplicate_recipe";
                ezCmd.CommandType = CommandType.StoredProcedure;


                ezCmd.Parameters.AddWithValue("@_old_recipe_id", strRecipeID);
                ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

                ezCmd.Parameters.AddWithValue("@_diagram_filename", DBNull.Value);
                ezCmd.Parameters["@_diagram_filename"].Direction = ParameterDirection.Output;

                ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
                ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

                ezCmd.Parameters.AddWithValue("@_new_recipe_id", DBNull.Value);
                ezCmd.Parameters["@_new_recipe_id"].Direction = ParameterDirection.Output;

                ezCmd.ExecuteNonQuery();

                string strResp = ezCmd.Parameters["@_response"].Value.ToString();
                string strFilePath = ezCmd.Parameters["@_diagram_filename"].Value.ToString();

                string strNewRecipeID = "";
                object result = ezCmd.Parameters["@_new_recipe_id"].Value;
                if (result.GetType().ToString().Contains("System.Byte"))
                {
                    System.Text.ASCIIEncoding asi = new System.Text.ASCIIEncoding();
                    strNewRecipeID = asi.GetString((byte[])result);
                }
                else
                {
                    strNewRecipeID = result.ToString();
                }

                ezCmd.Dispose();
                ezConn.Dispose();

                //go to the newly-created process
                if (strNewRecipeID.Length > 0)
                {
                    //copy diagram file
                    string strFolder = Server.MapPath(System.Configuration.ConfigurationManager.AppSettings.Get("RecipeImageDir"));
                    string strOldFile = string.Format("{0}{1}_{2}", strFolder, strRecipeID, strFilePath);
                    string strNewFile = string.Format("{0}{1}_{2}", strFolder, strNewRecipeID, strFilePath);
                    System.IO.File.Copy(strOldFile, strNewFile, true);

                    Server.Transfer(Request.CurrentExecutionFilePath + "?Id=" + strNewRecipeID, false);

                }
            }
            catch (Exception ex)
            {
                lblMainError.Text = ex.Message;
            }
        }
    }
}
