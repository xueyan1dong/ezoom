<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="Reposition.aspx.cs" Inherits="ezMESWeb.Tracking.Reposition" Title="Reposition Batch -- ezOMM" %>
<%@ Register TagPrefix="asp" TagName="lot" Src="~/Tracking/lot.ascx" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" language="javascript">
   function writeResult(result, txtControl)
  {
    document.getElementById(txtControl).value= result;      
  }
  function checkResult(txtControl)
  {
    var result=document.getElementById(txtControl).value;
    if(result.length >0)
        return true;
    else
    {
        alert('Please first select a step to position batch to.');
        return false;
    }
  }
 </script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" /> 
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
              <asp:Button ID="btnDo" runat="server" Text="Reposition Batch" 
                    Style="font-family:Times New Roman;font-size:22px; width:200px;" 
                    onclick="btnDo_Click" BackColor="Green" ForeColor="White" />
              <asp:Label ID="lblCaption" runat="server"  Width="362px" Style="font-family:Times New Roman;font-size:22px;"></asp:Label>  
            </td>

        </tr>
        <tr>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font>&nbsp;<asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Quantity:</font> &nbsp; 
                <asp:TextBox ID="txtQuantity" runat="server" Width="80px" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
                <asp:Label ID="lblUom" runat="server"  Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>

            </td>
         </tr>

         <tr style="display:none">
         <td align=left  colspan=3><asp:TextBox ID="txtResult" runat="server" ></asp:TextBox>

         </td>
             
         </tr> 
          <tr><td colspan=3>&nbsp;</td></tr>       
         <tr>
            <td align=left colspan=3><font Style="font-family:Times New Roman;font-size:20px;">Comment:</font> <br />
                <asp:TextBox ID="txtComment" runat="server" Width="100%" Height="50px" Wrap="True" TextMode="MultiLine" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
            </td>

        </tr>
        <tr>
            <td align=left><asp:Label ID="lblApprover" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver:</asp:Label></td>
            <td>
                <asp:DropDownList ID="drpApprover" runat="server" Width="180px" Style="font-family:Times New Roman;font-size:20px;" Visible=false>
                </asp:DropDownList>
            </td>
            <td><asp:Label ID="lblPassword" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Approver Password:</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Style="font-family:Times New Roman;font-size:20px;" Visible=false></asp:TextBox></td>
        
        </tr>
         <tr>
         <td align=center colspan=3>
                <asp:Table ID="tbSteps" runat="server" Visible=false Caption="Select a Step for Repositioning" CssClass="datagrid" Width=95%>
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
         </td>
         </tr>        
    </table>
  </td>
</tr>
<tr><td>&nbsp;</td></tr>

 </table>   
</div>
</asp:panel>

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
        The batch has been repositioned successfully. Please click a button to go back to Move Product form or go to repositioned step.</asp:Label>
        </td></tr>
        <tr><td>&nbsp;
        <asp:Label ID="lblStartTime" runat="server" Visible = false></asp:Label>
        <asp:Label ID="lblStepStatus" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblSubProcessId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblPositionId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblSubPositionId" runat="server" Visible=false></asp:Label>
        <asp:Label ID="lblStepId" runat="server" Visible=false></asp:Label>
        
        </td></tr>
        <tr><td>
        <asp:Button ID="btnListForm" runat="server" Text="Back To Product List" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnListForm_Click" />
        <asp:Button ID="btnMoveForm" runat="server" Text="Go To Next Step" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnMoveForm_Click"  />  
         </td></tr>
         </table>           
       </asp:Panel>
         
</asp:Content>


