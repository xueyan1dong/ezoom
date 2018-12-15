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

namespace ezMESWeb.Configure.Material
{
   public partial class MaterialConfig : ConfigTemplate
   {
     protected global::System.Web.UI.WebControls.SqlDataSource sdsMaterialGrid;
       public DataColumnCollection colc;
       protected Label lblError, lblMainError;
       protected TextBox txtPartNum;
      protected DropDownList dpVendors;
      protected Label Message, RecordCount;
    //  protected EzSqlConnection ezConn;
    //    protected EzSqlCommand ezCmd;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;
        protected int iTotalCount = 0;
        protected DataSet dbSet;
        protected Button Search;

      protected String sql_SelectParts = 
         "SELECT m.id, m.name, "+
         "(select supplier_id FROM material_supplier s WHERE s.material_id = m.id ORDER BY preference limit 1) AS alias, "+
         "(select name FROM material_supplier s, client c WHERE s.material_id = m.id  and c.id = s.supplier_id ORDER BY preference limit 1) vendor,"+
         " m.mg_id, mg.name as group_name, u.name as uom_name, m.material_form, m.status, m.if_persistent, m.alert_quantity, "+                            
         " m.lot_size, m.uom_id, m.enlist_time,m.enlisted_by, concat(e1.firstname, ' ', e1.lastname) as enlisted_person,"+
         " m.update_time, m.updated_by, concat(e2.firstname, ' ', e2.lastname) as updated_person,"+
         " m.description, m.comment FROM material m LEFT JOIN material_group mg ON mg.id = m.mg_id"+
         " LEFT JOIN uom u ON u.id = m.uom_id"+
         " LEFT JOIN employee e1 ON e1.id = m.enlisted_by"+
         " LEFT JOIN employee e2 ON e2.id = m.updated_by"+
         " LEFT JOIN client c ON c.id = m.alias Where m.name = ?";
       protected String sql_SelectVendor = 
         "SELECT m.id, m.name, "+
         "(select supplier_id FROM material_supplier s WHERE s.material_id = m.id ORDER BY preference limit 1) AS alias, "+
         "(select name FROM material_supplier s, client c WHERE s.material_id = m.id  and c.id = s.supplier_id ORDER BY preference limit 1) vendor,"+
         " m.mg_id, mg.name as group_name, u.name as uom_name, m.material_form, m.status, m.if_persistent, m.alert_quantity, "+                            
         " m.lot_size, m.uom_id, m.enlist_time,m.enlisted_by, concat(e1.firstname, ' ', e1.lastname) as enlisted_person,"+
         " m.update_time, m.updated_by, concat(e2.firstname, ' ', e2.lastname) as updated_person,"+
         " m.description, m.comment FROM material m LEFT JOIN material_group mg ON mg.id = m.mg_id"+
         " LEFT JOIN uom u ON u.id = m.uom_id"+
         " LEFT JOIN employee e1 ON e1.id = m.enlisted_by"+
         " LEFT JOIN employee e2 ON e2.id = m.updated_by"+
         " LEFT JOIN client c ON c.id = m.alias Where m.name = ?";

       protected override void OnInit(EventArgs e)
       {
          base.OnInit(e);
          {
            DataView dv = (DataView)sdsMaterialGrid.Select(DataSourceSelectArguments.Empty);
             colc = dv.Table.Columns;

             //Initial insert template  
             FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"Material.xml"));

             //Initial Edit template           
             FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"Material.xml"));

             //Event happens before the select index changed clicked.
             gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
          }
       }
      
       protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                InitializePage();
            }
        }

       private void InitializePage()
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

            if (Session["UserID"] == null)
            {
               Server.Transfer("/Default.aspx");
               return;
            }
           
            try
            {
                if (ezConn == null)
                    ezConn = new EzSqlConnection(ezType, connStr);
                if (ezConn.State != ConnectionState.Open)
                    ezConn.Open();

                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "Select distinct tempTable.alias, tempTable.vendor from (" + sdsMaterialGrid.SelectCommand + ") tempTable";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                dpVendors.Items.Add(new ListItem("-- Select All Vendors", "-1"));
              
                while (ezReader.Read())
                {
                    dpVendors.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                }

                ezReader.Close();
                ezReader.Dispose();
                ezCmd.Dispose();
                ezConn.Dispose();

               //bind grid view
                gvTable.DataSourceID = "sdsMaterialGrid";
                gvTable.DataBind();

            }

            catch (Exception ex)
            {
                return;
            }

            RecordCount.Text = "<br/><b>Viewing records: " + ((gvTable.PageIndex * gvTable.PageSize) + 1) + " - ";
            if (iTotalCount <= ((gvTable.PageIndex + 1) * gvTable.PageSize))
               RecordCount.Text += iTotalCount;
            else
               RecordCount.Text += ((gvTable.PageIndex + 1) * gvTable.PageSize);

            RecordCount.Text += " of " + iTotalCount + "</b>";

            txtPartNum.Text = "";
        }

       protected void dpVendor_SelectedIndexChanged(object sender, EventArgs e)
       {
          //reload grid view.
          try
          {
              BindData();
          }

          catch (Exception ex)
          {
             Message.Text = "Unable to connect to the database.";
             return;
          }

          txtPartNum.Text = "";
       }

       protected void BindData()
       {
          ConnectToDb();
          UpdateDataPanel();

       }
 
      protected void UpdateDataPanel()
      {

          if (ezConn.State == ConnectionState.Open)
          {
             dbSet = new DataSet();

             ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
             ezCmd.Connection = ezConn;
             if (dpVendors.SelectedValue.ToString() == "-1")
                ezCmd.CommandText = "Select * from ( " + sdsMaterialGrid.SelectCommand + ") tempTable";
             else
                ezCmd.CommandText = "Select * from ( " + sdsMaterialGrid.SelectCommand + ") tempTable where tempTable.alias = " +
                   dpVendors.SelectedValue.ToString();
             ezCmd.CommandType = CommandType.Text;

             ezAdapter = new ezDataAdapter();
             ezAdapter.SelectCommand = ezCmd;
             ezAdapter.Fill(dbSet);
             if (dbSet.Tables.Count > 0)
             {
                gvTable.DataSourceID = null;
                gvTable.DataSource = dbSet;
                iTotalCount = dbSet.Tables[0].Rows.Count;
                gvTable.DataBind();
             }
             else
             {
                Message.Text = "No item/part for selected vendor";
             }

             RecordCount.Text = "<br/><b>Viewing records: " + ((gvTable.PageIndex * gvTable.PageSize) + 1) + " - ";
             if (iTotalCount <= ((gvTable.PageIndex + 1) * gvTable.PageSize))
                RecordCount.Text += iTotalCount;
             else
                RecordCount.Text += ((gvTable.PageIndex + 1) * gvTable.PageSize);

             RecordCount.Text += " of " + iTotalCount + "</b>";

             gvTablePanel.Update();
         
          }
          return;
       }
       protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
       {
          string response;

         lblMainError.Text = "";
         //bool approveChoice, autostartChoice;
         if (Request.Params["__EVENTTARGET"].Contains("btnDeleteRow"))
         {
           try
           {
             ConnectToDb();
             if (ezConn.State == ConnectionState.Open)
             {
               ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
               ezCmd.Connection = ezConn;
               ezCmd.CommandText = "delete_material";
               ezCmd.CommandType = CommandType.StoredProcedure;

               ezCmd.Parameters.AddWithValue("@_material_id", gvTable.SelectedDataKey.Value.ToString());//gvTable.SelectedPersistedDataKey.Values["id"].ToString());
               ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

               ezCmd.Parameters.AddWithValue("@_response", DBNull.Value, ParameterDirection.Output);


               ezCmd.ExecuteNonQuery();
               response = ezCmd.Parameters["@_response"].Value.ToString();

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
           ezCmd.Dispose();
           ezConn.Dispose();
         }
         else
         {
           base.gvTable_SelectedIndexChanged(sender, e);
         }
       }
       protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
       {
            FormView1.ChangeMode(FormViewMode.Edit);
            //modify the mode of form view
            // if (!Request.Params["__EVENTTARGET"].Contains("btnViewDetails"))
            if (Request.Params.GetValues(0)[0].Contains("ibClone"))
            {
                FormView1.Caption = "Copy Item/Part";

            }
            else
                FormView1.Caption = "";


            //if (Request.Params.GetValues(0)[0].Contains("ibClone"))
            //{
            //    FormView1.Caption = "Copy Item/Part";
            //    FormView1.ChangeMode(FormViewMode.Insert);
            //}
            //else
            //{
            //    FormView1.Caption = "";
            //    FormView1.ChangeMode(FormViewMode.Edit);
            //}

        }


      protected void btnSubmit_Click(object sender, EventArgs e)
        {
           if (Page.IsValid)
           {
              string response;
              ConnectToDb();
              ezCmd =new CommonLib.Data.EzSqlClient.EzSqlCommand();
              ezCmd.Connection = ezConn;
              ezCmd.CommandText = "modify_material";
              ezCmd.CommandType = CommandType.StoredProcedure;
              ezMES.ITemplate.FormattedTemplate fTemp;


              if (FormView1.CurrentMode == FormViewMode.Insert)
              {
                 ezCmd.Parameters.AddWithValue("@_material_id", DBNull.Value);
                 ezCmd.Parameters["@_material_id"].Direction = ParameterDirection.InputOutput;
                 fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;
        
              }
              else
              {
                 if (FormView1.Caption.Contains("Copy")) //clone into new material id
                     ezCmd.Parameters.AddWithValue("@_material_id", DBNull.Value);
                 else
                     ezCmd.Parameters.AddWithValue("@_material_id", gvTable.SelectedDataKey.Value.ToString());//gvTable.SelectedPersistedDataKey.Values["id"].ToString());
                 ezCmd.Parameters["@_material_id"].Direction = ParameterDirection.InputOutput;
       
                 fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
              }
              ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));


              LoadSqlParasFromTemplate(ezCmd, fTemp);


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
  //                  UpdateDataPanel();
              }
           }
        
        }


       protected void btnCancel_Click(object sender, EventArgs e)
       {
          lblError.Text = "";
          ModalPopupExtender.Hide();
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
          lblMainError.Text = "";
       }

       protected void btnSearch_Click(object sender, EventArgs e)
       {
          //get the part number and refresh the gridview
          String strPartNum = txtPartNum.Text;

          ConnectToDb();

          if (ezConn.State == ConnectionState.Open)
          {
             dbSet = new DataSet();

             ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
             ezCmd.Connection = ezConn;
             
             if (dpVendors.SelectedValue.ToString() == "-1")
                ezCmd.CommandText = "Select * from ( " + sdsMaterialGrid.SelectCommand + ") tempTable where 0=0";
             else
                ezCmd.CommandText = "Select * from ( " + sdsMaterialGrid.SelectCommand + ") tempTable where tempTable.alias = " +
                   dpVendors.SelectedValue.ToString();

             if (strPartNum != null && strPartNum.Length > 0)
             {
                ezCmd.CommandText += " and tempTable.name like '" + strPartNum + "%'";
             }

             ezCmd.CommandType = CommandType.Text;

             ezAdapter = new ezDataAdapter();
             ezAdapter.SelectCommand = ezCmd;
             ezAdapter.Fill(dbSet);
             if (dbSet.Tables.Count > 0)
             {
                gvTable.DataSourceID = null;
                gvTable.DataSource = dbSet;
                iTotalCount = dbSet.Tables[0].Rows.Count;
                gvTable.DataBind();
                gvTablePanel.Update();
             }
             else
             {
                Message.Text = "No item/part for selected vendor";
             }

             RecordCount.Text = "<br/><b>Viewing records: " + ((gvTable.PageIndex * gvTable.PageSize) + 1) + " - ";
             if (iTotalCount <= ((gvTable.PageIndex + 1) * gvTable.PageSize))
                RecordCount.Text += iTotalCount;
             else
                RecordCount.Text += ((gvTable.PageIndex + 1) * gvTable.PageSize);

             RecordCount.Text += " of " + iTotalCount + "</b>";
          }
          return;


        
       }

       protected void sqlDataSource_Selected(object sender, SqlDataSourceStatusEventArgs e)
       {
          iTotalCount = e.AffectedRows; 
          //Convert.ToInt32(e.Command.Parameters["@RowCount"].Value);
       }

       protected void gvTable_pageIndexChanging(object sender, GridViewPageEventArgs e)
       {
          gvTable.PageIndex = e.NewPageIndex;
          BindData();
         
       }

         
   }
}
