<%@ Page Language="C#" MasterPageFile="ConfigureModule.Master" AutoEventWireup="true" CodeBehind="Configuration.aspx.cs" Inherits="ezMESWeb.Configure.Configuration" Title="Configuration Module -- ezOOM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div >
<!--<fieldset id="info" style="width:780px; height:500px">-->
<div class="cssnav">
<a href="/Configure/Process/RecipeConfig.aspx"><span>Recipe Configuration</span></a>
</div>
<div class="cssnav">
<a href="/Configure/Inventory/InventoryConfig.aspx"><span>Inventory Configuration</span></a>
</div>
<div class="cssnav">
<a href="/Configure/Process/ProcessConfig.aspx"><span>Process Configuration</span></a>
</div>

<!--</fieldset>-->

</div>
</asp:Content>
