<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryLabelPrint.aspx.cs" Inherits="ezMESWeb.InventoryLabelPrint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 360px;
            vertical-align:middle;
            padding:0px;
            border-spacing:0px;
            border-width:1px;
            border-collapse:collapse;
        }
        .auto-style2 {
            width: 100px;
        }
    </style>

<style type = "text/css">
   <!--
      @page { size : 4.0in 3.0in;
              margin-top: 0.0cm;
              margin-bottom: 0.0cm;
              margin-left: 0.0cm;
              margin-right: 0.0cm;
              overflow: hidden;
      }
    .auto-style3 {
        width: 100px;
        height: 17px;
    }
    .auto-style4 {
        height: 17px;
    }
   -->
</style>

</head>
<body>
    <form id="form1" runat="server">
        <font face="calibri" size="-1">
        <table class="auto-style1">
            <tr>
                <td colspan="2" align="center">
                    <asp:Label ID="lblAddress1" runat="server" Text="595 Federal Road"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Label ID="lblAddress2" runat="server" Text="Brookfield, CT 06804"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">Date:</td>
                <td>
                    <asp:Label ID="lblDate" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">Inventory ID:</td>
                <td>
                    <asp:Label ID="lblInventoryID" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Image ID="imgInventoryID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style2">Type<NOBR>:</NOBR></td>
                <td>
                    <asp:Label ID="lblType" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2"><NOBR>Part #:</NOBR></td>
                <td>
                    <asp:Label ID="lblPartNumber" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan = "2" align="center">
                    <asp:Image ID="imgPartNumber" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style2">Supplier:</td>
                <td>
                    <asp:Label ID="lblSupplier" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">Batch ID:</td>
                <td>
                    <asp:Label ID="lblBatchID" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Image ID="imgBatchID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style3">Serial #:</td>
                <td>
                    <asp:Label ID="lblSerialNumber" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr id="blankLine1">
                <td class="auto-style2"></td>
                <td>&nbsp;</td>
            </tr>
            <tr id="blankLine2">
                <td class="auto-style2"></td>
                <td>&nbsp;</td>
            </tr>
            <tr id="blankLine3">
                <td class="auto-style2"></td>
                <td align="right">
                <asp:Button ID="btnPrint" runat="server" Text="Print" Width="71px" OnClientClick="printHTMLString();return false;" />
                <asp:Label ID="lblSpace" runat="server" Visible="False" Width="30px"></asp:Label>
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" Width="66px" OnClientClick="cancelPrint();return false;" />
                </td>
            </tr>
        </table>
        </font>
    </form>
</body>
</html>
