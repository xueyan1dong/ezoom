<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="PassDisplayStep.aspx.cs" Inherits="ezMESWeb.Tracking.PassDisplayStep" Title="Review Step -- ezOOM" %>
<%@ Register TagPrefix="asp" TagName="lot" Src="~/Tracking/lot.ascx" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div>
<asp:panel id="pnlScroll" runat="server" width="100%" 
height="100%" scrollbars="Horizontal"> 
<table width=98% align="center">
<tr>
    <td>   
        <asp:lot ID="eLot" runat="server" />
    </td>
</tr>
<tr><td><asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" /></td></tr>
<tr>
<td>
<table style="width: 95%; height: 137px;" align="center" cellspacing=10px>
        <tr>
            <td colspan=2 align=left>
            <font Style="font-family:Times New Roman;font-size:20px;">
            Please carefully review the instructions and when done, click button to </font>&nbsp;
              <asp:Button ID="btnDo" runat="server" Text="Move to Next Step" 
                    Style="font-family:Times New Roman;font-size:22px; width:180px;" 
                    onclick="btnDo_Click"/>  
            </td>

        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font>&nbsp;<asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Quantity:</font> &nbsp; 
                <asp:TextBox ID="txtQuantity" runat="server" Width="80px" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
                <asp:Label ID="lblUom" runat="server"  Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
         </tr>
         <tr>
            <td align=left colspan=2><font Style="font-family:Times New Roman;font-size:20px;">Comment:</font> <br />
                <asp:TextBox ID="txtComment" runat="server" Width="100%" Height="50px" Wrap="True" TextMode="MultiLine" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
            </td>

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
</div>
</asp:panel>
</asp:Content>


