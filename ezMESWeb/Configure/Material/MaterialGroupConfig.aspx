<%@ Import Namespace="System.Data" %>

<%@ Page Language="C#" MasterPageFile="~/Configure/ConfigureModule.master" AutoEventWireup="true" CodeBehind="MaterialGroupConfig.aspx.cs" Inherits="ezMESWeb.Configure.Material.MaterialGroupConfig" Title="Material Group Configuration -- ezOOM" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="IdeaSparx.CoolControls.Web" Namespace="IdeaSparx.CoolControls.Web" TagPrefix="asp" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<asp:Button ID="btnInsert" runat="server" Text="Insert" Width="147px" OnClick="btn_Click"/> 

 <asp:panel id="pnlScroll" runat="server" width="900px"
scrollbars="Horizontal">   
   <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <table width="100%">
            <tr style="height:30px;"> 
            <td align="center">
            <asp:label id="title" runat="server"><b>Item/Part Groups</b></asp:label>
            </td>
            </tr>
            </table>

             <asp:CoolGridView ID="gvTable" runat="server" Caption="" 
               CssClass="GridStyle" GridLines="None" DataSourceID="sdsGrid" 
               EmptyDataText="No item group currently available" 
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="id" AllowPaging="True"  AllowSorting="false" PageSize="15" EnableTheming="False"
               Width="860px" Height="480px" AllowResizeColumn="true" 
               PagerStyle-BackColor="#f2e8da" PagerSettings-Mode="NumericFirstLast"  
               onpageindexchanged="gvTable_PageIndexChanged"
             >
             <Columns>
               <asp:TemplateField>
               <ItemTemplate>
			       <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			     </ItemTemplate>
				 </asp:TemplateField>	
              
                 <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" SortExpression="id" />
                 <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                 <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description">
                 <HeaderStyle Width="300px" /></asp:BoundField>
                 <asp:BoundField DataField="comment" HeaderText="Comment" SortExpression="comment">
                 <HeaderStyle Width="160px" /> </asp:BoundField>
                   	
			   </Columns>
               <SelectedRowStyle  BackColor="#FFFFCC"/>
                 <BoundaryStyle BorderColor="Gray" BorderWidth="1px" BorderStyle="Solid"></BoundaryStyle>
                 <AlternatingRowStyle CssClass="GridAlternateRowStyle" />
                 <RowStyle CssClass="GridRowStyle" />
                        
                </asp:CoolGridView>
               </ContentTemplate>
              </asp:UpdatePanel> 
                    </asp:panel>        
       <asp:SqlDataSource ID="sdsGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM material_group WHERE id=?" 
           ProviderName="System.Data.Odbc" 
       SelectCommand="SELECT id, name, description, comment FROM material_group" >
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
        
       <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsConfig"
       EnableTheming="True" Height="100px" 
       HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333" 
       >      
       </asp:FormView>
       
       <asp:SqlDataSource ID="sdsConfig" runat="server" 
       ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
       ProviderName="System.Data.Odbc"  
       EnableCaching="false"
       SelectCommand="SELECT name,
                             description,
                             comment 
                        FROM material_group
                       WHERE id = ?" 
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
  
</asp:Content>
