<%@ Page Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="ezMESWeb.ContactUs" Title="Contact/Feedback -- ezOMM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<!-- <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<asp:Button ID="btnInsert" runat="server" Text="Add Feedback" Width="147px" OnClick="btn_Click"/> 
               
 <asp:panel id="pnlScroll" runat="server" width="100%" 
height="90%">   
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
       <ContentTemplate>
           <asp:GridView ID="gvTable" runat="server" Caption="Feedbacks for ezOMM" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsFeedbackGrid" 
               EmptyDataText="No feedbacks so far." Height="145px" Width="100%"
               AutoGenerateColumns="False"  
               onselectedindexchanged="gvTable_SelectedIndexChanged" 
                DataKeyNames="id" AllowPaging="True"  AllowSorting="True" 
               EnableTheming="False" 
    onpageindexchanged="gvTable_PageIndexChanged"
             >
               <SelectedRowStyle  BackColor="#FFFFCC"/>
               <Columns>
                   <asp:TemplateField>
                       <ItemTemplate>
                           <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" 
                       CommandName="Select" />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:BoundField DataField="subject" HeaderText="Subject" 
                    SortExpression="subject" >
                       <ControlStyle Width="15%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="create_time" HeaderText="Create Time" 
                    SortExpression="create_time" >
                       <ControlStyle Width="8%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="noter" HeaderText="Issuer" SortExpression="noter" >
                       <ControlStyle Width="6%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="last_noter" HeaderText="Last Updated By" 
                    SortExpression="last_noter" >
                       <ControlStyle Width="6%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="last_note_time" HeaderText="Last Update Time" 
                    SortExpression="last_note_time" >
                       <ControlStyle Width="8%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="contact_info" HeaderText="Additional Contact Info" 
                    SortExpression="contact_info" >
                       <ControlStyle Width="10%" />
                   </asp:BoundField>
                   <asp:BoundField DataField="note" HeaderText="Feedback" SortExpression="note" >
                       <ControlStyle Width="50%" />
                   </asp:BoundField>
               </Columns>
           </asp:GridView>
           
       </ContentTemplate>
              </asp:UpdatePanel> 
             <div style="background-color:Beige; font-style:italic; padding:10px 5px 5px 10px;">You may also contact AmberSoft, LLC at: <a href="mailto:info@ambersoftsys.com">info@ambersoftsys.com</a>, 203-702-0623</div> 
              
       <asp:SqlDataSource ID="sdsFeedbackGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
           SelectCommand="select f.id, 
                         f.create_time, 
                         f.noter_id,
                         concat(e1.firstname, ' ', e1.lastname) as noter,
                         f.subject,
                         f.contact_info,
                         f.last_noter_id,
                         concat(e2.firstname, ' ', e2.lastname) as last_noter,
                         f.last_note_time,
                         f.note,
                         f.response
                    FROM feedback f
                    LEFT JOIN employee e1 ON e1.id = f.noter_id
                    LEFT JOIN employee e2 ON e2.id = f.last_noter_id">
       </asp:SqlDataSource>
       
        <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:330px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateRecordPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
         <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsFeedbackConfig"
       EnableTheming="True" Height="100px" HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
          <asp:SqlDataSource ID="sdsFeedbackConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       EnableCaching="false"
       ProviderName="System.Data.Odbc" 
       SelectCommand="Select  subject, contact_info, note FROM feedback WHERE id=?" 
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
-->
 <div style="padding-left:5px;">
    <p style="padding-bottom:10px; font-size:14px; font-weight:bold">
      From:<br />
      <asp:TextBox ID="txtContact" runat="server" Columns="35" /></p>
    
    <p style="padding-bottom:10px; font-size:14px; font-weight:bold">
      Subject:<br />
      <asp:TextBox ID="txtSubject" runat="server" Columns="50" /></p>
    <p style="padding-bottom:10px; font-size:14px; font-weight:bold">
      Body:<br />
      <asp:TextBox ID="txtBody" runat="server" Columns="75" TextMode="MultiLine" Rows="6" /></p>
    <p style="padding-bottom:10px; font-size:14px; font-weight:bold">
      <asp:Button ID="btnSend" runat="server" Text="Send Mail" OnClick="btn_Send" /></p>
  </div>
  <br />
  <br />
  <asp:label id="lblResults" runat="server"  ForeColor="Red" Visible="false">Results:</asp:label>&nbsp;<br />
   
</asp:Content>
 