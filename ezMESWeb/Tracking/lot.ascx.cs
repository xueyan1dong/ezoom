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
using CommonLib.Data.EzSqlClient;//added for pulling data from db

namespace ezMESWeb.Tracking
{
  public partial class lot : System.Web.UI.UserControl
  {
    protected Label 
      
      //lblName1, 
      //lblProduct1, 
      //lblProcess1, 
      //lblPriority1, 
      //lblLotStatus1,
      //lblQuantity1,
      //lblUom1,
      //lblStepStatus1,
      //lblLocation1,
      //lblName, 
      //lblProduct, 
      lblProcess, 
      lblPriority, 
      lblLotStatus,
      lblQuantity,
      lblUom,
      lblStepStatus,
      lblLocation,
      lblError;

    protected void Page_Load(object sender, EventArgs e)
    {
      string stepStatus1 = Request.QueryString["step_status"];
            
            if (!IsPostBack)
            {
                //lblName1.Text = Session["lot_alias"].ToString();
                //lblProduct1.Text = Session["product"].ToString();
                //lblProcess1.Text = Session["process"].ToString();
                //lblPriority1.Text = Session["Priority"].ToString();
                //lblLotStatus1.Text = Session["lot_status"].ToString();
                //lblQuantity1.Text = Request.QueryString["quantity"];
                //lblUom1.Text = Session["uom"].ToString();
                //lblLocation1.Text = Session["location"].ToString();


                //if (stepStatus1 == null || !(stepStatus1.Equals("shipped") || stepStatus1.Equals("scrapped") || stepStatus1.Equals("dispatched")))
                //    lblStepStatus1.Text = Request.QueryString["step_status"];
                    
                //connect to db and pull info on lot_alias, rpoduct, process, priority, lot_status, quantity, uom, location
                string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
                string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
                DbConnectionType ezType;
                EzSqlConnection ezConn;
                EzSqlCommand ezCmd;
                System.Data.Common.DbDataReader ezReader;

                if (dbConnKey.Equals("ODBC"))
                {
                    ezType = DbConnectionType.MySqlODBC;

                }
                else if (dbConnKey.Equals("MySql"))
                {
                    //ezType = DbConnectionType.MySql;
                    ezType = DbConnectionType.MySqlADO;
                }
                else
                    ezType = DbConnectionType.Unknown;


                ezConn = new EzSqlConnection(ezType, connStr);
                ezConn.Open();
                ezCmd = new EzSqlCommand();

                ezCmd.Connection = ezConn;
                
                try
                {
                    if (Request.QueryString["lot_id"] == null) return;
                    //ezCmd.CommandText = "SELECT s.alias, pr.name as product, pc.name as process, p.name as priority_name, s.status as lot_status, h.status as step_status, u.name as uom, s.actual_quantity, l.name from lot_status s inner join lot_history h on h.lot_id = s.id and h.process_id = s.process_id and h.start_timecode = (select max(h1.start_timecode) from lot_history h1 where h1.lot_id = h.lot_id) and (h.end_timecode is null or (not exists(select * from lot_history h2 where h2.lot_id = h.lot_id and h2.start_timecode = h.start_timecode and h2.end_timecode is null) and h.end_timecode = (select max(h3.end_timecode) from lot_history h3 where h3.lot_id = h.lot_id))) left join product pr on pr.id = s.product_id left join process pc on pc.id  = s.process_id left join uom u on u.id = s.uomid left join priority p on p.id = s.priority left join location l on l.id = h.location_id where s.status not in ('shipped', 'scrapped') and s.id =" + Request.QueryString["lot_id"];                        
                    //if location_id is null

                
                    ezCmd.CommandText = "SELECT alias, product, process, priority_name, lot_status, step_status, uom, ROUND(actual_quantity, 0) as actual_quantity, location_id, ponumber from view_lot_in_process where id = " + Request.QueryString["lot_id"];
                    ezCmd.CommandType = CommandType.Text;
                    ezReader = ezCmd.ExecuteReader();
                    if (ezReader.Read())
                    {
                        //po number
                        string strPONumber = String.Format("{0}", ezReader[9]);

                        Image po_barcode = (Image)FindControl("po_barcode");
                        po_barcode.ImageUrl = "/BarcodeImage.aspx?d=" + strPONumber + "&h=60&w=400&il=true&t=Code 128-A";
                        
                        //name
                        string strName = String.Format("{0}", ezReader[0]);
                        //lblName.Text = strName;
                        //barcode
                        Image name_barcode = (Image)FindControl("name_barcode");
                        name_barcode.ImageUrl = "/BarcodeImage.aspx?d=" + strName + "&h=60&w=400&il=true&t=Code 128-A";

                        //product
                        string strProduct = String.Format("{0}", ezReader[1]);
                        Image product_barcode = (Image)FindControl("product_barcode");
                        product_barcode.ImageUrl = "/BarcodeImage.aspx?d=" + strProduct + "&h=60&w=400&il=true&t=Code 128-B";

                        //lblProduct.Text = strProduct;
                        lblProcess.Text = String.Format("{0}", ezReader[2]);
                        lblPriority.Text = String.Format("{0}", ezReader[3]);
                        lblLotStatus.Text = String.Format("{0}", ezReader[4]);
                        lblStepStatus.Text = String.Format("{0}", ezReader[5]);
                        lblUom.Text = String.Format("{0}", ezReader[6]);
                        lblQuantity.Text = String.Format("{0}", ezReader[7]);
                        string locationID = String.Format("{0}", ezReader[8]);
                        ezReader.Dispose();
                        if (locationID == null || locationID.Length == 0) lblLocation.Text = "N/A";
                        else
                        {
                            ezCmd.CommandText = "SELECT name from location where id =" + locationID;
                            ezCmd.CommandType = CommandType.Text;
                            ezReader = ezCmd.ExecuteReader();
                            if (ezReader.Read())
                            {
                                lblLocation.Text = String.Format("{0}", ezReader[0]);
                                ezReader.Dispose();
                            }
                        }
                    } 
                }catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                    ezCmd.Dispose();
                    ezConn.Dispose();
                }
            }
    }

  }
}