<%@ Page Language="C#" MasterPageFile="ReportModule.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="ezMESWeb.Reports.Report" Title="ezOMM -- Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
<div class="cssnav">
<a href="/Reports/ProductInventoryReport.aspx"><span>Product, Inventory, Process Report</span></a>
</div>
<div class="cssnav">
<a href="/Reports/BoMReport.aspx"><span>Bill of Material Report</span></a>
</div>
<div class="cssnav">
<a href="/Reports/WorkflowReport.aspx"><span>Workflow Browser</span></a>
</div>
<div class="cssnav">
<a href="/Reports/LotHistoryReport.aspx"><span>Batch Status and History Report</span></a>
</div>
<div class="cssnav">
<a href="/Reports/DispatchHistoryReport.aspx"><span>Batch Dispatch History Report</span></a>
</div>
<div class="cssnav">
<a href="/Reports/ProductInProcessReport.aspx"><span>Products Quickview</span></a>
</div>
</div>
</asp:Content>
