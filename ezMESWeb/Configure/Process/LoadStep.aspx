<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.Master" AutoEventWireup="true" CodeBehind="LoadStep.aspx.cs" Inherits="ezMESWeb.Configure.Process.LoadStep" Title="Load Step -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

<br />
<p><em>This tool only read csv (comma separated values) file. Please save your file as .csv file before upload.</em></p>
<br />
    <asp:FileUpload ID="fuLoad1" runat="server" Width=500px Height=30px />
<br /><br />
<asp:Button ID="btnInsert" runat="server" Text="Preview" Width="147px" OnClick="btn_Click"/>     
<br />
<asp:Label ID="lblError" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label><br />
    <p>Required columns: Step_Name, Step_Type, Equipment, Employee_Usage, Employee_Group, Recipe, Min_Time, Max_Time, Description, Comment, Parameter 1, Parameter 2, Parameter 3, Parameter 4, Parameter 5, Parameter 6, Parameter 7, Parameter 8, Parameter 9, Parameter 10.</p><br />
    <p>Examples: testName_Step1, testTypeID_DisplayMessage, printer, Employee Group, general, testRecipe_jo_rp2, 10, 30, display complete diagram, good, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10.</p><br />
    <p><em>ezOOM is going to update following information in ezOOM, please review and click Submit button at bottom to start updating.</em></p>
 <br />   <asp:TextBox ID="txtContent1" runat="server" TextMode="MultiLine" Height=1100px Width=800px OnTextChanged="txtContent_TextChanged"></asp:TextBox>
<br />
 <asp:ListBox ID="lbVendor" runat="server" Visible="false"></asp:ListBox>
<br />
 <asp:ListBox ID="lbMaterial1" runat="server" Visible="false"></asp:ListBox>
<br />
<asp:Button ID="btnSubmit" runat="server" Text="Submit" Width="147px" OnClick="btnSubmit_Click"/>  
   <asp:Panel ID="MessagePanel" runat="server" CssClass="detail" 
   style="margin-top: 19px;  height:200px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Green">
 <asp:Button id="btnMessagePopup" runat="server" style="display:none" />
 <asp:ModalPopupExtender ID="MessagePopupExtender1" runat="server" TargetControlID="btnMessagePopup"
     BackgroundCssClass="modalBackground" PopupControlID="MessagePanel" 
    PopupDragHandleControlID="MessagePanel" Drag="True" DropShadow="True" >
    </asp:ModalPopupExtender>    
    <table width=90% height=90% cellpadding=5px cellspacing = 10px align="center" >
    <tr><td>&nbsp;</td></tr>
    <tr><td>
    <asp:Label ID="lblMessage" runat="server"  Style="font-family:Times New Roman; font-style:italic; font-size:20px; line-height:22px; color:Green;">
    Congratulations! The data have been successfully loaded into database. Please click below button to  </asp:Label>
    </td></tr>

    <tr><td>
    <asp:Button ID="btnInvForm" runat="server" Text="Go To Inventory Form" 
                Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:200px;" 
                onclick="btnInvForm_Click" />
     </td></tr>
     </table>           
   </asp:Panel>
</asp:Content>