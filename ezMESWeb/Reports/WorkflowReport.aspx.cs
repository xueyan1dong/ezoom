/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : WorkflowReport.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for display workflow steps in workflow browser report
*    Log                    :
*    2009: xdong: first created
	*  04/19/2019: xdong: Changed quantity display format in ingredients to decimal with 1 decimal for non-integer quantity                   
	*                     
----------------------------------------------------------------*/
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
using CommonLib.Data.EzSqlClient;
using Microsoft.Reporting.WebForms;

namespace ezMESWeb.Reports
{
    public partial class WorkflowReport : System.Web.UI.Page
    {
        protected EzSqlConnection ezConn;
        protected EzSqlCommand ezCmd;
        protected ezDataAdapter ezAdapter;
        protected System.Data.Common.DbDataReader ezReader;


        protected Panel pnMain;

        protected DropDownList  dpProcess;


        protected Button btnView;
        protected Label lblStep, lblInstruction, lblIntro;
        protected HyperLink hpPrev, hpNext, hpFail;
        protected Image imgDiagram, imgDiagram2;
        protected TableCell tcInstruction;
        protected Table tbIngredients, tbSteps;

        protected void Page_Load(object sender, EventArgs e)
        {
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
                InitializePage(sender, e);
            }
        }
        private void InitializePage(object sender, EventArgs e)
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


           
            int count = 0;
            try
            {
                if (ezConn == null)
                    ezConn = new EzSqlConnection(ezType, connStr);
                if (ezConn.State != ConnectionState.Open)
                    ezConn.Open();

                ezCmd = new EzSqlCommand();
                ezCmd.Connection = ezConn;
                ezCmd.CommandText = "SELECT id, name FROM process";
                ezCmd.CommandType = CommandType.Text;

                ezReader = ezCmd.ExecuteReader();

                while (ezReader.Read())
                {

                    dpProcess.Items.Add(new ListItem(String.Format("{0}", ezReader[1]), String.Format("{0}", ezReader[0])));
                    count++;
                }

                string tString = (Request.QueryString.Count > 0) ? Request.QueryString["processid"] : null;
                if (count > 0 && tString != null)
                {
                  dpProcess.SelectedValue = tString;
                  btnView_Click(sender, e);
                }
                else
                {
                  ezReader.Close();
                  ezReader.Dispose();
                  ezCmd.Dispose();
                  ezConn.Dispose();
                }

            }
            catch (Exception ex)
            {
                LiteralControl lc = new LiteralControl("<h3>Report Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the report.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />");
                pnMain.Controls.Add(lc);

                return;
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            //rvProInvent.LocalReport.DataSources.Clear();
            
            getStepInfo();

            //rvProInvent.LocalReport.Refresh();
            //rvProInvent.Visible = true;

            ezReader.Close();
            ezReader.Dispose();
           
            ezCmd.Dispose();
            ezConn.Dispose();
        }

        private void getStepInfo()
        {
          string position = (Request.QueryString.Count > 1 && Request.QueryString["positionid"].Length >0)?Request.QueryString["positionid"]:"1";
          string prevPosition, 
            nextPosition, 
            falsePosition,
            imageFilename, 
            ynApproval, 
            approveEmpUsage, 
            approveEmp, 
            prompt, 
            instruction,
            recipe_id,
            restriction,
            execMethod,
            stepType,
            stepId;
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

            ezCmd.CommandText = "SELECT process_id, position_id, step_id, prev_step_pos, next_step_pos, false_step_pos, rework_limit, if_sub_process, prompt, if_autostart, YN_need_approval, approve_emp_usage, approve_emp_name FROM view_process_step WHERE process_id="
            + dpProcess.SelectedValue + " AND position_id=" + position;

            ezCmd.CommandType = CommandType.Text;

            ezReader = ezCmd.ExecuteReader();

            if (ezReader.Read())
            {
              ifAutostart = Convert.ToInt16(ezReader["if_autostart"]);
              ynApproval = ezReader["YN_need_approval"].ToString();
              approveEmp = ezReader["approve_emp_name"].ToString();
              approveEmpUsage = ezReader["approve_emp_usage"].ToString();
              prompt = ezReader["prompt"].ToString();

              lblStep.Text = Convert.ToInt16(ezReader["if_sub_process"]) > 0 ? "Current Sub Process: " : "Current Step: ";
              prevPosition = ezReader["prev_step_pos"].ToString();
              if ((prevPosition.Length > 0) && (Convert.ToInt16(prevPosition) >= 0))
              {
                hpPrev.NavigateUrl = Request.CurrentExecutionFilePath
                  + "?processid=" + dpProcess.SelectedValue
                  + "&positionid=" + prevPosition;
                hpPrev.Visible = true;
              }
              else
              {
                hpPrev.Text = "Start Step";
                hpPrev.NavigateUrl = Request.CurrentExecutionFilePath
                  + "?processid=" + dpProcess.SelectedValue;
                hpPrev.Visible = true;
              }

              
              nextPosition = ezReader["next_step_pos"].ToString();
              if ((nextPosition.Length > 0) && (Convert.ToInt16(nextPosition) >= 0))
              {
                hpNext.NavigateUrl = Request.CurrentExecutionFilePath
                  + "?processid=" + dpProcess.SelectedValue
                  + "&positionid=" + nextPosition;
                hpNext.Visible = true;
              }


              falsePosition = ezReader["false_step_pos"].ToString();
              if ((falsePosition.Length > 0) && (Convert.ToInt16(falsePosition) >= 0))
              {
                hpFail.NavigateUrl = Request.CurrentExecutionFilePath
                  + "?processid=" + dpProcess.SelectedValue
                  + "&positionid=" + falsePosition;
                hpFail.Visible = true;
              }
              
              
              ezCmd.CommandText = "select_step_details";
              ezCmd.CommandType = CommandType.StoredProcedure;

              stepId = ezReader["step_id"].ToString();
              ezCmd.Parameters.AddWithValue("@_step_id",stepId );
              ezReader.Close();
              ezReader.Dispose();
              ezReader = ezCmd.ExecuteReader();
              if (ezReader.Read())
              
              {
                lblStep.Text = lblStep.Text + ezReader["step_name"].ToString();

                lblIntro.Text = "Description: " + ezReader["description"].ToString() + "<br/>";

                stepType = ezReader["step_type_name"].ToString();
                if (stepType.Equals("reposition"))
                {

                  ezCmd.CommandText =
                    "SELECT ps.position_id,s.name,s.description FROM process_step ps, step s WHERE ps.process_id = "
                    + dpProcess.SelectedValue + " AND s.id= ps.step_id AND s.id != "
                    + stepId + " ORDER BY ps.position_id";
                  ezCmd.CommandType = CommandType.Text;

                  ezReader.Close();
                  ezReader.Dispose();

                  ezReader = ezCmd.ExecuteReader();

                  while (ezReader.Read())
                  {
                    newRow = CreateTableRow();


                    newCell = CreateTableCell(String.Format("{0}", ezReader["position_id"]));
                    newRow.Cells.Add(newCell);

                    newCell = CreateTableCell(String.Format("{0}", ezReader["name"]));
                    newRow.Cells.Add(newCell);

                    newCell = CreateTableCell(String.Format("{0}", ezReader["description"]));
                    newCell.HorizontalAlign = HorizontalAlign.Left;
                    newRow.Cells.Add(newCell);


                    tbSteps.Rows.Add(newRow);
                  }

                  if (tbSteps.Rows.Count > 1)
                  {
                    tbSteps.Visible = true;
                  }
                }
                else
                {
                
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
                  lblIntro.Text += "For any question related to the step, please contact "
                    + ezReader["contact_employee_name"].ToString() + ".<br/>";
                }

                if (ynApproval.Equals("Y"))
                {
                  lblIntro.Text += "The step needs approval upon finish from " + approveEmpUsage + " " + approveEmp + ".<br/>";
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
                      imgDiagram2.Width = imageInfo.Width;
                      imgDiagram2.Height = imageInfo.Height;
                    }

 
                    imgDiagram2.ImageUrl = imageFilename;
                    imgDiagram2.Visible = true;
                  }
                }

                
                execMethod =  ezReader["exec_method"].ToString();
                

                if ((recipe_id.Length > 0) && (Convert.ToInt32(recipe_id) > 0))
                {
                  ezReader.Close();
                  ezReader.Dispose();
                  ezCmd.CommandText = 
                    "SELECT source_type, name, description, quantity, uom_name, mintime, maxtime FROM view_ingredient WHERE recipe_id="
                    + recipe_id + " ORDER BY `order`";

                  ezCmd.CommandType = CommandType.Text;

                  ezReader = ezCmd.ExecuteReader();
                  
                  while (ezReader.Read())
                  {
                    newRow = CreateTableRow();
                    

                    newCell = CreateTableCell(String.Format("{0}", ezReader["source_type"]));
                    newRow.Cells.Add(newCell);

                    newCell=  CreateTableCell(String.Format("{0}", ezReader["name"]));
                    newRow.Cells.Add(newCell);

                    newCell = CreateTableCell(String.Format("{0:F1} {1}", ezReader["quantity"], ezReader["uom_name"]));
                    newRow.Cells.Add(newCell);

                    newCell = CreateTableCell(String.Format("{0}", ezReader["description"]));
                    newCell.HorizontalAlign = HorizontalAlign.Left;
                    newRow.Cells.Add(newCell);

                    restriction = "";
                    if ((ezReader["mintime"].ToString().Length > 0) && (Convert.ToInt32(ezReader["mintime"]) > 0))
                      restriction = "This action has to take at least " + ezReader["mintime"].ToString() + " minutes.";
                    if ((ezReader["maxtime"].ToString().Length>0)&& (Convert.ToInt32(ezReader["maxtime"])>0))
                      restriction += "This action has to be finished within " + ezReader["maxtime"].ToString() + " minutes.";
                    newCell = CreateTableCell(restriction);
                    newCell.HorizontalAlign = HorizontalAlign.Left;
                    newRow.Cells.Add(newCell);

                    tbIngredients.Rows.Add(newRow);
                  }
  
                  if (tbIngredients.Rows.Count > 1)
                  {
                    if (execMethod.Equals("ordered"))
                      tbIngredients.Caption += " following the order displayed";
                    tbIngredients.Visible = true;
                  }

                }
                }
              }
            }
            else
            {
              if (position.Equals("1"))
                lblStep.Text = "The workflow does not contain any step currently";
              else
                lblStep.Text = "The workflow does not contain the step requested";
            }
            //ReportParameter p1 = new ReportParameter("step_label", Convert.ToInt16(ezReader["if_sub_process"])>0?"Process":"Step");
            //ReportParameter p2 = new ReportParameter("YN_need_approval", ezReader["YN_need_approval"].ToString());
            //ReportParameter p3 = new ReportParameter("approval_emp", ezReader["approve_emp_name"].ToString());
            //ReportParameter p4 = new ReportParameter("approval_emp_usage", ezReader["approve_emp_usage"].ToString());
            //ReportParameter p5 = new ReportParameter("prompt", ezReader["prompt"].ToString());
            //ReportParameter p6=new ReportParameter("root", Request.Url.AbsoluteUri.Remove(Request.Url.AbsoluteUri.IndexOf('/',7)));

            //rvProInvent.LocalReport.SetParameters(new ReportParameter[] { p1, p2, p3, p4, p5, p6 });



          }
          catch (Exception ex)
          {
            lblIntro.Text += "<h3>Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while generating the traveler.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />";


            return;
          }

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
        private TableCell CreateTableCell( string Text)
        {
            TableCell tableCell = new TableCell();
            tableCell.Text = Text;
            return tableCell;
        }

        protected void dpProcess_SelectedIndexChanged(object sender, EventArgs e)
        {
          Server.Transfer(Request.CurrentExecutionFilePath + "?processid=" + dpProcess.SelectedValue, false);
        }


 
    }
}
