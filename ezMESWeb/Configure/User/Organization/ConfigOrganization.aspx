<%@ Page Language="C#" MasterPageFile="../../ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ConfigOrganization.aspx.cs" Inherits="ezMESWeb.Configure.User.ConfigOrganization" Title="Organization Configuration -- ezOOM"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<script type="text/javascript">
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

    let rootCompanyDict = {};

    function generateRootCompanies() {
        let rootCompanies = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drproot_company');
        // Put all root companies into a dictionary as keys with their root org type as values
        for (let i = 0; i < rootCompanies.length; i++) {
            let rootCompany = rootCompanies[i].text;
            let rootCompanyName = rootCompany.substr(0, rootCompany.indexOf('#'));
            let rootCompanyOrgType = rootCompany.substr(rootCompany.indexOf('#') + 1, rootCompany.length - 1);
            rootCompanyDict[rootCompanyName] = rootCompanyOrgType;
            // Replace text name in dropdown
            rootCompanies[i].text = rootCompanyName;
            rootCompanies[i].classList.add(rootCompanyOrgType + "RootCompany");
        }
    }

    function filterRootCompanies() {
        let rootOrgType = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drproot_org_type') || document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_lblroot_org_type');
        let rootOrgTypeValue = rootOrgType.value || rootOrgType.textContent;
        let rootCompanies = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drproot_company');
        let selectedRootCompany = rootCompanies.options[rootCompanies.selectedIndex];
        // Filter the dropdown by using rootCompanyDict
        for (let i = 0; i < rootCompanies.length; i++) {
            let rootCompany = rootCompanies[i];
            if (!(rootCompany.classList.contains(rootOrgTypeValue + "RootCompany"))) {
                rootCompany.style.display = 'none';
            }
            else {
                rootCompany.style.display = 'initial';
                if (rootOrgTypeValue == "host") {
                    if (rootCompany.text == "Waterworks" && rootCompany.classList.contains("hostRootCompany")) {
                        rootCompany.selected = "selected";
                    }
                }
                else {
                    if (rootCompany.text == "Dayton Grey Corp" && rootCompany.classList.contains("clientRootCompany")) {
                        rootCompany.selected = "selected";
                    }
                }
            }
        }
        // Maintain the selected value if it exists in the filtered set
        for (let i = 0; i < rootCompanies.length; i++) {
            if (rootCompanies[i].style.display != 'none') {
                if (selectedRootCompany == rootCompanies[i]) {
                    selectedRootCompany.selected = "selected";
                    break;
                }
            }
        }
        filterParentOrganizations();
    }

    let parentOrganization2DArray = [];

    function generateParentOrganizations() {
        let parentOrganizations = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpparent_organization');
        // Store parent organization names, root companies, and root org types into an array
        for (let i = 1; i < parentOrganizations.length; i++) {
            let parentOrganization = parentOrganizations[i].text;
            parentOrganization2DArray[i - 1] = parentOrganization.split('#');
            // Replace text name in dropdown
            parentOrganizations[i].text = parentOrganization2DArray[i - 1][0];
            parentOrganizations[i].classList.add(parentOrganization2DArray[i - 1][2] + "ParentOrganization");
        }
    }

    // Filter parent_organization dropdown dynamically to only show parent orgs with the same root_company as the one chosen.
    function filterParentOrganizations() {
        let rootOrgType = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drproot_org_type') || document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_lblroot_org_type');
        let rootOrgTypeValue = rootOrgType.value || rootOrgType.textContent;
        let rootCompanies = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drproot_company');
        let rootCompany = rootCompanies.options[rootCompanies.selectedIndex];
        let parentOrganizations = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpparent_organization');
        let selectedParent = parentOrganizations.value;
        for (let i = 1; i < parentOrganizations.length; i++) {
            let parentOrganization = parentOrganizations[i];
            if (parentOrganization2DArray[i - 1][1] != rootCompany.value || !(parentOrganization.classList.contains(rootOrgTypeValue + "ParentOrganization"))) {
                parentOrganization.style.display = 'none';
            }
            else {
                parentOrganization.style.display = 'initial';
            }
        }
        // Maintain selected value if it exists in the filtered set
        for (let i = 0; i < parentOrganizations.length; i++) {
            if (parentOrganizations[i].style.display != 'none') {
                if (selectedParent == parentOrganizations[i].value) {
                    selectedParent.selected = "selected";
                    break;
                }
            }
            parentOrganizations[0].selected = "selected";
        }
    }

    let leadEmployee2DArray = [];

    function generateLeadEmployees() {
        let leadEmpoyees = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drplead_employee');
        // Store lead employee names and org IDs into an array
        for (let i = 1; i < leadEmpoyees.length; i++) {
            let leadEmployee = leadEmpoyees[i].text;
            leadEmployee2DArray[i - 1] = leadEmployee.split('#');
            // Replace text name in dropdown
            leadEmpoyees[i].text = leadEmployee2DArray[i - 1][0];
        }
    }

    // Filter lead_employee dropdown to only show lead employees with the same or_id as the parent organization chosen.
    function filterLeadEmployees() {
        // Get parent organization select value
        let parentOrganizations = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drpparent_organization');
        let parentOrganization = parentOrganizations.options[parentOrganizations.selectedIndex];
        let leadEmployees = document.getElementById('ctl00_ContentPlaceHolder1_fvUpdate_drplead_employee');
        if (parentOrganization == parentOrganizations[0]) {
            for (let i = 1; i < leadEmployees.length; i++) {
                leadEmployees[i].style.display = 'none';
            }
        }
        else {
            let selectedEmployee = leadEmployees.value;
            for (let i = 1; i < leadEmployees.length; i++) {
                let leadEmployee = leadEmployees[i];
                if (leadEmployee2DArray[i - 1][1] != parentOrganization.value) {
                    leadEmployee.style.display = 'none';
                }
                else {
                    leadEmployee.style.display = 'initial';
                }
            }
            // Maintain selected value if it exists in the filtered set
            for (let i = 0; i < leadEmployees.length; i++) {
                if (leadEmployees[i].style.display != 'none') {
                    if (selectedEmployee == leadEmployees[i].value) {
                        selectedEmployee.selected = "selected";
                        break;
                    }
                }
                leadEmployees[0].selected = "selected";
            }
        }
    }
</script>

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<%-- Tab Container with buttons to select between host and client organization tabs. --%>
<asp:TabContainer ID="tcMain" runat="server" Height="10px" Width="100%" ActiveTabIndex="0" CssClass="amber_tab" OnActiveTabChanged ="TabContainer_ActiveTabChanged" AutoPostBack  ="true">
    <asp:TabPanel ID="Tp1" runat="server" HeaderText ="Host Organizations">
        <ContentTemplate >
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button ID="btnNewOrganization1" runat="server" Text='New Organization'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click" class="Pointer"></asp:Button>
                </ContentTemplate>
            </asp:UpdatePanel>
                <%}%>
        </ContentTemplate>
    </asp:TabPanel>
    <asp:TabPanel ID="Tp2" runat="server" HeaderText="Client Organizations">
        <ContentTemplate>
            <% if (Session["Role"].Equals("Admin"))
                {%>
            <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Button ID="btnNewOrganization2" runat="server" Text='New Organization'  style ="display: block;  width:103px; font-size:12px" OnClick ="btn_Click" class="Pointer"></asp:Button>
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
            <asp:GridView ID="gvTable" runat="server" Caption="Host Organizations" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsOrgConfigGrid" 
               EmptyDataText="No Client currently available" Height="100%" Width="100%"
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
                    <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                    <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                    <asp:BoundField DataField="root_company" HeaderText="Root Company" SortExpression="root_company" />
                    <asp:BoundField DataField="parent_organization" HeaderText="Parent Organization" SortExpression="parent_organization" />
                    <asp:BoundField DataField="lead_employee" HeaderText="Lead Employee" SortExpression="lead_employee" />
                    <%--<asp:BoundField DataField="root_org_type" HeaderText="Root Organization Type" SortExpression="root_org_type" />--%>
                </Columns>
             </asp:GridView>  
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsOrgConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
          DeleteCommand="Update `Organization` set status='removed' WHERE `Organization`.id=?" 
       SelectCommand="SELECT o.id, o.name, o.status, o.phone, o.email, o.description, o.root_org_type, c.name as root_company, o1.name as parent_organization, concat(e.firstname,' ',e.lastname) as lead_employee
  FROM Organization o
  LEFT JOIN Employee e ON e.id = o.lead_employee
  LEFT JOIN Organization o1 ON o1.id = o.parent_organization
  LEFT JOIN Company c ON c.id = o.root_company 
  WHERE o.root_org_type = 'host' ">
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
       
       <asp:FormView ID="fvUpdate" runat="server" DataSourceID="sdsOrgConfig"
       EnableTheming="True" Height="100%" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" >
           <ItemTemplate>
           </ItemTemplate>
       </asp:FormView>
                  <% if (Session["Role"].Equals("Admin"))
                     {%> 
       <asp:SqlDataSource ID="sdsOrgConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="SELECT id, name, status, phone, email, description, root_org_type, parent_organization, root_company, lead_employee
           FROM Organization
           WHERE id = ?" >

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