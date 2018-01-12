<%@ Page Language="C#" MasterPageFile="~/Tracking/TrackingModule.master" AutoEventWireup="true" CodeBehind="EndConsumeMaterial.aspx.cs" Inherits="ezMESWeb.Tracking.EndConsumeMaterial" Title="End Step -- ezOMM" %>
<%@ Register TagPrefix="asp" TagName="lot" Src="~/Tracking/lot.ascx" %>
<%@ Register TagPrefix="asp" TagName="ConsumptionStep" Src="~/Tracking/ConsumptionStep.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" language="javascript">
   function showInfo(source, ctr1name, ctr2name)
  {
  
    var sourceID = source.name;
    sourceID = sourceID.replace(/\$/g, '_');

    sourceID = sourceID.substring (0,sourceID.length-16);

    var value_array = source.options[source.selectedIndex].value.split(",");
    
    document.getElementById(sourceID + ctr1name).innerHTML = value_array[1];;
    document.getElementById(sourceID + ctr2name).innerHTML = value_array[4];
   
         
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
              <asp:Button ID="btnDo" runat="server" Text="End Step" 
                    Style="font-family:Times New Roman;font-size:22px; width:160px;" 
                    onclick="btnDo_Click" BackColor="Green" ForeColor="White" />
              <asp:Label ID="lblCaption" runat="server"  Width="362px" Style="font-family:Times New Roman;font-size:22px;"></asp:Label>  
            </td>

        </tr>
        <tr>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Step Name:</font>&nbsp;<asp:Label ID="lblStep" runat="server" Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">End Quantity:</font> &nbsp; 
                <asp:TextBox ID="txtQuantity" runat="server" Width="80px" Style="font-family:Times New Roman;font-size:20px;"></asp:TextBox>
                <asp:Label ID="lblUom" runat="server"  Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
            <td align=left>
                <font Style="font-family:Times New Roman;font-size:20px;">Equipment:</font> &nbsp; 
                <asp:Label ID="lblEquipment" runat="server"  Style="font-family:Times New Roman;font-size:20px;"></asp:Label></td>
                
            </td>
         </tr>
         <tr>
         <td align=center colspan=3>
    <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
               
             <asp:GridView ID="gvTable" runat="server" Caption="Part(s) Consumption" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsPDGrid" 
               EmptyDataText="The step does not consume parts" Height="50px" Width="700px"
               AutoGenerateColumns="False"  
               onselectedindexchanged="gvTable_SelectedIndexChanged" 
                DataKeyNames="source_type, ingredient_id, name, required_quantity, used_quantity, uom_id" AllowPaging="False"  AllowSorting="False" 
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
             <Columns>
             <asp:TemplateField HeaderText="Consume">
			   <ItemTemplate>
			       <asp:LinkButton ID="btnConsume" runat="server" Text="from Inventory" CommandName="Select" />
			     </ItemTemplate>  
			     </asp:TemplateField> 
			    <asp:TemplateField HeaderText="Return">                   
 			   <ItemTemplate>
			       <asp:LinkButton ID="btnReturn" runat="server" Text="to Inventory" CommandName="Select" />
			     </ItemTemplate>                    
                 </asp:TemplateField>                
			     <asp:BoundField DataField="source_type" HeaderText="Source Type" />  
			     <asp:BoundField DataField="ingredient_id" HeaderText="ingredient_id" Visible="false" /> 
			     <asp:BoundField DataField="name" HeaderText="Part #"  /> 
			     <asp:BoundField DataField="order" HeaderText="Consumption Order"  /> 
			     <asp:BoundField DataField="description" HeaderText="Description" /> 
			     <asp:BoundField DataField="required_quantity" HeaderText="Required Quantity" DataFormatString="{0:N0}" /> 
			     <asp:BoundField DataField="used_quantity" HeaderText="Quantity Used" DataFormatString="{0:N0}"/> 			     
			     <asp:BoundField DataField="uom_name" HeaderText="Unit" /> 
			     <asp:BoundField DataField="restriction" HeaderText="Time Restriction" /> 
                 <asp:BoundField DataField="uom_id" HeaderText="uom id" visible="false" /> 
			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/>
                </asp:GridView>
                </ContentTemplate>
                </asp:UpdatePanel>        
         </td>
         </tr>
         <tr><td colspan=3>&nbsp;</td></tr>
         <tr>
         <td align=left  colspan=3><asp:Label ID="lblResult" runat="server"  Style="font-family:Times New Roman;font-size:20px;" Visible=false>Final Result:</asp:Label>
<asp:RadioButtonList ID="rbResult" runat="server" RepeatDirection="Horizontal"  RepeatLayout="Flow"  Visible=false > 
       <asp:ListItem  Value="True" Selected="True" ><font Style="font-family:Times New Roman;font-size:20px;">Pass</font> </asp:ListItem>
                               <asp:ListItem  Value="False" ><font Style="font-family:Times New Roman;font-size:20px;">Fail</font> </asp:ListItem>
                           </asp:RadioButtonList>
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
       <asp:SqlDataSource ID="sdsPDGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>"  
           ProviderName="System.Data.Odbc" 
       SelectCommand="
{call report_consumption_for_step(?, ?, ?, ?, ?, @response)}">
           <SelectParameters>
               <asp:SessionParameter DefaultValue="0" Name="lot_id" SessionField="lot_id" />
               <asp:SessionParameter DefaultValue="null" Name="lot_alias" 
                   SessionField="lot_alias" />
               <asp:SessionParameter DefaultValue="0" Name="process_id" 
                   SessionField="process_id" />
               <asp:QueryStringParameter DefaultValue="0" Name="step_id" 
                   QueryStringField="step" />
               <asp:QueryStringParameter DefaultValue="201201010000000" Name="start_timecode" 
                   QueryStringField="start_time" />
           </SelectParameters>
        </asp:SqlDataSource>
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
        The step has successfully ended. Please click a button to go back to Move Product form or go to next step.</asp:Label>
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
                    onclick="btnMoveForm_Click" />  
         </td></tr>
         </table>           
       </asp:Panel>
       <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:370px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateRecordPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsInventoryConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Edit" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsInventoryConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  
       EnableCaching="false"
       SelectCommand="SELECT 0 as ingredient_id,
       0.00 as required_quantity,
       0.00 as used_quantity,
       (select max(u.name) FROM uom u, ingredients g WHERE g.source_type = ? AND g.ingredient_id=? AND u.id = g.uom_id) as uom_name,
       '' as comment" 
        >

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="source_type" 
            PropertyName='SelectedDataKey.Values["source_type"]' />
       </SelectParameters> 

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="ingredient_id" 
            PropertyName='SelectedDataKey.Values["ingredient_id"]' />
       </SelectParameters>

                     
       </asp:SqlDataSource>
       
       <div class="footer">
          <asp:LinkButton ID="btnSubmit" runat="server" CausesValidation="True" 
            OnClick="btnSubmit_Click"  Text="Submit" />&nbsp;
          <asp:LinkButton ID="btnCancel" runat="server" 
           CausesValidation="False" CommandName="Cancel" OnClick="btnCancel_Click"
             Text="Cancel" />
       </div>
       <asp:Label ID="lblError2" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label>
                  
      </ContentTemplate>
      </asp:UpdatePanel>
       </asp:Panel>          
</asp:Content>


