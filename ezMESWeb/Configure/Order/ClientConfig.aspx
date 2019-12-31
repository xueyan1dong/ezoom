<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.Master" AutoEventWireup="true" CodeBehind="ClientConfig.aspx.cs" Inherits="ezMESWeb.Configure.Client.ClientConfig" Title="Client Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>


<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />

<asp:Button ID="btnInsert" runat="server" Text="Insert" Width="147px" OnClick="btn_Click"/> 
               
 <asp:panel id="pnlScroll" runat="server" width="100%" scrollbars="Horizontal"> 
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            
             <table width="100%"><tr style="height:30px;">
			<td align="center">
				<asp:label id="title" runat="server"><b>Clients</b></asp:label>
            </td></tr>
          </table>    
            
            <asp:CoolGridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" DataSourceID="sdsClientConfigGrid" 
               EmptyDataText="No Client currently available" 
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" EnablePersistedSelection="true"
               onselectedindexchanged="gvTable_SelectedIndexChanged"  DataKeyNames="name,id" AllowPaging="True"  AllowSorting="True" PageSize="15" Width="100%" Height="100%" AllowResizeColumn="true" 
               PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast" 
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                <SelectedRowStyle  BackColor="#FFFFCC"/>
                 <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
                   <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                        <RowStyle CssClass="GridRowStyle" />
                <Columns>
                  <asp:TemplateField><ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate></asp:TemplateField>
                    <asp:BoundField DataField="name" HeaderText="Name" ReadOnly="True" SortExpression="name" />
                    <asp:BoundField DataField="type" HeaderText="Type" ReadOnly="True" SortExpression="type" />
                    <asp:BoundField DataField="internal_contact_name" HeaderText="Internal Contact"
                        SortExpression="internal_contact_name" />
                    <asp:BoundField DataField="company_phone" HeaderText="Company Ph#" SortExpression="company_phone" />
                    <asp:HyperLinkField DataNavigateUrlFields="id" 
                        DataNavigateUrlFormatString="ClientDocConfig.aspx?clientid={0}" 
                        DataTextField="numdoc" DataTextFormatString="{0}" HeaderText="Num of Doc(s)" />                    
                    <asp:BoundField DataField="wAddress" 
                        HeaderText="Address" SortExpression="wAddress">
                        
                    </asp:BoundField>
                    <asp:BoundField DataField="wAddress2" HeaderText="Address 2" SortExpression="wAddress2" />
                    <asp:BoundField DataField="contact_person1" 
                        HeaderText="Contact&lt;br /&gt;Person 1"  HtmlEncode="false" 
                        SortExpression="contact_person1" />
                    <asp:BoundField DataField="contact_person2" HeaderText="Contact<br />Person 2" HtmlEncode="false" SortExpression="contact_person2" />
                    <asp:BoundField DataField="person1_workphone" HeaderText="Person 1 Workphone" SortExpression="person1_workphone" />
                    <asp:BoundField DataField="person1_cellphone" HeaderText="person 1 Cellphone" SortExpression="person1_cellphone" />
                    <asp:BoundField DataField="person1_email" HeaderText="Person 1 Email" SortExpression="person1_email" />
                    <asp:BoundField DataField="person2_workphone" HeaderText="Person 2 Workphone" SortExpression="person2_workphone" />
                    <asp:BoundField DataField="person2_cellphone" HeaderText="Person 2 Cellphone" SortExpression="person2_cellphone" />
                    <asp:BoundField DataField="person2_email" HeaderText="Person 2 Email" SortExpression="person2_email" />
                    <asp:BoundField DataField="firstlistdate" HeaderText="First List Date" HtmlEncode="false" SortExpression="firstlistdate" />
                    <asp:BoundField DataField="ifactive" HeaderText="If Active" SortExpression="ifactive" />
                    <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment" />
                </Columns>
             </asp:CoolGridView>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsClientConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM `client` WHERE `client`.name = ? and `client`.id = ?" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="Select  c.id, c.name, c.type, c.internal_contact_id, employee.firstname ||' '||employee.lastname as internal_contact_name,
       company_phone,  address,   city,   state,  zip,   country,  
       address || '\n' ||city ||' '||state ||' ' || zip ||'\n' || country as wAddress,
       address2,  city2,   state2,  zip2, 
       address2 || '\n' ||city2 ||' '||state2 ||' ' || zip2 as wAddress2,
       contact_person1,   
       contact_person2, person1_workphone, 
       person1_cellphone, person1_email, 
       person2_workphone, person2_cellphone, 
       person2_email, firstlistdate,  if(ifactive=1,'Y','N') as ifactive,  c.comment,count(d.id) as numdoc From client c
       INNER JOIN employee ON c.internal_contact_id = employee.id LEFT JOIN document d ON d.source_id = c.id AND d.source_table = 'client' GROUP BY c.id"     
       InsertCommand="modify_client" InsertCommandType="StoredProcedure">
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsClientConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsClientConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc" InsertCommand="Insert"
       EnableCaching="false"
       SelectCommand="Select  name,  type, internal_contact_id,   
       company_phone,  address,   
       city,   state, zip,   
       country,  address2,  city2,   
       state2,  zip2, contact_person1,   
       contact_person2, person1_workphone, 
       person1_cellphone, person1_email, 
       person2_workphone, person2_cellphone, 
       person2_email, firstlistdate, ifactive, comment 
       From client where client.name = ? and client.id = ?" 
        >
         <SelectParameters>
            <asp:ControlParameter ControlID="gvTable" Name="vName" 
            PropertyName="SelectedPersistedDataKey.Values[name]" Type="String" />
            <asp:ControlParameter ControlID="gvTable" Name="id" 
            PropertyName="SelectedPersistedDataKey.Values[id]" />
            
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
 
               
  </asp:Panel>
    
</asp:Content>
