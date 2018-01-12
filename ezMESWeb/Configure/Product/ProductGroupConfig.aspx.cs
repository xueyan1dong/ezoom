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

namespace ezMESWeb
{
    
    public partial class ProductGroupConfig : System.Web.UI.Page
    {
        protected SqlDataSource sdProductGroup; 
        protected SqlDataSource sdsPDGrid;
        protected GridView gvProductGroup;
        protected FormView fvUpdatePG;
        protected FormView fvProductGroup;
        protected Button btnInsert;
        protected ModalPopupExtender btnInsert_ModalPopupExtender;
        protected ModalPopupExtender btnUpdate_ModalPopupExtender;
        protected UpdatePanel updPnlProductGroup;
        protected UpdatePanel gridViewPanel;
        
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvProductGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            //  set it to true so it will render
            this.fvUpdatePG.Visible = true;
            //  force databinding
            this.fvUpdatePG.DataBind();
            //  update the contents in the detail panel
            this.updPnlProductGroup.Update();
            //  show the modal popup
            this.btnUpdate_ModalPopupExtender.Show();
        }

        protected void BtnUpdate_Click(object sender, EventArgs args)
        {
            if (this.Page.IsValid)
            {
                //  move the data back to the data object
                this.fvUpdatePG.UpdateItem(false);
                this.fvUpdatePG.Visible = false;

                //  hide the modal popup
                this.btnUpdate_ModalPopupExtender.Hide();

                //  add the css class for our yellow fade
                ScriptManager.GetCurrent(this).RegisterDataItem(
                    // The control I want to send data to
                    this.gvProductGroup,
                    //  The data I want to send it (the row that was edited)
                    this.gvProductGroup.SelectedIndex.ToString()
                );

                //  refresh the grid so we can see our changed
                this.gvProductGroup.DataBind();
                this.gridViewPanel.Update();
            }
        }

        protected void BtnInsert_Click(object sender, EventArgs args)
        {
           if (this.Page.IsValid)
           {
              //  move the data back to the data object
              this.fvProductGroup.InsertItem(false);
         
              //  refresh the grid so we can see our changed
              this.gvProductGroup.DataBind();
              this.gridViewPanel.Update();
           }
        }

        protected void PgGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
    
        }

        protected void ProductsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
       
        }


        protected void PgDataSource_Selecting(object sender,EventArgs e)
        {
    
        }

        protected void fvUpdatePG_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            gvProductGroup.DataBind();
        }

        protected void gvProductGroup_PageIndexChanged(object sender, EventArgs e)
        {
            gvProductGroup.SelectedIndex = -1;
        }




              



    }
}
