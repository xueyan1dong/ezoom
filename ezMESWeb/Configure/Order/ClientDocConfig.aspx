<%@ Page Language="C#" MasterPageFile="../../Tracking/TrackingModule.Master" AutoEventWireup="true" CodeBehind="ClientDocConfig.aspx.cs" Inherits="ezMESWeb.Configure.Client.ClientDocConfig" Title="Client Documents Association -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


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
<table border = 0><tr><td class="style19">Client:</td><td><asp:DropDownList ID="dpClient" 
        runat="server" Width="168px" Height="30px" AutoPostBack="True" 
        onselectedindexchanged="dpClient_SelectedIndexChanged">
    </asp:DropDownList></td></tr>
    <tr><td colspan =2>&nbsp;</td></tr>
<tr><td colspan=2><asp:Button ID="btnInsert" runat="server" Text="Add Document" 
        Width="147px" OnClick="btn_Click"/> </tr>
 </table>              
<table style="width: 100%; height: 423px; margin-right: 0px; margin-top: 0px; border : 2px solid #6FBD06; ">
      <tr>
         <td style="height: 117px; width: 353px;">
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <asp:GridView ID="gvTable" runat="server" Caption="Document(s) Related to Client" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsClientDocConfigGrid" 
               EmptyDataText="No Client currently available" Height="145px" Width="500px"
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
                    DataKeyNames="id" AllowPaging="True"  AllowSorting="True" PageSize="15" 
               EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                <Columns>
                  <asp:TemplateField><ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate></asp:TemplateField>

                    <asp:BoundField DataField="key_words" HeaderText="Key Words" ReadOnly="True" 
                        SortExpression="key_words" />
                    <asp:BoundField DataField="title" HeaderText="Title" ReadOnly="True" 
                        SortExpression="title" />
                    <asp:BoundField DataField="path" HeaderText="Path" SortExpression="path" />
                    <asp:BoundField DataField="version" HeaderText="Version" 
                        SortExpression="version" />
                    <asp:BoundField DataField="contact" HeaderText="Contact" 
                        SortExpression="contact" />
                    <asp:BoundField DataField="recorder" HeaderText="Recorder" 
                        SortExpression="recorder" />
                    <asp:BoundField DataField="record_time" HeaderText="Record Time" 
                        SortExpression="record_time" />
                    <asp:BoundField DataField="updated_by" HeaderText="Last Updated By" 
                        SortExpression="updated_by" />
                    <asp:BoundField DataField="update_time" HeaderText="Update Time" 
                        SortExpression="update_time" />
                    <asp:BoundField DataField="description" HeaderText="Description" 
                        SortExpression="description" />
                    <asp:BoundField DataField="comment" HeaderText="Comment" 
                        SortExpression="comment" />
                </Columns>
                <SelectedRowStyle  BackColor="#FFFFCC"/>
             </asp:GridView>
             </ContentTemplate>
              </asp:UpdatePanel> 
              
       <asp:SqlDataSource ID="sdsClientDocConfigGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM `document` WHERE id=?" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="  SELECT d.id, d.key_words, 
         d.title, path, 
         d.`version`, 
         concat(e.firstname, ' ', e.lastname) as contact,
         concat(e1.firstname, ' ', e1.lastname) as recorder,
         d.record_time,
         concat(e2.firstname, ' ', e2.lastname) as updated_by,
         d.update_time,
         d.description,
         d.comment
   FROM document d INNER JOIN employee e ON e.id = d.contact_id
        INNER JOIN employee e1 ON e1.id = d.recorder_id
        LEFT JOIN employee e2 ON e2.id = d.updated_by
   WHERE d.source_table = 'client'
     AND d.source_id = ?"     
       InsertCommand="modify_client" InsertCommandType="StoredProcedure">
           <SelectParameters>
               <asp:ControlParameter ControlID="dpClient" DefaultValue="0" Name="clientid" 
                   PropertyName="SelectedValue" />
           </SelectParameters>

        </asp:SqlDataSource>
        
        <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:350px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateRecordPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="ModalPopupExtender" runat="server" TargetControlID="btnShowPopup"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsClientDocConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsClientDocConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  
       SelectCommand="Select  key_words,  title, path,   
       version,  contact_id as contact,   
       description, comment 
       From document 
       WHERE source_table='client'
         AND id = ?" 
        >
         <SelectParameters>
            <asp:ControlParameter ControlID="gvTable" Name="vid" 
            PropertyName="SelectedValue" Type="int32" />
            
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
 
      </td>
       </tr>
       <tr>
        <td style="width: 353px">
           &nbsp;</td>
        </tr>               
  </table>
    
</asp:Content>
