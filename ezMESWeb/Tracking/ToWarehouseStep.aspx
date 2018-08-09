<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="ToWarehouseStep.aspx.cs" Inherits="ezMESWeb.Tracking.ToWarehouseStep" Title="Ship to Warehouse Step -- ezOOM" %>
<%@ Register TagPrefix="asp" TagName="lot" Src="~/Tracking/lot.ascx" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

  <style type="text/css">
    .auto-style1 {
      width: 379px;
    }
  </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" /> 
<div>
<asp:panel id="pnlScroll" runat="server" width="100%" 
height="100%" scrollbars="Horizontal"> 
<table width="98%" align="center">
<tr>
    <td>   
        <asp:lot runat="server" />
    </td>
</tr>
<tr><td><asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" /></td></tr>
<tr>
<td>
<table style="width: 95%; height: 137px;" align="center" cellspacing="10px">
        <tr>
            <td colspan="2" align="left">
            <font Style="font-family:'Times New Roman';font-size:20px;">
              Please fill the warehouse location and optional comment, then click button</font>&nbsp;
              <asp:Button ID="btnDo" runat="server" Text="Ship to Warehouse" 
                    Style="font-family:Times New Roman;font-size:22px; width:180px;" 
                    onclick="btnDo_Click" BackColor="Green" ForeColor="White"/>  
            </td>

        </tr>
        <tr><td class="auto-style1">&nbsp;</td></tr>
        <tr>
            <td align="left" class="auto-style1">
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font>&nbsp;<asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <%--<td align="left">
                <font Style="font-family:Times New Roman;font-size:20px;">Location:</font> &nbsp; 
                <asp:TextBox ID="txtLocation" runat="server" Width="297px" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
                </td>--%>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Location:</font> &nbsp;
                <asp:DropDownList ID="drpLocation" runat="server" Width="180px" Style="font-family:Times New Roman;font-size:20px;" >
                <asp:ListItem Text="......SELECT......"  Value=""></asp:ListItem>
                </asp:DropDownList>
            </td>
         </tr>
         <tr>
            <td align=left colspan=2><font Style="font-family:Times New Roman;font-size:20px;">Comment:</font> <br />
                <asp:TextBox ID="txtComment" runat="server" Width="100%" Height="50px" Wrap="True" TextMode="MultiLine" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
            </td>

        </tr>
        <tr>
            <td align=left><asp:Label ID="lblApprover" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver:</asp:Label>
                <asp:DropDownList ID="drpApprover" runat="server" Width="180px" Style="font-family:Times New Roman;font-size:20px;" Visible=false>
                </asp:DropDownList>
            </td>
            <td><asp:Label ID="lblPassword" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver Password:</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Style="font-family:Times New Roman;font-size:20px;" Visible=false></asp:TextBox></td>
        
        </tr>
    </table>
  </td>
</tr>
<tr><td>&nbsp;</td></tr>
 </table>   
</asp:panel>
</div>
        <asp:Panel ID="MessagePanel" runat="server" CssClass="detail" 
       style="margin-top: 19px;  height:200px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Green">
     <asp:Button id="btnMessagePopup" runat="server" style="display:none" />
     <asp:ModalPopupExtender ID="MessagePopupExtender" runat="server" TargetControlID="btnMessagePopup"
         BackgroundCssClass="modalBackground" PopupControlID="MessagePanel" 
        PopupDragHandleControlID="MessagePanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>    
        <table width="90%" height="90%" cellpadding="5px" cellspacing = "10px" align="center" >
        <tr><td>&nbsp;</td></tr>
        <tr><td>
        <asp:Label ID="lblMessage" runat="server"  Style="font-family:Times New Roman; font-style:italic; font-size:20px; line-height:22px; color:Green;">
        The step has successfully ended. Please click a button to go back to Move Product form or go to next step.</asp:Label>
        </td></tr>
        <tr><td>&nbsp;
        <asp:Label ID="lblStartTime" runat="server" Visible = false></asp:Label>
        <asp:Label ID="lblStepStatus" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblSubProcessId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblPositionId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblSubPositionId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblStepId" runat="server" Visible=false></asp:Label>
        
        </td></tr>
        <tr><td>
        <asp:Button ID="btnListForm" runat="server" Text="Back To Product List" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnListForm_Click" />
        <asp:Button ID="btnMoveForm" runat="server" Text="Go To Next Step" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnMoveForm_Click" />  
         </td></tr>
         </table>           
       </asp:Panel>
</asp:Content>


