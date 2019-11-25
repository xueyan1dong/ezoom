<%@ Page Language="C#" MasterPageFile="../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigOrganization.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigOrganization" Title="Organization Configuration -- ezOOM"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
  <% if ((Session["Role"]!= null) && (Session["Role"].Equals("Admin")))
     {%> 
<asp:Button ID="btnInsert" runat="server" Text="Insert" Width="147px" OnClick="btn_Click"/> 
             <%} %>  
 <asp:panel id="pnlScroll" runat="server" width="85%" 
height="100%" scrollbars="Horizontal">    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
            <asp:GridView ID="gvTable" runat="server" Caption="Organization List" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsOrgConfigGrid" 
               EmptyDataText="No Client currently available" Height="145px" Width="500px"
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
                    <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                    <asp:BoundField DataField="parent_organization" HeaderText="Parent Organization" SortExpression="parent_organization" />
                    <asp:BoundField DataField="root_company" HeaderText="Root Company" SortExpression="root_company" />
                    <asp:BoundField DataField="root_org_type" HeaderText="Root Organization Type" SortExpression="root_org_type" />
                </Columns>
             </asp:GridView>
     <%}
                     else
                     { %>
              <asp:GridView ID="gvTable1" runat="server" Caption="Organization List" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsOrgConfigGrid" 
               EmptyDataText="No Client currently available" Height="145px" Width="500px"
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
                    <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                    <asp:BoundField DataField="parent_organization" HeaderText="Parent Organization" SortExpression="parent_organization" />
                    <asp:BoundField DataField="root_company" HeaderText="Root Company" SortExpression="root_company" />
                    <asp:BoundField DataField="root_org_type" HeaderText="Root Organization Type" SortExpression="root_org_type" />
                </Columns>
             </asp:GridView>                   
     <%} %>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsOrgConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
          DeleteCommand="Update `Organization` set status='removed' WHERE `Organization`.id=?" 
       SelectCommand="SELECT o.id, o.name, o.status, e.firstname+' '+e.lastname as lead_employee, o.phone, o.email, o.description, o1.name as parent_organization, o2.name as root_company, o.root_org_type
  FROM Organization o
  LEFT JOIN Employee e ON e.id = o.lead_employee
  LEFT JOIN Organization o1 ON o1.id = o.parent_organization
  LEFT JOIN Organization o2 ON o2.id = o.root_company ">
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsOrgConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
       <asp:SqlDataSource ID="sdsOrgConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="select  username, password, status, or_id, eg_id,
       firstname, lastname, middlename, email,
       phone, roleId as role_id, report_to, comment from Employee e, users_in_roles u
       where u.userId = e.id and e.id = ?" 
        >

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="vid" 
            PropertyName="SelectedValue" />


       </SelectParameters>
       </asp:SqlDataSource>
       <%}
                            else
                            { %>
        <asp:SqlDataSource ID="sdsOrgConfig1" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="select  username, password, status, or_id, eg_id,
       firstname, lastname, middlename, email,
       phone, roleId as role_id, report_to, comment from Employee e, users_in_roles u
       where u.userId = e.id and e.id = ?" 
        >

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