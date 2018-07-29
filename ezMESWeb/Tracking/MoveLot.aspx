<%@ Page Language="C#" MasterPageFile="TrackingModule.Master" AutoEventWireup="true" CodeBehind="MoveLot.aspx.cs" Inherits="ezMESWeb.Tracking.MoveLot" Title="Move Product -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>


<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .style19
        {
            height: 35px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

  <asp:panel id="pnlScroll" runat="server" width="100%" scrollbars=Horizontal>  
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate> 
             <table width="100%"><tr style="height:30px;">
			<td align="center">
				<asp:label id="title" runat="server"><b>Product Orders</b></asp:label>
            </td></tr>
          </table>    
                <asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" />
             <asp:CoolGridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" DataSourceID="sdsPDGrid" 
               EmptyDataText="There is no outstanding order currently" PageSize="15" Width="1080px" Height="480px" AllowResizeColumn="true" 
               AutoGenerateColumns="False"  
               onselectedindexchanged="gvTable_SelectedIndexChanged" 
                DataKeyNames="id, sub_process_id, sub_position_id, product_id, process_id, step_id, lot_status, result, equipment_id,  start_timecode, alias" AllowPaging="True"  AllowSorting="True" 
               EnableTheming="False" PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast" onpageindexchanged="gvTable_PageIndexChanged"
             >
             <Columns>
             <asp:TemplateField>
			   <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Move" CommandName="Select" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                 <asp:BoundField DataField="id" HeaderText="Batch ID" ReadOnly="True"  Visible="false" />
                 <asp:HyperLinkField DataNavigateUrlFields="alias" 
                DataNavigateUrlFormatString="~/Reports/LotHistoryReport.aspx?batch={0}" 
                DataTextField="alias"  HeaderText="Batch Name" SortExpression="alias" /> <%--2--%>
                 <asp:BoundField DataField="product" HeaderText="Product" SortExpression="product" />
                 <asp:BoundField DataField="priority_name" HeaderText="Priority" SortExpression="priority"/>
                 <asp:BoundField DataField="dispatch_time" HeaderText="Dispatched At" SortExpression="dispatch_time" />
                 <asp:BoundField DataField="lot_status" HeaderText="Lot Status" SortExpression="lot_status"/>
                 <asp:BoundField DataField="process" HeaderText="Workflow" SortExpression="process" />
                 <asp:BoundField DataField="sub_process_id" HeaderText="SubWorkflow"  Visible="false" />
                 <asp:BoundField DataField="location_id" HeaderText="Location" SortExpression="location_id" /> <%--9--%>
                 <asp:BoundField DataField="position_id" HeaderText="Current Position" SortExpression="position_id" />
                 <asp:BoundField DataField="sub_position_id" HeaderText="Sub Position"  Visible="false" />
                 <asp:BoundField DataField="step" HeaderText="Step Name" SortExpression="step" />
                 <asp:BoundField DataField="step_status" HeaderText="Step Status" SortExpression="step_status" />
                 <asp:BoundField DataField="start_time" HeaderText="Step Start" SortExpression="start_time" />
                 <asp:BoundField DataField="end_time" HeaderText="Step End" SortExpression="end_time" />                 
                 <asp:BoundField DataField="actual_quantity" HeaderText="Current Quantity" 
                     SortExpression="actual_quantity" DataFormatString="{0:N0}" />
                 <asp:BoundField DataField="uom" HeaderText="Unit" SortExpression="uom" />
                 <asp:BoundField DataField="contact_name" HeaderText="Contact" SortExpression="contact_name" />
                 <asp:BoundField DataField="comment" HeaderText="Comment" />
                 <asp:BoundField DataField="product_id" HeaderText="product_id" Visible="false" />
                 <asp:BoundField DataField="process_id" HeaderText="process_id" Visible="false" /> 
                 <asp:BoundField DataField="step_id" HeaderText="step_id" Visible="false" />  
                 <asp:BoundField DataField="result" HeaderText="result" Visible="false" />  
                 <asp:BoundField DataField="equipment_id" HeaderText="Equipment" Visible="false" />	
                 <asp:BoundField DataField="start_timecode" HeaderText="StartTime" Visible="false" />	
                 
			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/>
                 <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
                        <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
                </asp:CoolGridView>
                </ContentTemplate>
                <Triggers><asp:PostBackTrigger ControlID="gvTable" /></Triggers>
                </asp:UpdatePanel> 
              </asp:panel>   
                <div>
                </div>
            
              
              
       <asp:SqlDataSource ID="sdsPDGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>"  
           ProviderName="System.Data.Odbc" 
       SelectCommand="
SELECT id,
        alias,
        product_id,
        product,
        priority,
        priority_name,
        dispatch_time,
        process_id,
        process,
        sub_process_id,
        sub_process,
        position_id,
        sub_position_id,
        step_id,
        step,
        lot_status,
        step_status,
        start_time,
        end_time,
        start_timecode,
        actual_quantity,
        uomid,
        uom,
        contact_name,
        equipment_id,
        comment,
        result,
        emp_usage,
        emp_id,
        ifnull((select name from location where id = location_id), '') as location_id
   FROM view_lot_in_process
   ORDER BY start_timecode DESC"
        EnableCaching="false">
        </asp:SqlDataSource>
  
  
</asp:Content>
