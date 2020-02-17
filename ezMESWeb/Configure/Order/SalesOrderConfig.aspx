<%@ Page Language="C#" MasterPageFile="../../Tracking/TrackingModule.Master" AutoEventWireup="true" CodeBehind="SalesOrderConfig.aspx.cs" EnableEventValidation="false" Inherits="ezMESWeb.Configure.Order.SalesOrderConfig"
 Title="Sale Order Configuration -- ezOOM" %>   

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 

 <script type="text/javascript" language="javascript">
  function reloadContent(sender, e)
  {
    window.location="SalesOrderConfig.aspx?Tab="+sender.get_activeTabIndex()
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

    stub = stub.substring (0,stub.length-9);  
    uomDropdown = document.getElementById(stub + 'ddUom');
    uomBox = document.getElementById(stub+'lblUom');
    uomBox.innerHTML = uomDropdown.options[sender.selectedIndex].value;
    
  }

</script> 

</asp:content> 

<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1">
 

<asp:TabContainer ID="tcMain" runat="server" Height="0px" Width="100%" CssClass="amber_tab" onclientactivetabchanged="reloadContent" ActiveTabIndex="0" OnActiveTabChanged ="TabContainer_ActiveTabChanged" AutoPostBack  ="true" ><%----%>
     <%--<asp:TabPanel ID="hidden" runat="server" style ="display: none"> </asp:TabPanel>--%>
    <asp:TabPanel ID="Tp1" runat="server">
                            <HeaderTemplate>
                                Orders To Do</HeaderTemplate>
                            <ContentTemplate>
                                <asp:Button ID="btnNewOrder" runat="server" Text='Create New Order'  style ="display: block;  width:103px; font-size:12px" OnClick ="btnInsert_Onclick"></asp:Button>
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="Tp2" runat="server" >
                            <HeaderTemplate>
                                Orders in Process</HeaderTemplate>
                            <ContentTemplate>
                                <asp:Label ID="LblEmail" runat="server" Text=''>
                                </asp:Label>
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="Tp3" runat="server" >
                            <HeaderTemplate>
                                Orders Finished</HeaderTemplate>
                            <ContentTemplate>
                                <asp:Label ID="Llbphn" runat="server" Text=''>
                                </asp:Label>
                            </ContentTemplate>
                        </asp:TabPanel>
</asp:TabContainer>


   <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="True" />

     <asp:Panel ID="RecordPanel" runat="server" ScrollBars="Auto" CssClass="detail" 
       style="margin-top: 19px;  height:500px; width:370px; display:none" HorizontalAlign="Left" >
   <asp:UpdatePanel ID="updateRecordPanel" runat="server" UpdateMode="Conditional">
   <ContentTemplate>
   <asp:Button id="Popup1" runat="server" style="display:none" />
    <asp:ModalPopupExtender ID="ModalPopupExtender" runat="server" TargetControlID="Popup1"
         BackgroundCssClass="modalBackground" PopupControlID="RecordPanel" 
        PopupDragHandleControlID="RecordPanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>
        
       <asp:FormView ID="insertNewOrder" runat="server" DataSourceID= "sdsMain"
       EnableTheming="True" Height="100px" HorizontalAlign="Center" Width="100%" CssClass="detailgrid" DefaultMode="Insert" CellPadding="4" ForeColor="#333333"
       >      
       </asp:FormView>
       <div class="footer">
          <asp:LinkButton ID="btnSubmit" runat="server" CausesValidation="True" 
            OnClick="btnInsertOrderSubmit_Click"  Text="Submit" />&nbsp;
          <asp:LinkButton ID="LinkButton1" runat="server" 
           CausesValidation="False" CommandName="Cancel" OnClick="btnInsertOrderCancel_Click"
             Text="Cancel" />
            <asp:Label ID="lblActiveTab"
                          runat="server" Visible="False"></asp:Label>
       </div>
       <asp:Label ID="lblError" runat="server" ForeColor="#FF3300" 
                Height="60px" Width="350px"></asp:Label>
      </ContentTemplate>
      </asp:UpdatePanel>
       </asp:Panel>  
<asp:UpdatePanel ID="InsertionUpdate" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
<asp:GridView ID="GridView1" runat="server" Caption="Orders"
               CssClass="GridStyle" GridLines="None"  DataKeyNames="id" DataSourceID="SqlDataSource1" PagerStyle-BackColor="#f2e8da"
               EmptyDataText="There are no orders" Height="200px" Width="1024px" AllowPaging="True" AllowSorting="True"
               AutoGenerateColumns="False" OnSelectedIndexChanged = "GridView1_OnSelectedIndexChanged" PagerSettings-Mode="NumericFirstLast" OnRowDataBound="GridView1_OnRowDataBound" > <%--OnRowCreated="GridView1_RowCreated --%>               
           
   
    <Columns>
                <%--<asp:TemplateField>--%>
                    <%--<ItemTemplate>
                <asp:LinkButton ID="showOrder" runat="server" CommandName="Select" Text ="View Order" Visible="true"/>
                        </ItemTemplate>--%>
            
                <%--</asp:TemplateField>--%>
                 <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false" />
                  <asp:BoundField DataField="ponumber" HeaderText="PO #" ReadOnly="True" SortExpression="ponumber" />
                <asp:BoundField DataField="priority" HeaderText="Priority" ReadOnly="True" SortExpression="priority" />
                <asp:BoundField DataField="order_date" HeaderText="Order Date" ReadOnly="True" SortExpression="order_date" />
                <asp:BoundField DataField="Expected_Deliver_Date" HeaderText="Expected Delivery Date" ReadOnly="True" SortExpression="Expected_Deliver_Date" />
                <asp:BoundField DataField="Quantity_Requested" HeaderText="Quantity Requested" ReadOnly="True" SortExpression="Quantity_Requested" />
                <asp:BoundField DataField="Quantity_in_Process" HeaderText="Quantity in Process" ReadOnly="True" SortExpression="Quantity_in_Process" />
                <asp:BoundField DataField="Quantity_Made_or_Shipped" HeaderText="Quantity Made or Shipped" ReadOnly="True" SortExpression="Quantity_Made_or_Shipped" />
             </Columns>      
             </asp:GridView> 

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
       SelectCommand=" SELECT distinct g.id, ponumber, 
p.name as Priority, 
DATE_FORMAT((SELECT min(h.state_date) FROM order_state_history h WHERE h.order_id = g.id AND h.state='POed'),'%m/%d/%Y') AS order_date,
DATE_FORMAT(g.expected_deliver_date,'%m/%d/%Y') as Expected_Deliver_Date,
t1.r as Quantity_Requested,
t1.pr as Quantity_in_Process,
(t1.m + t1.s) as Quantity_Made_Or_Shipped

	 FROM order_general g
	 left join priority p on p.id = g.priority
	 left join order_detail d on d.order_id = g.id
     left join (select order_id, sum(quantity_requested) as r, sum(quantity_in_process) as pr, sum(quantity_made) as m, sum(quantity_shipped) as s from order_detail group by order_id) t1 on t1.order_id = g.id
	 left join (select order_id, max(quantity_requested - quantity_in_process - quantity_made - quantity_shipped) as diff, max(quantity_in_process) as proc from order_detail group by order_id) t2 on t2.order_id = g.id
     where t2.diff is null or t2.diff > 0"
        EnableCaching="false">
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                   PropertyName="Text" />
           </SelectParameters>
        </asp:SqlDataSource> 
    </ContentTemplate>
</asp:UpdatePanel>

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
                 CssClass="detailgrid" BorderWidth="2px" Caption='General Sales Order Information' 
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
                          <td width="30%"><asp:Label ID="clientLabel" runat="server" Text='<%# Bind("client_name") %>' /></td>
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
                            <tr>                         
                          <td colspan=4 align ="center"><asp:Image ID="barcode_image" runat="server" />
                          </td>
                          </tr>
                                                  <tr><td colspan=2>
                            <asp:HyperLink ID="hpStatus" runat="server" Target="_blank" NavigateUrl="/Reports/OrderReport.aspx?orderid=22">View Fulfill Status</asp:HyperLink>
                            </td>
                            <td colspan=2>
                            <asp:HyperLink ID="hpBatch" runat="server" Target="_blank" NavigateUrl="/Reports/OrderBatchDetail.aspx?order=22">View Batch Details</asp:HyperLink>
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
         <td style="height: 117px; width: 1080px;" height="20px">
                     
             <asp:Button ID="btnInsert" runat="server" Text="Add Product to Order" 
                 Width="147px"  /> 
             <asp:ModalPopupExtender ID="mdlPopup" runat="server" TargetControlID="btnInsert"
             BackgroundCssClass="modalBackground" PopupControlID="InsertPanel" 
              PopupDragHandleControlID="InsertPanel" Drag="True" DropShadow="True" >
             </asp:ModalPopupExtender>

             <asp:Button ID="btnDispatch" runat="server" Text="Dispatch Order" 
                 Width="147px"  /> 
             <asp:ModalPopupExtender ID="mdlDispatch" runat="server" TargetControlID="btnDispatch"
             BackgroundCssClass="modalBackground" PopupControlID="DispatchPanel" 
              PopupDragHandleControlID="DispatchPanel" Drag="True" DropShadow="True" >
             </asp:ModalPopupExtender>
                 <div>
                
                <asp:UpdatePanel ID="tbLotPanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

               <asp:GridView ID="gvLotTable" runat="server" Caption="Batches Dispatched Within 24 Hours" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsLotGrid" DataKeyNames="id"
               EmptyDataText="There is no batch dispatched within 24 Hours" Height="100px" Width="300px"
               AutoGenerateColumns="False" OnRowCommand ="btnPrintLabel_RowCommand" ><%--OnRowCommand="btnPrintLabel_Click" EnableEventValidation="false" EnableViewState="false" CausesValidation="false"

             >--%>
             <Columns>
                 <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="true" />
                  <asp:BoundField DataField="alias" HeaderText="Batch Name" ReadOnly="True" SortExpression="alias" />
                 <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:Image ID="alias_barcode" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                 <asp:BoundField DataField="actual_quantity" HeaderText="Quantity" SortExpression="actual_quantity" />
                 <asp:BoundField DataField="dispatch_time" HeaderText="Dispatch Time" SortExpression="dispatch_time" />
                 <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:ImageButton ID="btnPrint" runat="server"  CommandName="OrderPrint" ImageUrl="/Images/print.png" Width="32px" Height="32px"  CommandArgument='<%# Eval("id") %>'  CausesValidation="True"/>  
                    </ItemTemplate>
                </asp:TemplateField>
             </Columns>      
             </asp:GridView>  
                    <br />
                    <asp:Button ID="btnPrintBatches" runat="server" Text="Print Batches" OnClientClick="doPrint()" Width ="150px" Height="30px"/>
                    <br />
             <br />       
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Reports/DispatchHistoryReport.aspx?for=2&start=1">View batches dispatched this month</asp:HyperLink>
               </ContentTemplate>                           
               </asp:UpdatePanel>
                </div>
            
       <asp:SqlDataSource ID="sdsLotGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
       SelectCommand=" SELECT id,
              alias,
              actual_quantity,
              get_local_time(dispatch_time) as dispatch_time 
         FROM lot_status
        WHERE order_id = ?
          AND get_local_time(dispatch_time) >=get_local_time(addtime(utc_timestamp(), '-24:00'))"  
        EnableCaching="false">
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                   PropertyName="Text" />
           </SelectParameters>
        </asp:SqlDataSource> 
           <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
               <ContentTemplate>
                   <asp:GridView ID="gvTable" runat="server" Caption="Ordered Products" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsGrid" 
               EmptyDataText="No products had been listed in this order." Height="145px" Width="100%"
               AutoGenerateColumns="False"  
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="line_num" AllowPaging="True" PageSize="15" 
                    EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                       <Columns>
                       <asp:TemplateField><ItemTemplate>
			           <asp:LinkButton ID="btnDeleteDetail" runat="server" Text="Delete" CommandName="Select" CommandArgument="Delete"/>
			         </ItemTemplate>
			         </asp:TemplateField>
                       <asp:TemplateField><ItemTemplate>
			           <asp:LinkButton ID="btnViewDetails" runat="server" Text="Edit" CommandName="Select" />
			         </ItemTemplate>
			         </asp:TemplateField>
                           <asp:BoundField DataField="product_id" HeaderText="Product Id" 
                     SortExpression="product_id" ReadOnly="True" Visible="False" />
                           <asp:BoundField DataField="line_num" HeaderText="Line Number"
                     SortExpression="line_num" ReadOnly="true" />
                           <asp:BoundField DataField="product_name" HeaderText="Product" 
                     SortExpression="product_name" />
                           <asp:BoundField DataField="product_description" HeaderText="Description" 
                     SortExpression="product_description" />
                           <asp:BoundField DataField="product_group" HeaderText="Product Group" 
                     SortExpression="product_group" />
                           <asp:BoundField DataField="quantity_requested" HeaderText="Requested Quantity" 
                                    SortExpression="quantity_requested" DataFormatString={0:N0} />
                           <asp:BoundField DataField="unit_price" HeaderText="Unit Price ($)" 
                                    SortExpression="unit_price" />
                           <asp:BoundField DataField="quantity_made" HeaderText="Quantity Made" 
                                    SortExpression="quantity_made" DataFormatString={0:N0} />
                           <asp:BoundField DataField="quantity_in_process" 
                     HeaderText="Quantity In Process" SortExpression="quantity_in_process" DataFormatString={0:N0} />
                           <asp:BoundField DataField="quantity_shipped" HeaderText="Quantity Shipped" 
                     SortExpression="quantity_shipped" DataFormatString={0:N0} />
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
           ProviderName="System.Data.Odbc" 
           DeleteCommand="SELECT line_num FROM order_detail where order_id =0 AND line_num = ?"
           SelectCommand=" SELECT o.source_id as product_id,
        o.line_num,
        p.name AS product_name,
        p.description AS product_description,
        pg.name AS product_group,
        o.quantity_requested,
        o.unit_price,
        o.quantity_made,
        o.quantity_in_process,
        o.quantity_shipped,
        o.uomid,
        u.name AS uom_name,
        DATE_FORMAT(o.output_date, '%m/%d/%Y') AS output_date,
        DATE_FORMAT(o.expected_deliver_date, '%m/%d/%Y') AS expected_deliver_date,
        DATE_FORMAT(o.actual_deliver_date, '%m/%d/%Y') AS actual_deliver_date,
        o.comment
   FROM order_detail o, product p, uom u, product_group pg
  WHERE 
     o.order_id = ? AND
     o.source_type = 'product'
    AND p.id = o.source_id
    AND u.id = o.uomid
    AND pg.id=p.pg_id
   ORDER BY o.line_num">
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                   PropertyName="Text" />
           </SelectParameters>
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
                 DataKeyNames="line_num" DataSourceID="sdsUpdate" 
                   DefaultMode="Edit" Height="290px" 
                HorizontalAlign="Center" onitemupdated="fvUpdate_ItemUpdated" Width="100%">
                
                     <EditItemTemplate>
                     &nbsp;&nbsp;
                        <asp:Table ID="Table3" runat="server" CssClass="detailgrid">
                            <asp:TableRow ID="TableRow30" runat="server">
                              <asp:TableCell ID="TableCell301" runat="server" Height="25px" HorizontalAlign="Right">
                              Line Number: 
                              </asp:TableCell>
                              <asp:TableCell ID="TableCell302" runat="server" Height="25px" HorizontalAlign="Left">
                              <asp:Label ID="LineNumber1" runat="server" 
                               Text='<%# Bind("line_num") %>' /></asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow31" runat="server">
                              <asp:TableCell ID="TableCell311" runat="server" Height="25px" HorizontalAlign="Right">
                              Product: 
                              </asp:TableCell><asp:TableCell ID="TableCell312" runat="server" Height="25px" HorizontalAlign="Left">
                              <asp:Label ID="productIDLabel" runat="server" 
                               Text='<%# Bind("product_id") %>' Visible="false" />
                              <asp:Label ID="productLabel1" runat="server" 
                               Text='<%# Bind("product_name") %>' /></asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow32" runat="server">
                              <asp:TableCell ID="TableCell321" runat="server" Height="25px" HorizontalAlign="Right">
                              Requested Quantity: 
                              </asp:TableCell><asp:TableCell ID="TableCell322" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="requestedTextBox" runat="server" 
                                    Text='<%# Bind("quantity_requested") %>' />
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow33" runat="server">
                                <asp:TableCell ID="TableCell331" runat="server" Height="25px" HorizontalAlign="Right">
                                Unit of Measure:</asp:TableCell><asp:TableCell ID="TableCell332" runat="server" Height="25px" HorizontalAlign="Left">
                                 <asp:Label ID="uomidLabel" runat="server" 
                               Text='<%# Bind("uomid") %>' Visible="false" />
                                    <asp:Label ID="uomLabel" runat="server" 
                                    Text='<%# Bind("uom_name") %>' />                    
                                </asp:TableCell></asp:Tablerow><asp:TableRow ID="TableRow50" runat="server">
                              <asp:TableCell ID="TableCell501" runat="server" Height="25px" HorizontalAlign="Right">
                              Unit Price ($): 
                              </asp:TableCell><asp:TableCell ID="TableCell502" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="priceTextBox" runat="server" 
                                    Text='<%# Bind("unit_price") %>' />
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow51" runat="server">
                              <asp:TableCell ID="TableCell511" runat="server" Height="25px" HorizontalAlign="Right">
                              Quantity Already Made: 
                              </asp:TableCell><asp:TableCell ID="TableCell512" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="madeTextBox" runat="server" 
                                    Text='<%# Bind("quantity_made") %>' />
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow52" runat="server">
                              <asp:TableCell ID="TableCell521" runat="server" Height="25px" HorizontalAlign="Right">
                              Quantity in Process: 
                              </asp:TableCell><asp:TableCell ID="TableCell522" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="processTextBox" runat="server" 
                                    Text='<%# Bind("quantity_in_process") %>' />
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow53" runat="server">
                              <asp:TableCell ID="TableCell531" runat="server" Height="25px" HorizontalAlign="Right">
                              Quantity Shipped: 
                              </asp:TableCell><asp:TableCell ID="TableCell532" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="shippedTextBox" runat="server" 
                                    Text='<%# Bind("quantity_shipped") %>' />
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow34" runat="server">
                                <asp:TableCell ID="TableCell341" runat="server" Height="25px" HorizontalAlign="Right">
                                Output Date:
                                </asp:TableCell><asp:TableCell ID="TableCell342" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="outputTextBox" runat="server" 
                                    Text='<%# Bind("output_date") %>' />
                                  <asp:CalendarExtender ID="output_CalendarExtender" runat="server" 
                                          Enabled="True" TargetControlID="outputTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                                  </asp:CalendarExtender>
                                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow35" runat="server">
                                <asp:TableCell ID="TableCell351" runat="server" Height="25px" HorizontalAlign="Right">
                                Expected Delivery Date:
                                </asp:TableCell><asp:TableCell ID="TableCell352" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="expectedTextBox" runat="server" 
                               Text='<%# Bind("expected_deliver_date") %>' />
                               <asp:CalendarExtender ID="expected_CalendarExtender" runat="server" 
                                      Enabled="True" TargetControlID="expectedTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                              </asp:CalendarExtender>
                               </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow36" runat="server">
                                <asp:TableCell ID="TableCell361" runat="server" Height="25px" HorizontalAlign="Right">
                                Actual Delivery Date::
                                </asp:TableCell><asp:TableCell ID="TableCell362" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="actualTextBox" runat="server" 
                               Text='<%# Bind("actual_deliver_date") %>' />
                                <asp:CalendarExtender ID="actual_CalendarExtender" runat="server" 
                                      Enabled="True" TargetControlID="actualTextBox" TodaysDateFormat="d" Animated="False" CssClass="amber__calendar">
                              </asp:CalendarExtender>
                               </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow39" runat="server">
                                <asp:TableCell ID="TableCell391" runat="server" Height="25px" HorizontalAlign="Right">
                                Comment:
                                </asp:TableCell><asp:TableCell ID="TableCell392" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="commentTextBox" runat="server" 
                               Text='<%# Bind("comment") %>' />
                               </asp:TableCell></asp:TableRow></asp:Table></EditItemTemplate><InsertItemTemplate>

                     </InsertItemTemplate>
                     <ItemTemplate>
                     </ItemTemplate>
                 </asp:FormView>
                 &nbsp;&nbsp; <div  align="center">
                    <asp:LinkButton ID="btnSubmitUpdate" runat="server" CausesValidation="True" 
                      OnClick="btnSubmitUpdate_Click" CommandName="Update" Text="Submit" />&nbsp; <asp:LinkButton ID="btnCancelUpdate" runat="server" 
                         CausesValidation="False" CommandName="Cancel" OnClick="btnCancelUpdate_Click"
                         Text="Cancel" />
                 </div>
               <asp:Label ID="lblErrorUpdate" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label></ContentTemplate></asp:UpdatePanel></asp:Panel><asp:SqlDataSource ID="sdsUpdate" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
               
                 ProviderName="System.Data.Odbc" 
                 
                 
                 
                 
                 
                 SelectCommand=" SELECT p.name as product_name,
                 p.id as product_id,
                o.line_num as line_num,
        CAST(o.quantity_requested AS UNSIGNED INTEGER) AS quantity_requested,
        o.unit_price,
        CAST(o.quantity_made AS UNSIGNED INTEGER) AS quantity_made,
        CAST(o.quantity_in_process AS UNSIGNED INTEGER) AS quantity_in_process,
        CAST(o.quantity_shipped AS UNSIGNED INTEGER) AS quantity_shipped,
        o.uomid,
        u.name as uom_name,
        DATE_FORMAT(o.output_date, '%m/%d/%Y') AS output_date,
        DATE_FORMAT(o.expected_deliver_date, '%m/%d/%Y') AS expected_deliver_date,
        DATE_FORMAT(o.actual_deliver_date, '%m/%d/%Y') AS actual_deliver_date,
        o.comment
   FROM order_detail o, product p, uom u
  WHERE order_id = ?
    AND source_type = 'product'
    and o.line_num = ?
    AND p.id = o.source_id
    AND u.id = o.uomid">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="txtID" Name="order_id" 
                         PropertyName="Text" DefaultValue="0" />
                     <asp:ControlParameter ControlID="gvTable" DefaultValue="1" Name ="line_num"
                         PropertyName ="SelectedValue" />
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
        concat(e.firstname, ' ', e.lastname) AS internal_contact_name,
        o.external_contact,
        1 as recorder_id,
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
                 SelectCommand="select id, name from client where type in ('both', 'customer')"></asp:SqlDataSource> 
             <asp:SqlDataSource ID="sdsEmployee" runat="server" 
                 SelectCommand="select id, concat(firstname, ' ', lastname) as name from employee" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc"></asp:SqlDataSource>

             
  <asp:Panel   
   ID="InsertPanel" runat="server" Height="460px" CssClass="detail" 
                 style="display:none" Width="350px" 
                 HorizontalAlign="Left" >
             <asp:UpdatePanel ID="insertBufferPanel" runat="server" UpdateMode="Conditional">          
 

          <ContentTemplate>

       <asp:Table ID="Table1" runat="server" BorderWidth="0" Width="100%" Height="398px">
           <asp:TableRow ID="TableRow1" runat="server">
               <asp:TableCell ID="TableCell1" runat="server" Height="30px" HorizontalAlign="Center">
                   Add Product to Order
               </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow2" runat="server">
               <asp:TableCell ID="TableCell2" runat="server" HorizontalAlign="Right">
               <asp:Table ID="Table2" runat="server" CssClass="detailgrid">
                   <asp:TableRow ID="TableRow20" runat="server">
                       <asp:TableCell ID="TableCell201" runat="server" Height="25px" HorizontalAlign="Right">
                           Line Number:</asp:TableCell>
                       <asp:TableCell ID="TableCell202" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="linenumberTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>
                   <asp:TableRow ID="TableRow21" runat="server">
                       <asp:TableCell ID="TableCell21" runat="server" Height="25px" HorizontalAlign="Right">
                           Product:</asp:TableCell>
                       <asp:TableCell ID="TableCell22" runat="server" Height="25px"  HorizontalAlign="Left">
                           <asp:DropDownList ID="ddProduct" runat="server" 
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
                    </asp:TableRow>
                     <asp:TableRow ID="TableRow24" runat="server">
                      <asp:TableCell ID="TableCell241" runat="server" Height="25px" HorizontalAlign="Right">
                      Unit Price ($): 
                      </asp:TableCell>
                        <asp:TableCell ID="TableCell242" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="priceTextBox" runat="server"  />
                        </asp:TableCell>
                    </asp:TableRow>
                     <asp:TableRow ID="TableRow25" runat="server">
                      <asp:TableCell ID="TableCell251" runat="server" Height="25px" HorizontalAlign="Right">
                      Quantity Already Made: 
                      </asp:TableCell>
                        <asp:TableCell ID="TableCell252" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="madeTextBox" runat="server" />
                        </asp:TableCell>
                    </asp:TableRow>
                     <asp:TableRow ID="TableRow26" runat="server">
                      <asp:TableCell ID="TableCell261" runat="server" Height="25px" HorizontalAlign="Right">
                      Quantity in Process: 
                      </asp:TableCell>
                        <asp:TableCell ID="TableCell262" runat="server" Height="25px" HorizontalAlign="Left">
                            <asp:TextBox ID="processTextBox" runat="server" />
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
               </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow3" runat="server">
               <asp:TableCell ID="TableCell3" runat="server" HorizontalAlign="Center">
               <asp:LinkButton ID="btnSubmitInsert" runat="server" CausesValidation="False" CommandName="Insert" Text="Submit" onclick="btnSubmitInsert_Click" />    
               &nbsp;&nbsp;
               <asp:LinkButton ID="btnCancelInsert" runat="server" 
                         CausesValidation="False" CommandName="Cancel" Text="Cancel" onclick="btnCancelInsert_Click"/>
               
               </asp:TableCell></asp:TableRow></asp:Table><asp:Label ID="lblErrorInsert" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label></ContentTemplate></asp:UpdatePanel></asp:Panel></td></tr><tr><td>
                                   <asp:SqlDataSource ID="sdsLocation" runat="server" 
                 SelectCommand="select 0 as id, '' AS name union select id, name from location" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc"></asp:SqlDataSource>
             <asp:Panel ID="DispatchPanel" runat="server" Height="300px" CssClass="detail" Style="display:none" Width =" 550px" HorizontalAlign ="Left">
   
    <asp:UpdatePanel ID="DispatchBufferPanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
           <asp:Table ID="TableDispatch" runat="server" BorderWidth ="0" Width="100%" Height="250px">
              <asp:TableRow ID="TableRowD1" runat="server">
                <asp:TableCell ID="TableCellD1" runat="server" Height="30px" HorizontalAlign="Center" Width="100%">
                   Dispatch Selected Lines:
                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRowD2" runat="server">
                <asp:TableCell ID="TableCellD2" runat="server" HorizontalAlign ="Center" >
                    <asp:Table ID="TableD21" runat="server" CssClass="detailgrid" Width="100%" >
                        <asp:TableRow ID="TableRowD211" runat="server" Width="100%">
                           <asp:TableCell ID="TableCell2111" runat="server" Height="25px" Width="20%" HorizontalAlign="Right">
                               Line Numbers:</asp:TableCell>
                           <asp:TableCell ID="TableCell2112" runat="server" Height="25px" Width="80%" HorizontalAlign="Left">
                               <asp:TextBox ID="txtLineNumbers" runat="server" Width="80%">
                               </asp:TextBox>  
                           </asp:TableCell>
                       </asp:TableRow>
                       <asp:TableRow ID="TableRowD212" runat="server">
                           <asp:TableCell ID="TableCell2121" runat="server" Height="25px" HorizontalAlign ="Right">
                               Prefix:
                           </asp:TableCell>
                           <asp:TableCell ID="TableCell2122" runat="server" Height="25px" HorizontalAlign="Left">
                               <asp:TextBox ID="txtPrefix" runat="server"  maxlength="24" ></asp:TextBox>
                           </asp:TableCell>
                       </asp:TableRow>
                       <asp:TableRow ID="TableRowD213" runat="server">
                           <asp:TableCell ID="TableCellD2131" runat="server" Height="25px" HorizontalAlign ="Right">
                               Contact Person:
                           </asp:TableCell>
                           <asp:TableCell ID="TableCell2132" runat="server" Height="25px" HorizontalAlign="Left">
                               <asp:DropDownList ID="ddContact" runat="server"  DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                                   Height="25px" Width="166px" >
                               </asp:DropDownList> 
                           </asp:TableCell>
                       </asp:TableRow>
                       <asp:TableRow ID="TableRowD214" runat="server">
                           <asp:TableCell ID="TableCellD2141" runat="server" Height="25px" HorizontalAlign ="Right">
                               Priority:
                           </asp:TableCell>
                           <asp:TableCell ID="TableCellD2142" runat="server" Height="25px" HorizontalAlign="Left">
                               <asp:DropDownList ID="ddBatchPriority" runat="server" 
                                   DataSourceID="sdsPriority" DataTextField="name" DataValueField="id"
                                   Height="25px" Width="166px" >
                               </asp:DropDownList> 
                           </asp:TableCell>
                       </asp:TableRow>
                       <asp:TableRow ID="TableRow215" runat="server">
                           <asp:TableCell ID="TableCellD2151" runat="server" Height="25px" HorizontalAlign ="Right">
                               Location:
                           </asp:TableCell>
                           <asp:TableCell ID="TableCellD2152" runat="server" Height="25px" HorizontalAlign="Left">
                               <asp:DropDownList ID="ddBatchLocation" runat="server" 
                                   DataSourceID="sdsLocation" DataTextField="name" DataValueField="id"
                                   Height="25px" Width="166px" >
                               </asp:DropDownList> 
                           </asp:TableCell>
                       </asp:TableRow>
                     <asp:TableRow ID="TableRowD216" runat="server">
                           <asp:TableCell ID="TableCellD2161" runat="server" Height="25px" HorizontalAlign ="Right">
                               Comment:
                           </asp:TableCell>
                           <asp:TableCell ID="TableCellD2162" runat="server" Height="25px" HorizontalAlign="Left">
                               <asp:TextBox ID="txtBatchComment" runat="server" Width="100%"></asp:TextBox>
                           </asp:TableCell>
                       </asp:TableRow>
                    </asp:Table>
                </asp:TableCell></asp:TableRow><asp:TableRow ID="TableRowD3" runat="server">
                <asp:TableCell ID="TableCellD31" runat="server" HorizontalAlign="Center">
                    <asp:LinkButton ID="btnSubmitDispatch" runat="server" CausesValidation="False" CommandName="Dispatch" Text="Submit" onclick="btnSubmitDispatch_Click" />    
               &nbsp;&nbsp;
               <asp:LinkButton ID="btnCancelDispatch" runat="server" 
                         CausesValidation="False" CommandName="Cancel" Text="Cancel" onclick="btnCancelDispatch_Click"/>
               
               </asp:TableCell></asp:TableRow></asp:Table><asp:Label ID="lblErrorDispatch" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label></ContentTemplate></asp:UpdatePanel></asp:Panel><asp:Panel ID="MessagePanel" runat="server" CssClass="detail" 
       style="margin-top: 19px;  height:130px; width:400px; display:none" HorizontalAlign="Center" BorderColor="Black">
         <asp:UpdatePanel ID="MessageUpdatePanel"  runat="server" UpdateMode="Conditional">
                 <ContentTemplate>
     <asp:Button id="btnMessagePopup" runat="server" style="display:none" />
     <asp:ModalPopupExtender ID="MessagePopupExtender" runat="server" TargetControlID="btnMessagePopup"
         BackgroundCssClass="modalBackground" PopupControlID="MessagePanel" 
        PopupDragHandleControlID="MessagePanel" Drag="True" DropShadow="True" >
        </asp:ModalPopupExtender>    
        <table width="90%" cellpadding="5px" cellspacing = "10px" align="center" >
        <tr><td>&nbsp;</td></tr><tr><td align="left">
        <asp:Label ID="lblDeleteDetailError" runat="server"  Style="font-family:Times New Roman; font-style:italic; font-size:20px; text-align:left; line-height:22px; color:#FF3300;">
        </asp:Label></td></tr><tr><td>&nbsp;</td></tr><tr><td>
        <asp:Button ID="btnOK" runat="server" Text="OK" 
                    Style="font-family:Times New Roman;font-size:16px; font-weight:bold; width:150px;" 
                    onclick="btnOK_Click" />  
         </td></tr>
         </table>   
              </ContentTemplate>      
         </asp:UpdatePanel>
       </asp:Panel>


                                                                                                                        </td></tr><tr>
                    <td style="width: 347px">
                    <asp:Label ID="lblGridError" runat="server" ForeColor="#FF3300" 
                  Height="60px" Width="350px"></asp:Label></td></tr></table></asp:Content>