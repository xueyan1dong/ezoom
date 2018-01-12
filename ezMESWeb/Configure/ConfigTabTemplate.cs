using System;
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


namespace ezMESWeb
{
   public struct sqlParameter
   {
      private string _key;
      private object _value;

      public string Key
      {
         get { return _key; }
         set { _key = value; }
      }

      public object Value
      {
         get { return _value; }
         set { _value = value; }
      }
   }

   public class ConfigTabTemplate : System.Web.UI.Page
   {
      protected EzSqlConnection ezConn;
      protected EzSqlCommand ezCmd;

      //protected ezDataAdapter ezAdapter;
      protected DbDataReader ezReader;

      protected global::System.Web.UI.WebControls.SqlDataSource sdsUpdate;
      protected global::System.Web.UI.WebControls.SqlDataSource sdsGrid;
      protected global::System.Web.UI.WebControls.GridView gvTable;

      protected FormView fvUpdate;
      protected Button btnInsert;
      protected ModalPopupExtender mdlPopup;
      protected ModalPopupExtender btnUpdate_ModalPopupExtender;
      protected UpdatePanel insertBufferPanel, updateBufferPanel;
      protected UpdatePanel gvTablePanel;
      protected Panel InsertPanel;
      protected Label lblErrorInsert, lblErrorUpdate;
      protected ToolkitScriptManager ToolkitScriptManager1;

      protected FormView fvMain;
      protected Button btnDo, btnCancel;
      protected TabContainer tcMain;
      protected Label lblMainError;
      protected TextBox txtID;
      protected SqlDataSource sdsMain;
      protected UpdatePanel upMain;

      public System.Collections.ArrayList paras;


      //protected Label lblErrorUpdate;
      protected void ConnectToDb() //does not handle exception here
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

         if (ezConn == null)
            ezConn = new EzSqlConnection(ezType, connStr);
         if (ezConn.State != ConnectionState.Open)
            ezConn.Open();
      }

      protected virtual void Page_Load(object sender, EventArgs e)
      {
      }

      protected virtual void btnCancel_Click(object sender, EventArgs e)
      {
         if (fvMain.CurrentMode == FormViewMode.Insert)
         {
            //In inserting mode, just clear all the fields
            fvMain.DataSource = null;
            fvMain.DataBind();
            lblMainError.Text = "";
         }
         else if (fvMain.CurrentMode == FormViewMode.Edit)
         {
            //In editing mode, change text and cancel the process.
            fvMain.ChangeMode(FormViewMode.ReadOnly);
            fvMain.DataBind();
            upMain.Update();
            btnDo.Text = "Update Workflow Info";
            btnCancel.Text = "Delete Workflow";
         }
         else
            //In display mode, the cancel button is used to delete the item from table.
            //handle it in derived class.
            ;
      }
      protected void LoadMainTabPanel(String sqlText, String strName)
      {
         string id = Request.QueryString["Id"];
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
               ezCmd.CommandText = sqlText;
               ezCmd.CommandType = CommandType.Text;
               ezReader = ezCmd.ExecuteReader();
            }
            catch (Exception ex)
            {
               lblMainError.Text = ex.Message;
            }
            while (ezReader.Read())
            {
               temp = new TabPanel();
               temp.ID = String.Format("{0}", ezReader[0]);
               temp.HeaderText = String.Format("{0}", ezReader[1]);
               temp.BackColor = System.Drawing.Color.Silver;
               tcMain.Controls.Add(temp);
               if ((id != null) && (temp.ID.Equals(id)))
               {
                  show_Exist(count, strName);

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
                     show_Exist(actTab, strName);
                  else
                     show_New(count, strName);
               }
               else
                  show_New(count, strName);
            }
            //toggle the step or sub process dropdownlist on Step Insertion popup form
            /*            rblStepOrProcess.Attributes.Add("OnClick", "showDropDown('" +
                            rblStepOrProcess.ClientID + "','"
                            + ddStep.ClientID + "','" + ddSubProcess.ClientID + "','" +
                            chkIfAutoStart.ClientID + "')");
                        //toggle "approved by" on Step Insertion popup form
                        chkApproval.Attributes.Add("OnClick", "showApprovedBy('" + chkApproval.ClientID
                            + "','" + tbrApprove.ClientID + "')");
          */
            ezReader.Dispose();
            ezCmd.Dispose();
            //ezConn.Dispose();
         }
         else
         {
            //      toggle_dropdowns(rblStepOrProcess.SelectedValue, chkApproval.Checked, true);

         }
      }

      /*      protected void toggle_dropdowns(string substep, bool approve, bool IfInsertForm)
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
           */
      protected virtual void Show_Update()
      {
         fvMain.ChangeMode(FormViewMode.Edit);
         fvMain.DataBind();
         upMain.Update();

         btnDo.Text = "Submit";
         btnCancel.Text = "Cancel";
      }

      protected virtual void show_Exist(short tabIndex, String name)
      {
         tcMain.ActiveTabIndex = tabIndex;
         txtID.Text = tcMain.ActiveTab.ID;
         fvMain.Caption = "General " + name + " Information";
         fvMain.ChangeMode(FormViewMode.ReadOnly);
         fvMain.DataBind();
         upMain.Update();
         btnDo.Text = "Update Workflow Info";
         btnCancel.Text = "Delete Workflow";
         btnInsert.Visible = true;
         gvTable.Visible = true;
      }

      protected virtual void show_New(short tabIndex, String Name)
      {
         tcMain.ActiveTabIndex = tabIndex;
         fvMain.ChangeMode(FormViewMode.Insert);
         btnInsert.Visible = false;
         gvTable.Visible = false;
         btnDo.Text = "Submit";
         btnCancel.Text = "Clear";
      }

      protected void LoadSqlParasFromTemplate(EzSqlCommand ezCmd, ezMES.ITemplate.FormattedTemplate fTemp)
      {
         paras = new ArrayList();
         sqlParameter iPara;

         ezMES.ITemplate.FieldItem theItem;
         string name;
         for (int i = 0; i < fTemp.Fields.Count; i++)
         {

            theItem = (ezMES.ITemplate.FieldItem)fTemp.Fields[i];
            name = theItem.Key;
            if (name.IndexOf("drp") == 0) //dropdown list
            {
               DropDownList lst = (DropDownList)fvMain.Row.FindControl(name);

               string param = "@_" + theItem.Value;

               iPara = new sqlParameter();
               iPara.Key = param;
               iPara.Value = ((DropDownList)fvMain.Row.FindControl(name)).SelectedItem.Value;
               paras.Add(iPara);

               //    ezCmd.Parameters.AddWithValue(param, ((DropDownList)fvMain.Row.FindControl(name)).SelectedItem.Value);
            }
            else if (name.IndexOf("txt") == 0) //text box
            {
               string param = "@_" + theItem.Value;
               DataColumn _dc = fTemp._dccol[theItem.Value];
               iPara = new sqlParameter();
               iPara.Key = param;

               String txtValue = ((TextBox)fvMain.Row.FindControl(name)).Text;
               if (txtValue != null && txtValue.Length > 0)
               {

                  switch (_dc.DataType.ToString())
                  {
                     case "System.String":
                        iPara.Value = txtValue;

                        //      ezCmd.Parameters.AddWithValue(param, txtValue);
                        break;
                     case "System.UInt32":
                        iPara.Value = Convert.ToInt32(txtValue);
                        //      ezCmd.Parameters.AddWithValue(param, Convert.ToInt32(txtValue));
                        break;
                     case "System.Int16":
                     case "System.Int32":
                     case "System.Int64":
                     case "int":
                        iPara.Value = Convert.ToInt64(txtValue);
                        //     ezCmd.Parameters.AddWithValue(param, Convert.ToInt64(txtValue));
                        break;
                     case "System.Decimal":
                        iPara.Value = txtValue;
                        //                          ezCmd.Parameters.AddWithValue(param, txtValue);
                        break;
                     case "System.DateTime":
                        iPara.Value = Convert.ToDateTime(txtValue);
                        //                          ezCmd.Parameters.AddWithValue(param, Convert.ToDateTime(txtValue));
                        break;
                     default:
                        iPara.Value = txtValue;
                        // ezCmd.Parameters.AddWithValue(param, txtValue);
                        break;

                  }
               }
               else
                  iPara.Value = DBNull.Value;
               // ezCmd.Parameters.AddWithValue(param, DBNull.Value);

               paras.Add(iPara);

            }
            else if (name.IndexOf("rbl") == 0) //radio button
            {
               string param = "@_" + theItem.Value;
               DataColumn _dc = fTemp._dccol[theItem.Value];
               iPara = new sqlParameter();
               iPara.Key = param;
               iPara.Value = ((RadioButtonList)fvMain.Row.FindControl(name)).SelectedValue;
               paras.Add(iPara);
               //       ezCmd.Parameters.AddWithValue(param, ((RadioButtonList)fvMain.Row.FindControl(name)).SelectedValue);
            }
            else // not used in this form
            {
            }
         }
      }
      protected virtual void gvTable_SelectedIndexChanged(object sender, EventArgs e)
      {
         //  set it to true so it will render
         this.fvUpdate.Visible = true;
         //  force databinding
         this.fvUpdate.DataBind();
         //  update the contents in the detail panel
         this.updateBufferPanel.Update();
         //  show the modal popup
         this.btnUpdate_ModalPopupExtender.Show();
      }




      protected void fvUpdate_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
      {
         gvTable.DataBind();
         this.gvTablePanel.Update();
      }



      protected void gvTable_PageIndexChanged(object sender, EventArgs e)
      {
         gvTable.SelectedIndex = -1;
      }
      protected virtual void btnSubmitInsert_Click(object sender, EventArgs e)
      {
      }
      protected virtual void btnCancelInsert_Click(object sender, EventArgs e)
      {
         lblErrorInsert.Text = "";
         mdlPopup.Hide();
      }
      protected void btnCancelUpdate_Click(object sender, EventArgs e)
      {
         lblErrorUpdate.Text = "";
      }
      protected virtual void btnSubmitUpdate_Click(object sender, EventArgs args)
      {
      }
   }
}
