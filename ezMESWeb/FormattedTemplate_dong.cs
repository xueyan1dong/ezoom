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
using System.Collections;
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
using CommonLib.Data.EzSqlClient;


namespace ezMES.ITemplate
{
    public struct FieldItem
    {
        private string _key;
        private string _value;
      //automatically collect user input without code examination
        private bool _autoCollect; 
        public string Key
        {
            get { return _key; }
            set { _key = value; }
        }

        public string Value
        {
            get { return _value; }
            set { _value = value; }
        }
        public bool AutoCollect
        {
          get { return _autoCollect; }
          set { _autoCollect = value; }
        }
    }
   
   public class FormattedTemplate : System.Web.UI.ITemplate, INamingContainer
   {
      System.Web.UI.WebControls.ListItemType _type;
      public DataColumnCollection _dccol;
      //public System.Collections.Hashtable Fields;
      public System.Collections.ArrayList Fields;
      public bool ShowEdit = false;
      public string csFileName = null;
      XmlTextReader xtr = null;
      //String FieldName;

      public Type GetEnumType(string name)
      {
         Type eType = null;

         switch (name)
         {
            case "OrderType":
               eType = typeof(OrderType);
               break;
            case "ClientType":
               eType = typeof(ClientType);
               break;
            case "EmpStatusType":
               eType = typeof(EmpStatusType);
               break;
            case "StateType":
               eType = typeof(StateType);
               break;
            case "EqUsageType":
               eType = typeof(EqUsageType);
               break;
            case "EmpUsageType":
               eType = typeof(EmpUsageType);
               break;
            case "ExecMethodType":
               eType = typeof(ExecMethodType);
               break;
            case "SourceType":
               eType = typeof(SourceType);
               break;
            case "MaterialFormType":
               eType = typeof(MaterialFormType);
               break;
            case "MaterialStatusType":
               eType = typeof(MaterialStatusType);
               break;
            default:
               break;
         }

         return eType;


      }

      public FormattedTemplate(ListItemType type, DataColumnCollection dccol, bool showEdit, string fileName)
      {
         _type = type;
         _dccol = dccol;
         ShowEdit = showEdit;
         csFileName = fileName;
      }

      public void InstantiateIn(Control container)
      {
         //Fields = new System.Collections.Hashtable();
          Fields = new System.Collections.ArrayList();
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
                  td.CssClass = "detailgrid";
                  
               }
            }
         }
      }
      
      private void SetAColumn(TableCell td, DataColumn _dc)
      {
         TextBox txt = null;
         ImageButton imgButton = null;
         CalendarExtender calExd = null;
         DropDownList drpLst = null, drpLst2 = null;
         Label lbl = null;
         RegularExpressionValidator rexpval = null;
         FieldItem newItem; //
         bool normalField = true; 
         //RangeValidator rangeVal = null;

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
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                       normalField = xtr.ReadElementContentAsBoolean();
                     }

                     newItem = new FieldItem();
                     newItem.Key = lbl.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);

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
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                       normalField = xtr.ReadElementContentAsBoolean();
                     }
                     newItem = new FieldItem();
                     newItem.Key = txt.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);

                     txt.MaxLength = nLen;

                     txt.Width = Unit.Pixel(166);

                     if (nLen > 50)
                     {
                        txt.Wrap = true;
                        txt.TextMode = TextBoxMode.MultiLine;
                        txt.Rows = nLen / 80;
                     }
                     
                     td.Controls.Add(txt);
                     txt.DataBinding += new EventHandler(txt_DataBinding);
                     
                     break;
                  case "password":
                     //read box length.
                     //  xtr.Read(); //advance
                     strLen = xtr.ReadElementString("TextBoxLength");
                     nLen = 20; //default
                     if (strLen.Length > 0)
                       nLen = Convert.ToInt32(strLen);

                     txt = new TextBox();
                     txt.ID = "txt" + _dc.ColumnName;
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                       normalField = xtr.ReadElementContentAsBoolean();
                     }

                     newItem = new FieldItem();
                     newItem.Key = txt.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);

                     txt.MaxLength = nLen;

                     txt.Width = Unit.Pixel(166);

                     txt.TextMode = TextBoxMode.Password;

                     td.Controls.Add(txt);
                     txt.DataBinding += new EventHandler(txt_DataBinding);

                     break;
                  case "dropdown":
                     if ( xtr.Name == "DropdownQuery")
                     {
                        //Display column. Display the column value in list.
                        int dcol = Convert.ToInt32(xtr.GetAttribute("dcol"));
                        //Value column. Save the column value as list item value
                        int vcol = Convert.ToInt32(xtr.GetAttribute("vcol"));
                    
                        string strQuery = xtr.ReadElementString("DropdownQuery");

                        //run Query 
                        //DbUtil dbutil = new DbUtil();
                        //dbutil.Connect();

                        //System.Data.DataSet ds = dbutil.GetDataSet(strQuery);

                        //dbutil.Disconnect();
                       EzSqlConnection ezConn;
                       EzSqlCommand ezCmd=new EzSqlCommand();
                       ezDataAdapter ezAdapter=new ezDataAdapter();
                       DataSet ds;
                       
                       string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
                       string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
                       DbConnectionType ezType;

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


                       ezCmd.Connection = ezConn;
                       ezCmd.CommandText = strQuery;
                       ezCmd.CommandType = CommandType.Text;
                       //System.Data.DataSet ds = dbutil.GetDataSet(strQuery, "temp");
                       ds = new DataSet();
                       ezAdapter.SelectCommand = ezCmd;
                       ezAdapter.Fill(ds);



                        drpLst = new DropDownList();
                        drpLst.ID = "drp" + _dc.ColumnName;
                        
                        drpLst.Height = Unit.Pixel(23);
                        drpLst.Width = Unit.Pixel(166);


                        drpLst.DataSource = ds.Tables[0];
                        drpLst.DataTextField = ds.Tables[0].Columns[dcol].ToString();
                        drpLst.DataValueField = ds.Tables[0].Columns[vcol].ToString();
                        drpLst.DataBind();
                       //Attribute element allow us to add something to control attributes
                       //call to java script or styles. Right now only dropdown implemented this. 
                       //X.D. 8/27/2010
                        if (xtr.IsStartElement() && xtr.Name == "Attribute")
                        {
                          drpLst.Attributes.Add(xtr.GetAttribute("key"), xtr.ReadElementString("Attribute"));
                        }

                        //"NormalField" is an optional tag, only define it when the field is not normal
                        //non-normal field won't be added to Fields, thus, can't be accessed through fields.
                        //this is needed when fields need special treatment with special code, like two dropdowns
                        //provide values to one data column.
                        //it must appear after tag "Attribute", if "Attribute" tag exist

                        if (xtr.IsStartElement() && xtr.Name == "NormalField")
                        {
                          normalField = xtr.ReadElementContentAsBoolean();
                        }
                        newItem = new FieldItem();
                        newItem.Key = drpLst.ID;
                        newItem.Value = _dc.ColumnName;
                        newItem.AutoCollect = normalField;
                        Fields.Add(newItem);                       

                        drpLst.DataBinding += new EventHandler(drp_DataBinding);
                        
                       //special code for inventory config form

                        td.Controls.Add(drpLst);

                        ezAdapter.Dispose();
                        ezCmd.Dispose();
                        ezConn.Dispose();

                       //Following code allows to have another control in the same table cell
                       //For example, in inventory form, two dropdowns are in one cell, only one
                       //displays according to the selection of source type.
                       //The control inside AlterControl tag doesn't define <DisplayName>,
                       //but need to define all other tags in the same order and format.
                       //The control can be any other control.
                       //Right now, only dropdown can have AlterControl (because we haven't written
                       //code to read this tag) for other control.
                        //AlterControl should be the last tag for a Column
                       //X. D. 8/27/2010
                        if (xtr.IsStartElement() && xtr.Name == "AlterControl")
                        {

                          DataColumn alterDc = new DataColumn(xtr.GetAttribute("name"));
                          xtr.Read();
                          SetAColumn(td, alterDc);
                        }
                        xtr.Read();
                     }
                     else
                     {
                        string strList = xtr.ReadElementString("EnumType");
                        if (strList != null && strList.Length > 0)
                        {
                           drpLst = new DropDownList();
                           drpLst.ID = "drp" + _dc.ColumnName;
                           
                           drpLst.Height = Unit.Pixel(23);
                           drpLst.Width = Unit.Pixel(166);

                           Type enumType = GetEnumType(strList);
                         
                           string[] lst = Enum.GetNames(enumType);
                           Array values = Enum.GetValues(enumType);

                           Hashtable ht = new Hashtable();
                           for (int i = 0; i < lst.Length; i++)
                           {
                              int key = Convert.ToInt32(Enum.Parse(enumType, values.GetValue(i).ToString()));
                              string text = Convert.ToString(Enum.Parse(enumType, values.GetValue(i).ToString()));

                              //ht.Add(key, text);
                              ht.Add(text, text);
                           }

                           drpLst.DataSource = ht;
                           drpLst.CssClass = strList; //use CSS class to transfer the enum type name. Temporary solution.

                           drpLst.DataTextField = "value";
                           drpLst.DataValueField = "key";
                           drpLst.DataBind();
                           //
                           if (xtr.IsStartElement() && xtr.Name == "Attribute")
                           {
                             drpLst.Attributes.Add(xtr.GetAttribute("key"), xtr.ReadElementString("Attribute"));
                           }
                          //"NormalField" is an optional tag, only define it when the field is not normal
                          //non-normal field won't be added to Fields, thus, can't be accessed through fields.
                          //this is needed when fields need special treatment with special code, like two dropdowns
                          //provide values to one data column.
                          //it must appear after tag "Attribute", if "Attribute" tag exist
                          
                           if (xtr.IsStartElement() && xtr.Name == "NormalField")
                           {
                             normalField = xtr.ReadElementContentAsBoolean();
                           }
                           newItem = new FieldItem();
                           newItem.Key = drpLst.ID;
                           newItem.Value = _dc.ColumnName;
                           newItem.AutoCollect = normalField;
                           Fields.Add(newItem);
                           //
                           //Fields.Add(drpLst.ID, _dc.ColumnName);
                           drpLst.DataBinding += new EventHandler(drp_DataBinding);
                        
                           td.Controls.Add(drpLst);
                           //Following code allows to have another control in the same table cell
                           //For example, in inventory form, two dropdowns are in one cell, only one
                           //displays according to the selection of source type.
                           //The control inside AlterControl tag doesn't define <DisplayName>,
                           //but need to define all other tags in the same order and format.
                           //The control can be any other control.
                           //Right now, only dropdown can have AlterControl (because we haven't written
                           //code to read this tag) for other control.
                          //AlterControl should be the last tag for a Column
                           //X. D. 8/27/2010
                           if (xtr.IsStartElement() && xtr.Name == "AlterControl")
                           {

                             DataColumn alterDc = new DataColumn(xtr.GetAttribute("name"));
                             xtr.Read();
                             SetAColumn(td, alterDc);
                           }
                           xtr.Read();
                        }
                   
                      
                     }
                      break;
                  case "datetime":
                     strLen = xtr.ReadElementString("TextBoxLength");
                     nLen = 20; //default
                     if (strLen.Length > 0)
                        nLen = Convert.ToInt32(strLen);
                     
                     txt = new TextBox();
                     txt.ID = "txt" + _dc.ColumnName;
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                       normalField = xtr.ReadElementContentAsBoolean();
                     }

                     newItem = new FieldItem();
                     newItem.Key = txt.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);
                    
                     txt.MaxLength = nLen;
                     txt.Width = nLen * 6;
                     td.Controls.Add(txt);
                     txt.DataBinding += new EventHandler(txt_DataBinding);

                   /*  rexpval = new RegularExpressionValidator();
                     rexpval.ValidationExpression = @"^\(?\d{3}[\)\-\s]?\d{3}[-\s]?\d{4}$";
                     rexpval.ControlToValidate = txt.ID;
                     rexpval.Display = ValidatorDisplay.Dynamic;
                     rexpval.Text = "*";
                     rexpval.ErrorMessage = "Entered value for " + _dc.ColumnName + " is not a valid date entry";
                     td.Controls.Add(rexpval);*/
                    
                     ////Image button, link to calendar extender
                     //imgButton = new ImageButton();
                     //imgButton.ID = "imgButton" + _dc.ColumnName;
                     //imgButton.ImageUrl = "~/Images/Calendar.gif";
                     //imgButton.AlternateText = "Click here to display calendar";
                     ////
                     //newItem = new FieldItem();
                     //newItem.Key = imgButton.ID;
                     //newItem.Value = _dc.ColumnName;
                     //Fields.Add(newItem);

                     //imgButton.Width = Unit.Pixel(10);
                     //td.Controls.Add(imgButton);

                     //Add ajax calendar extender control
                     calExd = new CalendarExtender();
                     calExd.DefaultView = CalendarDefaultView.Days;
                     calExd.CssClass = "amber__calendar";
                     calExd.ID = "cal" + _dc.ColumnName;
                     
                     calExd.TargetControlID = txt.ID;
                     //calExd.PopupButtonID = imgButton.ID;
                     calExd.PopupButtonID = txt.ID;
                     calExd.Enabled = true;
                     //
                     newItem = new FieldItem();
                     newItem.Key = calExd.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = false;
                     Fields.Add(newItem);
                     //
                     //Fields.Add(calExd.ID, _dc.ColumnName);
                     td.Controls.Add(calExd);
                     break;
                  case "radiobutton":
                     RadioButtonList rbl = new RadioButtonList();
                     rbl.ID = "rbl" + _dc.ColumnName;
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                       normalField = xtr.ReadElementContentAsBoolean();
                     }

                     newItem = new FieldItem();
                     newItem.Key = rbl.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);

                     System.Web.UI.WebControls.ListItem li = new System.Web.UI.WebControls.ListItem("Yes", "True");
                     rbl.Items.Add(li);
                     rbl.RepeatLayout = RepeatLayout.Flow;
                     rbl.RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal;
                     li = new System.Web.UI.WebControls.ListItem("No", "False");
                     rbl.Items.Add(li);
                     rbl.SelectedIndex = 0;
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
       /// <summary>
       /// Added By xueyan
       /// </summary>
       /// <param name="key"></param>
       /// <returns></returns>
      private string FindFieldValue(string key)
      {
          FieldItem theItem;
          for (int i = 0; i < Fields.Count; i++)
          {
              theItem = (FieldItem)Fields[i];
              if (theItem.Key.Equals(key))
                  return theItem.Value;
          }
          return "";
      }
      void drp_DataBinding(object sender, EventArgs e)
      {
        UInt32 selValue;
        Int64 selValue64;
         DropDownList drpLst = (DropDownList)sender;
         DataRowView drv = null;
          
         //DataColumn _dc = _dccol[Fields[drpLst.ID].ToString()];
         DataColumn _dc = _dccol[FindFieldValue(drpLst.ID)]; //
         if (_dc == null)
           return; //for abnormal field, _dccol may not have it.
         drv = (DataRowView)((FormView)drpLst.NamingContainer).DataItem;
         if (drv != null && drv[_dc.ColumnName] != System.DBNull.Value)
         {
            switch (_dc.DataType.ToString())
            {
               case "System.String":

                  Type eType = GetEnumType(drpLst.CssClass);
                  if (eType != null) //Enum type, convert it to integer
                      //drpLst.SelectedValue = Convert.ToInt32(Enum.Parse(eType, drv[_dc.ColumnName].ToString())).ToString();
                      drpLst.SelectedValue = Enum.Parse(eType, drv[_dc.ColumnName].ToString()).ToString();
                  else
                      drpLst.SelectedValue = drv[_dc.ColumnName].ToString();
                  break;
               case "System.UInt32":
                selValue = Convert.ToUInt32(drv[_dc.ColumnName]);
             
                drpLst.SelectedValue = (selValue >= drpLst.Items.Count?"0":selValue.ToString("#0"));
                
                  break;
               case "System.Int16":
               case "System.Int32":
               case "System.Int64":
               case "int":
                  selValue64 = Convert.ToInt64(drv[_dc.ColumnName]);
                 if (drpLst.Items.FindByValue(selValue64.ToString("#0"))!=null)
                   drpLst.SelectedValue = selValue64 .ToString("#0");
                  //drpLst.SelectedValue = (selValue64 >= drpLst.Items.Count ? "0" : );
                  break;
               case "System.Decimal":
                  drpLst.SelectedValue = Convert.ToDecimal(drv[_dc.ColumnName]).ToString("#0.00");
                  break;
               case "System.DateTime":
                  drpLst.SelectedValue = Convert.ToDateTime(drv[_dc.ColumnName]).ToString("MM/dd/yyyy");
                  break;
               case "System.Byte":
                  drpLst.SelectedValue = Convert.ToByte(drv[_dc.ColumnName]).ToString();
                  break;
               default:
                  drpLst.SelectedValue = drv[_dc.ColumnName].ToString();
                  break;
            }
         }
      }

void txt_DataBinding(object sender, EventArgs e)
{
 TextBox txt = (TextBox)sender;
 DataRowView drv = null;
 //DataColumn _dc = _dccol[Fields[txt.ID].ToString()];
 DataColumn _dc = _dccol[FindFieldValue(txt.ID)]; //
 drv = (DataRowView)((FormView)txt.NamingContainer).DataItem;

 if (drv != null && drv[_dc.ColumnName] != System.DBNull.Value )
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
         //DataColumn _dc = _dccol[Fields[rbl.ID].ToString()];
         DataColumn _dc = _dccol[FindFieldValue(rbl.ID)]; //
         drv = (DataRowView)((FormView)rbl.NamingContainer).DataItem;

         if (drv != null)
         {
            if (drv[_dc.ColumnName].ToString() == "1")
               rbl.SelectedIndex = 0; //yes, first
            else
               rbl.SelectedIndex = 1;
         }
      }

      void lbl_DataBinding(object sender, EventArgs e)
      {
         Label lbl = ((Label)sender);
         DataRowView drv = null;
         //DataColumn _dc = _dccol[Fields[lbl.ID].ToString()];
         DataColumn _dc = _dccol[FindFieldValue(lbl.ID)]; //
         drv = (DataRowView)((FormView)lbl.NamingContainer).DataItem;

         
         //change the data format based on the data if the datacolumn is not a primary key field
         if (drv != null && drv[_dc.ColumnName] != System.DBNull.Value)
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




