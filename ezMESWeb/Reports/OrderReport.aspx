<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="OrderReport.aspx.cs" Inherits="ezMESWeb.Reports.OrderReport" 
 Title="Order Progress Report -- ezOMM" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 


    <style type="text/css">
        .style20
        {
            height: 42px;
        }
    </style>

</asp:content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1"> 

   
      

       <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="None" 
            Width="100%" Height="100%">
         <table border=0 cellpadding=5px cellspacing = 5px width=100%>
         <tr><td align=center>
        <table border = 0 cellpadding=5px cellspacing=5px width=95% >
        <tr>
            <td 
                style="font-family:Times New Roman;font-style:italic;font-size:25px;" 
                class="style20">Order Status Report</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
        <td style="font-family:Times New Roman; font-size:18px;" align="left" valign="bottom">Please Select An Order:</td>
        </tr>
        <tr>
        <td align=left><asp:DropDownList ID="dpOrder" runat="server" Width="300px" Height="25px">
        </asp:DropDownList> 
       <asp:Button ID="btnView" runat="server" Text="View Report" 
               onclick="btnView_Click" Height="35px" Width="100px" /></td>
        </tr>
        </table>      
</td></tr>
<tr><td>

           <rsweb:ReportViewer ID="rvProInvent" runat="server" Height="800px" 
               Width="98%" Font-Names="Verdana" Font-Size="8pt" Visible="False">
               <LocalReport ReportPath="Reports\report_templates\rpOrder.rdlc">

               </LocalReport>
           </rsweb:ReportViewer>
</td></tr>
</table>



       </asp:Panel>
      
    

</asp:Content>