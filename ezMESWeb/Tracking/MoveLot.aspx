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
                 <tr style="height:30px;">
                     <td><asp:Label ID="lblBatchName" runat="server" Text="Batch #:"></asp:Label>
                         <asp:TextBox ID="txtBatchName" runat="server"></asp:TextBox>
                         <asp:Button ID="btnMove" runat="server" Text="Move" width ="70px" OnClick="btnMove_Click"/>
                     </td>
                 </tr>
          </table>    
                <asp:Label ID="lblError" Style="font-family:Times New Roman;font-size:20px;" ForeColor="Red" runat="server" />
             <asp:GridView ID="gvTable" runat="server" Caption="" 
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
                DataTextField="alias"  HeaderText="Batch #" SortExpression="alias" /> <%--2--%>
                 <asp:BoundField DataField="product" HeaderText="Product" SortExpression="product" />
                 <asp:BoundField DataField="priority_name" HeaderText="Priority" SortExpression="priority"/>
                 <asp:BoundField DataField="dispatch_time" HeaderText="Dispatched At" SortExpression="dispatch_time" />
                 <asp:BoundField DataField="lot_status" HeaderText="Batch Status" SortExpression="lot_status"/>
                 <asp:BoundField DataField="process" HeaderText="Workflow" SortExpression="process" />
                 <asp:BoundField DataField="sub_process_id" HeaderText="SubWorkflow"  Visible="false" />
                 <asp:BoundField DataField="location_name" HeaderText="Location" SortExpression="location_name" /> <%--9--%>
                 <asp:BoundField DataField="position_id" HeaderText="Current Position" SortExpression="position_id" />
                 <asp:BoundField DataField="sub_position_id" HeaderText="Sub Position"  Visible="false" />
                 <asp:BoundField DataField="step" HeaderText="Current Step" SortExpression="step" />
                 <asp:BoundField DataField="step_status" HeaderText="Step Status" SortExpression="step_status" />
                 <asp:BoundField DataField="start_time" HeaderText="Step Start" SortExpression="start_time" />
                 <asp:BoundField DataField="end_time" HeaderText="Step End" SortExpression="end_time" />
                 <asp:BoundField DataField="actual_quantity" HeaderText="Current Quantity" 
                     SortExpression="actual_quantity" DataFormatString="{0:N0}" />
                 <asp:BoundField DataField="uom" HeaderText="Unit" SortExpression="uom" /><%--17--%>
                 <asp:BoundField DataField="next_step_true" HeaderText="Next Step_True" SortExpression="next_step_true" Visible ="false" />
                 <asp:BoundField DataField="next_step" HeaderText="Next Step" SortExpression="next_step" />
                 <asp:BoundField DataField="contact_name" HeaderText="Contact" SortExpression="contact_name" /> <%--18 -> 20--%>
                 <asp:BoundField DataField="comment" HeaderText="Comment" /><%--19 -> 21--%>
                 <asp:BoundField DataField="product_id" HeaderText="product_id" Visible="false" /> <%--20 -> 22--%>
                 <asp:BoundField DataField="process_id" HeaderText="process_id" Visible="false" /> 
                 <asp:BoundField DataField="step_id" HeaderText="step_id" Visible="false" />  
                 <asp:BoundField DataField="result" HeaderText="result" Visible="false" /><%--23 -> 25--%>
                 <asp:BoundField DataField="equipment_id" HeaderText="Equipment" Visible="false" />	
                 <asp:BoundField DataField="start_timecode" HeaderText="StartTime" Visible="false" />
                 
			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/> 

                        <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
                </asp:GridView>
                </ContentTemplate>
                <Triggers><asp:PostBackTrigger ControlID="gvTable" /></Triggers>
                <Triggers><asp:PostBackTrigger ControlID="btnMove" /></Triggers>
                </asp:UpdatePanel> 
              </asp:panel>   
                <div>
                </div>
            
              
              
       <asp:SqlDataSource ID="sdsPDGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>"  
           ProviderName="System.Data.Odbc" 
       SelectCommand="
SELECT v.id,
        alias,
        product_id,
        product,
        priority,
        priority_name,
        dispatch_time,
        v.process_id,
        process,
        sub_process_id,
        sub_process,
        v.position_id,
        sub_position_id,
        v.step_id,
        step,
        lot_status,
        step_status,
        start_time,
        end_time,
        start_timecode,
        actual_quantity,
        uomid,
        uom,
        if(v.position_id = 0, (select step_id from process_step where process_id = v.process_id and position_id = 1), ps2.step_id) as next_step_true,
        -- if(ps1.false_step_pos is Null, (select name from step where id = next_step_true), if(step_status = 'started', concat((select name from step where id = next_step_true), ' / ', (select name from step where id = (select step_id from process_step where process_id = v.process_id and position_id = ps1.false_step_pos))), if((select result from lot_history where lot_id = v.id and position_id = v.position_id) = 'True', (select name from step where id = next_step_true), (select name from step where id = (select step_id from process_step where process_id = v.process_id and position_id = ps1.false_step_pos))))) as next_step,
        if(st.name = 'condition', 
			  if(v.step_status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(v.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(v.result,',',-1)), if(v.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
	    ) as next_step,
        contact_name,
        equipment_id,
        v.comment,
        result,
        v.emp_usage,
        v.emp_id,
        ifnull((select name from location where id = location_id), 'N/A') as location_name
        
   FROM view_lot_in_process v
        -- left join process_step ps1 on v.process_id = ps1.process_id and v.position_id = ps1.position_id and v.step_id = ps1.step_id left join process_step ps2 on v.process_id = ps2.process_id and ps1.next_step_pos = ps2.position_id
        LEFT JOIN step s ON s.id = v.step_id
        LEFT JOIN step_type st ON st.id = s.step_type_id
        LEFT JOIN process_step ps1 on ps1.process_id = v.process_id and ps1.position_id = if(v.position_id = 0, 1, v.position_id)
        LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
        LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
        where lot_status not in ('done', 'shipped', 'scrapped')
   ORDER BY start_timecode DESC"
        EnableCaching="false">
        </asp:SqlDataSource>
  
  
</asp:Content>
