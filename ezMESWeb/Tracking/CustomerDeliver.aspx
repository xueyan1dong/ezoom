<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="CustomerDeliver.aspx.cs" Inherits="ezMESWeb.Tracking.CustomerDeliver" Title="Customer Deliver -- ezOOM" %>
<%@ Register TagPrefix="asp" TagName="lot" Src="~/Tracking/lot.ascx" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div>
<asp:panel id="pnlScroll" runat="server" width="100%" 
height="100%" scrollbars="Horizontal"> 
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" 
        EnableScriptGlobalization="True" />
<table width=98% align="center">
<tr>
    <td>   
        <asp:lot runat="server" />
    </td>
</tr>
<tr><td><asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" /></td></tr>
<tr>
<td>
<table width=95% align="center">
        <tr>
            <td colspan=4 align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">
            Please fill customer receiving information needed and when done, click button to </font>&nbsp;
              <asp:Button ID="btnDo" runat="server" Text="Mark" 
                    Style="font-family:Times New Roman;font-size:22px; width:150px;" 
                    onclick="btnDo_Click"/> <font Style="font-family:Times New Roman;font-size:20px;"> &nbsp;
            the batch as delivered. </font>
            </td>

        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
            <td align=left width=20%>
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font></td>
            <td width=30%><asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:18px;"></asp:Label></td>
            <td align=left width=20%>
                <font Style="font-family:Times New Roman;font-size:20px;">Quantity:</font></td>
             <td> 
                <asp:TextBox ID="txtQuantity" runat="server" Width="100px" Style="font-family:Times New Roman;font-size:18px;"></asp:TextBox>
                <asp:Label ID="lblUom" runat="server"  Style="font-family:Times New Roman;font-size:18px;"></asp:Label></td>
         </tr>
         <tr><td>&nbsp;</td></tr>
         <tr>
         
         <td align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">Delivery Date & Time:</font>
         </td><td>
            <asp:TextBox ID="txtDeliveryDate" runat="server" Width="80px" ></asp:TextBox>
                           <asp:CalendarExtender ID="date1_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="txtDeliveryDate" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender> 
             <asp:DropDownList ID="drpHour" runat="server" Width=50px >
             </asp:DropDownList>
             <font Style="font-family:Times New Roman;font-size:18px;">:</font>
            <asp:DropDownList ID="drpMinute" runat="server" Width=50px >
             </asp:DropDownList> 
             <asp:DropDownList ID="drpAP" runat="server" Width=60px >
             <asp:ListItem>AM</asp:ListItem>
             <asp:ListItem>PM</asp:ListItem>
             </asp:DropDownList>                         
         </td>

           
         <td align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">Recipient Name:</font> </td>
         <td>
            <asp:TextBox ID="txtName" runat="server" Width="150px" MaxLength="30"></asp:TextBox>
         
         </td>       

         </tr>
 <tr><td>&nbsp;</td></tr>
         <tr>
          <td align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">Delivery Address:</font></td>
          <td>
            <asp:TextBox ID="txtAddress" runat="server" Width="99%" Style="font-family:Times New Roman;font-size:18px;" MaxLength="255" Rows="4" TextMode="MultiLine"></asp:TextBox>
         </td>
          <td align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">Recipient Contact Info:</font></td>
          <td>
            <asp:TextBox ID="txtContact" runat="server" Width="99%" Style="font-family:Times New Roman;font-size:18px;" MaxLength="255" Rows="4" TextMode="MultiLine"></asp:TextBox>
         </td>
         </tr> 
     <tr><td>&nbsp;</td></tr>        
         <tr>
            <td align=left colspan=4><font Style="font-family:Times New Roman;font-size:20px;">Comment:</font> <br />
                <asp:TextBox ID="txtComment" runat="server" Width="100%" Height="50px" Wrap="True" TextMode="MultiLine" Style="font-family:Times New Roman;font-size:18px;"></asp:TextBox>
            </td>

        </tr>
      <tr><td>&nbsp;</td></tr>        
        <tr>
            <td align=left><asp:Label ID="lblApprover" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver:</asp:Label></td>
            <td>
                <asp:DropDownList ID="drpApprover" runat="server" Width="180px" Style="font-family:Times New Roman;font-size:18px;" Visible=false>
                </asp:DropDownList>
            </td>
            <td><asp:Label ID="lblPassword" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver Password:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Style="font-family:Times New Roman;font-size:18px;" Visible=false></asp:TextBox></td>
        
        </tr>        
    </table>
  </td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
    <td>   
        <asp:ConsumptionStep ID="newStep" runat="server" />
    </td>
</tr>
 </table>   
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
        Congratulations! The batch has successfully finished its workflow. Please click below button to </asp:Label>
        </td></tr>

        <tr><td>
        <asp:Button ID="btnListForm" runat="server" Text="Go To Move Product Form" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:200px;" 
                    onclick="btnListForm_Click" />
 
         </td></tr>
         </table>           
       </asp:Panel>
</asp:panel>
</div>
</asp:Content>


