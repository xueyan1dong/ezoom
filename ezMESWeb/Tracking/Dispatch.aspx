<%@ Page Language="C#" MasterPageFile="TrackingModule.master" AutoEventWireup="true" CodeBehind="Dispatch.aspx.cs" Inherits="ezMESWeb.Tracking.Dispatch" Title="Dispatch Page" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />     
   <p style="font-style:italic; color:Blue; font-weight:bold;">Please click the Dispatch link besides an order to dispatch new batch(es) against the order</p>
           
 <asp:panel id="pnlScroll" runat="server" width="100%" 
scrollbars=Both>  
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <table width="100%"><tr style="height:30px;">
			<td align="center">
				<asp:label id="title" runat="server"><b>Product Orders</b></asp:label>
            </td></tr>
          </table>    
             <asp:GridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" DataSourceID="sdsPDGrid" 
               EmptyDataText="There is no outstanding order currently" 
               AutoGenerateColumns="False"  
               onselectedindexchanged="gvTable_SelectedIndexChanged" 
                DataKeyNames="id,line_num,source_id" AllowPaging="True"  AllowSorting="True" PageSize="5" 
               EnableTheming="False" Width="100%" Height="500px" AllowResizeColumn="True" 
               PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast" 
               onpageindexchanged="gvTable_PageIndexChanged" HeaderStyle-Wrap="true" RowStyle-Wrap="true"
             >
             <Columns>
             <asp:TemplateField>
			   <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Dispatch" CommandName="Select" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                 <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false" />
                 <asp:BoundField DataField="order_type" HeaderText="Order Type" SortExpression="order_type"></asp:BoundField>
                 <asp:BoundField DataField="ponumber" HeaderText="PO Num" SortExpression="ponumber" ></asp:BoundField>
                 <asp:BoundField DataField="line_num" HeaderText="Line No." SortExpression="line_num" ></asp:BoundField>
                 <asp:BoundField DataField="source_id" HeaderText="source_id" SortExpression="source_id" visible="false" />
                 <asp:BoundField DataField="ProductName" HeaderText="Product" SortExpression="ProductName" ></asp:BoundField>
                 <asp:BoundField DataField="ClientName" HeaderText="Client" SortExpression="ClientName" />
                 <asp:BoundField DataField="expected_deliver_date" HeaderText="Expected Deliver Date"
                     SortExpression="expected_deliver_date" DataFormatString="{0:d}" />
                 <asp:BoundField DataField="PriName" HeaderText="Priority" SortExpression="PriName" />
                 <asp:BoundField DataField="quantity_requested" HeaderText="Qty Requested" 
                     SortExpression="quantity_requested" DataFormatString="{0:N0}" />
                 <asp:BoundField DataField="product_demand_prediction" HeaderText="Product Prediction" SortExpression="product_demand_prediction" />
                 <asp:BoundField DataField="quantity_made" HeaderText="Qty Made" 
                     SortExpression="quantity_made" DataFormatString="{0:N0}" />
               <asp:HyperLinkField DataNavigateUrlFields="source_id,order_id" 
                DataNavigateUrlFormatString="~/Reports/ProductInProcessReport.aspx?prod={0}&order={1}" 
                DataTextField="quantity_in_process" DataTextFormatString="{0:N0}" HeaderText="Qty In Process" />  
                 <asp:BoundField DataField="quantity_shipped" HeaderText="Qty Shipped" 
                     SortExpression="quantity_shipped" DataFormatString="{0:N0}" />
                 <asp:BoundField DataField="uom" HeaderText="Unit" SortExpression="uom" />
                 <asp:BoundField DataField="order_date" HeaderText="Order Date" SortExpression="order_date" DataFormatString="{0:d}"/>
                 <asp:BoundField DataField="output_date" HeaderText="Output Date" SortExpression="output_date" DataFormatString="{0:d}" Visible="false" />
                 
                 <asp:BoundField DataField="actual_deliver_date" HeaderText="Actual Deliver Date"
                     SortExpression="actual_deliver_date" Visible="False" DataFormatString="{0:d}"/>
                 <asp:BoundField DataField="internal_contact_name" HeaderText="Internal Contact" SortExpression="internal_contact_name" />
                 <asp:BoundField DataField="external_contact" HeaderText="External Contact" SortExpression="external_contact" Visible="false"/>
                 <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment" />

			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/>

                        <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
                </asp:GridView>
                </ContentTemplate>
                </asp:UpdatePanel> 
              </asp:panel>   
                <div>
                
                <asp:UpdatePanel ID="tbLotPanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                                        <asp:GridView ID="gvLotTable" runat="server" Caption="Batches Dispatched Within An Hour" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsLotGrid" 
               EmptyDataText="There is no batch dispatched within an hour" Height="100px" Width="300px"
               AutoGenerateColumns="False"  

             >
             <Columns> 
                  <asp:BoundField DataField="alias" HeaderText="Batch Name" ReadOnly="True" SortExpression="alias" />
                 <asp:BoundField DataField="dispatch_time" HeaderText="Dispatch Time(MST)" SortExpression="dispatch_time" />   
             </Columns>      
             </asp:GridView>  
             <br />       
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Reports/DispatchHistoryReport.aspx?for=0&start=1">View batches dispatched today</asp:HyperLink>
               </ContentTemplate>                           
               </asp:UpdatePanel>
                </div>
            
       <asp:SqlDataSource ID="sdsLotGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="{call delete_order( ?)}" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="
       SELECT alias,
              get_local_time(dispatch_time) as dispatch_time
         FROM lot_status
        WHERE get_local_time(dispatch_time) >=get_local_time(addtime(utc_timestamp(), '-01:00'))"  
        EnableCaching="false">
        </asp:SqlDataSource>       
       <asp:SqlDataSource ID="sdsPDGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="{call delete_order( ?)}" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="{call order_dispatch_display_per_product()}"
       InsertCommand="insert_order" InsertCommandType="StoredProcedure" OnSelecting="sdsPDGrid_Selecting" SelectCommandType="StoredProcedure">
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsOrder"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsOrder" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       SelectCommand="
       SELECT d.line_num,
            p.name as ProductName,
            (SELECT PP.process_id 
           FROM product_process pp 
           WHERE PP.product_id = p.id ORDER BY pp.priority desc LIMIT 1) as process_id, 
            p.lot_size,
            u.name as uom,
            1 as num_lots,
            substring(p.name, 1, 10) as alias_prefix,  
            (SELECT id from `location` ORDER BY id asc LIMIT 1) as location_id,
            o.internal_contact as lot_contact,
            o.priority as lot_priority,
          substr(o.comment,0,0) as comment
          
  FROM `order_general` o
  INNER JOIN order_detail d ON d.order_id = o.id AND d.line_num=?
  INNER JOIN product p ON d.source_type = 'product' AND d.source_id=? AND p.id = d.source_id
  LEFT JOIN uom u ON p.uomid =u.id
 WHERE o.id= ? " 
   
             
        >
         <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="lid" 
            PropertyName='SelectedDataKey.Values["line_num"]' />
           <asp:ControlParameter ControlID="gvTable" Name="pid" 
            PropertyName='SelectedDataKey.Values["source_id"]' />
             <asp:ControlParameter ControlID="gvTable" Name="vid" 
                 PropertyName='SelectedDataKey.Values["id"]' />
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

