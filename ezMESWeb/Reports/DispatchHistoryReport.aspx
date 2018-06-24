<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="DispatchHistoryReport.aspx.cs" Inherits="ezMESWeb.Reports.DispatchHistoryReport"  Title="Dispatch History Report -- ezOOM"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/calendar.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/reportstyle.css" type="text/css" media="screen" /> 
</asp:content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1"> 
<%--
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
--%>
   <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="Double" 
           Width="800px" Height="1100px" >
          
 <center class="title">Batch Dispatch History Report</center>    
 <div style="padding-bottom:5px; padding-top:5px;">
<%--
 <ul class="topBody" >

<li><span>Start Date:</span><asp:TextBox ID="txtStartCal" runat="server" Width="150px" Height="15px" BorderStyle="Groove"></asp:TextBox></li>
 <li>
    <asp:CalendarExtender ID="calStartDate" runat="server" TargetControlID="txtStartCal"
    CssClass="amber__calendar"
    Format="MMMM d, yyyy">
     </asp:CalendarExtender>
 </li>
 <li><span>End Time:</span><asp:TextBox ID="txtEndCal" runat="server" Width="150px" Height="15px" BorderStyle="Groove"></asp:TextBox></li>
 <li>
  <asp:CalendarExtender ID="calEndDate" runat="server" TargetControlID="txtEndCal"
    CssClass="amber__calendar"
    Format="MMMM d, yyyy">
     </asp:CalendarExtender>
 </li>
 <li><asp:Button ID="btnView" runat="server" Text="View Report" 
               onclick="btnView_Click"  Height="25px" Width="100px" /></li>
 </ul>
 --%>
 
 <ul class="topBody">
 <li>
 <span>For:</span>
 <asp:DropDownList id="dpDuration"  runat="server" class="drpStyle">
 <asp:ListItem selected="True" value="0">1 day</asp:ListItem>
 <asp:ListItem value="1">1 week</asp:ListItem>
 <asp:ListItem value="2">1 month</asp:ListItem>
 <asp:ListItem value="3">2 months</asp:ListItem>
 <asp:ListItem value="4">6 months</asp:ListItem>
 <asp:ListItem value="5">1 year</asp:ListItem>
 <asp:ListItem value="6">All History</asp:ListItem>
 </asp:DropDownList> 
 </li>
 <li>
 <span>Starting:</span>
 <asp:DropDownList id="dpStart" runat="server" CssClass="drpStyle">
 <asp:ListItem Selected="True" Value="1">Today</asp:ListItem>
 </asp:DropDownList> 
 
  </li>   
  <li><asp:Button ID="btnViewHistory" runat="server" Text="View History Report" 
               onclick="btnViewHistory_Click"  Height="25px" Width="150px" /></li>          
</ul>
 </div>  
 
        <asp:ScriptManager ID="ScriptManager1" runat="server">
       </asp:ScriptManager>
 
        <rsweb:ReportViewer ID="rvDispatch" runat="server" Font-Names="Verdana" Font-Size="8pt" Height="80%" Visible="False" Width="99%">
           <localreport reportpath="Reports\report_templates\rpDispatchHistory.rdlc">
           </localreport>
        </rsweb:ReportViewer>
        
     </asp:Panel>
</asp:Content>