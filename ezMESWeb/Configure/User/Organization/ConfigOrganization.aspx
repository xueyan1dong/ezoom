<%@ Page Language="C#" MasterPageFile="../../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigOrganization.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigOrganization" Title="Organization Configuration -- ezOOM"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type="text/javascript">
    // Generate parent_organization dropdown dynamically to only show parent orgs with the same root_company as the one chosen.
    function generateParentOrganizations() {
        // Get root_company dropdown value
        let rootCompany = document.getElementById('ctl00$ContentPlaceHolder1_fvUpdate_drproot_company');
        console.log(rootCompany);
    }
</script>

<%-- Tab Container with buttons to select between host and client organization tabs. --%>
<asp:TabContainer ID="tcMain" runat="server" Height="10px" Width="100%" ActiveTabIndex="0" CssClass="amber_tab" OnActiveTabChanged ="TabContainer_ActiveTabChanged" AutoPostBack  ="true" >
    <asp:TabPanel ID="Tp1" runat="server" HeaderText ="Host Organizations">
        <ContentTemplate>
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:Button ID="btnNewOrganization1" runat="server" Text='New Organization'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click"></asp:Button>
                <%}%>
        </ContentTemplate>
    </asp:TabPanel>
    <asp:TabPanel ID="Tp2" runat="server" HeaderText="Client Organizations">
        <ContentTemplate>
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:Button ID="btnNewOrganization2" runat="server" Text='New Organization'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click"></asp:Button>
                <%}%>
        </ContentTemplate>
    </asp:TabPanel>
</asp:TabContainer>

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

<asp:panel id="pnlScroll" runat="server" width="85%" 
height="100%" scrollbars="Horizontal" >    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <asp:GridView ID="gvTable" runat="server" Caption="Host Organizations" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsOrgConfigGrid" 
               EmptyDataText="No Client currently available" Height="145px" Width="500px"
               AutoGenerateColumns="False" EnablePersistedSelection="true"
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
                    <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" ReadOnly="true" InsertVisible="false" Visible="false" />
                    <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                    <asp:BoundField DataField="root_company" HeaderText="Root Company" SortExpression="root_company" />
                    <asp:BoundField DataField="parent_organization" HeaderText="Parent Organization" SortExpression="parent_organization" />
                    <%--<asp:BoundField DataField="root_org_type" HeaderText="Root Organization Type" SortExpression="root_org_type" />--%>
                </Columns>
             </asp:GridView>  
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsOrgConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
          DeleteCommand="Update `Organization` set status='removed' WHERE `Organization`.id=?" 
       SelectCommand="SELECT o.id, o.name, o.status, concat(e.firstname,' ',e.lastname) as lead_employee, o.phone, o.email, o.description, c.name as root_company, o1.name as parent_organization, o.root_org_type
  FROM Organization o
  LEFT JOIN Employee e ON e.id = o.lead_employee
  LEFT JOIN Organization o1 ON o1.id = o.parent_organization
  LEFT JOIN Company c ON c.id = o.root_company 
  WHERE o.root_org_type = 'host' ">
        </asp:SqlDataSource>
        
        <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:370px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateBufferPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="btnUpdate_ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="fvUpdate" runat="server" DataSourceID="sdsOrgConfig"
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
       SelectCommand="SELECT id, name, status, lead_employee, phone, email, description, parent_organization, root_company, root_org_type
           FROM Organization
           WHERE id = ?" 
        >

        <SelectParameters>
           <asp:ControlParameter ControlID="gvTable" Name="vid" 
            PropertyName="SelectedValue" />


       </SelectParameters>
       </asp:SqlDataSource>
       <%}%>
       <div class="footer">
          <asp:LinkButton ID="btnSubmit" runat="server" CausesValidation="True" 
            OnClick="btnSubmit_Click"  Text="Submit" />&nbsp;
          <asp:LinkButton ID="btnCancel1" runat="server" 
           CausesValidation="False" CommandName="Cancel" OnClick="btnCancel_Click"
             Text="Cancel" />
           <asp:Label ID="lblActiveTab"
                          runat="server" Visible="False"></asp:Label>
       </div>
       <asp:Label ID="lblError" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label>
                  
      </ContentTemplate>
      </asp:UpdatePanel>
       </asp:Panel>  
 
</asp:panel>
  
</asp:Content>