<%@ Page Language="C#" MasterPageFile="../ConfigureModule.master" AutoEventWireup="true" CodeBehind="RecipeConfig.aspx.cs" Inherits="ezMESWeb.Configure.Process.RecipeConfig"
 Title="Recipe Configuration -- ezOOM" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 

 <script type="text/javascript" language="javascript">
  function updateUOMLabel(sourceType, sender)
  {
  //this function allow to update UOM label besides quantity box
  //according to selected material or product.
    var stub = sender.name;
    stub = stub.replace(/\$/g, '_');
    var uomDropdown;
    var uomBox;
    if (sourceType == 'material')
    {
        stub = stub.substring (0,stub.length-10);  
        uomDropdown = document.getElementById(stub + 'ddMUom');
        uomBox = document.getElementById(stub+'lblUom');
        uomBox.innerHTML = uomDropdown.options[sender.selectedIndex].value;
    }  
    else if (sourceType == 'product')
    {
        stub = stub.substring (0,stub.length-9);  
        uomDropdown = document.getElementById(stub + 'ddPUom');
        uomBox = document.getElementById(stub+'lblUom');
        uomBox.innerHTML = uomDropdown.options[sender.selectedIndex].value;
    }
  }
  function reloadContent(sender, e)
  {
    window.location="RecipeConfig.aspx?Tab="+sender.get_activeTabIndex()
  }
  function confirmDelete(button)
  {
    if (button.value == "Delete Recipe")
        return confirm("Do you really want to delete this recipe?");
  }
  function showDropDown(rbl, drp1name, drp2name)
  {
  
   //this function show appropriate dropdown of either product or material
   //update UOM label accordingly. 
    var rblitems=document.getElementById(rbl);


    var dropdown1;
    var dropdown2;
    var autostartbox;
    var stub = rbl;
    stub = stub.substring (0,stub.length-7);      
    var uomDropdown;
    var uomBox=document.getElementById(stub + 'lblUom');
    var ind=0;

        //material
        if (rblitems.rows[0].cells[0].childNodes[0].checked)
        {
            dropdown1=document.getElementById(drp1name);
            dropdown2=document.getElementById(drp2name);
            uomDropdown =document.getElementById(stub + 'ddMUom');
            if (dropdown1.selectedIndex>0)
                ind=dropdown1.selectedIndex;
            uomBox.innerHTML=uomDropdown.options[ind].value;
        }
        else
        {
            dropdown2=document.getElementById(drp1name);
            dropdown1=document.getElementById(drp2name);   
             uomDropdown =document.getElementById(stub + 'ddPUom');


        }
        if (dropdown1.style.display = 'none')
        {
           dropdown1.style.display = 'block';
           dropdown2.style.display ='none';
        }   
         
        if (dropdown1.selectedIndex>0)
        {
            ind=dropdown1.selectedIndex;
        }
        uomBox.innerHTML=uomDropdown.options[ind].value;       
         
  }
  function showApprovedBy(chk, tbr)
  {
    var chkitem = document.getElementById(chk);
    var tbritem = document.getElementById(tbr);
    
    if (chkitem.checked)
    {
      tbritem.style.display='block';
    }
    else {
      tbritem.style.display='none';
    }
    
  }
</script> 
<script src="http://code.jquery.com/jquery-1.9.1.js">
    
    $(function () {

        $(".ajax__tab_header").html("<div style='height:80px;width:1200px;' >" + $(".ajax__tab_header").html() + "</div>");

    })
</script>
<style type="text/css">
    .style19
    {
        width: 100%;
        height: 168px;
    }
    .ajax__tab_header {
        height: 80px !important;
        width: 100%;
        overflow-x: scroll;
        overflow-y: scroll;
    }
</style>
</asp:content> 

<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <asp:TabContainer ID="tcMain" runat="server" 
        Height="0px" Width="100%" CssClass="amber_tab" 
        onclientactivetabchanged="reloadContent">
        
    </asp:TabContainer>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
<table style="width: 100%; height: 423px; margin-right: 0px; margin-top: 0px; border : 2px solid #6FBD06; ">
      <tr>
      <td style="width: 100%;">
          
          <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional" >
              <ContentTemplate>
              <table border="0" width="100%">
                 <tr>
                   <td class="style19">
                  <asp:FormView ID="fvMain" runat="server" DataKeyNames="" 
                      DataSourceID="sdsMain" BorderStyle="Groove" 
                 CssClass="detailgrid" BorderWidth="2px" Caption='General Recipe Information' 
                           Width ="600px" Height="191px">
                      <EditItemTemplate>
                      <table border=0 width="100%">
                          <tr>
                          <td>Name:</td>
                          
                          <td><asp:TextBox ID="nameTextBox" runat="server" Text='<%# Eval("name") %>' MaxLength="20" /></td>
                          <td>Contact:</td>
                          <td><asp:DropDownList ID="ddContact" runat="server" 
                               DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList>
                           <asp:Label ID="lblContact" runat="server" Text='<%#Eval("contact_employee") %>' Visible="False"></asp:Label>
                           </td>                       

                          </tr>
                          <tr>
                          
                           <td> Execution Method:</td><td>
                           
                           <asp:RadioButtonList ID="rbExec" runat="server" RepeatDirection="Vertical" RepeatLayout="Flow">
                               <asp:ListItem  Value="ordered" />
                               <asp:ListItem  Value="random" Selected />
                           </asp:RadioButtonList>
                           <asp:Label ID="lblExec" runat="server" Text='<%#Eval("exec_method") %>' Visible="False"></asp:Label>
                           </td>

                           <td>Instruction Diagram:</td>
                           <td>
                           <asp:RadioButtonList ID="rbDiagram" runat="server" RepeatDirection="Vertical" >
                               <asp:ListItem  Value="nochange" Selected=True>No Change </asp:ListItem>
                               <asp:ListItem  Value="delete" >Delete Diagram File </asp:ListItem>
                               <asp:ListItem  Value="replace" > Replace with New File </asp:ListItem>
                           </asp:RadioButtonList>
                               <asp:FileUpload ID="flInstruction" runat="server" />
                           <asp:Label ID="lblFile" runat="server" Text='<%#Eval("diagram_filename") %>' Visible="False"></asp:Label>

                           </td>
                           </tr>
                           <tr>
                          <td>Text Instruction:</td>
                          <td><asp:TextBox ID="instructionTextBox" runat="server" TextMode="MultiLine" 
                          Height="100" Width="200" Text ='<%# Eval("instruction") %>'/></td>                              

                          <td>Comment:</td>
                          <td><asp:TextBox ID="commentTextBox" runat="server" TextMode="MultiLine" 
                                  Height="100px" Width="200px" Text='<%# Eval("comment") %>' /></td>
                          </tr>
                         </table>
                      </EditItemTemplate>
                      <InsertItemTemplate>
                      <table border=0 width="100%">
                          <tr>
                          <td>Name:</td>
                          <td><asp:TextBox ID="nameTextBox" runat="server"  MaxLength="20" /></td>
                          <td>Execution Method:</td>
                          <td><asp:RadioButtonList ID="rbExec" runat="server" RepeatDirection="Horizontal" 
                                  Width="230px" Height="22px" RepeatLayout="Flow" > 
                               <asp:ListItem  Value="ordered" />
                               <asp:ListItem  Value="random" Selected />
                           </asp:RadioButtonList>     </td>   

                          

                          </tr>
                          <tr>       
                          <td>Contact:</td>
                          <td><asp:DropDownList ID="ddContact" runat="server" 
                               DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList></td>                     
                         
                           <td>Instruction Diagram:</td><td>
                               <asp:FileUpload ID="flInstruction" runat="server" />
                           </td>
                          </tr>
                          
                          <tr>
                          
                          <td>Text Instruction:</td>
                          <td><asp:TextBox ID="instructionTextBox" runat="server" TextMode="MultiLine" Height="100" Width="200" /></td>                              
                          <td>Comment:</td>
                          <td><asp:TextBox ID="commentTextBox" runat="server" TextMode="MultiLine" Height="100" Width="200" /></td>                              
                         
                         
                          </tr>                          
                      </table>
                      </InsertItemTemplate>
                      <ItemTemplate>
                      <table border=0 width="100%">
                        <tr>
                          <td width="15%">Name:</td>
                          <td width="35%"><asp:Label ID="nameLabel" runat="server" Text='<%# Bind("name") %>' /></td>
                          <td>Execution Method:</td>   
                          <td>
                          <asp:Label ID="execLabel" runat="server" 
                              Text='<%# Bind("exec_method") %>' />
                          </td>                          
                        </tr>
                        <tr>

                          <td>Contact:</td>
                          <td><asp:Label ID="contactLabel" runat="server" Text='<%# Bind("contact_employee_name") %>' />
                          </td>
                          <td>Instruction Diagram:</td>
                            
                          <td>
                              <asp:HyperLink ID="fileLink" runat="server" 
                                  Text='<%# Bind("diagram_filename") %>'  Target="_new" 
                                  NavigateUrl="~/Default.aspx" /></td>
                        </tr>
                        <tr>
                          <td>Text Instruction:</td>
                          <td><asp:Label ID="instructionLabel" runat="server" Text='<%# Bind("instruction") %>' /></td>
                          <td>Comment:</td>
                          <td><asp:Label ID="commentLabel" runat="server" Text='<%# Bind("comment") %>' />
                          </td>
                        </tr>
                        <tr>
                          <td>Create Time:</td>
                          <td><asp:Label ID="create_timeLabel" runat="server" 
                              Text='<%# Bind("create_time") %>' />
                          </td>
                          <td>Created By:</td>
                          <td><asp:Label ID="created_byLabel" runat="server" 
                              Text='<%# Bind("created_by_name") %>' />
                          </td>
                        </tr>
                        <tr>
                          <td>Update Time:</td>
                          <td><asp:Label ID="update_timeLabel" runat="server" 
                              Text='<%# Bind("update_time") %>' />
                          </td>
                          <td>Updated By:</td>
                          <td><asp:Label ID="updated_byLabel" runat="server" 
                              Text='<%# Bind("updated_by_name") %>' />
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
                      <asp:Button ID="btnDuplicate" runat="server" Height="26px" Text="Duplicate Recipe" 
                          Width="143px" onclick="btnDuplicate_Click" />
                      </td></tr>
                 </table>
                 
              </ContentTemplate>
             <Triggers>
                   <asp:PostBackTrigger ControlID="btnDo" />        
                 <asp:PostBackTrigger ControlID="btnCancel" /> 
                 <asp:PostBackTrigger ControlID="btnDuplicate" />
             </Triggers>
          </asp:UpdatePanel>
          </td>
      </tr>
      <tr><td><hr /></td></tr>
      <tr><td>&nbsp;&nbsp;</td></tr>
      <tr>
         <td style="height: 117px; width: 347px;" height="20px">
                     
             <asp:Button ID="btnInsert" runat="server" Text="Add New Part" 
                 Width="147px"  /> 
             <asp:ModalPopupExtender ID="mdlPopup" runat="server" TargetControlID="btnInsert"
             BackgroundCssClass="modalBackground" PopupControlID="InsertPanel" 
              PopupDragHandleControlID="InsertPanel" Drag="True" DropShadow="True" >
             </asp:ModalPopupExtender>
 
           <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
               <ContentTemplate>
                   <asp:GridView ID="gvTable" runat="server" Caption="Parts" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsGrid" 
               EmptyDataText="No part has been recorded for this recipe." Height="145px" Width="900px"
               AutoGenerateColumns="False" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="source_type,ingredient_id,order" AllowPaging="True" PageSize="15" 
                    EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                       <Columns>
                            <asp:TemplateField>
                               <ItemTemplate>
                                   <asp:LinkButton ID="btnDeleteRow" runat="server" Text='Delete' 
                       CommandName="Select" CommandArgument="Delete" />
                               </ItemTemplate>
                           </asp:TemplateField>
                           <asp:TemplateField>
                               <ItemTemplate>
                                   <asp:LinkButton ID="btnViewDetails" runat="server" Text='Edit' 
                       CommandName="Select" />
                               </ItemTemplate>
                           </asp:TemplateField>
                           <asp:BoundField DataField="ingredient_id" HeaderText="Ingredient Id" 
                     SortExpression="ingredient_id" ReadOnly="True" Visible="False" />
                           <asp:BoundField DataField="source_type" HeaderText="Source Type" 
                     SortExpression="source_type" />
                           <asp:BoundField DataField="name" HeaderText="Part #"    />
                           <asp:BoundField DataField="quantity" HeaderText="Quantity" />
                           <asp:BoundField DataField="order" HeaderText="Input Order" />
                           <asp:BoundField DataField="mintime" HeaderText="Mininum Time"/>
                           <asp:BoundField DataField="maxtime" HeaderText="Maximum Time"  />
                           <asp:BoundField DataField="comment" HeaderText="Comment" />
                       </Columns>
                       <SelectedRowStyle  BackColor="#ffffcc"/>
                   </asp:GridView>
               </ContentTemplate>
              </asp:UpdatePanel> 
       <asp:SqlDataSource ID="sdsGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           ProviderName="System.Data.Odbc" 
           SelectCommand=" SELECT i.recipe_id,
        i.source_type,
        i.ingredient_id,
        p.name,
        concat(CAST(CAST(i.quantity AS DECIMAL(16,1)) AS CHAR), ' ', u.name) AS quantity,
        i.`order`,
        i.mintime,
        i.maxtime,
        i.comment
   FROM ingredients i, product p, uom u
  WHERE i.recipe_id = ?
    AND i.source_type = 'product'
    AND p.id = i.ingredient_id
    AND u.id = i.uom_id
  UNION 
 SELECT i1.recipe_id,
        i1.source_type,
        i1.ingredient_id,
         m.name,
        concat(CAST(CAST(i1.quantity AS DECIMAL(16,1)) AS CHAR), ' ', u1.name) AS quantity,
        i1.`order`,
        i1.mintime,
        i1.maxtime,
        i1.comment
   FROM ingredients i1, material m, uom u1
  WHERE i1.recipe_id = ?
    AND i1.source_type = 'material'
    AND m.id = i1.ingredient_id
    AND u1.id = i1.uom_id
 ORDER BY recipe_id, `order`
        " >
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id1" 
                   PropertyName="Text" />
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id2" 
                   PropertyName="Text" />
           </SelectParameters>
       </asp:SqlDataSource>
       
        <asp:Panel ID="UpdatePanel" runat="server" CssClass="detail" style="display:none"
              Height="347px" HorizontalAlign="Left" Width="350px">
       <asp:UpdatePanel ID="updateBufferPanel" runat="server" UpdateMode="Conditional">
           <ContentTemplate>
           <asp:Button id="btnShowPopup" runat="server" style="display:none" />
           <asp:ModalPopupExtender ID="btnUpdate_ModalPopupExtender" runat="server" 
                 PopupControlID="UpdatePanel" PopupDragHandleControlID="UpdatePanel"
                 TargetControlID="btnShowPopup" 
                   BackgroundCssClass="modalBackground" Drag="True" DropShadow="True">
             </asp:ModalPopupExtender>
       <asp:Table ID="tbUpdate" runat="server" BorderWidth="0" Width="100%" Height="272px">
           <asp:TableRow ID="TableRow4" runat="server">
               <asp:TableCell ID="TableCell8" runat="server" Height="25px" HorizontalAlign="Center" VerticalAlign="Bottom">
                   Update Part in Recipe
               </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow ID="TableRow8" runat="server">
               <asp:TableCell ID="TableCell11" runat="server" HorizontalAlign="Center">

                        <asp:Table ID="Table3" runat="server" CssClass="detailgrid" Width="100%" >
                            <asp:TableRow ID="TableRow31" runat="server" >
                              <asp:TableCell ID="TableCell311" runat="server" Height="25px" HorizontalAlign="Right">
                              Source Type: 
                              </asp:TableCell>
                              <asp:TableCell ID="TableCell312" runat="server" Height="25px" HorizontalAlign="Left">
                                  <asp:Label ID="sourceLabel" runat="server" ></asp:Label>
                              </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow32" runat="server">
                              <asp:TableCell ID="TableCell321" runat="server" Height="25px" HorizontalAlign="Right">
                              Part #: 
                              </asp:TableCell>
                              <asp:TableCell ID="TableCell322" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:Label ID="ingredientLabel" runat="server" ></asp:Label>
                               </asp:TableCell>
                            </asp:TableRow>

                            <asp:TableRow ID="TableRow34" runat="server">
                                <asp:TableCell ID="TableCell341" runat="server" Height="25px" HorizontalAlign="Right">
                                Quantity:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell342" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="qtyTextBoxu" runat="server"  /> &nbsp;
                                    <asp:Label ID="uomLabelu" runat="server" />
                                </asp:TableCell>
                            </asp:TableRow>
  
                            <asp:TableRow ID="TableRow39" runat="server">
                                <asp:TableCell ID="TableCell391" runat="server" Height="25px" HorizontalAlign="Right">
                                Order:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell392" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="orderTextBoxu" runat="server"  /><asp:Label ID="orderLabelu" runat="server" Visible="False"></asp:Label>
                               </asp:TableCell>
                            </asp:TableRow> 
                            <asp:TableRow ID="TableRow40" runat="server">
                                <asp:TableCell ID="TableCell401" runat="server" Height="25px" HorizontalAlign="Right">
                                Minimum Time:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell402" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="mintimeTextBoxu" runat="server"  />
                               </asp:TableCell>
                            </asp:TableRow> 
                            <asp:TableRow ID="TableRow41" runat="server">
                                <asp:TableCell ID="TableCell411" runat="server" Height="25px" HorizontalAlign="Right">
                                Maximum Time:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell412" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="maxtimeTextBoxu" runat="server"  />
                               </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow42" runat="server">
                                <asp:TableCell ID="TableCell421" runat="server" Height="25px" HorizontalAlign="Right">
                                Comment:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell422" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="commentTextBoxu" runat="server"  />
                               </asp:TableCell>
                            </asp:TableRow>
                       </asp:Table>    

   
                 </asp:TableCell>
                 </asp:TableRow>
                 </asp:Table>
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
                 
                 
                 
                 
                 
                 SelectCommand=" SELECT i.source_type,
        i.ingredient_id,
        CASE i.source_type 
              WHEN 'material' THEN (SELECT s.name FROM material s WHERE s.id = i.ingredient_id)
              ELSE (SELECT s1.name FROM product s1 WHERE s1.id = i.ingredient_id)
        END AS ingredient_name,
        i.quantity,
        i.uom_id,
       u.name as uom_name,
        IF(i.`order` &gt; 0 OR i.`order` IS NULL, i.`order`, 'N/A') as `order`,
        i.mintime,
        i.maxtime,
        i.comment
   FROM ingredients i, uom u
  WHERE i.recipe_id = ?
    AND i.source_type = 'material'
    AND i.ingredient_id =1
   AND u.id = i.uom_id">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="txtID" Name="recipe_id" 
                         PropertyName="Text" DefaultValue="0" />
                 </SelectParameters>
             </asp:SqlDataSource>
                   <asp:SqlDataSource ID="sdsMain" runat="server" 
                      ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                      ProviderName="System.Data.Odbc" 
                      
                 
                 
                 SelectCommand="SELECT r.name, 
       r.exec_method, 
       r.contact_employee, 
       (SELECT concat(e.firstname, ' ', e.lastname) 
          FROM employee e 
         WHERE e.id = r.contact_employee) AS contact_employee_name,
       r.create_time,
       (SELECT concat(e1.firstname, ' ', e1.lastname)
          FROM employee e1
         WHERE e1.id = r.created_by) AS created_by_name,
       r.update_time,
       (SELECT concat(e2.firstname, ' ', e2.lastname)
          FROM employee e2
         WHERE e2.id = r.updated_by) AS updated_by_name,
       r.diagram_filename,
       r.instruction,
       r.comment
  FROM recipe r
 WHERE r.id = ?">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                              PropertyName="Text" />
                      </SelectParameters>
                  </asp:SqlDataSource> 

             <asp:SqlDataSource ID="sdsEmployee" runat="server" 
                 SelectCommand="select id, concat(firstname, ' ', lastname) as name from employee" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc">
             </asp:SqlDataSource>
  <asp:Panel   
   ID="InsertPanel" runat="server" Height="345px" CssClass="detail" 
                 style="display:none" Width="350px" 
                 HorizontalAlign="Left" >
             <asp:UpdatePanel ID="insertBufferPanel" runat="server" UpdateMode="Conditional">          
 

          <ContentTemplate>

       <asp:Table ID="Table1" runat="server" BorderWidth="0" Width="100%" Height="282px">
           <asp:TableRow ID="TableRow1" runat="server">
               <asp:TableCell ID="TableCell1" runat="server" Height="30px" HorizontalAlign="Center">
                   Add New Part to Recipe
               </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow ID="TableRow2" runat="server">
               <asp:TableCell ID="TableCell2" runat="server" HorizontalAlign="Center">
               <asp:Table ID="Table2" runat="server" CssClass="detailgrid">
                    <asp:TableRow ID="TableRow25" runat="server">

                       <asp:TableCell  ColumnSpan="2" ID="TableCell5" runat="server" Height="25px"  HorizontalAlign="Center">
                           <asp:RadioButtonList ID="rblMorP" runat="server" RepeatDirection="Horizontal" >
                               <asp:ListItem  Value="material" Selected="True" > Material</asp:ListItem>
                               <asp:ListItem  Value="product" > Product </asp:ListItem>
                           </asp:RadioButtonList>
                       </asp:TableCell>     
                   </asp:TableRow>                                    
                   <asp:TableRow ID="TableRow21" runat="server">
                       <asp:TableCell ID="TableCell21" runat="server" Height="25px" HorizontalAlign="Right">
                           Part #:</asp:TableCell>
                       <asp:TableCell ID="TableCell22" runat="server" Height="25px"  HorizontalAlign="Left">
                           <asp:DropDownList ID="ddMaterial" runat="server" Width="100%" OnChange="updateUOMLabel('material', this)">
                           </asp:DropDownList>
                            <asp:DropDownList ID="ddMUom" runat="server" 
                                                           Height="25px" Width="100%" style="display:none;">
                           </asp:DropDownList>
                           <asp:DropDownList ID="ddProduct" runat="server" 
                               Height="25px" Width="100%" style="display:none;" OnChange="updateUOMLabel('product', this)">
                           </asp:DropDownList>
                            <asp:DropDownList ID="ddPUom" runat="server" 
                                                           Height="25px" Width="100%" style="display:none;">
                           </asp:DropDownList>                           
                       </asp:TableCell>
                   </asp:TableRow>
                    <asp:TableRow ID="TableRow26" runat="server">
                       <asp:TableCell ID="TableCell6" runat="server" Height="25px" HorizontalAlign="Right">
                           Quantity:</asp:TableCell>
                       <asp:TableCell ID="TableCell7" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="qtyTextBox" runat="server" Width="60%"></asp:TextBox>
                           <asp:Label ID="lblUom" runat="server"></asp:Label>
                       </asp:TableCell>
                   </asp:TableRow>                  
                   <asp:TableRow  ID="TableRow23" runat="server">
                       <asp:TableCell ID="TableCell25" runat="server" Height="25px" HorizontalAlign="Right">
                           Order:</asp:TableCell>
                       <asp:TableCell ID="TableCell26" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="orderTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>
                    <asp:TableRow  ID="TableRow5" runat="server">
                       <asp:TableCell ID="TableCell4" runat="server" Height="25px" HorizontalAlign="Right">
                           Minimum Time:</asp:TableCell>
                       <asp:TableCell ID="TableCell9" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="mintimeTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>    
                   <asp:TableRow  ID="TableRow6" runat="server">
                       <asp:TableCell ID="TableCell10" runat="server" Height="25px" HorizontalAlign="Right">
                           Maximum Time:</asp:TableCell>
                       <asp:TableCell ID="TableCell12" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="maxtimeTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>  
                    <asp:TableRow  ID="TableRow7" runat="server">
                       <asp:TableCell ID="TableCell13" runat="server" Height="25px" HorizontalAlign="Right">
                           Comment:</asp:TableCell>
                       <asp:TableCell ID="TableCell14" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="commentTextBox" runat="server" ></asp:TextBox>
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
                  Height="60px" Width="348px"></asp:Label>
               
           
       
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
