using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb.Configure.Process
{
   public partial class ProcessStepConfig : ConfigTemplate
   {

      protected SqlDataSource sdsPStepGrid, sdsPStepConfig;
      public DataColumnCollection colc;
      protected Label lblError;

      protected override void OnInit(EventArgs e)
      {
         base.OnInit(e);

         {
            DataView dv = (DataView)sdsPStepGrid.Select(DataSourceSelectArguments.Empty);
            colc = dv.Table.Columns;

            //Initial insert template  
            FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"PStep_insert.xml"));

            //Initial Edit template           
            FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"PStep_modify.xml"));

            //Event happens before the select index changed clicked.
            gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
         }
      }

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
         //modify the mode of form view
         FormView1.ChangeMode(FormViewMode.Edit);
         FormView1.DataBind();

      }
      protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
      {
        base.gvTable_SelectedIndexChanged(sender, e);
        DropDownList drp0 = (DropDownList)FormView1.FindControl("drpemp_usage");
        DropDownList drp1 = (DropDownList)FormView1.FindControl("drpemp_id");
        DropDownList drp2 = (DropDownList)FormView1.FindControl("drpemp_id2");
        DataRowView drv = (DataRowView)FormView1.DataItem;
        string choice = drv["emp_usage"].ToString();
        if (choice.Equals("employee group"))
        {
          drp1.SelectedValue = drv["emp_id"].ToString();
          drp2.Attributes.Remove("style");
          drp2.Attributes.Add("style", "display:none");
          drp1.Attributes.Remove("style");
          drp1.Attributes.Add("style", "display:block");
        }
        else
        {
          drp2.SelectedValue = drv["emp_id"].ToString();
          drp1.Attributes.Remove("style");
          drp1.Attributes.Add("style", "display:none");
          drp2.Attributes.Remove("style");
          drp2.Attributes.Add("style", "display:block");
        }

      }
      protected void btnCancel_Click(object sender, EventArgs e)
      {
         lblError.Text = "";
         ModalPopupExtender.Hide();
      }

      protected void btnSubmit_Click(object sender, EventArgs e)
      {
        string response;
        string emp_usage, empId=string.Empty;
         if (Page.IsValid)
         {
           try
           {
             ConnectToDb();
             ezCmd = new EzSqlCommand();
             ezCmd.Connection = ezConn;
             ezCmd.CommandText = "modify_step";
             ezCmd.CommandType = CommandType.StoredProcedure;
             ezMES.ITemplate.FormattedTemplate fTemp;


             if (FormView1.CurrentMode == FormViewMode.Insert)
             {
               ezCmd.Parameters.AddWithValue("@_step_id", DBNull.Value);
               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
               ezCmd.Parameters["@_step_id"].Direction = ParameterDirection.InputOutput;
             }
             else
             {
               ezCmd.Parameters.AddWithValue("@_step_id", Convert.ToInt32(gvTable.SelectedPersistedDataKey.Values["id"]));
               ezCmd.Parameters["@_step_id"].Direction = ParameterDirection.InputOutput;

               fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
             }
             ezCmd.Parameters.AddWithValue("@_created_by", Convert.ToInt32(Session["UserID"]));
             ezCmd.Parameters.AddWithValue("@_version", 1);
             ezCmd.Parameters.AddWithValue("@_if_default_version", 1);
             ezCmd.Parameters.AddWithValue("@_state", "production");
             ezCmd.Parameters.AddWithValue("@_eq_usage", "equipment");
             emp_usage = ((DropDownList)FormView1.FindControl("drpemp_usage")).SelectedValue;
             ezCmd.Parameters.AddWithValue("@_emp_usage", emp_usage);

             if (emp_usage.Equals("employee"))
               empId = ((DropDownList)FormView1.FindControl("drpemp_id2")).SelectedValue;
             else
               empId=((DropDownList)FormView1.FindControl("drpemp_id")).SelectedValue;

             if(empId.Length > 0)
              ezCmd.Parameters.AddWithValue("@_emp_id", empId );
             else
               ezCmd.Parameters.AddWithValue("@_emp_id", DBNull.Value);

             int nParaCount = 0, totalParaCount = 0;
             ezMES.ITemplate.FieldItem theItem;
             string name, txtValue;

             LoadSqlParasFromTemplate(ezCmd, fTemp);

             //find actual parameter count
             for (int i = fTemp.Fields.Count - 1; i > -1; i--)
             {
               theItem = (ezMES.ITemplate.FieldItem)fTemp.Fields[i];
               name = theItem.Key;
               if (name.IndexOf("txt") == 0)
               {
                 if (String.Compare(theItem.Value.Substring(0, 4), "para") == 0)
                 {
                   totalParaCount++;

                   txtValue = ((TextBox)FormView1.Row.FindControl(name)).Text;
                   if (txtValue != null && txtValue.Length > 0)
                     nParaCount++;
                   if (totalParaCount == 10)
                     break;

                 }
               }
             }



             ezCmd.Parameters.AddWithValue("@_para_count", nParaCount);

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
