<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="lot.ascx.cs" Inherits="ezMESWeb.Tracking.lot" %>
 <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <asp:Panel BorderColor="#009900" BorderStyle="Solid" BorderWidth="1px" Width="100%" runat="server">
    <table style="width: 98%; height: 137px;" align="center" >
        <tr>
            <td colspan=3 align=center>
              <asp:Label ID="lblCaption" runat="server" Height="33px" Width="362px" Style="font-family:Times New Roman;font-size:22px;">Batch Information</asp:Label>  
            </td>

        </tr>
        <tr">

            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Name: </font>&nbsp; <asp:Label ID="lblName" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Status:</font> &nbsp; <asp:Label ID="lblLotStatus" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
               <font Style="font-family:Times New Roman;font-size:20px;">Priority:</font> &nbsp; <asp:Label ID="lblPriority" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <font Style="font-family:Times New Roman;font-size:20px;">Product:</font> &nbsp; <asp:Label ID="lblProduct" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td>
                <font Style="font-family:Times New Roman;font-size:20px;">Workflow:</font>&nbsp; <asp:Label ID="lblProcess" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
               <font Style="font-family:Times New Roman;font-size:20px;">Quantity:</font> &nbsp; <asp:Label ID="lblQuantity" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
               <asp:Label ID="lblUom" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
        </tr>
        <tr>

            <td align=left colspan=2>
               <font Style="font-family:Times New Roman;font-size:20px;">Last Step Status:</font> &nbsp;
               <asp:Label ID="lblStepStatus" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
            <td align=left colspan=2>
               <font Style="font-family:Times New Roman;font-size:20px;">Location:</font> &nbsp;
               <asp:Label ID="lblLocation" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>

        </tr>
    </table>
</asp:Panel>