﻿<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.Master" AutoEventWireup="true" CodeBehind="LoadOrder.aspx.cs" Inherits="ezMESWeb.Configure.Order.LoadOrder" Title="Load Order -- ezOOM"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

<br />
<p><em>This tool only reads csv (comma separated values) files. Please save your files as .csv file before uploading.</em></p>
    <p>&nbsp;</p>
    <p>
        <table class="auto-style1">
            <tr>
                <td width="30"></td>
                <td class="auto-style2"><b>Order file:</b></td>
                <td class="auto-style4">
                    <asp:FileUpload ID="inputFile" runat="server" Width="326px" Height="25px" />
                </td>
            </tr>
            <tr>
                <td colspan="3" class="auto-style7">Required columns: Client, PO Number, Order Type, Order State, State Date, Priority, Net Total, Tax Percentage, Tax Amount, Other Fees, Total Price, Expected Delivery Date, Internal Contact UserName, External Contact,Comment</td>
            </tr>
            <tr>
                <td colspan="3">
    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Visible="False" Width="600px"></asp:TextBox>
                    <br />
                    <asp:ListBox ID="lstContent" runat="server" Visible="False"></asp:ListBox>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="auto-style9">
                    <asp:TextBox ID="txtError" runat="server" BorderStyle="None" ForeColor="#FF3300" TextMode="MultiLine" Visible="False" Width="600px"></asp:TextBox>
                </td>
            </tr>
        </table>
    </p>
    <p>&nbsp;</p>
<asp:Button ID="btnInsert" runat="server" Text="Preview" Width="147px" OnClick="btn_Click"/>     
<br />
<br />
    <asp:Label ID="lblUploadNote" runat="server" Text="Please review the information and click Submit button at bottom to start updating." Visible="False"></asp:Label>
    <br />
<br />
<asp:Button ID="btnSubmit" runat="server" Text="Submit" Width="147px" OnClick="btnSubmit_Click" Visible="False"/>  
   <asp:Panel ID="MessagePanel" runat="server" CssClass="detail" 
   style="margin-top: 19px;  height:200px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Green">
 <asp:Button id="btnMessagePopup" runat="server" style="display:none" />
 <asp:ModalPopupExtender ID="MessagePopupExtender" runat="server" TargetControlID="btnMessagePopup"
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
    <br />
    <br />
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            width: 59%;
            height: 87px;
        }
        .auto-style2 {
            height: 42px;
            width: 75px;
        }
        .auto-style4 {
            height: 42px;
            width: 347px;
        }
        .auto-style7 {
            height: 44px;
        }
        .auto-style9 {
            height: 36px;
        }
    </style>
</asp:Content>

