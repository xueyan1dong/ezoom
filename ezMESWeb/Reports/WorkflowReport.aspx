<%@ Page Language="C#" MasterPageFile="ReportModule.master" AutoEventWireup="true" CodeBehind="WorkflowReport.aspx.cs" Inherits="ezMESWeb.Reports.WorkflowReport" 
 Title="Workflow Browser -- ezOOM" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 
    <link rel="Stylesheet" href="/CSS/general.css" type="text/css" media="screen" /> 
    <link rel="Stylesheet" href="/CSS/datagrid.css" type="text/css" media="screen" /> 



</asp:content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1"> 

   
      

       <asp:Panel ID="pnMain" runat="server" BackColor="White" BorderStyle="None" 
            Width=8in Height=11in>
         <table border=0 cellpadding=5px cellspacing = 5px width=100% >
         <tr><td align=center>
        <table border = 0 cellpadding=0px cellspacing=0px width=95% >
        <tr>
            <td 
                style="font-family:Times New Roman;font-style:italic;font-size:25px; height:30px" 
                class="style20">Workflow Browser</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
        <td align=left style="font-family:Times New Roman;font-size:20px;  line-height:22px;" >Please Select A Workflow:</td>
        </tr>
        <tr>
                              
         <td align="left" valign = "middle">
         <table border=0><tr>
         <td>
                            <asp:DropDownList ID="dpProcess" runat="server" Height="35px" Width="300px" 
                                onselectedindexchanged="dpProcess_SelectedIndexChanged">
                            </asp:DropDownList></td>
                            <td>
                            <asp:Button ID="btnView" runat="server" Height="35px" onclick="btnView_Click" 
                                Text="View Traveler" Width="100px" /></td>
                   </tr>
           </table>
                        </td>
                        </tr> 
                        <tr ><td ><hr color="Silver" />
                            </td></tr>
        <tr>

            <td align="left">
                <table border="0" cellpadding="5px" cellspacing="10px" width =100%>
                    <tr height = 50px>

          
                        <td align="right" width=15%>
                            <asp:HyperLink ID="hpPrev" runat="server" Visible="False"><< Prev Step </asp:HyperLink>
                       &nbsp;
                        </td>
                        <td align="center" >
                        <asp:Label ID="lblStep" runat="server" 
                                Height="20px" style="font-family:Times New Roman;font-size:20px;  line-height:22px;" ></asp:Label>
                        </td>
                        <td align="left"  width=15%>&nbsp;
                            <asp:HyperLink ID="hpNext" runat="server" Visible="False"> Next Step >></asp:HyperLink>
                            
                        </td>
                    </tr>
                    <tr><td align="right" colspan=2><asp:HyperLink ID="hpFail" runat="server" Visible="false">Step for Failed Condition</asp:HyperLink></td></tr>
                </table>
            </td>

        </tr>
        <tr ><td ><hr color="silver" /></td></tr>
        </table>   
                
</td></tr>

</table>
<br />
   <asp:Panel id="pnlScroll" runat="server" width=100% 
height=70% ScrollBars="Auto"> 
         <center>
    <asp:Table runat="server" BorderWidth=0 Width=95% Height=80% >
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
        <asp:TableRow>
            <asp:TableCell ColumnSpan=2>
              <asp:Table ID="tbSteps" runat="server" Visible=false Caption="Valid Steps for Repositioning" CssClass="datagrid" Width=95%>
             <asp:TableHeaderRow>
                <asp:TableHeaderCell Width=5%>
                    Position
                </asp:TableHeaderCell>
                 <asp:TableHeaderCell Width=25%>
                    Step Name
                </asp:TableHeaderCell>
                 <asp:TableHeaderCell Width=70%>
                    Description
                </asp:TableHeaderCell>                               
            </asp:TableHeaderRow>               
              </asp:Table>
            </asp:TableCell>
        </asp:TableRow>
      <asp:TableRow VerticalAlign="Top" HorizontalAlign = "Center"><asp:TableCell ColumnSpan =2>
    &nbsp;</asp:TableCell></asp:TableRow>      
    <asp:TableRow VerticalAlign="Top">
    <asp:TableCell ID=tcInstruction Width=60% HorizontalAlign="left">
    <asp:Label ID="lblInstruction" runat="server" Height="100%" Width="100%" Visible="false" Style="font-family:Times New Roman;font-size:20px;  line-height:22px;"></asp:Label>
    </asp:TableCell>
    <asp:TableCell ID=tcImage HorizontalAlign="left">
        <asp:Image ID="imgDiagram" runat="server"  Width="100%" Height="100%" Visible="False" ImageAlign="TextTop" />
    </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow><asp:TableCell ColumnSpan =2>
    <asp:Image ID="imgDiagram2" runat="server" Width="100%" Visible="False" ImageAlign="TextTop" />
    </asp:TableCell></asp:TableRow>
    </asp:Table>

</center>
   
   </asp:Panel>
   
</asp:Panel>

</asp:Content>