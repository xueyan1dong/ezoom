using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing.Imaging;

namespace ezMESWeb
{
    public partial class BarcodeImage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //BarcodeImage.aspx?d=12345&h=200&w=300&il=true&t=Code 128-B"
            //raw  data
            string strData = Request.QueryString["d"];
            if (strData == null) return;
            strData = strData.Trim();

            //image dimension
            int nHeight = Convert.ToInt32(Request.QueryString["h"]);
            int nWidth = Convert.ToInt32(Request.QueryString["w"]);

            //whether to display label text
            bool bShowLabel = Request.QueryString["il"].ToLower().Trim() == "true";

            //barcode type
            string strType = Request.QueryString["t"].Trim();
            BarcodeLib.TYPE nType = BarcodeLib.TYPE.UNSPECIFIED;
            switch (strType)
            {
                case "Code 128-A":
                    nType = BarcodeLib.TYPE.CODE128A;
                    break;

                case "Code 128-B":
                    nType = BarcodeLib.TYPE.CODE128B;
                    break;

                case "Code 128-C":
                    nType = BarcodeLib.TYPE.CODE128C;
                    break;

                case "UPC-A":
                    nType = BarcodeLib.TYPE.UPCA;
                    break;

                case "UPC-E":
                    nType = BarcodeLib.TYPE.UPCE;
                    break;
            }

            //generate image
            System.Drawing.Image image = null;
            try
            {
                BarcodeLib.Barcode barcode = new BarcodeLib.Barcode();

                //barcode settings
                barcode.IncludeLabel = bShowLabel;
                barcode.LabelPosition = BarcodeLib.LabelPositions.BOTTOMCENTER;

                barcode.Alignment = BarcodeLib.AlignmentPositions.CENTER;

                //encode data
                image = barcode.Encode(nType,
                    strData,
                    System.Drawing.Color.Black,
                    System.Drawing.Color.White,
                    nWidth,
                    nHeight);

                //save image as jpeg to memory stream
                Response.ContentType = "image/jpeg";
                System.IO.MemoryStream stream = new System.IO.MemoryStream();
                image.Save(stream, ImageFormat.Jpeg);

               // BarcodeLib.Barcode.ImageSize nSize = barcode.GetSizeOfImage(false);
                //write image data to response's output stream
                stream.WriteTo(Response.OutputStream);
            }
            catch (Exception ex) { }
            finally
            {
                //clean up image
                if (image != null) image.Dispose();
            }
        }
    }
}