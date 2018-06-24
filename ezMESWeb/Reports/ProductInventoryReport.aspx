<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="ProductInventoryReport.aspx.cs" Inherits="ezMESWeb.Reports.ProductInventoryReport" 
 %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/reportstyle.css" type="text/css" media="screen" /> 

    <style type="text/css">
        .style20
        {
            height: 42px;
        }
    </style>

</asp:content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1"> 

   
      

   <asp:Panel ID="pnMain" runat="server" BackColor="White"  
           Width="850px" Height="1800px" ScrollBars="Vertical">
 <center class="title">Product, Workflow, and Inventory Combined Report</center>    
 <div style="padding-bottom:5px; padding-top:5px;">
  <ul class="topBody">
 <li>
 <span>Product:</span>
<asp:DropDownList ID="dpProduct" runat="server" Width="200px" Height="25px" 
                onselectedindexchanged="dpProduct_SelectedIndexChanged" 
                AutoPostBack="True"></asp:DropDownList>
 </li>

 <li>
 <span> Workflow:</span>
<asp:DropDownList ID="dpProcess" runat="server" Width="200px" Height="25px">
        </asp:DropDownList>
  </li>   
  <li> <asp:Button ID="btnView" runat="server" Text="View Report" 
               onclick="btnView_Click"  Height="25px" Width="120px" /></li>          
</ul>
 </div>
       
           <asp:ScriptManager ID="ScriptManager1" runat="server">
       </asp:ScriptManager>
       
           <rsweb:ReportViewer ID="rvProInvent" runat="server" Height=1600px
               Width=800px Font-Names="Verdana" Font-Size="8pt" Visible="False">
               <LocalReport ReportPath="Reports\report_templates\rpProductInventory.rdlc">

               </LocalReport>
           </rsweb:ReportViewer>




       </asp:Panel>
      
    

</asp:Content>