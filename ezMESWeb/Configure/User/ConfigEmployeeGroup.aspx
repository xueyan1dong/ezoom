<%@ Page Language="C#" MasterPageFile="../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigEmployeeGroup.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigEmployeeGroup" Title="Employee Group Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
  <% if ((Session["Role"]!= null) && (Session["Role"].Equals("Admin")))
     {%> 
<asp:Button ID="btnInsert" runat="server" Text="New Group" Width="147px" OnClick="btn_Click"/> 
             <%} %>  
 <asp:panel id="pnlScroll" runat="server" width="85%" 
height="100%" scrollbars="Horizontal">    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
            <asp:GridView ID="gvTable" runat="server" Caption="Employee Groups" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsEmpGroupConfigGrid" 
               EmptyDataText="No employee group currently available" Height="145px" Width="500px"
               AutoGenerateColumns="False" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  DataKeyNames="id" 
                    AllowPaging="True"  AllowSorting="True" PageSize="15" 
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
      
                <SelectedRowStyle  BackColor="#FFFFCC"/>
                <Columns>

                    <asp:CommandField ShowDeleteButton="True" />
                    
                 <asp:TemplateField>
			   <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                    <asp:BoundField DataField="groupname" HeaderText="Group Name" SortExpression="groupname" />
                    <asp:BoundField DataField="o_name" HeaderText="Oragnization" SortExpression="o_name" />
                    <asp:BoundField DataField="ifprivilege" HeaderText="Privilege" SortExpression="ifprivilege" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                </Columns>
             </asp:GridView>
     <%}
                     else
                     { %>
              <asp:GridView ID="gvTable1" runat="server" Caption="Employee Groups" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsEmpGroupConfigGrid" 
               EmptyDataText="No employee group currently available" Height="145px" Width="500px"
               AutoGenerateColumns="False" onselectedindexchanging="gvTable_SelectedIndexChanging"
               onselectedindexchanged="gvTable_SelectedIndexChanged"  DataKeyNames="id" 
                    AllowPaging="True"  AllowSorting="True" PageSize="15" 
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
      
                <SelectedRowStyle  BackColor="#FFFFCC"/>
                <Columns>
                    
                 <asp:TemplateField>
			   <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                    <asp:BoundField DataField="groupname" HeaderText="Group Name" SortExpression="groupname" />
                    <asp:BoundField DataField="o_name" HeaderText="Oragnization" SortExpression="o_name" />
                    <asp:BoundField DataField="ifprivilege" HeaderText="Privilege" SortExpression="ifprivilege" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                </Columns>
             </asp:GridView>                   
     <%} %>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsEmpGroupConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
          DeleteCommand="{CALL delete_employee_group(?)}"
       SelectCommand="SELECT eg.id as id,
           eg.name AS groupname,
           org.name AS o_name,  org.id AS or_id,
           if(eg.ifprivilege=0, 'N', 'Y') as ifprivilege,
           eg.email AS email,
           eg.phone AS phone,
           e.firstname AS lead_employee,
           eg.description AS description
        FROM employee_group as eg
        LEFT JOIN organization AS org
           ON org.id = eg.org_id
        LEFT JOIN employee AS e
           ON e.id = org.lead_employee" >
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsEmpGroupConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
       <asp:SqlDataSource ID="sdsEmpGroupConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="SELECT eg.name AS groupname,
           eg.org_id,
           if(eg.ifprivilege=0, 'N', 'Y') as ifprivilege,
           eg.email,
           eg.phone,
           eg.lead_employee,
           eg.description
        FROM employee_group AS eg
        WHERE eg.id = ?" >

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="vid" 
            PropertyName="SelectedValue" />


       </SelectParameters>
       </asp:SqlDataSource>
       <%}
                            else
                            { %>
        <asp:SqlDataSource ID="sdsEmpGroupConfig1" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="SELECT eg.name AS groupname,
           eg.org_id,
           if(eg.ifprivilege=0, 'N', 'Y') as ifprivilege,
           eg.email,
           eg.phone,
           eg.lead_employee,
           eg.description
        FROM employee_group AS eg
        WHERE eg.id = ?" >

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable1" Name="vid" 
            PropertyName="SelectedValue" />
       </SelectParameters>
       </asp:SqlDataSource>                           
       <%} %>
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
