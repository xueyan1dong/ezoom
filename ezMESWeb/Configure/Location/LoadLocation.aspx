<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.master" AutoEventWireup="true" CodeBehind="LoadLocation.aspx.cs" Inherits="ezMESWeb.Configure.Location.LoadLocation" Title= "Load Location -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:ToolKitScriptManager ID ="ToolKitScriptManager1" runat ="server"></asp:ToolKitScriptManager>

<br />
<p><em>This tool only read csv (comma separated values) file. CSV headers are required. Please save your file as .csv file before upload. </em></p><br />
<p>Required columns: name, parent_loc_id, adjacent_loc_id1, adjacent_loc_id2, adjacent_loc_id3, adjacent_loc_id4, contact_employee, description, comment.</p>
<br />
<asp:FileUpload ID="fuLoad" runat="server" Width=500px Height=30px />
<br /><br />
<asp:Button ID="btnInsert" runat="server" Text="Preview" Width="147px" OnClick="btn_Click"/>     
<br />
<asp:Label ID="lblError" runat="server" ForeColor="#FF3300" Height="60px" Width="350px"></asp:Label><br />
<p><em>ezOOM is going to update following information in ezOOM, please review and click Submit button at bottom to start updating.</em></p>
<br />
<asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Height=1100px Width=800px OnTextChanged="txtContent_TextChanged"></asp:TextBox>
<br />
<asp:Label ID="lblErrorSubmit" runat="server" ForeColor="#FF3300" Height="60px" Width="350px"><br />
<asp:Button ID="btnSubmit" runat="server" Text="Submit" Width="147px" OnClick="btnSubmit_Click"/> 
</asp:Label><asp:Label ID ="lblLoaded" runat="server" Visible ="false"></asp:Label>
<asp:Panel ID="MessagePanel" runat="server" CssClass="detail" style="margin-top: 19px;  height:200px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Green">
<asp:Button id="btnMessagePopup" runat="server" style="display:none" />
<asp:ModalPopupExtender ID="MessagePopupExtender" runat="server" TargetControlID="btnMessagePopup" BackgroundCssClass="modalBackground" PopupControlID="MessagePanel" PopupDragHandleControlID="MessagePanel" Drag="True" DropShadow="True" ></asp:ModalPopupExtender>    
<table width=90% height=90% cellpadding=5px cellspacing = 10px align="center" >
<tr><td>&nbsp;</td></tr>
<tr><td>
<asp:Label ID="lblMessage" runat="server"  Style="font-family:Times New Roman; font-style:italic; font-size:20px; line-height:22px; color:Green;">
Congratulations! The data have been successfully loaded into database. Please click below button to  </asp:Label>
</td></tr>
<tr><td>
<asp:Button ID="btnLocForm" runat="server" Text="Go To Location" Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:200px;" onclick="btnLocForm_Click" />
</td></tr>
</table>           
</asp:Panel>
</asp:Content>
