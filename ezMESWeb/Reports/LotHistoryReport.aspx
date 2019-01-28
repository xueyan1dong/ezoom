<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="LotHistoryReport.aspx.cs" Inherits="ezMESWeb.Reports.LotHistoryReport" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/reportstyle.css" type="text/css" media="screen" />
</asp:content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1"> 
    <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="Double" 
           Width="800px" Height="1100px" >
  <center class="title">Batch Genealogy Report</center>    
 <div style="padding-bottom:5px; padding-top:5px;">   
  <ul class="topBody">
 <li>
 <span>Please Type In Batch Name:</span>
 <asp:TextBox ID="tbLotAlias" runat="server" Width="150px" >
        </asp:TextBox>
 </li>
   <li>        <asp:Button ID="btnView" runat="server" Text="View Report" 
               onclick="btnView_Click"  Height="25px" Width="120px"  /></li>          
</ul>
 </ul>
 </div>       

            <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>

            <rsweb:ReportViewer ID="rvLot" runat="server" Height="941px" 
               Width="99%" Font-Names="Verdana" Font-Size="8pt" Visible="False">
               <LocalReport ReportPath="Reports\report_templates\rpLotStatusHistory.rdlc">

               </LocalReport>
           </rsweb:ReportViewer>
   </asp:Panel>
</asp:Content>