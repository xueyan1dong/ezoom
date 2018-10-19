
<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="BoMReport.aspx.cs" Inherits="ezMESWeb.Reports.BoMReport" 
 Title="Bill of Material Report -- ezOOM" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

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
                class="style20">Bill of Material Report</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
            <td style="font-family:Times New Roman; font-size:18px;" align="left" valign="bottom" colspan ="1">Please Select An Order:
            <asp:DropDownList ID="dpProcess" runat="server" Width="300px" Height="25px"></asp:DropDownList></td>
        </tr>
        <tr>
            <td style="font-family:Times New Roman;font-size:18px;" align ="left" valign ="bottom" colspan="1">Please Input The Number Of Final Product Units:
            <asp:TextBox ID="txtNumProduct" runat="server" Width="180px" Style="font-family:Times New Roman;font-size:18px;" Text ="1"></asp:TextBox>
            <asp:Button ID="btnView" runat="server" Text="View Report" onclick="btnView_Click" Height="35px" Width="100px" /></td>
        </tr>

        </table>      
</td></tr>
<tr><td>

           <asp:ScriptManager ID="ScriptManager1" runat="server">
           </asp:ScriptManager>

           <rsweb:ReportViewer ID="rvProInvent" runat="server" Height="500px" 
               Width="98%" Font-Names="Verdana" Font-Size="8pt" Visible="False">
               <LocalReport ReportPath="Reports\report_templates\rpworkflowBom.rdlc">

               </LocalReport>
           </rsweb:ReportViewer>
</td></tr>
</table>



       </asp:Panel>
      
    

</asp:Content>