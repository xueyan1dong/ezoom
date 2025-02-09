<%@ Page Language="C#" MasterPageFile="../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigEmployee.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigEmployee" Title="Employee Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type="text/javascript">
    let dictionaryReportToEmployees = JSON.parse('<%=serializedDictReportToEmployees%>');

    function generateReportToEmployees() {
        let organization = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpor_id').value;
        let reportToEmployees = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpreport_to');
        let selectedEmployee = reportToEmployees.value;

        for (let i = 1; i < reportToEmployees.length; i++) {
            // if parentOrganization id does not correspond to rootCompany in dict
            if (dictionaryReportToEmployees[reportToEmployees[i].value] != organization) {
                reportToEmployees[i].style.display = 'none';
            }
            else {
                reportToEmployees[i].style.display = 'initial';
            }
        }
        // Maintain selected value if it exists in the filtered set
        for (let i = 0; i < reportToEmployees.length; i++) {
            if (reportToEmployees[i].style.display != 'none') {
                if (selectedEmployee == reportToEmployees[i].value) {
                    reportToEmployees.value = selectedEmployee;
                    break;
                }
            }
            reportToEmployees.value = reportToEmployees[0];
        }
    }

    function orderStatusDropdown() {
        // Get dropdown values
        let statusDropDown = document.createElement("select");
        statusDropDown = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpstatus');
        let selected = statusDropDown.value;
        // Put them into an array
        let arr = [];
        while (statusDropDown.options.length != 0) {
            arr.push(statusDropDown[0].value);
            statusDropDown.remove(statusDropDown[0]);
        }
        // Sort the array
        arr.sort();
        let length = arr.length;
        // Place them back into the dropdown
        for (let i = 0; i < length; i++) {
            let option = document.createElement("option");
            option.text = arr[i];
            statusDropDown.append(option);
        }
        statusDropDown.value = selected;
    }
    let dictionaryOrganizations = JSON.parse('<%=serializedDictOrganizations%>');
    function orderOrganizationDropdown() {
        let userType = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpuser_type') || document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_lbluser_type');
        let userTypeValue = userType.value || userType.textContent;
        let organizations = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpor_id');
        let selectedOrganization = organizations.value;
        let length = organizations.length;
        for (let i = 0; i < length; i++) {
            organization = organizations[i];
            // if organization is not of the user type, hide it
            if (dictionaryOrganizations[organization.value] != userTypeValue) {
                organization.style.display = 'none';
            }
            else {
                organization.style.display = '';
                if (userTypeValue == "host") {
                    if (organization.label == "Waterworks") {
                        organization.selected = "selected";
                    }
                }
                else {
                    if (organization.label == "Dayton Grey Contacts") {
                        organization.selected = "selected";
                    }
                }
            }
        }
        for (let i = 0; i < length; i++) {
            if (organizations[i].style.display != 'none') {
                if (selectedOrganization == organizations[i].value) {
                    organizations.value = selectedOrganization;
                    break;
                }
            }
        }
        generateReportToEmployees();
    }
</script>

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

<%-- Tab Container with buttons to select between host and client user lists tabs. --%>
<asp:TabContainer ID="tcMain" runat="server" Height="10px" Width="100%" ActiveTabIndex="0" CssClass="amber_tab" OnActiveTabChanged ="TabContainer_ActiveTabChanged" AutoPostBack  ="true">
    <asp:TabPanel ID="Tp1" runat="server" HeaderText ="Host User List">
        <ContentTemplate>
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button ID="btnNewUser1" runat="server" Text='New User'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click" class="Pointer"></asp:Button>
                </ContentTemplate>
            </asp:UpdatePanel>
                <%}%>
        </ContentTemplate>
    </asp:TabPanel>
    <asp:TabPanel ID="Tp2" runat="server" HeaderText="Client User List">
        <ContentTemplate>
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button ID="btnNewUser2" runat="server" Text='New User'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click" class="Pointer"></asp:Button>
                </ContentTemplate>
            </asp:UpdatePanel>
                <%}%>
        </ContentTemplate>
    </asp:TabPanel>
</asp:TabContainer>

 <asp:panel id="pnlScroll" runat="server" width="100%" 
height="100%" scrollbars="Horizontal" >    
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
            <asp:GridView ID="gvTable" runat="server" Caption="Employee List" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsEmpConfigGrid" 
               EmptyDataText="No Client currently available" Height="100%" Width="100%"
               AutoGenerateColumns="False" EnablePersistedSelection="true"
               onselectedindexchanged="gvTable_SelectedIndexChanged"  DataKeyNames="id" 
                    AllowPaging="True"  AllowSorting="True" PageSize="15"
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
      
                <SelectedRowStyle BackColor="#FFFFCC"/>
                <Columns>

                    <asp:CommandField ShowDeleteButton="True" />
                    
                 <asp:TemplateField>
			     <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                 <asp:TemplateField>
			     <ItemTemplate>
			       <asp:LinkButton ID="btnChangePassword" runat="server" Text="Change Password" CommandName="Select" OnClick="AddPasswordTemplate" />
			     </ItemTemplate>                 
                 </asp:TemplateField>
                    <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" ReadOnly="true" InsertVisible="false" Visible="false" />
                    <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="o_name" HeaderText="Organization" SortExpression="o_name" />
                    <asp:BoundField DataField="eg_name" HeaderText="User Group" SortExpression="eg_name" />
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
               EmptyDataText="No Client currently available" Height="100%" Width="100%"
               AutoGenerateColumns="False" EnablePersistedSelection="true"
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
                    <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" ReadOnly="true" InsertVisible="false" Visible="false" />
                    <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                    <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                    <asp:BoundField DataField="o_name" HeaderText="Organization" SortExpression="o_name" />
                    <asp:BoundField DataField="eg_name" HeaderText="User Group" SortExpression="eg_name" />
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
       SelectCommand="SELECT e.id, e.company_id, e.username, e.password, e.status, e.user_type, e.or_id, o.name as o_name, e.eg_id, 
       eg.name as eg_name, e.firstname, e.lastname, e.middlename, e.email, e.phone, ur.roleId as role_id, sr.name as role, concat(e1.firstname, ' ', e1.lastname) as report_to, 
       e.comment
  FROM Employee e 
  LEFT JOIN Employee_group eg ON eg.id = e.eg_id
                  LEFT JOIN Organization o ON o.id = e.or_id
                  LEFT JOIN employee e1 ON e1.id = e.report_to
LEFT JOIN users_in_roles ur ON ur.userId = e.id
LEFT JOIN system_roles sr ON sr.id=ur.roleId 
WHERE e.user_type = 'host' ">
        </asp:SqlDataSource>
        
        <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:100%; width:100%; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateBufferPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="btnUpdate_ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="fvUpdate" runat="server" DataSourceID="sdsEmpConfig"
       EnableTheming="True" Height="100%" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
       <asp:SqlDataSource ID="sdsEmpConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="select e.id, username, password, status, user_type, or_id, eg_id,
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
       SelectCommand="select e.id, username, password, status, user_type, or_id, eg_id,
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
          <asp:LinkButton ID="btnCancel1" runat="server" 
           CausesValidation="False" CommandName="Cancel" OnClick="btnCancel_Click"
             Text="Cancel" />
       </div>
       <asp:Label ID="lblError" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label>
       <asp:Label ID="lblActiveTab"
                          runat="server" Visible="False"></asp:Label>
                  
      </ContentTemplate>
      </asp:UpdatePanel>
       </asp:Panel>  
 
</asp:panel>
  
</asp:Content>
