<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.Master" AutoEventWireup="true" CodeBehind="MaterialConfig.aspx.cs" Inherits="ezMESWeb.Configure.Material.MaterialConfig" Title="Material Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<asp:Button ID="btnInsert" runat="server" Text="Insert Item/Part" Width="147px" OnClick="btn_Click"/> 
<br />
<asp:panel id="pnlScroll" runat="server" width="1024px" BorderColor="ActiveBorder" 
scrollbars="Both" DefaultButton="Search">    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
 
 <table width="100%">
<tr style="height:30px;">
<td colspan="2" align="center">
<asp:label id="title" runat="server"><b>Item/Part</b></asp:label>
</td>
</tr>
<tr align="center" >
  <td align="left" style="width:35%" valign="middle">
   Choose a Vendor: <asp:DropDownList id="dpVendors" Width="200px" runat="server" class="drpStyle" AutoPostBack="True" onselectedindexchanged="dpVendor_SelectedIndexChanged"/>
   </td>
    <td align="left" valign="middle" >
     &nbsp;&nbsp;Part #: <asp:TextBox id="txtPartNum" runat="server" />  &nbsp;&nbsp;<asp:Button id="Search" runat="server" Width="100px" Text="Search" onclick="btnSearch_Click"/>
    </td>
</tr>
</table>       
            <asp:label id="Message" forecolor="Red" runat="server"/>
            <asp:label id="RecordCount" runat="server">Init</asp:label>
                <asp:Label ID="lblMainError" runat="server" ForeColor="#FF3300" 
                 Width="350px"></asp:Label><br />            
             <asp:CoolGridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" FixHeaders="true"  
               EmptyDataText="No item currently available"
               AutoGenerateColumns="False"
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="id" AllowPaging="True"  AllowSorting="true" PageSize="15" EnableTheming="False" 
               Width="1024px" Height="480px" AllowResizeColumn="true" 
               PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast" onpageindexchanging="gvTable_pageIndexChanging"
             >
             <Columns>
                <asp:TemplateField>
               <ItemTemplate>
			       <asp:LinkButton ID="btnDeleteRow" runat="server" Text="Delete" CommandName="Select" />
			     </ItemTemplate>
			     <HeaderStyle Width="50px" />
				 </asp:TemplateField>            
               <asp:TemplateField>
               <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate>
			     <HeaderStyle Width="40px" />
				 </asp:TemplateField>	

			   <asp:TemplateField>  
               <ItemTemplate>
                   <asp:ImageButton ID="ibClone" runat="server" ImageUrl="/Images/copy_paste.png" CommandName="Select"  ToolTip="Copy/Paste" AlternateText="Copy"   />
			     </ItemTemplate>			     
			     <HeaderStyle Width="40px" />
				 </asp:TemplateField>	              
                 <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false">
                </asp:BoundField>
                 <asp:BoundField DataField="name" HeaderText="Part#" SortExpression="name" />
                <asp:BoundField DataField="vendor" HeaderText="Vendor" SortExpression="vendor" />                 
                 <asp:BoundField DataField="group_name" HeaderText="Group" SortExpression="group" />
                 <asp:BoundField DataField="material_form" HeaderText="Form" SortExpression="material_form" />
                 <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                 <asp:BoundField DataField="if_persistent" HeaderText="If Persistent" SortExpression="if_persistent" />
                 <asp:BoundField DataField="alert_quantity" HeaderText="Alert Quantity Level" SortExpression="alert_quantity" DataFormatString="{0:N0}"/>                 
                 <asp:BoundField DataField="lot_size" HeaderText="Lot Size" SortExpression="lot_size" DataFormatString="{0:N0}"/>
                 <asp:BoundField DataField="uom_name" HeaderText="Uom" SortExpression="uom_name" />
                 <asp:BoundField DataField="enlist_time" HeaderText="Enlist Date" SortExpression="enlist_time" />
                 <asp:BoundField DataField="enlisted_person" HeaderText="Enlisted By" SortExpression="enlist_person" />
                 <asp:BoundField DataField="update_time" HeaderText="Update Date" SortExpression="update_time" />
                 <asp:BoundField DataField="updated_person" HeaderText="Updated By" SortExpression="updated_person" />
                 <asp:BoundField DataField="description" HeaderText="description" SortExpression="description" />
                 <asp:BoundField DataField="comment" HeaderText="comment" SortExpression="comment" />
                   	
			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/>
                <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
                        <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
               
                </asp:CoolGridView>
               </ContentTemplate>
              </asp:UpdatePanel> 
              </asp:panel>
              
       <asp:SqlDataSource ID="sdsMaterialGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM material WHERE id=?" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="SELECT m.id, 
                             m.name,
                            (select convert(supplier_id, char(255)) FROM material_supplier s WHERE s.material_id = m.id ORDER BY preference limit 1) AS alias,
                           --  (select c.id FROM material_supplier s, client c WHERE s.material_id = m.id  and c.id = s.supplier_id ORDER BY preference limit 1) AS alias,
                             (select name FROM material_supplier s, client c WHERE s.material_id = m.id  and c.id = s.supplier_id ORDER BY preference limit 1) AS vendor,
                             m.mg_id, 
                             mg.name as group_name,  
                             u.name as uom_name,
                             m.material_form,
                             m.status,
                             Case m.if_persistent when 0 then 'False' when 1 then 'true' else 'N/A' end as if_persistent,
                             m.alert_quantity,                             
                             m.lot_size,
                             m.uom_id, 
                             m.enlist_time,
                             m.enlisted_by,
                             concat(e1.firstname, ' ', e1.lastname) as enlisted_person,
                             m.update_time,
                             m.updated_by,
                             concat(e2.firstname, ' ', e2.lastname) as updated_person,
                             m.description,
                             m.comment
                             FROM material m LEFT JOIN material_group mg ON mg.id = m.mg_id
                             LEFT JOIN uom u ON u.id = m.uom_id
                             LEFT JOIN employee e1 ON e1.id = m.enlisted_by
                             LEFT JOIN employee e2 ON e2.id = m.updated_by
                             LEFT JOIN client c ON c.id = m.alias
                             ORDER BY m.name" 
                             
        onselected="sqlDataSource_Selected" >
        </asp:SqlDataSource>
        
        <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:370px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateRecordPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsMaterialConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsMaterialConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  
       EnableCaching="false"
       SelectCommand="SELECT m.name,
                            (select convert(s.supplier_id, char(255)) FROM material_supplier s WHERE s.material_id = m.id ORDER BY s.preference limit 1) AS alias,
                            -- (select c.id FROM material_supplier s, client c WHERE s.material_id = m.id  and c.id = s.supplier_id ORDER BY preference limit 1) AS alias,
                             m.mg_id,
                             m.material_form,
                             m.status,
                             m.if_persistent,
                             m.alert_quantity,                             
                             m.lot_size,
                             m.uom_id,
                             m.description,
                             m.comment
                        FROM material m
                       WHERE m.id = ?" 
        >
        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="vid" 
            PropertyName="SelectedValue" />
       </SelectParameters>
       </asp:SqlDataSource>
       
       <div class="footer">
          <asp:LinkButton ID="btnSubmit" runat="server" CausesValidation="True" 
            OnClick="btnSubmit_Click"  Text="Submit" />&nbsp;
          <asp:LinkButton ID="btnCancel" runat="server" 
           CausesValidation="False" CommandName="Cancel" OnClick="btnCancel_Click"
             Text="Cancel" />
       </div>
       <asp:Label ID="lblError" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label>
                  
      </ContentTemplate>
      </asp:UpdatePanel>
       </asp:Panel>  
       
</asp:Content>
