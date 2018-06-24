<%@ Page Language="C#" MasterPageFile="~/Reports/ReportModule.Master" AutoEventWireup="true" CodeBehind="ProductInProcessReport.aspx.cs" Inherits="ezMESWeb.Reports.ProductInProcessReport" Title="Product In Process Report" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/calendar.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/reportstyle.css" type="text/css" media="screen" /> 
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<%--
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
--%>
   <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="None" 
           Width="850px" Height="1100px" >
 <center class="title">Product Batch Status Report</center>    
 <center>
 <table border="1" cellpadding="1" cellspacing="0" class="Rpt_Filter_Table" style="margin-bottom:10px" >
   <tr class="Rpt_Deep_Gray" >
      <td style="font-size:14px; color:White; font-weight:bold; padding:1px 0px 1px 0px;">Products:</td>
      <td style="font-size:14px; color:White; font-weight:bold; padding:1px 0px 1px 0px">Order:</td>
      <td style="font-size:14px; color:White; font-weight:bold; padding:1px 0px 1px 0px">Status:</td>
      <td></td>
   </tr>
   <tr>
     <td><asp:DropDownList id="dpProduct" size="3" Height="60px" Width="270px" runat="server" class="drpStyle" onselectedindexchanged="dpProduct_SelectedIndexChanged" AutoPostBack="True">
 </asp:DropDownList> </td>
    <td><asp:DropDownList id="dpOrder" size="3" Height="60px" runat="server" CssClass="drpStyle">
 </asp:DropDownList></td>
    <td> <asp:DropDownList ID="dpStatus" size="3" Height="60px" runat="server" CssClass="drpStyle">
      </asp:DropDownList></td>
      <td align="center" valign="middle" style="padding-right:5px"  >
       <asp:Button ID="btnRunReport" runat="server" Text="Run Report" CssClass="submit_button" 
               onclick="btnRunReport_Click"  Height="25px" Width="110px" />  
       </td>
      </tr>
   
</table>
</center>


       <asp:ScriptManager ID="ScriptManager1" runat="server">
       </asp:ScriptManager>


     <rsweb:ReportViewer Width="100%"  ID="rvDispatch" runat="server" 
    Font-Names="Verdana" Font-Size="8pt" Visible="False" >
           <LocalReport ReportPath="Reports\report_templates\rpProductInProcess.rdlc" EnableHyperlinks="True">
           </LocalReport>
        </rsweb:ReportViewer>
     </asp:Panel>
   
     
</asp:Content>
