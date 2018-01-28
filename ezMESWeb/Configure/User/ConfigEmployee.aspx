<%@ Page Language="C#" MasterPageFile="../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigEmployee.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigEmployee" Title="Employee Configuration -- ezOOM" %>
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
            <asp:GridView ID="gvTable" runat="server" Caption="Employee List" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsEmpConfigGrid" 
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
                    <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="o_name" HeaderText="Oragnization" SortExpression="o_name" />
                    <asp:BoundField DataField="eg_name" HeaderText="Employee Group" SortExpression="eg_name" />
                    <asp:BoundField DataField="firstname" HeaderText="First Name" SortExpression="firstname" />
                    <asp:BoundField DataField="lastname" HeaderText="Last Name" SortExpression="lastname" />
                    <asp:BoundField DataField="middlename" HeaderText="MI." SortExpression="middlename" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="role" HeaderText="Role" SortExpression="role" />
                    <asp:BoundField DataField="report_to" HeaderText="Report To" SortExpression="report_to" />
                    <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment" />
                </Columns>
             </asp:GridView>
     <%}
                     else
                     { %>
              <asp:GridView ID="gvTable1" runat="server" Caption="Employee List" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsEmpConfigGrid" 
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
                    <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="o_name" HeaderText="Oragnization" SortExpression="o_name" />
                    <asp:BoundField DataField="eg_name" HeaderText="Employee Group" SortExpression="eg_name" />
                    <asp:BoundField DataField="firstname" HeaderText="First Name" SortExpression="firstname" />
                    <asp:BoundField DataField="lastname" HeaderText="Last Name" SortExpression="lastname" />
                    <asp:BoundField DataField="middlename" HeaderText="MI." SortExpression="middlename" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="role" HeaderText="Role" SortExpression="role" />
                    <asp:BoundField DataField="report_to" HeaderText="Report To" SortExpression="report_to" />
                    <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment" />
                </Columns>
             </asp:GridView>                   
     <%} %>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsEmpConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
          DeleteCommand="Update `Employee` set status='removed' WHERE `Employee`.id=?" 
       SelectCommand="SELECT e.id, e.company_id, e.username, e.password, e.status, e.or_id, o.name as o_name, e.eg_id, 
       eg.name as eg_name, e.firstname, e.lastname, e.middlename, e.email, e.phone, ur.roleId as role_id, sr.name as role, concat(e1.firstname, ' ', e1.lastname) as report_to, 
       e.comment 
  FROM Employee e 
  LEFT JOIN Employee_group eg ON eg.id = e.eg_id
                  LEFT JOIN Organization o ON o.id = e.or_id
                  LEFT JOIN employee e1 ON e1.id = e.report_to
LEFT JOIN users_in_roles ur ON ur.userId = e.id
LEFT JOIN system_roles sr ON sr.id=ur.roleId ">
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsEmpConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
       <asp:SqlDataSource ID="sdsEmpConfig" runat="server" 
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
        <asp:SqlDataSource ID="sdsEmpConfig1" runat="server" 
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
