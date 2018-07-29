<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="StartConsumeMaterial.aspx.cs" Inherits="ezMESWeb.Tracking.StartConsumeMaterial" Title="Start Step -- ezOOM" %>
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
        <asp:lot runat="server" />
    </td>
</tr>
<tr><td><asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" /></td></tr>
<tr>
<td>
<table style="width: 95%; height: 137px;" align="center" cellspacing=10px>
        <tr>
            <td colspan=3 align=left>
              <asp:Button ID="btnDo" runat="server" Text="Start Step" 
                    Style="font-family:Times New Roman;font-size:22px; width:160px;" 
                    onclick="btnDo_Click"/>
              <asp:Label ID="lblCaption" runat="server" Height="33px" Width="362px" Style="font-family:Times New Roman;font-size:22px;"></asp:Label>  
            </td>

        </tr>
        <tr>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font>&nbsp;<asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Start Quantity:</font> &nbsp; 
                <asp:TextBox ID="txtQuantity" runat="server" Width="80px" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
                <asp:Label ID="lblUom" runat="server"  Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Equipment:</font> &nbsp; 
                <asp:DropDownList ID="drpEquipment" Width="160px" runat="server" Style="font-family:Times New Roman;font-size:20px;">
                </asp:DropDownList>
            </td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Location:</font> &nbsp; 
                <asp:DropDownList ID="drpLocation" Width="160px" runat="server" Style="font-family:Times New Roman;font-size:20px;">
                    <%--<asp:ListItem Text="Select a location..."  Value=""></asp:ListItem>--%>
                </asp:DropDownList>
            </td>
         </tr>
         <tr>
            <td align=left colspan=3><font Style="font-family:Times New Roman;font-size:20px;">Comment:</font> <br />
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


