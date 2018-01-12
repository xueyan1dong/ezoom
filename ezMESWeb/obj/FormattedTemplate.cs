/*--------------------------------------------------------------
*    Copyright 2010 Ambersoft LLC.
*    Source File            : FormattedTemplate.cs
*    Created By             : Fei Xue
*    Date Created           : 1/31/2010
*    Platform Dependencies  : .NET 2.0
*    Description            : Common template file for configuration 
*                             page.
*
----------------------------------------------------------------*/
using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using AjaxControlToolkit;
using System.Xml;
using CommonLib;


namespace ezMES.ITemplate
{
   public class FormattedTemplate : System.Web.UI.ITemplate, INamingContainer
   {
      System.Web.UI.WebControls.ListItemType _type;
      DataColumnCollection _dccol;
      private System.Collections.Hashtable Fields;
      public bool ShowEdit = false;
      public string csFileName = null;
      XmlTextReader xtr = null;

      public FormattedTemplate(ListItemType type, DataColumnCollection dccol, bool showEdit, string fileName)
      {
         _type = type;
         _dccol = dccol;
         ShowEdit = showEdit;
         csFileName = fileName;
      }

      public void InstantiateIn(Control container)
      {
         Fields = new System.Collections.Hashtable();

         //create a table within the ItemTemplate
         Table tbl = new Table();

         if (_type == System.Web.UI.WebControls.ListItemType.EditItem || _type == ListItemType.Item)
            tbl.Caption = "Edit ";
         else
            tbl.Caption = "Insert ";

         TableRow tr = null;
         TableCell td = null;
         container.Controls.Add(tbl);

         if (csFileName != null && csFileName.Length > 0)
         {
            xtr = new XmlTextReader(csFileName);
            xtr.WhitespaceHandling = WhitespaceHandling.None;
            xtr.Read(); // read the XML declaration node, advance to <Tables> tag
            if (xtr.Name == "Tables" && !xtr.IsStartElement())
               return;

            while (xtr.Name != "Header" || !xtr.IsStartElement())
            {
               xtr.Read(); // advance to <Header> tag
               if (xtr.Name == "Header" && xtr.IsStartElement())
               {
                  tbl.Caption += xtr.ReadElementString("Header");
                  break;
               }
            }

            bool bEOF = false;
            foreach (DataColumn dc in _dccol)
            {

               while (xtr.Name != "Column" || !xtr.IsStartElement())
               {
                  xtr.Read(); // advance to <Column> tag
                  if (xtr.Name == "Table" && !xtr.IsStartElement()) //end of file
                  {
                     bEOF = true;
                     break;
                  }
               }

               if (bEOF)
                  break;

               if (dc.ColumnName != null &&
                  (xtr != null && !xtr.EOF &&
                  (xtr.GetAttribute("name") == dc.ColumnName)))
               {
                  xtr.Read(); //advance to <DisplayName> tag
                  string ColumnDisplayName = xtr.ReadElementString("DisplayName"); //advance to <IsEnable> tag

                  //for each DataColum create a TableRow with 2 cells
                  tr = new TableRow();
                  tbl.Rows.Add(tr);
                  td = new TableCell();
                  tr.Cells.Add(td);
                  td.Text = ColumnDisplayName.ToUpper(); // (dc.ColumnName);
                  td.CssClass = "detailgrid";
                  td = new TableCell();
                  tr.Cells.Add(td);
                  SetAColumn(td, dc);
               }
            }
            //if ShowEdit is set to true add a LinkButton for Edit within the ItemTemplate
            //and 2 linkButons (Update, Cancel) for the EditItemTemplate
            tr = new TableRow();
            tbl.Rows.Add(tr);
            td = new TableCell();
            tr.Cells.Add(td);
            if (_type == ListItemType.Item)
            {
               td.ColumnSpan = 2;
               LinkButton lnkEdit = new LinkButton();
               lnkEdit.Text = "Edit";
               lnkEdit.ToolTip = "Click here to turn on the EditItemTemplate of the FormView";
               lnkEdit.CommandName = "Edit";
               td.Controls.Add(lnkEdit);
            }
            else if (_type == System.Web.UI.WebControls.ListItemType.EditItem)
            {
               LinkButton lnkButton = new LinkButton();
               lnkButton.Text = "Cancel";
               lnkButton.ToolTip = "Click here to cancel the Edit process";
               lnkButton.CommandName = "Cancel";
               td.Controls.Add(lnkButton);

               td = new TableCell();
               tr.Cells.Add(td);

               lnkButton = new LinkButton();
               lnkButton.Text = "Update";
               lnkButton.ToolTip = "Click here to update the record";
               lnkButton.CommandName = "Update";
               td.Controls.Add(lnkButton);
            }
            else
            {
               LinkButton lnkButton = new LinkButton();
               lnkButton.Text = "Cancel";
               lnkButton.ToolTip = "Click here to cancel the Edit process";
               lnkButton.CommandName = "Cancel";
               td.Controls.Add(lnkButton);

               td = new TableCell();
               tr.Cells.Add(td);

               lnkButton = new LinkButton();
               lnkButton.Text = "Insert";
               lnkButton.ToolTip = "Click here to insert the record";
               lnkButton.CommandName = "Insert";
               td.Controls.Add(lnkButton);
            }
         }
      }
      
      private void SetAColumn(TableCell td, DataColumn _dc)
      {
         TextBox txt = null;
         ImageButton imgButton = null;
         CalendarExtender calExd = null;
         DropDownList drpLst = null;
         Label lbl = null;
         RegularExpressionValidator rexpval = null;
         RangeValidator rangeVal = null;

         CommonLib.ColumnItem ci = new CommonLib.ColumnItem();

         ci.isDisplayEnabled = true;
         
         if ( xtr != null )
         {
         //   xtr.ReadToFollowing("IsEnable");
            ci.isDisplayEnabled = xtr.ReadElementContentAsBoolean();
            //Get <UI> Tag
            ci.uiType = xtr.ReadElementString("UI").ToLower();
            if ( ci.uiType != null && ci.uiType.Length > 0 )
            {
               string strLen;
               int nLen;

               switch ( ci.uiType )
               {
                  case "label":
                     lbl = new Label();
                     lbl.ID = "lbl" + _dc.ColumnName;
                     Fields.Add(lbl.ID, _dc.ColumnName);
                     if (_dc.ReadOnly && _dc.Unique)
                     {
                        lbl.CssClass = "PrimaryKeyCell";
                     }
                     //compose a tooltip from the column attributes
                     lbl.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                     if (_dc.ReadOnly) lbl.ToolTip += ", Readonly";
                     if (_dc.Unique) lbl.ToolTip += ", Unique";
                     if (_dc.DefaultValue.Equals(DBNull.Value)) lbl.ToolTip += ", Default value is DBNull";
                     if (!_dc.Expression.Equals(string.Empty)) lbl.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();
                     td.Controls.Add(lbl);
                     lbl.DataBinding += new EventHandler(lbl_DataBinding);
                     
                     break;
                  case "textbox":
                     //read box length.
                   //  xtr.Read(); //advance
                     strLen = xtr.ReadElementString("TextBoxLength");
                     nLen = 20; //default
                     if ( strLen.Length > 0)
                        nLen = Convert.ToInt32(strLen);
                                          
                     txt = new TextBox();
                     txt.ID = "txt" + _dc.ColumnName;
                     Fields.Add(txt.ID, _dc.ColumnName);
                     txt.MaxLength = nLen;
                     txt.Width = nLen * 6;
                     td.Controls.Add(txt);
                     txt.DataBinding += new EventHandler(txt_DataBinding);
                     
                     break;
                  case "dropdown":
                     int col = Convert.ToInt32(xtr.GetAttribute("col"));
                     string strQuery = xtr.ReadElementString("DropdownQuery");
                     
                     if ( strQuery != null && strQuery.Length > 0 )
                     {
                        //run Query 
                        DbUtil dbutil = new DbUtil();
                        System.Data.DataSet ds = dbutil.getDBDataset(strQuery, "temp");

                        drpLst = new DropDownList();
                        drpLst.ID = "drp" + _dc.ColumnName;
                        drpLst.Height = Unit.Pixel(25);
                        drpLst.Width = Unit.Pixel(166);

                        DataRow myDataRow = null;

                        DataTable dt = ds.Tables["temp"];
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                           myDataRow = dt.Rows[i];

                           System.Web.UI.WebControls.ListItem drpLstItem = new System.Web.UI.WebControls.ListItem((string) myDataRow[col]) ;
                           drpLst.Items.Add(drpLstItem);
                        }

                        Fields.Add(drpLst.ID, _dc.ColumnName);
                        td.Controls.Add(drpLst);
                        xtr.Read();
                      }
                      break;
                  case "datetime":
                     strLen = xtr.ReadElementString("TextBoxLength");
                     nLen = 20; //default
                     if (strLen.Length > 0)
                        nLen = Convert.ToInt32(strLen);
                     
                     txt = new TextBox();
                     txt.ID = "txt" + _dc.ColumnName;
                     Fields.Add(txt.ID, _dc.ColumnName);
                    
                     txt.MaxLength = nLen;
                     txt.Width = nLen * 6;
                     td.Controls.Add(txt);
                     txt.DataBinding += new EventHandler(txt_DataBinding);

                     rexpval = new RegularExpressionValidator();
                     rexpval.ValidationExpression = @"^\(?\d{3}[\)\-\s]?\d{3}[-\s]?\d{4}$";
                     rexpval.ControlToValidate = txt.ID;
                     rexpval.Display = ValidatorDisplay.Dynamic;
                     rexpval.Text = "*";
                     rexpval.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not a valid date entry";
                     td.Controls.Add(rexpval);
                    
                     //Image button, link to calendar extender
                     imgButton = new ImageButton();
                     imgButton.ID = "imgButton" + _dc.ColumnName;
                     imgButton.ImageUrl = "~/Images/Calendar.gif";
                     imgButton.AlternateText = "Click here to display calendar";
                     Fields.Add(imgButton.ID, _dc.ColumnName);
                     imgButton.Width = Unit.Pixel(10);
                     td.Controls.Add(imgButton);

                     //Add ajax calendar extender control
                     calExd = new CalendarExtender();
                     calExd.ID = "cal" + _dc.ColumnName;
                     calExd.TargetControlID = txt.ID;
                     calExd.PopupButtonID = imgButton.ID;
                     calExd.Enabled = true;
                     Fields.Add(calExd.ID, _dc.ColumnName);
                     td.Controls.Add(calExd);
                     break;
                  case "radiobutton":
                     RadioButtonList rbl = new RadioButtonList();
                     rbl.ID = "rbl" + _dc.ColumnName;
                     Fields.Add(rbl.ID, _dc.ColumnName);
                     System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("Yes", "True");
                     rbl.Items.Add(li);
                     rbl.RepeatLayout = RepeatLayout.Flow;
                     rbl.RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal;
                     li = new System.Web.UI.WebControls.ListItem("No", "False");
                     rbl.Items.Add(li);
                     rbl.DataBound += new EventHandler(rbl_DataBound);
                     td.Controls.Add(rbl);
                     break;
                   default:
                      break;
                }
            }


       /*     switch (_type)
            {
               case System.Web.UI.WebControls.ListItemType.Item:

                  //if datacolumn is readonly and unique then it is a primary key
                  //render it as label a distinctive style
                  lbl = new Label();
                  lbl.ID = "lbl" + _dc.ColumnName;
                  Fields.Add(lbl.ID, _dc.ColumnName);
                  if (_dc.ReadOnly && _dc.Unique)
                  {
                     lbl.CssClass = "PrimaryKeyCell";
                  }
                  //compose a tooltip from the column attributes
                  lbl.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                  if (_dc.ReadOnly) lbl.ToolTip += ", Readonly";
                  if (_dc.Unique) lbl.ToolTip += ", Unique";
                  if (_dc.DefaultValue.Equals(DBNull.Value)) lbl.ToolTip += ", Default value is DBNull";
                  if (!_dc.Expression.Equals(string.Empty)) lbl.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();
                  td.Controls.Add(lbl);
                  lbl.DataBinding += new EventHandler(lbl_DataBinding);

                  break;
               case System.Web.UI.WebControls.ListItemType.EditItem:
               case System.Web.UI.WebControls.ListItemType.SelectedItem:

                  if (_dc.ReadOnly || (_dc.ReadOnly && _dc.Unique) || ci.isDisplayEnabled == false)
                  {
                     lbl = new Label();
                     lbl.ID = "lbl" + _dc.ColumnName;
                     Fields.Add(lbl.ID, _dc.ColumnName);
                     lbl.CssClass = "detailgrid";
                     //compose a tooltip from the column attributes
                     lbl.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                     if (_dc.ReadOnly) lbl.ToolTip += ", Readonly";
                     if (_dc.Unique) lbl.ToolTip += ", Unique";
                     if (_dc.DefaultValue.Equals(DBNull.Value)) lbl.ToolTip += ", Default value is DBNull";
                     td.Controls.Add(lbl);
                     lbl.DataBinding += new EventHandler(lbl_DataBinding);

                  }

                  else
                  {
                     switch (_dc.DataType.ToString())
                     {
                        case "System.Boolean":
                           RadioButtonList rbl = new RadioButtonList();
                           rbl.ID = "rbl" + _dc.ColumnName;
                           Fields.Add(rbl.ID, _dc.ColumnName);
                           System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("Yes", "True");
                           rbl.Items.Add(li);
                           rbl.RepeatLayout = RepeatLayout.Flow;
                           rbl.RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal;
                           li = new System.Web.UI.WebControls.ListItem("No", "False");
                           rbl.Items.Add(li);
                           rbl.DataBound += new EventHandler(rbl_DataBound);
                           td.Controls.Add(rbl);
                           break;
                        case "System.String":
                           txt = new TextBox();
                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);
                           txt.MaxLength = 20; // _dc.MaxLength;
                           txt.Width = Unit.Pixel(120);//_dc.MaxLength * 6);
                           td.Controls.Add(txt);
                           txt.DataBinding += new EventHandler(txt_DataBinding);
                           break;
                        case "System.Int16":
                           txt = new TextBox();

                           if (_dc.DefaultValue.Equals(DBNull.Value)) txt.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                           if (!_dc.Expression.Equals(string.Empty)) txt.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();

                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);

                           td.Controls.Add(txt);
                           txt.MaxLength = 5;
                           txt.Width = Unit.Pixel(40);
                           rangeVal = new RangeValidator();
                           rangeVal.ControlToValidate = txt.ID;
                           rangeVal.MaximumValue = "32767";
                           rangeVal.MinimumValue = "-32767";
                           rangeVal.Display = ValidatorDisplay.Dynamic;
                           rangeVal.Text = "*";
                           rangeVal.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not valid for an int16 type";

                           rangeVal.Type = ValidationDataType.Integer;
                           td.Controls.Add(rangeVal);
                           txt.DataBinding += new EventHandler(txt_DataBinding);
                           break;
                        case "System.Int32":
                           txt = new TextBox();
                           if (_dc.DefaultValue.Equals(DBNull.Value)) txt.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                           if (!_dc.Expression.Equals(string.Empty)) txt.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();

                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);
                           td.Controls.Add(txt);
                           txt.MaxLength = 10;
                           txt.Width = Unit.Pixel(60);
                           rangeVal = new RangeValidator();
                           rangeVal.ControlToValidate = txt.ID;
                           rangeVal.MaximumValue = "2147483647";
                           rangeVal.MinimumValue = "-2147483648";
                           rangeVal.Display = ValidatorDisplay.Dynamic;
                           rangeVal.Text = "*";
                           rangeVal.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not valid for an int32 type";
                           rangeVal.Type = ValidationDataType.Integer;
                           td.Controls.Add(rangeVal);
                           txt.DataBinding += new EventHandler(txt_DataBinding);
                           break;
                        case "System.Int64":
                           txt = new TextBox();
                           if (_dc.DefaultValue.Equals(DBNull.Value)) txt.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                           if (!_dc.Expression.Equals(string.Empty)) txt.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();

                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);
                           td.Controls.Add(txt);
                           txt.MaxLength = 19;
                           txt.Width = Unit.Pixel(60);
                           rangeVal = new RangeValidator();
                           rangeVal.ControlToValidate = txt.ID;
                           rangeVal.MaximumValue = "9223372036854775807";
                           rangeVal.MinimumValue = "-9223372036854775808";
                           rangeVal.Display = ValidatorDisplay.Dynamic;
                           rangeVal.Text = "*";
                           rangeVal.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not valid for an int64 type";
                           rangeVal.Type = ValidationDataType.Integer;
                           td.Controls.Add(rangeVal);
                           txt.DataBinding += new EventHandler(txt_DataBinding);
                           break;
                        case "System.Decimal":
                           txt = new TextBox();
                           if (_dc.DefaultValue.Equals(DBNull.Value)) txt.ToolTip = _dc.ColumnName + " is of type " + _dc.DataType.ToString();
                           if (!_dc.Expression.Equals(string.Empty)) txt.ToolTip += ", a calculated field based on " + _dc.Expression.ToString();

                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);
                           td.Controls.Add(txt);
                           txt.MaxLength = 19;
                           txt.Width = Unit.Pixel(60);
                           rexpval = new RegularExpressionValidator();
                           rexpval.ValidationExpression = @"^\d*.?\d{0,2}$";
                           rexpval.Display = ValidatorDisplay.Dynamic;
                           rexpval.Text = "*";
                           rexpval.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not valid for Decimal type";
                           rexpval.ControlToValidate = txt.ID;
                           td.Controls.Add(rexpval);
                           txt.DataBinding += new EventHandler(txt_DataBinding);
                           break;
            *//*
                        case "System.DateTime":
                           txt = new TextBox();
                           txt.ID = "txt" + _dc.ColumnName;
                           Fields.Add(txt.ID, _dc.ColumnName);
                           txt.MaxLength = 10;
                           txt.Width = Unit.Pixel(80);
                           td.Controls.Add(txt); */
                           /*    rexpval = new RegularExpressionValidator();
                               rexpval.ValidationExpression = @"^\(?\d{3}[\)\-\s]?\d{3}[-\s]?\d{4}$";
                               rexpval.ControlToValidate = txt.ID;
                               rexpval.Display = ValidatorDisplay.Dynamic;
                               rexpval.Text = "*";
                               rexpval.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not a valid date entry";
                               td.Controls.Add(rexpval);
                            * */
            /*       txt.DataBinding += new EventHandler(txt_DataBinding);

                   //Image button, link to calendar extender
                   imgButton = new ImageButton();
                   imgButton.ID = "imgButton" + _dc.ColumnName;
                   imgButton.ImageUrl = "~/Images/Calendar.gif";
                   imgButton.AlternateText = "Click here to display calendar";
                   Fields.Add(imgButton.ID, _dc.ColumnName);
                   imgButton.Width = Unit.Pixel(10);
                   td.Controls.Add(imgButton);

                   //Add ajax calendar extender control
                   calExd = new CalendarExtender();
                   calExd.ID = "cal" + _dc.ColumnName;
                   calExd.TargetControlID = txt.ID;
                   calExd.PopupButtonID = imgButton.ID;
                   calExd.Enabled = true;
                   Fields.Add(calExd.ID, _dc.ColumnName);
                   td.Controls.Add(calExd);

                   break;
                case "System.Byte":
                   //temp solution. Will change in the future
                   if (_dc.ColumnName == "priority")
                   {
                      //add drop down list
                      drpLst = new DropDownList();
                      drpLst.ID = "drp" + _dc.ColumnName;
                      drpLst.Height = Unit.Pixel(25);
                      drpLst.Width = Unit.Pixel(166);

                      System.Web.UI.WebControls.ListItem drpLstItem = new System.Web.UI.WebControls.ListItem("Critical");
                      drpLst.Items.Add(drpLstItem);
                      drpLstItem = new System.Web.UI.WebControls.ListItem("High");
                      drpLst.Items.Add(drpLstItem);
                      drpLstItem = new System.Web.UI.WebControls.ListItem("Medium");
                      drpLst.Items.Add(drpLstItem);
                      drpLstItem = new System.Web.UI.WebControls.ListItem("Low");
                      drpLst.Items.Add(drpLstItem);

                      Fields.Add(drpLst.ID, _dc.ColumnName);
                      td.Controls.Add(drpLst);

                   }
                   break;
                default:
                   txt = new TextBox();
                   txt.ID = "txt" + _dc.ColumnName;
                   Fields.Add(txt.ID, _dc.ColumnName);
                   td.Controls.Add(txt);
                   if (txt.MaxLength > 0)
                   {
                      txt.MaxLength = _dc.MaxLength;
                      txt.Width = Unit.Pixel(_dc.MaxLength * 6);
                   }
                   txt.DataBinding += new EventHandler(txt_DataBinding);
                   break;
             }

          }
          break;
    }*/
         }
 return;
}

void txt_DataBinding(object sender, EventArgs e)
{
 TextBox txt = (TextBox)sender;
 DataRowView drv = null;
 DataColumn _dc = _dccol[Fields[txt.ID].ToString()];
 drv = (DataRowView)((FormView)txt.NamingContainer).DataItem;

 if (drv != null)
 {
    switch (_dc.DataType.ToString())
    {

       case "System.String":
          txt.Text = drv[_dc.ColumnName].ToString();
          break;
       case "System.UInt32":
          txt.Text = Convert.ToUInt32(drv[_dc.ColumnName]).ToString("#0");
          break;
       case "System.Int16":
       case "System.Int32":
       case "System.Int64":
       case "int":
          if (Convert.ToInt64(drv[_dc.ColumnName]) < 0) txt.CssClass = "NegativeNumber";
          txt.Text = Convert.ToInt64(drv[_dc.ColumnName]).ToString("#0");
          break;
       case "System.Decimal":
          if (Convert.ToDecimal(drv[_dc.ColumnName]) < 0) txt.CssClass = "NegativeNumber";
          txt.Text = Convert.ToDecimal(drv[_dc.ColumnName]).ToString("#0.00");
          break;
       case "System.DateTime":
          if (Convert.ToDateTime(drv[_dc.ColumnName]) > DateTime.Now) txt.CssClass = "LateDate";
          txt.Text = Convert.ToDateTime(drv[_dc.ColumnName]).ToString("MM/dd/yyyy");
          break;

       default:
          txt.Text = drv[_dc.ColumnName].ToString();
          break;
    }
         }
      }


      void rbl_DataBound(object sender, EventArgs e)
      {
         RadioButtonList rbl = ((RadioButtonList)sender);
         DataRowView drv = null;
         DataColumn _dc = _dccol[Fields[rbl.ID].ToString()];
         
         drv = (DataRowView)((FormView)rbl.NamingContainer).DataItem;

         if ( drv != null )
            rbl.SelectedValue = drv[_dc.ColumnName].ToString();
      }

      void lbl_DataBinding(object sender, EventArgs e)
      {
         Label lbl = ((Label)sender);
         DataRowView drv = null;
         DataColumn _dc = _dccol[Fields[lbl.ID].ToString()];
         drv = (DataRowView)((FormView)lbl.NamingContainer).DataItem;

         
         //change the data format based on the data if the datacolumn is not a primary key field
           if (drv != null)
            {
               switch (_dc.DataType.ToString())
               {
                  case "System.DateTime":
                     lbl.Text = ((DateTime)drv[_dc.ColumnName]).ToString("ddd, MMM dd, yyyy");
                     if ((DateTime)drv[_dc.ColumnName] > DateTime.Now) lbl.CssClass = "LateDate";
                     break;
                  case "System.Decimal":
                     lbl.Text = ((Decimal)drv[_dc.ColumnName]).ToString("#0.00");
                     if ((Decimal)drv[_dc.ColumnName] < 0) lbl.CssClass = "NegativeNumber";
                     break;
                  case "System.Boolean":
                     lbl.Text = Convert.ToBoolean(drv[_dc.ColumnName]) ? "Yes" : "No";
                     break;
                  case "System.UInt32":
                     lbl.Text = Convert.ToUInt32(drv[_dc.ColumnName]).ToString("#0");
                     break;
                  default:
                     lbl.Text = drv[_dc.ColumnName].ToString();
                     break;

               }
            }
         }
   }

}




