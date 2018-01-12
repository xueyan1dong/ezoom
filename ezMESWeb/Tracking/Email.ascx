<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Email.ascx.cs" Inherits="ezMESWeb.Tracking.Email" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


   <asp:Panel id="pnlScroll" runat="server" width=100% 
height=100%> 

    <asp:Table ID="Table1" runat="server" BorderWidth=0 Width=95% Height=80% 
           HorizontalAlign="Center" >
       <asp:TableRow VerticalAlign="Top" Height="35px"><asp:TableCell ColumnSpan =2 HorizontalAlign = "Left">
    <asp:Label ID="lblError" runat="server"  Width="100%"  Style="font-family:Times New Roman;font-size:20px;  line-height:22px;"></asp:Label>
    </asp:TableCell></asp:TableRow>        
    <asp:TableRow VerticalAlign="Top" Height="35px">
    <asp:TableCell  HorizontalAlign = "Left" ColumnSpan=2>
    <asp:Label ID="lblIntro" runat="server"  Width="100%"  Style="font-family:Arial;font-size:18px; font-style:italic; line-height:22px;">
    </asp:Label>
    </asp:TableCell></asp:TableRow>
    <asp:TableRow Height="35px">
    <asp:TableCell  HorizontalAlign =Right Font-Size="20px" Width=10% Font-Names="Arial" >From:</asp:TableCell>
    <asp:TableCell HorizontalAlign="Left">
    <asp:Label ID="lblFrom" runat="server" Style="font-family:Arial;font-size:16px; font-style:italic; line-height:22px;"></asp:Label>
    </asp:TableCell></asp:TableRow>
    <asp:TableRow Height="35px">
    <asp:TableCell  HorizontalAlign =Right Font-Size="20px" Font-Names="Arial" >To:</asp:TableCell>
    <asp:TableCell HorizontalAlign=Left>
    <asp:TextBox ID="txtTo" runat="server" Width=50% Height="22" Style="font-family:Arial;font-size:16px; font-style:italic;"></asp:TextBox>
    </asp:TableCell></asp:TableRow>
        <asp:TableRow Height="35px">
        <asp:TableCell  HorizontalAlign =Right Font-Size="20px" Font-Names="Arial" >Cc:</asp:TableCell>
        <asp:TableCell HorizontalAlign="Left">
    <asp:TextBox ID="txtCc" runat="server" Width=50% Height=22 Style="font-family:Arial;font-size:16px; font-style:italic;"></asp:TextBox>
    </asp:TableCell></asp:TableRow>
        <asp:TableRow Height="35px">
        <asp:TableCell  HorizontalAlign =Right Font-Size="20px" Font-Names="Arial" >Subject:</asp:TableCell>
        <asp:TableCell HorizontalAlign="Left">
     <asp:TextBox ID="txtSubject" runat="server" Width=80% Height="22" Style="font-family:Arial;font-style:italic; font-size:16px;"></asp:TextBox>
    </asp:TableCell></asp:TableRow>  
            <asp:TableRow Height="35px">
     <asp:TableCell  HorizontalAlign =Right Font-Size="20px"  VerticalAlign=Top Font-Names="Arial" >Text:</asp:TableCell>
    <asp:TableCell HorizontalAlign="Left" VerticalAlign = "Top">
    <asp:TextBox ID="txtText" runat="server" TextMode="MultiLine" Height="150" Width="80%" Style="font-family:Arial;font-style:italic; font-size:16px;"></asp:TextBox>
    </asp:TableCell></asp:TableRow>
     <asp:TableRow Height="35px"><asp:TableCell ColumnSpan=2 HorizontalAlign=Center>
        <asp:Button ID="btnEmail" runat="server" Text="Send Email" Font-Size="20px" Font-Bold="True" Width=160px onclick="btnEmail_Click"/>

     </asp:TableCell></asp:TableRow> 
      
    </asp:Table>
      
   </asp:Panel>
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
        </asp:Label>
        </td></tr>
        <tr><td>
        <asp:Button ID="btnOK" runat="server" Text="Back To Product List" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnOK_Click" />
         </td></tr>
         </table>           
       </asp:Panel>