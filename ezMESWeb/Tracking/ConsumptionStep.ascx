<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsumptionStep.ascx.cs" Inherits="ezMESWeb.Tracking.ConsumptionStep" %>



   <asp:Panel id="pnlScroll" runat="server" width=100% 
height=9in ScrollBars="Auto"> 

    <asp:Table ID="Table1" runat="server" BorderWidth=0 Width=95% Height=80% HorizontalAlign="Center">
    <asp:TableRow VerticalAlign="Top"><asp:TableCell ColumnSpan =2 HorizontalAlign = "Left">
    <asp:Label ID="lblIntro" runat="server"  Width="100%"  Style="font-family:Times New Roman;font-size:20px;  line-height:22px;"></asp:Label>
    </asp:TableCell></asp:TableRow>
    <asp:TableRow VerticalAlign="Top" HorizontalAlign = "Center"><asp:TableCell ColumnSpan =2>
    &nbsp;</asp:TableCell></asp:TableRow>
        <asp:TableRow VerticalAlign="Top" HorizontalAlign = "Center"><asp:TableCell ColumnSpan =2>
            <asp:Table ID="tbIngredients" runat="server" Visible= false Caption="Use below parts in this step" CssClass="datagrid" Width=95%>
            <asp:TableHeaderRow>
                <asp:TableHeaderCell Width=15%>
                    Source Type
                </asp:TableHeaderCell>
                 <asp:TableHeaderCell Width=25%>
                    Part #
                </asp:TableHeaderCell>
                 <asp:TableHeaderCell Width=15%>
                    Quantity
                </asp:TableHeaderCell> 
                  <asp:TableHeaderCell Width=25% >
                    Description
                </asp:TableHeaderCell>                
                  <asp:TableHeaderCell >
                    Time Restriction
                </asp:TableHeaderCell>                              
            </asp:TableHeaderRow>
            </asp:Table>
        </asp:TableCell></asp:TableRow>
      <asp:TableRow VerticalAlign="Top" HorizontalAlign = "Center"><asp:TableCell ColumnSpan =2>
    &nbsp;</asp:TableCell></asp:TableRow>      
    <asp:TableRow VerticalAlign="Top">
    <asp:TableCell ID=tcInstruction Width=60% HorizontalAlign="left">
    <asp:Label ID="lblInstruction" runat="server" Height="100%" Width="100%" Visible="false" Style="font-family:Times New Roman;font-size:20px;  line-height:22px;"></asp:Label>
    </asp:TableCell>
    <asp:TableCell ID=tcImage HorizontalAlign="left">
        <asp:Image ID="imgDiagram" runat="server" Height="500px" Width="100%" Visible="False" ImageAlign="TextTop" />
    </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow><asp:TableCell ColumnSpan =2>
    <asp:Image ID="imgDiagram2" runat="server"  Width="100%" Visible="False" ImageAlign="TextTop" />
    </asp:TableCell></asp:TableRow>
    </asp:Table>


   
   </asp:Panel>
