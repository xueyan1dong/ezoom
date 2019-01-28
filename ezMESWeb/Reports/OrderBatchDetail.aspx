<%@ Page Language="C#" MasterPageFile="~/Reports/ReportModule.Master" AutoEventWireup="true" CodeBehind="OrderBatchDetail.aspx.cs" Inherits="ezMESWeb.Reports.OrderBatchDetail" Title="Order Batch Detail Report" %>
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
   <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="None"  width="100%" Height="1800px">
    <center class="title">Order Batch Detail Report</center>
 <center>
   <table width ="100%">
   <td colspan ="3" align="center"></td>
   <tr >
      <td align="left" style="width:20%;font-size:14px;"> Order: <asp:DropDownList id="dpOrder1" Width="150px" runat="server" onselectedindexchanged="dpOrder_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td>
      <td align ="left" style="width:35%;font-size:14px;">Products: <asp:DropDownList id="dpProduct1"  Width="270px" runat="server"  AutoPostBack="True"></asp:DropDownList></td>
      <td style="font-size:14px;">Status: <asp:DropDownList ID="dpStatus1"  runat="server" ></asp:DropDownList> <asp:Button ID="btnRunReport" runat="server" Text="Run Report"  onclick="btnRunReport_Click"  Height="25px" Width="110px" /></td>
   </tr>
</table>
</center>
<asp:ScriptManager ID="ScriptManager1" runat="server">
       </asp:ScriptManager>

     <rsweb:ReportViewer Width="100%" Height=1720px ID="rvDispatch" runat="server" 
    Font-Names="Verdana" Font-Size="8pt" Visible="False" >
           <LocalReport ReportPath="Reports\report_templates\rpOrderBatchDetail.rdlc" EnableHyperlinks="True">
           </LocalReport>
        </rsweb:ReportViewer>
     </asp:Panel>
   
     
</asp:Content>