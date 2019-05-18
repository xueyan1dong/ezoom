
<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.master" AutoEventWireup="true" CodeBehind="LoadParts.aspx.cs" Inherits="ezMESWeb.Configure.Material.LoadParts" Title= "Load Parts -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:ToolKitScriptManager ID ="ToolKitScriptManager1" runat ="server"></asp:ToolKitScriptManager>

<br />
<p><em>This tool only read csv (comma separated values) file. CSV headers are required. Please save your file as .csv file before upload. </em></p><br />
<asp:FileUpload ID="fuLoad1" runat="server" Width=500px Height=30px />
<br /><br />
<asp:Button ID="btnInsert" runat="server" Text="Preview" Width="147px" OnClick="btn_Click"/>     
<br />
<asp:Label ID="lblError" runat="server" ForeColor="#FF3300" Height="60px" Width="350px"></asp:Label><br />

<p>Required columns: Part_No, Vender, Group, Form, Status, If_Persistent, Alert_Quantity_Level, Lot_Size, Unit_of_Measure, Description, Comment</p></br>
<p>Example: "My Parts", "vender1" ,"group1","gas", "production", "1", "50", "18", "unit", "this is a sample description", "urgent"</p><br />
<p><em>ezOOM is going to update following information in ezOOM, please review and click Submit button at bottom to start updating.</em></p>
<br />
<asp:TextBox ID="txtContent1" runat="server" TextMode="MultiLine" Height=1100px Width=800px OnTextChanged="txtContent_TextChanged"></asp:TextBox>
<br />
<asp:ListBox ID="lbMaterial1" runat="server" Visible="false"></asp:ListBox>
<br />
<asp:Label ID="lblErrorSubmit" runat="server" ForeColor="#FF3300" Height="60px" Width="350px"><br />
<asp:Button ID="btnSubmit" runat="server" Text="Submit" Width="147px" OnClick="btnSubmit_Click"/> 
</asp:Label><asp:Label ID ="lblLoaded" runat="server" Visible ="false"></asp:Label>
<asp:Panel ID="MessagePanel" runat="server" CssClass="detail" style="margin-top: 19px;  height:200px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Green">
<asp:Button id="btnMessagePopup" runat="server" style="display:none" />
<asp:ModalPopupExtender ID="MessagePopupExtender1" runat="server" TargetControlID="btnMessagePopup" BackgroundCssClass="modalBackground" PopupControlID="MessagePanel" PopupDragHandleControlID="MessagePanel" Drag="True" DropShadow="True" ></asp:ModalPopupExtender>    
<table width=90% height=90% cellpadding=5px cellspacing = 10px align="center" >
<tr><td>&nbsp;</td></tr>
<tr><td>
<asp:Label ID="lblMessage" runat="server"  Style="font-family:Times New Roman; font-style:italic; font-size:20px; line-height:22px; color:Green;">
Congratulations! The data have been successfully loaded into database. Please click below button to  </asp:Label>
</td></tr>
<tr><td>
<asp:Button ID="btnPartForm" runat="server" Text="Go To Part Form" Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:200px;" onclick="btnPartForm_Click" />
</td></tr>
</table>           
</asp:Panel>
</asp:Content>