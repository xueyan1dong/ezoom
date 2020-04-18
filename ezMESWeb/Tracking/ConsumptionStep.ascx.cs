/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : ConsumptionStep.ascx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET
*    Description            : Active control for showing step recipe in (assembly or disassembly) steps involves recipe
*    Log                    :
*    12/02/2018: Xueyan Dong: in the recipe, instead of showing the ingredient unit quantity required for making one final product
*                             showing the extended quantity for making the all the final products in the batch
*    04/19/2019: xdong: Changed quantity display format in ingredients to decimal with 1 decimal for non-integer quantity
----------------------------------------------------------------*/
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using CommonLib.Data.EzSqlClient;

namespace ezMESWeb.Tracking
{
  public partial class ConsumptionStep : System.Web.UI.UserControl
  {
    protected Label lblIntro,lblInstruction;
    protected Image imgDiagram, imgDiagram2;

    protected TableCell tcInstruction;
    protected Table tbIngredients;

    protected EzSqlConnection ezConn;
    protected EzSqlCommand ezCmd;
    protected ezDataAdapter ezAdapter;
    protected System.Data.Common.DbDataReader ezReader;
    private string stepType="consume material";

    public string StepType
    {
      set { stepType = value; }
      get { return stepType; }
    }

    public bool ShowRecipe
    {
      set
      {
        tbIngredients.Visible = value;

      }
      get
      {
        return tbIngredients.Visible;
      }
    }
    //public override bool Visible
    //{
    //  set
    //  {
    //    lblIntro.Visible = value;
    //    lblInstruction.Visible = value;
    //    imgDiagram.Visible = value;
    //    imgDiagram2.Visible = value;
    //    tbIngredients.Visible = value;
    //  }
    //}

    protected void Page_Load(object sender, EventArgs e)
    {
          int test = 0;
          string pos = Request.QueryString["position"];
          if (pos == null) return;
          string position = (pos.Length >0)?pos:"1";
          string subProcessID = Request.QueryString["sub_process"].ToString();
          string subPosition = "1";
          string 
            imageFilename, 
            ynApproval, 
            approverUsage, 
            approveEmp, 
            prompt, 
            instruction,
            recipe_id,
            restriction,
            execMethod;
          string dbConnKey;
          string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
          Int16 ifAutostart;
          DbConnectionType ezType;
          TableRow newRow;
          TableCell newCell;

          try
          {
            if (ezConn == null)
            {
              dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
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
              ezConn = new EzSqlConnection(ezType, connStr);
            }

            if (ezConn.State != ConnectionState.Open)
              ezConn.Open();
            ezCmd = new EzSqlCommand();
            ezCmd.Connection = ezConn;

            if(subProcessID.Length > 0)
            {
              subPosition = Request.QueryString["sub_position"].Length >0?Request.QueryString["sub_position"].ToString():subPosition;
              ezCmd.CommandText = "SELECT  prompt, if_autostart, YN_need_approval, approver_usage, approve_emp_name FROM view_process_step WHERE process_id="
              + subProcessID + " AND position_id=" + subPosition;
            }
            else
              ezCmd.CommandText = "SELECT  prompt, if_autostart, YN_need_approval, approver_usage, approve_emp_name FROM view_process_step WHERE process_id="
              + Request.QueryString["process_id"]/*Session["process_id"].ToString() */ + " AND position_id=" + position;

            ezCmd.CommandType = CommandType.Text;

            ezReader = ezCmd.ExecuteReader();

            if (ezReader.Read())
            {
              ifAutostart = Convert.ToInt16(ezReader["if_autostart"]);
              ynApproval = ezReader["YN_need_approval"].ToString();
              approveEmp = ezReader["approve_emp_name"].ToString();
              approverUsage = ezReader["approver_usage"].ToString();
              prompt = ezReader["prompt"].ToString();
             
              ezCmd.CommandText = "select_step_details";
              ezCmd.CommandType = CommandType.StoredProcedure;

              ezCmd.Parameters.AddWithValue("@_step_id", Request.QueryString["step"].ToString());
              ezReader.Close();
              ezReader.Dispose();
              ezReader = ezCmd.ExecuteReader();
              if (ezReader.Read())
              {

                lblIntro.Text = "Description: " + ezReader["description"].ToString() + "<br/>";

                if ((ezReader["eq_id"].ToString().Length > 0) && (Convert.ToInt32(ezReader["eq_id"])>0))
                  lblIntro.Text += "The step can be performed only on " + ezReader["eq_usage"].ToString() + " '"
                    + ezReader["eq_name"].ToString() + "'.<br/>";


                if ((ezReader["emp_id"].ToString().Length > 0) && (Convert.ToInt32(ezReader["emp_id"]) > 0))
                  lblIntro.Text += "The step can be performed only by " + ezReader["emp_usage"].ToString() + " '"
                    + ezReader["emp_name"].ToString() + "'.<br/>";

                if ((ezReader["mintime"].ToString().Length > 0) && (Convert.ToInt32(ezReader["mintime"]) > 0))
                {
                  lblIntro.Text += "The step needs to take at least " + ezReader["mintime"].ToString() + " minutes.<br/>";
                }

                if ((ezReader["maxtime"].ToString().Length > 0) && (Convert.ToInt32(ezReader["maxtime"]) > 0))
                {
                  lblIntro.Text += "The step needs to be finished within " + ezReader["maxtime"].ToString() + " minutes.<br/>";
                }
                if (ezReader["contact_employee"].ToString().Length > 0)
                {
                  lblIntro.Text += "For any question related to parts used in the step, please contact "
                    + ezReader["contact_employee_name"].ToString() + ".<br/>";
                }

                if (ynApproval.Equals("Y"))
                {
                  lblIntro.Text += "The step needs approval upon finish from " + approverUsage + " " + approveEmp + ".<br/>";
                }


                recipe_id = ezReader["recipe_id"].ToString();
                instruction =ezReader["instruction"].ToString() ;

                if (instruction.Length > 0)
                {
                  lblInstruction.Text = "Instruction:<br/><br/>" + instruction.Replace("\n", "<br/>");
                  lblInstruction.Visible = true;

                }
                imageFilename = ezReader["diagram_filename"].ToString();
                if (imageFilename.Length>0)
                {
                  imageFilename = "/docs/" + recipe_id + "_"+imageFilename;
                  System.Drawing.Image imageInfo = System.Drawing.Image.FromFile(Server.MapPath(imageFilename));
                  if ((imageInfo.Width > 500) && (imageInfo.Height < imageInfo.Width))
                  {
                    if (imageInfo.Width < 800)
                    {
                      imgDiagram2.Width = imageInfo.Width;
                    }
                    imgDiagram2.ImageUrl = imageFilename;
                    imgDiagram2.Visible = true;
                    tcInstruction.Width = new Unit("100%");
                  }
                  else
                  {
                    if (imageInfo.Width < 500)
                    {
                      imgDiagram.Width = imageInfo.Width;
                      imgDiagram.Height = imageInfo.Height;
                    }
                    else
                    {
                      imgDiagram.Height = imageInfo.Height * 500 / imageInfo.Width;
                    }
                    imgDiagram.ImageUrl = imageFilename;
                    imgDiagram.Visible = true;
                  }
                }

                
                execMethod =  ezReader["exec_method"].ToString();
                
                if(ShowRecipe)
                {
                  if ((recipe_id.Length > 0) && (Convert.ToInt32(recipe_id) > 0))
                  {
                    ezReader.Close();
                    ezReader.Dispose();
                    ezCmd.CommandText =
                                               
                     "SELECT source_type, name, description, quantity, uom_name, mintime, maxtime, (select group_concat(concat((select name from location where id = i.location_id), ': ', Format(i.actual_quantity, 1)) separator '|') from inventory i where v.ingredient_id = i.pd_or_mt_id)as inventory FROM view_ingredient v where v.recipe_id = " + recipe_id + " ORDER BY `order`";

                    ezCmd.CommandType = CommandType.Text;

                    ezReader = ezCmd.ExecuteReader();

                    while (ezReader.Read())
                    {
                      newRow = CreateTableRow();

                      newCell = CreateTableCell(String.Format("{0}", ezReader["source_type"]));
                      newRow.Cells.Add(newCell);

                      newCell = CreateTableCell(String.Format("{0}", ezReader["name"]));
                      newRow.Cells.Add(newCell);

                      newCell = CreateTableCell(String.Format("{0:F1} {1}", 
                                                Convert.ToInt32(ezReader["quantity"])* Convert.ToInt32(Request.QueryString["quantity"]),
                                                ezReader["uom_name"]));
                      newRow.Cells.Add(newCell);

                      newCell = CreateTableCell(String.Format("{0}", ezReader["description"]));
                      newCell.HorizontalAlign = HorizontalAlign.Left;
                      newRow.Cells.Add(newCell);

                      restriction = "";
                      if ((ezReader["mintime"].ToString().Length > 0) && (Convert.ToInt32(ezReader["mintime"]) > 0))
                        restriction = "This action has to take at least " + ezReader["mintime"].ToString() + " minutes.";
                      if ((ezReader["maxtime"].ToString().Length > 0) && (Convert.ToInt32(ezReader["maxtime"]) > 0))
                        restriction += "This action has to be finished within " + ezReader["maxtime"].ToString() + " minutes.";
                      newCell = CreateTableCell(restriction);
                      newCell.HorizontalAlign = HorizontalAlign.Left;
                      newRow.Cells.Add(newCell);

                      newCell = CreateTableCell(String.Format("{0}", ezReader["inventory"]));
                      newRow.Cells.Add(newCell);
                      tbIngredients.Rows.Add(newRow);
                    }
                    ezReader.Dispose();
                    if (tbIngredients.Rows.Count > 1)
                    {
                      if (execMethod.Equals("ordered"))
                        tbIngredients.Caption += " following the order displayed";
                      tbIngredients.Visible = true;
                    }
                    else
                      tbIngredients.Visible = false;

                  }

                }
              }
            }
            else
            {
              if (position.Equals("1"))
                lblIntro.Text = "The workflow does not contain any step currently";
              else
                lblIntro.Text = "The workflow does not contain the step requested";
            }
          }
          catch (Exception ex)
          {
            lblIntro.Text += "<h3>Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the traveler.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />";

          }
          ezCmd.Dispose();
          ezConn.Dispose();
    }
    private TableRow CreateTableRow()
    {
      TableRow tableRow = new TableRow();
      return tableRow;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="Text"></param>
    /// <returns></returns>
    private TableCell CreateTableCell(string Text)
    {
      TableCell tableCell = new TableCell();
      tableCell.Text = Text;
      return tableCell;
    }
  }
}