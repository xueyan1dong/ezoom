<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="lot.ascx.cs" Inherits="ezMESWeb.Tracking.lot" %>
 <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <style type="text/css">
        .auto-style1 {
            width: 113px;
        }
    </style>
    <asp:Panel BorderColor="#009900" BorderStyle="Solid" BorderWidth="1px" Width="100%" runat="server">
    <table style="width: 98%; height: 137px;" align="center" >
        <tr>
            <td colspan=3 align=center>
              <asp:Label ID="lblCaption" runat="server" Height="33px" Width="362px" Style="font-family:Times New Roman;font-size:22px;">Batch Information</asp:Label>  
            </td>
        </tr>
        
        <tr>
            <td align ="left" class="auto-style1"><font style="font-family:Times New Roman;font-size:20px;">PO Number: </font></td>
            <td valign="middle"><asp:Image ID="po_barcode" runat="server" /></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Status:</font> &nbsp; <asp:Label ID="lblLotStatus" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
               <font Style="font-family:Times New Roman;font-size:20px;">Priority:</font> &nbsp; <asp:Label ID="lblPriority" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style1"><font style="font-family:Times New Roman;font-size:20px;">Name: </font></td>
            <td>
                <asp:Image ID="name_barcode" runat="server" />
            </td>
            <td>
                <font Style="font-family:Times New Roman;font-size:20px;">Workflow:</font>&nbsp; <asp:Label ID="lblProcess" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
               <font Style="font-family:Times New Roman;font-size:20px;">Quantity:</font> &nbsp; <asp:Label ID="lblQuantity" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
               <asp:Label ID="lblUom" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="auto-style1"><font style="font-family:Times New Roman;font-size:20px;">Product:</font></td>
            <td align=left>
                <asp:Image ID="product_barcode" runat="server" />
            </td>
            <td align=left>
                <font style="font-family:Times New Roman;font-size:20px;">Last Step Status:</font> &nbsp;
                <asp:Label ID="lblStepStatus" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
            <td><font style="font-family:Times New Roman;font-size:20px;">Location:</font> &nbsp;
                <asp:Label ID="lblLocation" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label>
            </td>
        </tr>

        
    </table>
</asp:Panel>