/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : EndDisassemble.aspx.cs
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : .NET 
*    Description            : UI for Move Lot form
*    Log                    :
*    07/01/2018: Xueyan Dong: initiate session[location] to empty string for now 
*                             to satisfy other tracking forms need for location
----------------------------------------------------------------*/
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

namespace ezMESWeb.Tracking
{
  public partial class MoveLot : TrackTemplate
   {


      //protected global::System.Web.UI.WebControls.SqlDataSource sdsGrid;
      protected global::System.Web.UI.WebControls.GridView gvTable;
      


      protected override void gvTable_SelectedIndexChanged(object sender, EventArgs e)
      {
        string stepType=string.Empty;
        string[] arr=new string[gvTable.SelectedRow.Cells.Count];

        lblError.Text = "";

        for (int i = 0; i < arr.Length; i++)
        {
          arr[i] = gvTable.SelectedRow.Cells[i].Text;
        }

        //make up the missing values for hiden columns.
        arr[1] = gvTable.SelectedDataKey.Values["id"].ToString();
        arr[2] = gvTable.SelectedDataKey.Values["alias"].ToString();
        arr[8] = gvTable.SelectedDataKey.Values["sub_process_id"].ToString();
            //arr[10] = gvTable.SelectedDataKey.Values["sub_position_id"].ToString();
            //arr[19] = gvTable.SelectedDataKey.Values["product_id"].ToString();
            //arr[20] = gvTable.SelectedDataKey.Values["process_id"].ToString();
            //arr[21] = gvTable.SelectedDataKey.Values["step_id"].ToString();
            //arr[22] = gvTable.SelectedDataKey.Values["result"].ToString();

        arr[11] = gvTable.SelectedDataKey.Values["sub_position_id"].ToString(); //[peiyu] pos index raised by 1
        arr[20] = gvTable.SelectedDataKey.Values["product_id"].ToString();
        arr[21] = gvTable.SelectedDataKey.Values["process_id"].ToString();
        arr[22] = gvTable.SelectedDataKey.Values["step_id"].ToString();
        arr[23] = gvTable.SelectedDataKey.Values["result"].ToString();

        Session["lot_id"] = arr[1];
        Session["lot_alias"] = arr[2];
        Session["product"] = arr[3];
        Session["priority"] = arr[4];
        Session["process"] = arr[7];
        Session["process_id"] = arr[21]; //[peiyu] pos index increased 1
        Session["lot_status"] = arr[6];
        Session["uom"] = arr[17]; //[peiyu] change from 16 to 17
        Session["location"] = arr[9]; //[peiyu]
        try
        {
          ConnectToDb();

          ezCmd = new EzSqlCommand();
          ezCmd.Connection = ezConn;

          if ((arr[6].Equals("dispatched") || arr[6].Equals("in transit") || arr[6].Equals("to warehouse"))
                && (arr[13].Equals("dispatched") || arr[13].Equals("ended"))) // 12 -> 13
          {
// added following variables: product arr[3], process arr[7], priority arr[4], uom arr[17], location arr[9], but after talking with Xueyan, I deleted it (keep original)
            GoNextStep(arr[1], arr[2], arr[6], arr[13], arr[21], arr[8], arr[10], arr[11], arr[22], arr[23], arr[16]);//12->13, 20->21,9->10,10->11,21->22,22->23, 15->16

          }
          else if ((arr[6].Equals("in process") || arr[6].Equals("hold")) && (arr[13].Equals("started") || arr[13].Equals("restarted"))) //12->13
          {

            GoEndStep(
              arr[1], arr[2], arr[6], gvTable.SelectedDataKey.Values["start_timecode"].ToString(),
              arr[13], arr[21], arr[8],//12->13,20->21
              arr[10], arr[11], arr[22], arr[23], arr[16], //9->10, 10->11, 21->22, 22->23, 15->16
              gvTable.SelectedDataKey.Values["equipment_id"].ToString());

          }
        }
        catch (Exception ex)
        {
          lblError.Text = ex.Message;
        }


        ezCmd.Dispose();
        ezConn.Dispose();

      }
      protected void gvTable_PageIndexChanged(object sender, EventArgs e)
      {
        gvTable.SelectedIndex = -1;
        lblError.Text = "";
      }
   }
}
