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

namespace ezMESWeb.Configure
{
    public partial class ProductAttributeConfig : ConfigTemplate
    {
        protected SqlDataSource sdsProductAttributeConfig, sdsProductAttributeConfigGrid;
        public DataColumnCollection colc;
        protected Label lblError;
        protected DropDownList dpProduct;
        protected System.Data.Common.DbDataReader ezReader;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            {
                DataView dv = (DataView)sdsProductAttributeConfigGrid.Select(DataSourceSelectArguments.Empty);
                colc = dv.Table.Columns;

                //Initial insert template  
                FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem,
                    colc,
                    false,
                    Server.MapPath(@"ProductAttribute_insert.xml"));

                //Initial Edit template           
                FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem,
                    colc,
                    true,
                    Server.MapPath(@"ProductAttribute_modify.xml"));

                //Event happens before the select index changed clicked.
                gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
            }
            if (!IsPostBack)
            {


                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "SELECT id, name FROM product";
                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {

                    dpProduct.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                }
                ezReader.Close();
                ezReader.Dispose();

                string tString = (Request.QueryString.Count > 0) ? Request.QueryString["prodid"] : null;
                if ((tString != null) && tString.Length > 0)
                {
                    dpProduct.SelectedValue = tString;
                    dpProd_SelectedIndexChanged(this, e);
                }
                else
                {
                    if (dpProduct.Items.Count > 0)
                    {
                        dpProduct.SelectedIndex = 0;
                        dpProd_SelectedIndexChanged(this, e);
                    }
                }

            }
        }

        protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
        {
            //modify the mode of form view
            FormView1.ChangeMode(FormViewMode.Edit);

        }



        protected void btnCancel_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            ModalPopupExtender.Hide();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string response;
                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "modify_product_attribute ";
                ezCmd.CommandType = CommandType.StoredProcedure;
                ezMES.ITemplate.FormattedTemplate fTemp;

                int nValue;
                nValue = Convert.ToInt32(Session["UserID"]);

                string strValue;
                if (FormView1.CurrentMode == FormViewMode.Insert)
                {
                    ezCmd.Parameters.AddWithValue("@_operation", "INSERT");
                    ezCmd.Parameters.AddWithValue("@_recorder_id", nValue);

                    fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
                }
                else
                {
                    ezCmd.Parameters.AddWithValue("@_operation", "MODIFY");
                    ezCmd.Parameters.AddWithValue("@_recorder_id", nValue);

                    fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
                }

                //product id
                strValue = dpProduct.SelectedValue;
                ezCmd.Parameters.AddWithValue("@_product_id", strValue);

                //attribute id when modify
                if (FormView1.CurrentMode != FormViewMode.Insert)
                {
                    nValue = Convert.ToInt32(gvTable.SelectedValue);
                    ezCmd.Parameters.AddWithValue("@_attr_id", nValue);
                }

                //other parameters
                LoadSqlParasFromTemplate(ezCmd, fTemp);

                //special treatment on attribute id when insert
                if (FormView1.CurrentMode == FormViewMode.Insert)
                {
                    EzSqlParameter param = ezCmd.Parameters["@_attr_id"];
                    strValue = param.Value.ToString();
                    nValue = strValue.IndexOf("||");
                    strValue = strValue.Substring(0, nValue);
                    param.Value = strValue;
                }

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

        protected void btn_Click(object sender, EventArgs e)
        {
            //  set it to true so it will render
            this.FormView1.Visible = true;
            FormView1.ChangeMode(FormViewMode.Insert);
            //  force databinding
            this.FormView1.DataBind();

            //filter out that ones that are already associated to the product
            DropDownList drpAttrID = (DropDownList)FormView1.FindControl("drpattr_id");
            if (drpAttrID != null)
            {
                string strProdID = dpProduct.SelectedItem.Value;
                string strValue, strAttrID;

                ConnectToDb();
                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "SELECT attr_id FROM attribute_value WHERE parent_id=" + strProdID;

                ezCmd.CommandType = CommandType.Text;
                ezReader = ezCmd.ExecuteReader();
                while (ezReader.Read())
                {
                    strAttrID = String.Format("{0}", ezReader[0]);

                    for (int i = 0; i < drpAttrID.Items.Count; i++)
                    {
                        strValue = drpAttrID.Items[i].Value;
                        if (strValue.IndexOf(strAttrID + "||") == 0)
                        {
                            drpAttrID.Items.RemoveAt(i);
                            break;
                        }
                    }
                }
                ezReader.Close();
                ezReader.Dispose();

                //first item as selected
                if (drpAttrID.Items.Count > 0)
                {
                    strValue = drpAttrID.Items[0].Value;
                    int nIndex = strValue.IndexOf("||");
                    strValue = strValue.Substring(nIndex + 2);

                    Label lblRestriction = (Label)FormView1.FindControl("lblrestriction");
                    lblRestriction.Text = strValue;
                }

                //product name
                strValue = dpProduct.SelectedItem.Text;
                Label lblProductName = (Label)FormView1.FindControl("lblproduct_name");
                lblProductName.Text = strValue;
            }

            //  update the contents in the detail panel
            this.updateRecordPanel.Update();
            //  show the modal popup
            this.ModalPopupExtender.Show();
        }

        protected void dpProd_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvTable.Caption = "Attributes of Product " + dpProduct.SelectedItem.Text;
            gvTable.DataBind();
        }
    }
}
