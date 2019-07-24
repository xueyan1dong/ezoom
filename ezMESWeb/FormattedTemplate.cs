/*--------------------------------------------------------------
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : FormattedTemplate.cs
*    Created By             : Fei Xue
*    Date Created           : 1/31/2010
*    Platform Dependencies  : .NET
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
      public string csPageStyle = null;
      //String FieldName;

      String[] usageArray = { "sub process only", "main process only", "both" };
      String[] StepOrWorkflow = { "step", "sub workflow" };

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
            //case "Usage":
            //   eType = typeof(usage);
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
         csPageStyle = "Default";
      }

       public FormattedTemplate(ListItemType type, DataColumnCollection dccol, bool showEdit, string fileName, string pageStyle)
      {
         _type = type;
         _dccol = dccol;
         ShowEdit = showEdit;
         csFileName = fileName;
         csPageStyle = pageStyle;
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
            int nCols = 2;

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

                  if (csPageStyle == "TabPage")
                  {
                     //for each DataColum create a TableRow with 4 cells
                     if (nCols == 2)
                     {
                        tr = new TableRow();
                        tbl.Rows.Add(tr);
                        nCols = 0;
                     }
                  }
                  else//default style
                  {
                     //for each DataColum create a TableRow with 2 cells
                     tr = new TableRow();
                     tbl.Rows.Add(tr);
                  }

                  td = new TableCell();
                  tr.Cells.Add(td);
                  td.Text = ColumnDisplayName; // (dc.ColumnName);
                  td.CssClass = "detailgrid";
                  td = new TableCell();
                  tr.Cells.Add(td);
                  SetAColumn(td, dc);
                  td.CssClass = "detailgrid";
                  nCols += 1;
                  
               }
            }

            //continue reading
            if (xtr.Name == "Table" && !xtr.IsStartElement()) //end of file
            {
               ;
            }
            else
            {
               bool bEOF2 = false;
               int nCol2s = 2;

               while (xtr.Name != "Column" || !xtr.IsStartElement())
               {

                  xtr.Read(); // advance to <Column> tag
                  if (xtr.Name == "Table" && !xtr.IsStartElement()) //end of file
                  {
                     bEOF2 = true;
                     break;
                  }


                  if (!bEOF2 && xtr != null && !xtr.EOF && xtr.GetAttribute("name") == "URL")
                  {
                     xtr.Read();
                     String strId = xtr.ReadElementString("ID");
                     String strName = xtr.ReadElementString("DisplayName");
                     String strURL = xtr.ReadElementString("Value");

                     //Create another row for URL if any.
                     if (csPageStyle == "TabPage")
                     {
                        //for each DataColum create a TableRow with 4 cells
                        if (nCol2s == 2)
                        {
                           tr = new TableRow();
                           tbl.Rows.Add(tr);
                           nCol2s = 0;
                        }
                     }
                     else//default style
                     {
                        //for each DataColum create a TableRow with 2 cells
                        tr = new TableRow();
                        tbl.Rows.Add(tr);
                     }

                     td = new TableCell();
                     td.ColumnSpan = 2;
                     tr.Cells.Add(td);
                     HyperLink hLink = new HyperLink();
                     hLink.ID = "url" + strId;
                     hLink.Text = strName;
                     hLink.NavigateUrl = strURL;
                     td.Controls.Add(hLink);
                     td.CssClass = "detailgrid";
                  }
               }
            }
         }
      }
      
      private void SetAColumn(TableCell td, DataColumn _dc)
      {
         TextBox txt = null;
         CheckBox cbox = null;
      //   ImageButton imgButton = null;
         CalendarExtender calExd = null;
         DropDownList drpLst = null;
         Label lbl = null;
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
                   case "checkbox":
                     cbox = new CheckBox();
                     
                     cbox.ID = "cbx" + _dc.ColumnName;
                     //
                     if (xtr.IsStartElement() && xtr.Name == "NormalField")
                     {
                        normalField = xtr.ReadElementContentAsBoolean();
                     }

                     if (xtr.IsStartElement("Text"))
                     {
                        string strValue = xtr.ReadInnerXml();
                        if (strValue != null && strValue.Length > 0)
                           cbox.Text = strValue;
                     }

                     newItem = new FieldItem();
                     newItem.Key = cbox.ID;
                     newItem.Value = _dc.ColumnName;
                     newItem.AutoCollect = normalField;
                     Fields.Add(newItem);

                     if (_dc.ReadOnly && _dc.Unique)
                     {
                        cbox.CssClass = "PrimaryKeyCell";
                     }
                     
                     td.Controls.Add(cbox);
                     cbox.DataBinding += new EventHandler(cbx_DataBinding);

                     break;

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
                 case "integer":
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

                     //Add value field to textbox, so it can display default value
                     if (xtr.IsStartElement("Value"))
                     {
                       string strValue = xtr.ReadInnerXml();
                       if (strValue != null && strValue.Length > 0)
                         txt.Text = strValue;
                     }
                     else if(ci.uiType=="integer")
                      txt.DataBinding += new EventHandler(int_DataBinding);
                     else
                       txt.DataBinding += new EventHandler(txt_DataBinding);

                     if ( ci.isDisplayEnabled )
                        td.Controls.Add(txt);

                     if (xtr.IsStartElement() && xtr.Name == "AlterControl")
                     {

                       DataColumn alterDcT = new DataColumn(xtr.GetAttribute("name"));
                       xtr.Read();
                       SetAColumn(td, alterDcT);
                     }                    
                     
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
                     //if (xtr.Name == "DropdownQuery")
                     string qryName = xtr.Name;//sd
                     if ( (qryName == "DropdownQuery")||(qryName=="EnumQuery"))
                     {
                       int dcol=0, vcol=0;
                       if (xtr.Name == "DropdownQuery")
                       {
                         //Display column. Display the column value in list.
                          dcol = Convert.ToInt32(xtr.GetAttribute("dcol"));
                         //Value column. Save the column value as list item value
                          vcol = Convert.ToInt32(xtr.GetAttribute("vcol"));
                       }
                        //string strQuery = xtr.ReadElementString("DropdownQuery");
                       string strQuery = xtr.ReadElementString(qryName); //sd

                        //run Query 

                       EzSqlConnection ezConn;
                       EzSqlCommand ezCmd=new EzSqlCommand();

                       
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




                        drpLst = new DropDownList();
                        drpLst.ID = "drp" + _dc.ColumnName;
                        
                        drpLst.Height = Unit.Pixel(23);
                        drpLst.Width = Unit.Pixel(166);

                        if (qryName == "DropdownQuery")
                        {
                         ezDataAdapter ezAdapter=new ezDataAdapter();
                         DataSet ds;
                         ds = new DataSet();
                         ezAdapter.SelectCommand = ezCmd;
                         ezAdapter.Fill(ds);
                          drpLst.DataSource = ds.Tables[0];
                          drpLst.DataTextField = ds.Tables[0].Columns[dcol].ToString();
                          drpLst.DataValueField = ds.Tables[0].Columns[vcol].ToString();
                          drpLst.DataBind();
                          ezAdapter.Dispose();
                        }
                        else if (qryName == "EnumQuery")
                        {

                          System.Data.Common.DbDataReader ezReader = ezCmd.ExecuteReader();
                          if (ezReader.Read())
                          {
                            string raw = ezReader["Type"].ToString();
                            string[] rawValues = raw.Substring(5, raw.Length - 6).Split(',');
                            Hashtable enumHt = new Hashtable();
                            for (int i = 0; i < rawValues.Length; i++)
                            {
                              enumHt.Add(i, rawValues[i].Substring(1, rawValues[i].Length-2));
                            }

                            drpLst.DataSource = enumHt;
                            //drpLst.CssClass = strList; //use CSS class to transfer the enum type name. Temporary solution.

                            drpLst.DataTextField = "value";
                            drpLst.DataValueField = "value";
                            drpLst.DataBind();
                            ezReader.Dispose();
                          }
                        }
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

                        //ezAdapter.Dispose();
                        ezCmd.Dispose();
                        ezConn.Dispose();

                       //Following code allows to have another control in the same table cell
                       //For example, in inventory form, two dropdowns are in one cell, only one
                       //displays according to the selection of source type.
                       //The control inside AlterControl tag doesn't define <DisplayName>,
                       //but need to define all other tags in the same order and format.
                       //The control can be any other control.
                       //Right now, only dropdown and textbox can have AlterControl (because we haven't written
                       //code to read this tag) for other control.
                        //AlterControl should be the last tag for a Column
                       //X. D. 11/12/2010
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

                     System.Web.UI.WebControls.ListItem li = null;
                     //new System.Web.UI.WebControls.ListItem("Yes", "True");
                    // rbl.Items.Add(li);
                     rbl.RepeatLayout = RepeatLayout.Flow;
                     rbl.RepeatDirection = System.Web.UI.WebControls.RepeatDirection.Horizontal;
                     
                     if (xtr.IsStartElement("ArrayName"))
                     {
                        string estrList = xtr.ReadElementString("ArrayName");
                     
                        //Load the elements from array
                        switch (estrList)
                        {
                           case "Usage":
                              {
                                 for (int i = 0; i < usageArray.GetLength(0); i++)
                                 {
                                    int nlItem = i + 1;
                                    li = new System.Web.UI.WebControls.ListItem(usageArray[i], nlItem.ToString());
                                    rbl.Items.Add(li);
                                 }
                                 break;
                              }
                           case "StepOrWorkflow":
                              {
                                for (int i = 0; i < StepOrWorkflow.GetLength(0); i++)
                                {
                                  int nlItem = i + 1;
                                  li = new System.Web.UI.WebControls.ListItem(StepOrWorkflow[i], nlItem.ToString());
                                  rbl.Items.Add(li);
                                }
                                break;
                              }
                           default:
                              break;
                        }
                        rbl.CssClass = estrList; //tempory solution. Will need change in future
                     }
                     else
                     {
                        li = new System.Web.UI.WebControls.ListItem("Yes", "True");
                        rbl.Items.Add(li);
                        li = new System.Web.UI.WebControls.ListItem("No", "False");
                        rbl.Items.Add(li);
                     
                     }

                     rbl.SelectedIndex = 0;
                     rbl.DataBound += new EventHandler(rbl_DataBound);
                     td.Controls.Add(rbl);
                     break;
                   default:
                      break;
                }
            }

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
                  drpLst.SelectedValue = Convert.ToUInt32(drv[_dc.ColumnName]).ToString("#0");
                  break;
               case "System.Int16":
               case "System.Int32":
               case "System.Int64":
               case "int":
                  string value = Convert.ToInt64(drv[_dc.ColumnName]).ToString("#0");
                  if (drpLst.Items.FindByValue(value) != null)
                    drpLst.SelectedValue = value;
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
void int_DataBinding(object sender, EventArgs e)
{
  TextBox txt = (TextBox)sender;
  DataRowView drv = null;
  //DataColumn _dc = _dccol[Fields[txt.ID].ToString()];
  DataColumn _dc = _dccol[FindFieldValue(txt.ID)]; //
  drv = (DataRowView)((FormView)txt.NamingContainer).DataItem;

  if (drv != null && drv[_dc.ColumnName] != System.DBNull.Value)
  {


     txt.Text = Convert.ToUInt32(drv[_dc.ColumnName]).ToString("#0");

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
            String strArray = rbl.CssClass;

            if (strArray != null) //need specify which index it matches
            {
               switch(strArray)
               {
                  case "Usage":
                     for (int i=0; i< usageArray.GetLength(0); i++)
                     {
                        if (usageArray[i] == drv[_dc.ColumnName].ToString())
                        {
                           rbl.SelectedIndex = i;
                           break;
                        }
                      }
                      break;
                   default:
                      break;
                 }
            }
            else
            {
               if (drv[_dc.ColumnName].ToString() == "1")
                  rbl.SelectedIndex = 0; //yes, first
               else
                  rbl.SelectedIndex = 1;
            }
         }
      }
      void cbx_DataBinding(object sender, EventArgs e)
      {
        CheckBox cbox = ((CheckBox)sender);
        DataRowView drv = null;
        DataColumn _dc = _dccol[FindFieldValue(cbox.ID)]; //
        drv = (DataRowView)((FormView)cbox.NamingContainer).DataItem;

        if (drv != null)
        {
          if (drv[_dc.ColumnName].ToString() == "1")
            cbox.Checked = true; //yes, first
          else
            cbox.Checked = false;
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




