<%@ Page Language="C#" MasterPageFile="../ConfigureModule.master" AutoEventWireup="true" CodeBehind="PurchaseOrderConfig.aspx.cs" Inherits="ezMESWeb.Configure.Order.PurchaseOrderConfig"
 Title="Purchase Order Configuration -- ezOOM" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 

 <script type="text/javascript" language="javascript">
  function reloadContent(sender, e)
  {
    window.location="PurchaseOrderConfig.aspx?Tab="+sender.get_activeTabIndex()
  }
  function confirmDelete(button)
  {
    if (button.value == "Delete Order")
        return confirm("Do you really what to delete this order?");
  }
  
  function updateUOMLabel(sender)
  {
  //this function allow to update UOM label besides quantity box
  //according to selected material or product.
    var stub = sender.name;
    stub = stub.replace(/\$/g, '_');
    var uomDropdown;
    var uomBox;

    stub = stub.substring (0,stub.length-10);  
    uomDropdown = document.getElementById(stub + 'ddUom');
    uomBox = document.getElementById(stub+'lblUom');
    uomBox.innerHTML = uomDropdown.options[sender.selectedIndex].value;
    
  }

</script> 
</asp:content> 

<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <asp:TabContainer ID="tcMain" runat="server" 
        Height="0px" Width="100%" CssClass="amber_tab" 
        onclientactivetabchanged="reloadContent" >
    </asp:TabContainer>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" 
        EnableScriptGlobalization="True" />
<table style="width: 100%; height: 423px; margin-right: 0px; margin-top: 0px; border : 2px solid #6FBD06; ">
      <tr>
      <td style="width: 100%;">
          
          <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional" >
              <ContentTemplate>
              <table border="0" width="100%">
                 <tr>
                   <td style="height: 200px; width: 100%;">
                  <asp:FormView ID="fvMain" runat="server" DataKeyNames="id" 
                      DataSourceID="sdsMain" BorderStyle="Groove" 
                 CssClass="detailgrid" BorderWidth="2px" Caption='General Purchase Order Information' 
                           Width ="600px">
                      <EditItemTemplate>
                      <table border=0 width="100%">
                          <tr>
                          <td>Client:</td>
                           <td><asp:DropDownList ID="ddClient" runat="server" 
                             DataSourceID="sdsClient" DataTextField="name" DataValueField="id"
                             Width="200px">
                         </asp:DropDownList>   
                         <asp:Label ID="lblClient" runat="server" Text='<%#Eval("client_id") %>' Visible="False"></asp:Label>
                         </td>
                          <td>PO Number:</td>                     
                          <td><asp:TextBox ID="poTextBox" runat="server" Text='<%# Eval("ponumber") %>' /></td>
                          </tr>
                          <tr>
                           <td>State:</td>
                           <td><asp:DropDownList ID="ddStateu" runat="server" 
                             Width="200px">
                               <asp:ListItem Value="quoted">Quoted</asp:ListItem>
                               <asp:ListItem>POed</asp:ListItem>
                               <asp:ListItem Value="scheduled">Scheduled</asp:ListItem>
                               <asp:ListItem Value="produced">Produced</asp:ListItem>
                               <asp:ListItem Value="shipped">Shipped</asp:ListItem>
                               <asp:ListItem Value="delivered">Delivered</asp:ListItem>
                               <asp:ListItem Value="invoiced">Invoiced</asp:ListItem>
                               <asp:ListItem Value="paid">Paid</asp:ListItem>
                               </asp:DropDownList> 
                           <asp:Label ID='lblState' runat="server" Text='<%#Eval("state") %>' Visible="False"></asp:Label>
                           </td>
                          <td>Date of the State:</td>                     
                          <td><asp:TextBox ID="dateTextBox" runat="server" Text='<%#Eval("state_date") %>' />
                          <asp:CalendarExtender ID="date1_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="dateTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                          </td>                           
                          </tr>
                          <tr>
                          <td>Priority:</td>
                          <td><asp:DropDownList ID="ddPriority" runat="server" 
                             DataSourceID="sdsPriority" DataTextField="name" DataValueField="id"
                             Width="200px">
                         </asp:DropDownList>
                         <asp:Label ID="lblPriority" runat="server" Text='<%#Eval("priority") %>' Visible="False"></asp:Label>
                         </td>
                          <td>Net Total Price($):</td>                     
                          <td><asp:TextBox ID="netTotalTextBox" runat="server" Text='<%# Eval("net_total") %>' /></td>                       
                          </tr>
                          <tr>
                          <td>Tax Percentage(%):</td>                     
                          <td><asp:TextBox ID="taxpTextBox" runat="server" Text='<%# Eval("tax_percentage") %>' /></td> 
                          <td>Tax Amount($):</td>                     
                          <td><asp:TextBox ID="taxmTextBox" runat="server" Text='<%# Eval("tax_amount") %>' /></td>                         
                          </tr>
                          <tr>
                          <td>Other Fees($):</td>                     
                          <td><asp:TextBox ID="feeTextBox" runat="server" Text='<%# Eval("other_fees") %>' /></td> 
                          <td>Total Price($):</td>                     
                          <td><asp:TextBox ID="totalTextBox" runat="server" Text='<%# Eval("total_price") %>' /></td>                         
                          </tr>
                          <tr>
 
                          <td>Expected Delivery Date:</td>                     
                          <td><asp:TextBox ID="expectedTextBox" runat="server" Text='<%# Eval("expected_deliver_date") %>' />
                          <asp:CalendarExtender ID="expected_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="expectedTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                          </td>                            
                           <td>Internal Contact:</td> 
                          <td><asp:DropDownList ID="ddInternal" runat="server" 
                               DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList>
                           <asp:Label ID="lblInternal" runat="server" Text='<%#Eval("internal_contact") %>' Visible="False"></asp:Label>
                           </td>                    
                          </tr>
                          <tr>
                          <td>External Contact:</td>
                          <td><asp:TextBox ID="externalTextBox" runat="server" Text='<%# Eval("external_contact") %>' /></td> 
                          <td>Comment:</td>
                          <td><asp:TextBox ID="commentTextBox" runat="server" TextMode="MultiLine" 
                                  Height="50px" Width="200px" Text='<%# Eval("comment") %>' /></td>
                          </tr>
                         </table>
                      </EditItemTemplate>
                      <InsertItemTemplate>
                      <table border=0 width="100%">
                          <tr>
                          <td>Client:</td>
                           <td><asp:DropDownList ID="ddClient" runat="server" 
                             DataSourceID="sdsClient" DataTextField="name" DataValueField="id"
                             Width="200px">
                         </asp:DropDownList>   
                         </td>
                          <td>PO Number:</td>                     
                          <td><asp:TextBox ID="poTextBox" runat="server" /></td>
                          </tr>
                           <tr>
                           <td>State:</td>
                           <td><asp:DropDownList ID="ddStatei" runat="server" 
                             Width="200px">
                               <asp:ListItem Value="quoted">Quoted</asp:ListItem>
                               <asp:ListItem>POed</asp:ListItem>
                               <asp:ListItem Value="scheduled">Scheduled</asp:ListItem>
                               <asp:ListItem Value="produced">Produced</asp:ListItem>
                               <asp:ListItem Value="shipped">Shipped</asp:ListItem>
                               <asp:ListItem Value="delivered">Delivered</asp:ListItem>
                               <asp:ListItem Value="invoiced">Invoiced</asp:ListItem>
                               <asp:ListItem Value="paid">Paid</asp:ListItem>
                               </asp:DropDownList> 
                           </td>
                          <td>Date of the State:</td>                     
                          <td><asp:TextBox ID="dateTextBox" runat="server" />
                              <asp:CalendarExtender ID="dateTextBox_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="dateTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                              </asp:CalendarExtender>
                               </td>                           
                          </tr>
                          <tr>
                          <td>Priority:</td>
                          <td><asp:DropDownList ID="ddPriority" runat="server" 
                             DataSourceID="sdsPriority" DataTextField="name" DataValueField="id"
                             Width="200px">
                         </asp:DropDownList>
                         </td>
                          <td>Net Total Price($):</td>                     
                          <td><asp:TextBox ID="netTotalTextBox" runat="server" /></td>                       
                          </tr>
                          <tr>
                          <td>Tax Percentage(%):</td>                     
                          <td><asp:TextBox ID="taxpTextBox" runat="server" /></td> 
                          <td>Tax Amount($):</td>                     
                          <td><asp:TextBox ID="taxmTextBox" runat="server" /></td>                         
                          </tr>
                          <tr>
                          <td>Other Fees($):</td>                     
                          <td><asp:TextBox ID="feeTextBox" runat="server" /></td> 
                          <td>Total Price($):</td>                     
                          <td><asp:TextBox ID="totalTextBox" runat="server" /></td>                         
                          </tr>
                         <tr>
                          <td>Expected Delivery Date:</td>                     
                          <td><asp:TextBox ID="expectedTextBox" runat="server" />
                          <asp:CalendarExtender ID="expected_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="expectedTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                          </td>                            
                           <td>Internal Contact:</td> 
                          <td><asp:DropDownList ID="ddInternal" runat="server" 
                               DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList>
                           </td>                    
                            
                          </tr>
                          <tr>
                          <td>External Contact:</td>
                          <td><asp:TextBox ID="externalTextBox" runat="server" /></td> 
                          <td>Comment:</td>
                          <td><asp:TextBox ID="commentTextBox" runat="server" TextMode="MultiLine" 
                                  Height="50px" Width="200px" /></td>
                          </tr>
                          
                      </table>
                      </InsertItemTemplate>
                      <ItemTemplate>
                      <table border=0 width="100%">
                        <tr>
                          <td width="15%">Client:</td>
                          <td width="35%"><asp:Label ID="clientLabel" runat="server" Text='<%# Bind("client_name") %>' /></td>
                          <td>PO Number:</td>   
                          <td>
                          <asp:Label ID="ponumberLabel" runat="server" 
                              Text='<%# Bind("ponumber") %>' />
                          </td>                          
                        </tr>
                        <tr>

                          <td>Priority:</td>
                          <td><asp:Label ID="priorityLabel" runat="server" Text='<%# Bind("priority_name") %>' />
                          </td>
                          <td>Current State:</td>
                          <td>
                          <asp:Label ID="lblState" runat="server" Text='<%# Bind("state") %>' />
                          </td>
                        </tr>
                        <tr>
                          <td>Net Total Price($):</td>
                          <td>
                          <asp:Label ID="netTotalLabel" runat="server" Text='<%# Bind("net_total") %>' />
                          </td>

                          <td>Tax Percentage(%):</td>
                          <td><asp:Label ID="percentageLabel" runat="server" 
                              Text='<%# Bind("tax_percentage") %>' />
                          </td>
                        </tr>
                        <tr>                          
                          <td>Tax Amount($):</td>
                          <td><asp:Label ID="amountLabel" runat="server" Text='<%# Bind("tax_amount") %>' />
                          </td>
                          <td>Other Fees($):</td>
                          <td><asp:Label ID="feesLabel" runat="server" 
                              Text='<%# Bind("other_fees") %>' />
                          </td>
                        </tr>
                        <tr>                          
                          <td>Total Price($):</td>
                          <td><asp:Label ID="totalLabel" runat="server" 
                              Text='<%# Bind("total_price") %>' />
                          </td>

                          <td>Order Date:</td>
                          <td><asp:Label ID="orderDateLabel" runat="server" 
                              Text='<%# Bind("order_date") %>' />
                          </td>
                        </tr>
                        <tr>                          
                          <td>Expected Delivery Date:</td>
                          <td><asp:Label ID="expectedLabel" runat="server" 
                              Text='<%# Bind("expected_deliver_date") %>' />
                          </td>

                          <td>Internal Contact:</td>
                          <td><asp:Label ID="internalLabel" runat="server" 
                              Text='<%# Bind("internal_contact_name") %>' />
                          </td>
                         </tr>
                        <tr>                         
                          <td>Actual Delivery Date:</td>
                          <td><asp:Label ID="actualLabel" runat="server" 
                              Text='<%# Bind("actual_deliver_date") %>' />
                          </td>

                          <td>External Contact:</td>
                          <td><asp:Label ID="externalLabel" runat="server" 
                              Text='<%# Bind("external_contact") %>' />
                          </td>
                          </tr>
                          <tr>                         
                          <td>Comment:</td>
                          <td colspan=3><asp:Label ID="commentLabel" runat="server" 
                              Text='<%# Bind("comment") %>' />
                          </td>
                        </tr>
                      </table>
                      </ItemTemplate>
                  </asp:FormView>

                    </td>
                  </tr>
                  <tr><td>
                      <asp:Label ID="lblMainError" runat="server" Width="600px" Height="50px" 
                          ForeColor="#CC3300"></asp:Label>
                     <asp:TextBox ID="txtID"
                          runat="server" Visible="False"></asp:TextBox>
                      </td></tr>
                  <tr><td>
                      <asp:Button ID="btnDo" runat="server" 
                          Text="Submit" Height="26px" Width="243px" 
                          onclick="btnDo_Click"   />
                      <asp:Button ID="btnCancel" runat="server" Height="26px" Text="Cancel" 
                          Width="143px" onclick="btnCancel_Click" 
                          onclientclick="return confirmDelete(this)" />
                      </td></tr>
                 </table>
                 
              </ContentTemplate>
              <Triggers>
                  <asp:PostBackTrigger ControlID="btnDo" />
                  <asp:PostBackTrigger ControlID="btnCancel" />
              </Triggers>
          </asp:UpdatePanel>
          </td>
      </tr>
      <tr><td><hr /></td></tr>
      <tr><td>&nbsp;&nbsp;</td></tr>
      <tr>
         <td style="height: 117px; width: 347px;" height="20px">
                     
             <asp:Button ID="btnInsert" runat="server" Text="Add Supply to Order" 
                 Width="147px"  /> 
             <asp:ModalPopupExtender ID="mdlPopup" runat="server" TargetControlID="btnInsert"
             BackgroundCssClass="modalBackground" PopupControlID="InsertPanel" 
              PopupDragHandleControlID="InsertPanel" Drag="True" DropShadow="True" >
             </asp:ModalPopupExtender>
 
           <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
               <ContentTemplate>
                   <asp:GridView ID="gvTable" runat="server" Caption="Ordered Products" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsGrid" 
               EmptyDataText="No supply had been listed in this order." Height="145px" Width="900px"
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="material_id" AllowPaging="True" PageSize="15" 
                    EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                       <Columns>
                       <asp:TemplateField><ItemTemplate>
			           <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			         </ItemTemplate>
			         </asp:TemplateField>
                           <asp:BoundField DataField="material_id" HeaderText="Material Id" 
                     SortExpression="material_id" ReadOnly="True" Visible="False" />
                           <asp:BoundField DataField="material_name" HeaderText="Material" 
                     SortExpression="material_name" />
                           <asp:BoundField DataField="quantity_requested" HeaderText="Requested Quantity" 
                                    SortExpression="quantity_requested" />
                           <asp:BoundField DataField="unit_price" HeaderText="Unit Price ($)" 
                                    SortExpression="unit_price" />
                           <asp:BoundField DataField="quantity_shipped" HeaderText="Quantity Shipped" 
                     SortExpression="quantity_shipped" />
                           <asp:BoundField DataField="uomid" HeaderText="uomid" 
                     SortExpression="uomid" Visible="False" />
                           <asp:BoundField DataField="uom_name" HeaderText="Unit of Measure" 
                               SortExpression="uom_name" />
                           <asp:BoundField DataField="output_date" HeaderText="Output Date" 
                                    SortExpression="output_date" />
                           <asp:BoundField DataField="expected_deliver_date" 
                               HeaderText="Expected Delivery Date" SortExpression="expected_deliver_date" />
                           <asp:BoundField DataField="actual_deliver_date" 
                               HeaderText="Actual Delivery Date" SortExpression="actual_deliver_date" />
                           <asp:BoundField DataField="comment" HeaderText="Comment" 
                               SortExpression="comment" />
                       </Columns>
                       <SelectedRowStyle  BackColor="#ffffcc"/>
                   </asp:GridView>
               </ContentTemplate>
              </asp:UpdatePanel> 
       <asp:SqlDataSource ID="sdsGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="DELETE FROM order_detail WHERE order_id = ? AND source_type = 'material' AND source_id = ?" 
           ProviderName="System.Data.Odbc" 
           SelectCommand=" SELECT o.source_id as material_id,
        m.name AS material_name,
        o.quantity_requested,
        o.unit_price,
        o.quantity_shipped,
        o.uomid,
        u.name AS uom_name,
        DATE_FORMAT(o.output_date, '%m/%d/%Y') AS output_date,
        DATE_FORMAT(o.expected_deliver_date, '%m/%d/%Y') AS expected_deliver_date,
        DATE_FORMAT(o.actual_deliver_date, '%m/%d/%Y') AS actual_deliver_date,
        o.comment
   FROM order_detail o, material m, uom u
  WHERE 
     o.order_id = ? AND
     o.source_type = 'material'
    AND m.id = o.source_id
    AND u.id = o.uomid">
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                   PropertyName="Text" />
           </SelectParameters>
           <DeleteParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="oid" 
                   PropertyName="Text" />
           </DeleteParameters>
       </asp:SqlDataSource>
       
        <asp:Panel ID="UpdatePanel" runat="server" CssClass="detail" style="display:none"
              Height="482px" HorizontalAlign="Left" Width="350px">
       <asp:UpdatePanel ID="updateBufferPanel" runat="server" UpdateMode="Conditional">
           <ContentTemplate>
           <asp:Button id="btnShowPopup" runat="server" style="display:none" />
           <asp:ModalPopupExtender ID="btnUpdate_ModalPopupExtender" runat="server" 
                 PopupControlID="UpdatePanel" PopupDragHandleControlID="UpdatePanel"
                 TargetControlID="btnShowPopup" 
                   BackgroundCssClass="modalBackground" Drag="True" DropShadow="True">
             </asp:ModalPopupExtender>
                 &nbsp; &nbsp;
            <asp:FormView ID="fvUpdate" runat="server" BorderStyle="Groove" 
                 BorderWidth="0px" Caption="Update Selected Product in Order:" 
                 DataKeyNames="material_id" DataSourceID="sdsUpdate" 
                   DefaultMode="Edit" Height="290px" 
                HorizontalAlign="Center" onitemupdated="fvUpdate_ItemUpdated" Width="100%">
                
                     <EditItemTemplate>
                     &nbsp;&nbsp;
                        <asp:Table ID="Table3" runat="server" CssClass="detailgrid">
                            <asp:TableRow ID="TableRow31" runat="server">
                              <asp:TableCell ID="TableCell311" runat="server" Height="25px" HorizontalAlign="Right">
                              Material: 
                              </asp:TableCell>
                              <asp:TableCell ID="TableCell312" runat="server" Height="25px" HorizontalAlign="Left">
                              <asp:Label ID="productLabel1" runat="server" 
                               Text='<%# Bind("material_name") %>' /></asp:TableCell>
                            </asp:TableRow>
                             <asp:TableRow ID="TableRow32" runat="server">
                              <asp:TableCell ID="TableCell321" runat="server" Height="25px" HorizontalAlign="Right">
                              Requested Quantity: 
                              </asp:TableCell>
                                <asp:TableCell ID="TableCell322" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="requestedTextBox" runat="server" 
                                    Text='<%# Bind("quantity_requested") %>' />
                                </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow33" runat="server">
                                <asp:TableCell ID="TableCell331" runat="server" Height="25px" HorizontalAlign="Right">
                                Unit of Measure:</asp:TableCell>
                                <asp:TableCell ID="TableCell332" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:Label ID="uomLabel" runat="server" 
                                    Text='<%# Bind("uom_name") %>' />                    
                                </asp:TableCell>
                            </asp:Tablerow>
                             <asp:TableRow ID="TableRow50" runat="server">
                              <asp:TableCell ID="TableCell501" runat="server" Height="25px" HorizontalAlign="Right">
                              Unit Price ($): 
                              </asp:TableCell>
                                <asp:TableCell ID="TableCell502" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="priceTextBox" runat="server" 
                                    Text='<%# Bind("unit_price") %>' />
                                </asp:TableCell>
                            </asp:TableRow>
                             <asp:TableRow ID="TableRow53" runat="server">
                              <asp:TableCell ID="TableCell531" runat="server" Height="25px" HorizontalAlign="Right">
                              Quantity Shipped: 
                              </asp:TableCell>
                                <asp:TableCell ID="TableCell532" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="shippedTextBox" runat="server" 
                                    Text='<%# Bind("quantity_shipped") %>' />
                                </asp:TableCell>
                            </asp:TableRow>
   
                            <asp:TableRow ID="TableRow34" runat="server">
                                <asp:TableCell ID="TableCell341" runat="server" Height="25px" HorizontalAlign="Right">
                                Output Date:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell342" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="outputTextBox" runat="server" 
                                    Text='<%# Bind("output_date") %>' />
                                  <asp:CalendarExtender ID="output_CalendarExtender" runat="server" 
                                          Enabled="True" TargetControlID="outputTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                                  </asp:CalendarExtender>
                                </asp:TableCell>
                                
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow35" runat="server">
                                <asp:TableCell ID="TableCell351" runat="server" Height="25px" HorizontalAlign="Right">
                                Expected Delivery Date:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell352" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="expectedTextBox" runat="server" 
                               Text='<%# Bind("expected_deliver_date") %>' />
                               <asp:CalendarExtender ID="expected_CalendarExtender" runat="server" 
                                      Enabled="True" TargetControlID="expectedTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                              </asp:CalendarExtender>
                               </asp:TableCell>
                            </asp:TableRow>   
                            <asp:TableRow ID="TableRow36" runat="server">
                                <asp:TableCell ID="TableCell361" runat="server" Height="25px" HorizontalAlign="Right">
                                Actual Delivery Date::
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell362" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="actualTextBox" runat="server" 
                               Text='<%# Bind("actual_deliver_date") %>' />
                                <asp:CalendarExtender ID="actual_CalendarExtender" runat="server" 
                                      Enabled="True" TargetControlID="actualTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                              </asp:CalendarExtender>
                               </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow39" runat="server">
                                <asp:TableCell ID="TableCell391" runat="server" Height="25px" HorizontalAlign="Right">
                                Comment:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell392" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="commentTextBox" runat="server" 
                               Text='<%# Bind("comment") %>' />
                               </asp:TableCell>
                            </asp:TableRow> 
                       </asp:Table>    

                     </EditItemTemplate>
                     <InsertItemTemplate>

                     </InsertItemTemplate>
                     <ItemTemplate>
                     </ItemTemplate>
                 </asp:FormView>
                 &nbsp;&nbsp;
                 <div  align="center">
                    <asp:LinkButton ID="btnSubmitUpdate" runat="server" CausesValidation="True" 
                      OnClick="btnSubmitUpdate_Click" CommandName="Update" Text="Submit" />&nbsp;
                    <asp:LinkButton ID="btnCancelUpdate" runat="server" 
                         CausesValidation="False" CommandName="Cancel" OnClick="btnCancelUpdate_Click"
                         Text="Cancel" />
                 </div>
               <asp:Label ID="lblErrorUpdate" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label>
                 </ContentTemplate>
                 </asp:UpdatePanel>
             </asp:Panel>
             <asp:SqlDataSource ID="sdsUpdate" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
               
                 ProviderName="System.Data.Odbc" 
                 
                 
                 
                 
                 
                 SelectCommand=" SELECT m.name as material_name,
                 m.id as material_id,
        o.quantity_requested,
        o.unit_price,
        o.quantity_made,
        o.quantity_in_process,
        o.quantity_shipped,
        o.uomid,
        u.name as uom_name,
        DATE_FORMAT(o.output_date, '%m/%d/%Y') AS output_date,
        DATE_FORMAT(o.expected_deliver_date, '%m/%d/%Y') AS expected_deliver_date,
        DATE_FORMAT(o.actual_deliver_date, '%m/%d/%Y') AS actual_deliver_date,
        o.comment
   FROM order_detail o, material m, uom u
  WHERE order_id = ?
    AND source_type = 'material'
    AND source_id = ?
    AND m.id = o.source_id
    AND u.id = o.uomid">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="txtID" Name="order_id" 
                         PropertyName="Text" DefaultValue="0" />
                     <asp:ControlParameter ControlID="gvTable" DefaultValue="0" Name="material_id" 
                         PropertyName="SelectedValue" />
                 </SelectParameters>
             </asp:SqlDataSource>
                   <asp:SqlDataSource ID="sdsMain" runat="server" 
                      ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                      ProviderName="System.Data.Odbc" 
                      
                 
                 
                 SelectCommand="   SELECT o.id,
        o.ponumber,
        o.client_id,
        c.name as client_name,
        o.priority,
        r.name as priority_name,
        o.state,
        DATE_FORMAT((SELECT MAX(h2.state_date) FROM order_state_history h2 WHERE h2.order_id = o.id AND h2.state = o.state),'%m/%d/%Y') AS state_date,
        o.net_total,
        o.tax_percentage,
        o.tax_amount,
        o.other_fees,
        o.total_price,
        DATE_FORMAT((SELECT min(h.state_date) FROM order_state_history h WHERE h.order_id = o.id AND h.state='POed'),'%m/%d/%Y') AS order_date,
        DATE_FORMAT(o.expected_deliver_date, '%m/%d/%Y') AS expected_deliver_date,
        (SELECT max(h1.state_date) FROM order_state_history h1 WHERE h1.order_id = o.id AND h1.state='delivered') AS actual_deliver_date,
        o.internal_contact,
        concat (e.firstname, ' ', e.lastname) AS internal_contact_name,
        o.external_contact,
        o.comment
  FROM `order_general` o 
  LEFT JOIN client c ON c.id = o.client_id
  LEFT JOIN employee e ON e.id = o.internal_contact
  LEFT JOIN priority r ON r.id = o.priority
 WHERE o.id=?">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                              PropertyName="Text" />
                      </SelectParameters>
                  </asp:SqlDataSource> 
             <asp:SqlDataSource ID="sdsPriority" runat="server" 
                 SelectCommand="select id, name from priority" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc"></asp:SqlDataSource>
             <asp:SqlDataSource ID="sdsClient" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc" 
                 SelectCommand="select id, name from client where type in ('both', 'supplier')"></asp:SqlDataSource> 
             <asp:SqlDataSource ID="sdsEmployee" runat="server" 
                 SelectCommand="select id, concat(firstname, ' ', lastname) as name from employee" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc">
             </asp:SqlDataSource>
  <asp:Panel   
   ID="InsertPanel" runat="server" Height="460px" CssClass="detail" 
                 style="display:none" Width="350px" 
                 HorizontalAlign="Left" >
             <asp:UpdatePanel ID="insertBufferPanel" runat="server" UpdateMode="Conditional">          
 

          <ContentTemplate>

       <asp:Table ID="Table1" runat="server" BorderWidth="0" Width="100%" Height="398px">
           <asp:TableRow ID="TableRow1" runat="server">
               <asp:TableCell ID="TableCell1" runat="server" Height="30px" HorizontalAlign="Center">
                   Add Supply to Order
               </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow ID="TableRow2" runat="server">
               <asp:TableCell ID="TableCell2" runat="server" HorizontalAlign="Right">
               <asp:Table ID="Table2" runat="server" CssClass="detailgrid">
                   <asp:TableRow ID="TableRow21" runat="server">
                       <asp:TableCell ID="TableCell21" runat="server" Height="25px" HorizontalAlign="Right">
                           Material:</asp:TableCell>
                       <asp:TableCell ID="TableCell22" runat="server" Height="25px"  HorizontalAlign="Left">
                           <asp:DropDownList ID="ddMaterial" runat="server" 
                               Height="25px" Width="166px" OnChange="updateUOMLabel(this)">
                           </asp:DropDownList>                            
                           <asp:DropDownList ID="ddUom" runat="server" style="display:none">
                            </asp:DropDownList>
                       </asp:TableCell>
                   </asp:TableRow>
                   <asp:TableRow ID="TableRow22" runat="server">
                       <asp:TableCell ID="TableCell23" runat="server" Height="25px" HorizontalAlign="Right">
                           Requested Quantity:</asp:TableCell>
                       <asp:TableCell ID="TableCell24" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="requestedTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>
                   <asp:TableRow ID="TableRow23" runat="server">
                        <asp:TableCell ID="TableCell231" runat="server" Height="25px" HorizontalAlign="Right">
                        Unit of Measure:</asp:TableCell>
                        <asp:TableCell ID="TableCell232" runat="server" Height="25px" HorizontalAlign="Left">
                  <asp:Label ID="lblUom" runat="server"></asp:Label>
                        </asp:TableCell>
                    </asp:Tablerow>
                     <asp:TableRow ID="TableRow24" runat="server">
                      <asp:TableCell ID="TableCell241" runat="server" Height="25px" HorizontalAlign="Right">
                      Unit Price ($): 
                      </asp:TableCell>
                        <asp:TableCell ID="TableCell242" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="priceTextBox" runat="server"  />
                        </asp:TableCell>
                    </asp:TableRow>
                     <asp:TableRow ID="TableRow27" runat="server">
                      <asp:TableCell ID="TableCell271" runat="server" Height="25px" HorizontalAlign="Right">
                      Quantity Shipped: 
                      </asp:TableCell>
                        <asp:TableCell ID="TableCell272" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="shippedTextBox" runat="server" />
                        </asp:TableCell>
                    </asp:TableRow>
   
                    <asp:TableRow ID="TableRow28" runat="server">
                        <asp:TableCell ID="TableCell281" runat="server" Height="25px" HorizontalAlign="Right">
                        Output Date:
                        </asp:TableCell>
                        <asp:TableCell ID="TableCell282" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="outputTextBox" runat="server" />
                          <asp:CalendarExtender ID="output_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="outputTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow ID="TableRow29" runat="server">
                        <asp:TableCell ID="TableCell291" runat="server" Height="25px" HorizontalAlign="Right">
                        Expected Delivery Date:
                        </asp:TableCell>
                        <asp:TableCell ID="TableCell292" runat="server" Height="25px" HorizontalAlign="Left">
                        <asp:TextBox ID="expectedTextBox" runat="server"  />
                          <asp:CalendarExtender ID="expected_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="expectedTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                       </asp:TableCell>
                    </asp:TableRow>   
                    <asp:TableRow ID="TableRow29A" runat="server">
                        <asp:TableCell ID="TableCell29A1" runat="server" Height="25px" HorizontalAlign="Right">
                        Actual Delivery Date::
                        </asp:TableCell>
                        <asp:TableCell ID="TableCell29A2" runat="server" Height="25px" HorizontalAlign="Left">
                        <asp:TextBox ID="actualTextBox" runat="server"  />
                          <asp:CalendarExtender ID="actual_CalendarExtender" runat="server" 
                                  Enabled="True" TargetControlID="actualTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                          </asp:CalendarExtender>
                       </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow ID="TableRow29B" runat="server">
                        <asp:TableCell ID="TableCell29B1" runat="server" Height="25px" HorizontalAlign="Right">
                        Comment:
                        </asp:TableCell>
                        <asp:TableCell ID="TableCell29B2" runat="server" Height="25px" HorizontalAlign="Left">
                        <asp:TextBox ID="commentTextBox" runat="server"  />
                       </asp:TableCell>
                    </asp:TableRow> 
 
               </asp:Table>
               </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow ID="TableRow3" runat="server">
               <asp:TableCell ID="TableCell3" runat="server" HorizontalAlign="Center">
               <asp:LinkButton ID="btnSubmitInsert" runat="server" CausesValidation="False" CommandName="Insert" Text="Submit" onclick="btnSubmitInsert_Click" />    
               &nbsp;&nbsp;
               <asp:LinkButton ID="btnCancelInsert" runat="server" 
                         CausesValidation="False" CommandName="Cancel" Text="Cancel" onclick="btnCancelInsert_Click"/>
               
               </asp:TableCell>
           </asp:TableRow>
           </asp:Table> 
                        
 
               <asp:Label ID="lblErrorInsert" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label>
               
           
       
          </ContentTemplate>
</asp:UpdatePanel>
   </asp:Panel>      
                    </td>
                </tr>

                 <tr>
                    <td style="width: 347px">
                        &nbsp;</td>
                </tr>               
            </table>

</asp:Content>
