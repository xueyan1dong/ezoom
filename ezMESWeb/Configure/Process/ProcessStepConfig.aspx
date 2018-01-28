<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ProcessStepConfig.aspx.cs" Inherits="ezMESWeb.Configure.Process.ProcessStepConfig" Title="Step Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<script type="text/javascript" language="javascript">
   function showDropDown(source, ctr1name, ctr2name)
  {
  
    var sourceID = source.name;
    sourceID = sourceID.replace(/\$/g, '_');
    sourceID = sourceID.substring (0,sourceID.length-12);
    
    var first = sourceID+'drp'+ctr1name;
    var second = sourceID+'drp' + ctr2name;


    var dropdown1;
    var dropdown2;



        
        if (source.selectedIndex == 0)
        {
            dropdown1=document.getElementById(first);
            dropdown2=document.getElementById(second);
            
        }
        else
        {
            dropdown2=document.getElementById(first);
            dropdown1=document.getElementById(second);   

        }
        if (dropdown1.style.display == 'none')
        {
           dropdown1.style.display = 'block';
           dropdown2.style.display ='none';
        }    
         
  }
 </script> 
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<asp:Button ID="btnInsert" runat="server" Text="Insert" Width="147px" OnClick="btn_Click"/> 

 <asp:panel id="pnlScroll" runat="server" width="100%" 
scrollbars="Horizontal">    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
          <table width="100%"><tr style="height:30px;">
			<td align="center">
				<asp:label id="title" runat="server"><b>Step Configuration</b></asp:label>
            </td></tr>
          </table>   
            
         <asp:CoolGridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" DataSourceID="sdsPStepGrid" 
               EmptyDataText="No step currently available" 
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" 
               onselectedindexchanged="gvTable_SelectedIndexChanged" 
                DataKeyNames="id" AllowPaging="True"  AllowSorting="true" PageSize="15" 
               EnableTheming="False" Width="860px" Height="480px" AllowResizeColumn="true" 
               PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast" 
               onpageindexchanged="gvTable_PageIndexChanged"
             >
            <SelectedRowStyle  BackColor="#FFFFCC"/>
            <Columns>
             <asp:TemplateField><ItemTemplate>
			    <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			 </ItemTemplate>
             <HeaderStyle Width="60px" />
             </asp:TemplateField>
			    <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" />
                <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                <asp:BoundField DataField="step_type_name" HeaderText="Type" SortExpression="step_type_name" />
                <asp:BoundField DataField="eq_name" HeaderText="Equipment" SortExpression="eq_name" />
                <asp:BoundField DataField="emp_usage" HeaderText="Employee or Group" SortExpression="emp_usage" />
                <asp:BoundField DataField="emp_name" HeaderText="Employee or Group Name" SortExpression="emp_name" />
                               <asp:HyperLinkField DataNavigateUrlFields="recipe_id" 
                DataNavigateUrlFormatString="RecipeConfig.aspx?Id={0}" 
                DataTextField="recipe_name" DataTextFormatString="{0}" HeaderText="Recipe" /> 
                <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment" />
                <asp:BoundField DataField="para_count" HeaderText="Num. of Parameters" SortExpression="para_count" />
                <asp:BoundField DataField="mintime" HeaderText="Minimum Duration" SortExpression="mintime" />
                <asp:BoundField DataField="maxtime" HeaderText="Maximum Duration" SortExpression="maxtime" />
                <asp:BoundField DataField="create_time" HeaderText="Create Date" SortExpression="create_time" />
                <asp:BoundField DataField="created_name" HeaderText="Created by" SortExpression="created_name" />
                <asp:BoundField DataField="state_change_time" HeaderText="Update Date" SortExpression="state_change_time" />
                <asp:BoundField DataField="state_changed_name" HeaderText="Updated by" SortExpression="state_changed_name" />
                <asp:BoundField DataField="para1" HeaderText="P.1" SortExpression="para1" />
                <asp:BoundField DataField="para2" HeaderText="P.2" SortExpression="para2" />
                <asp:BoundField DataField="para3" HeaderText="P.3" SortExpression="para3" />
                <asp:BoundField DataField="para4" HeaderText="P.4" SortExpression="para4" />
                <asp:BoundField DataField="para5" HeaderText="P.5" SortExpression="para5" />
                <asp:BoundField DataField="para6" HeaderText="P.6" SortExpression="para6" />
                <asp:BoundField DataField="para7" HeaderText="P.7" SortExpression="para7" />
                <asp:BoundField DataField="para8" HeaderText="P.8" SortExpression="para8" />
                <asp:BoundField DataField="para9" HeaderText="P.9" SortExpression="para9" />
                <asp:BoundField DataField="para10" HeaderText="P.10" SortExpression="para10" />
                   	
			   </Columns>
                 <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
                        <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
               
                   </asp:CoolGridView>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
              
       <asp:SqlDataSource ID="sdsPStepGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM step WHERE id=?" 
           ProviderName="System.Data.Odbc" 
           SelectCommand="SELECT ps.id,
       ps.name, 
       ps.step_type_id, 
       st.name AS step_type_name,   
       ps.eq_id, 
       eq.name AS eq_name, 
       ps.emp_usage,  
       case emp_usage
       when 'employee group' then (SELECT eg.name FROM employee_group eg WHERE eg.id = ps.emp_id)
       ELSE (SELECT concat(ep2.firstname, ' ', ep2.lastname) FROM employee ep2 WHERE ep2.id = ps.emp_id)
       end AS emp_name,
       ps.emp_id,
       ps.recipe_id, 
       r.name AS recipe_name,
       ps.mintime, 
       ps.maxtime, 
       ps.create_time, 
       ps.created_by, 
       concat(ep.firstname, ' ', ep.lastname) as created_name,
       ps.state_change_time,
       ps.state_changed_by, 
       concat(ep1.firstname, ' ', ep1.lastname) as state_changed_name,
       ps.para_count, 
       ps.description, 
       ps.comment, 
       ps.para1,
       ps.para2, 
       ps.para3, 
       ps.para4, 
       ps.para5, 
       ps.para6, 
       ps.para7, 
       ps.para8,
       ps.para9, 
       ps.para10 
  FROM step ps JOIN step_type st ON st.id = ps.step_type_id
               LEFT JOIN equipment eq ON eq.id = ps.eq_id
               LEFT JOIN employee ep ON ep.id = ps.created_by
               LEFT JOIN employee ep1 ON ep1.id = ps.state_changed_by
               LEFT JOIN recipe r ON r.id = ps.recipe_id"
InsertCommand="modify_step" InsertCommandType="StoredProcedure" EnableCaching="false">
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsPStepConfig"
       EnableTheming="True" Height="100px" HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
          <asp:SqlDataSource ID="sdsPStepConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       EnableCaching="false"
       ProviderName="System.Data.Odbc"  
       SelectCommand="SELECT ps.id, 
       ps.name, 
       ps.step_type_id, 
       ps.eq_id, 
       ps.emp_usage, 
       ps.emp_id, 
       ps.recipe_id,
       ps.mintime, 
       ps.maxtime,  
       ps.description, 
       ps.comment, 
       ps.para1,
       ps.para2, 
       ps.para3, 
       ps.para4, 
       ps.para5, 
       ps.para6, 
       ps.para7, 
       ps.para8,
       ps.para9, 
       ps.para10 from step ps
  where  ps.id = ?" 
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
 
</asp:panel>

</asp:Content>
