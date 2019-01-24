<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LabelPrint.aspx.cs" Inherits="ezMESWeb.LabelPrint" %>

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
                <td class="auto-style2">PO#:</td>
                <td>
                    <asp:Label ID="lblPONumber" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Image ID="imgPONumber" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style2"><NOBR>PO Line #:</NOBR></td>
                <td>
                    <asp:Label ID="lblPOLine" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Image ID="imgPOLine" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style2"><NOBR># of Pieces:</NOBR></td>
                <td>
                    <asp:Label ID="lblPieceCount" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style2"><NOBR>Item #:</NOBR></td>
                <td>
                    <asp:Label ID="lblItemNumber" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan = "2" align="center">
                    <asp:Image ID="imgItemNumber" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="auto-style2" valign="top">Finish:</td>
                <td>
                    <asp:Label ID="lblFinish" runat="server" Text="Label"></asp:Label>
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
