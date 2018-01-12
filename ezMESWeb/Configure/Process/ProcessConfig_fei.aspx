<%@ Page Language="C#" MasterPageFile="../ConfigureModule.master" AutoEventWireup="true" CodeBehind="ProcessConfig.aspx.cs" Inherits="ezMESWeb.ProcessConfig"
 Title="Process Configuration -- ezOMM" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:content ID="Content2" contentplaceholderid="head" runat="server"> 

 <script type="text/javascript" language="javascript">
  function reloadContent(sender, e)
  {
    window.location="ProcessConfig.aspx?Tab="+sender.get_activeTabIndex()
  }
  function confirmDelete(button)
  {
    if (button.value == "Delete Workflow")
        return confirm("Do you really what to delete this workflow?");
  }
  function showDropDown(rbl, step, process, autostart)
  {
  
    
    var rblitems=document.getElementById(rbl);


    var dropdown1;
    var dropdown2;
    var autostartbox;

        autostartbox = document.getElementById(autostart);
        
        if (rblitems.rows[0].cells[0].childNodes[0].checked)
        {
            dropdown1=document.getElementById(step);
            dropdown2=document.getElementById(process);
            
        }
        else
        {
            dropdown2=document.getElementById(step);
            dropdown1=document.getElementById(process);   
            autostartbox.checked = 1; 
        }
        if (dropdown1.style.display = 'none')
        {
           dropdown1.style.display = 'block';
           dropdown2.style.display ='none';
        }    
        
         
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
</asp:content> 

<asp:Content ID="Content1" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <asp:TabContainer ID="tcMain" runat="server" 
        Height="0px" Width="100%" CssClass="amber_tab" 
        onclientactivetabchanged="reloadContent" >
    </asp:TabContainer>
<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" />
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
                 CssClass="detailgrid" BorderWidth="2px" Caption='General Workflow Information' 
                           Width ="600px">
           
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
          </asp:UpdatePanel>
          </td>
      </tr>
      <tr><td><hr /></td></tr>
      <tr><td>&nbsp;&nbsp;</td></tr>
      <tr>
         <td style="height: 117px; width: 347px;" height="20px">
                     
             <asp:Button ID="btnInsert" runat="server" Text="Insert Step/Sub Workflow" 
                 Width="157px"  /> 
             <asp:ModalPopupExtender ID="mdlPopup" runat="server" TargetControlID="btnInsert"
             BackgroundCssClass="modalBackground" PopupControlID="InsertPanel" 
              PopupDragHandleControlID="InsertPanel" Drag="True" DropShadow="True" >
             </asp:ModalPopupExtender>
 
           <asp:UpdatePanel ID="gvTablePanel" runat="server" UpdateMode="Conditional">
               <ContentTemplate>
                   <asp:GridView ID="gvTable" runat="server" Caption="Workflow" 
               CssClass="datagrid" GridLines="None" DataSourceID="sdsGrid" 
               EmptyDataText="Thsi workflow does not consist any step." Height="145px" Width="900px"
               AutoGenerateColumns="False" AutoGenerateDeleteButton="True" 
               onselectedindexchanged="gvTable_SelectedIndexChanged"  
               DataKeyNames="position_id" AllowPaging="True" PageSize="15" 
                    EnableTheming="False" onpageindexchanged="gvTable_PageIndexChanged"
             >
                       <Columns>
                           <asp:TemplateField>
                               <ItemTemplate>
                                   <asp:LinkButton ID="btnViewDetails" runat="server" Text='Edit' 
                       CommandName="Select" />
                               </ItemTemplate>
                           </asp:TemplateField>
                           <asp:BoundField DataField="position_id" HeaderText="Position" 
                     SortExpression="position_id" />
                           <asp:BoundField DataField="step" HeaderText="Step/Sub Workflow" 
                     SortExpression="step" />
                           <asp:BoundField DataField="prev_step_pos" HeaderText="Previous Position" 
                                    SortExpression="prev_step_pos" />
                           <asp:BoundField DataField="next_step_pos" HeaderText="Next Position" 
                                    SortExpression="next_step_pos" />
                           <asp:BoundField DataField="false_step_pos" HeaderText="False Position" 
                                    SortExpression="false_step_pos" />
                           <asp:BoundField DataField="rework_limit" 
                     HeaderText="Rework Limit" />
                           <asp:BoundField DataField="if_sub_process" HeaderText="If Sub Workflow" 
                     SortExpression="if_sub_process" Visible="False" />
                           <asp:BoundField DataField="prompt" HeaderText="Prompt" 
                     SortExpression="prompt" />
                           <asp:BoundField DataField="if_autostart" HeaderText="If Autostart" 
                               SortExpression="if_autostart" />
                           <asp:BoundField DataField="need_approval" HeaderText="Need Approval" 
                                    SortExpression="need_approval" />
                           <asp:BoundField DataField="approved_by" HeaderText="Approved By" />
                       </Columns>
                       <SelectedRowStyle  BackColor="#ffffcc"/>
                   </asp:GridView>
               </ContentTemplate>
              </asp:UpdatePanel> 
       <asp:SqlDataSource ID="sdsGrid" runat="server" 
           ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
           DeleteCommand="{call delete_step_from_process( ?, ?, ?)}" 
           ProviderName="System.Data.Odbc" 
           SelectCommand="select ps.position_id, s.name as step, ps.prev_step_pos, ps.next_step_pos, ps.false_step_pos, ps.rework_limit,  if(ps.if_sub_process, 'Y', 'N') as if_sub_process, ps.prompt, if(ps.if_autostart, 'Y', 'N') as if_autostart,  if(ps.need_approval, 'Y', 'N') as need_approval, concat(e1.firstname, ' ', e1.lastname) as approved_by 
from process_step ps join step s on ps.step_id=s.id left join employee e1 on ps.approve_emp_id=e1.id where ps.process_id = ? and ps.if_sub_process=0
union
select ps.position_id, s.name as step, ps.prev_step_pos, ps.next_step_pos, ps.false_step_pos,ps.rework_limit, if(ps.if_sub_process, 'Y', 'N') as if_sub_process, ps.prompt, if(ps.if_autostart, 'Y', 'N') as if_autostart, if(ps.need_approval, 'Y', 'N') as need_approval, concat(e1.firstname, ' ', e1.lastname) as approved_by 
from process_step ps join process s on ps.step_id=s.id left join employee e1 on ps.approve_emp_id=e1.id where ps.process_id = ? and ps.if_sub_process=1
order by position_id" 
          
                 InsertCommand="insert into product_group (name, prefix, surfix, create_time, created_by, description, comment) values (@name, @prefix, @surfix, now(), 1, @description, @comment)" 
                 DeleteCommandType="StoredProcedure">
           <SelectParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id1" 
                   PropertyName="Text" />
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id2" 
                   PropertyName="Text" />
           </SelectParameters>
           <DeleteParameters>
               <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Pid" 
                   PropertyName="Text" />
               <asp:SessionParameter DefaultValue="1" Name="Eid" SessionField="UserID" />
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
                 BorderWidth="0px" Caption="Update Selected Position in Workflow:" 
                 DataKeyNames="position_id,step_id" DataSourceID="sdsUpdate" 
                   DefaultMode="Edit" Height="290px" 
                HorizontalAlign="Center" onitemupdated="fvUpdate_ItemUpdated" Width="100%">
                
                     <EditItemTemplate>
                     &nbsp;&nbsp;
                        <asp:Table ID="Table3" runat="server" CssClass="detailgrid">
                            <asp:TableRow ID="TableRow31" runat="server">
                              <asp:TableCell ID="TableCell311" runat="server" Height="25px" HorizontalAlign="Right">
                              Position: 
                              </asp:TableCell>
                              <asp:TableCell ID="TableCell312" runat="server" Height="25px" HorizontalAlign="Left">
                              <asp:Label ID="position_idLabel1" runat="server" 
                               Text='<%# Eval("position_id") %>' /></asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow32" runat="server">
                                <asp:TableCell ID="TableCell321" ColumnSpan="2" runat="server" Height="25px" HorizontalAlign="Center">
                                   <asp:RadioButtonList ID="rblStepOrProcess2" runat="server" RepeatDirection="Horizontal" >
                                    <asp:ListItem  Value="step" Selected="True" >step</asp:ListItem>
                                    <asp:ListItem  Value="sub process" > sub workflow </asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:TextBox ID="if_sub_processTextBox" runat="server" 
                                    Text='<%# Bind("if_sub_process") %>' Visible="False" />
                                </asp:TableCell>
                            </asp:TableRow>  
                            <asp:TableRow ID="TableRow33" runat="server">
                                <asp:TableCell ID="TableCell331" runat="server" Height="25px" HorizontalAlign="Right">
                                Name:</asp:TableCell>
                                <asp:TableCell ID="TableCell332" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:DropDownList ID="ddStep2" runat="server" 
                                    DataSourceID="sdsSteps" DataTextField="name" DataValueField="id" 
                                    Height="25px" Width="166px">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddSubProcess2" runat="server" 
                                    DataSourceID="sdsSubProcess" DataTextField="name" DataValueField="id" 
                                    Height="25px" Width="166px" style="display:none;">
                                    </asp:DropDownList>  
                                    <asp:TextBox ID="step_idTextBox" runat="server" 
                                    Text='<%# Bind("step_id") %>' Visible="False" />                    
                                </asp:TableCell>
                            </asp:Tablerow>   
                            <asp:TableRow ID="TableRow34" runat="server">
                                <asp:TableCell ID="TableCell341" runat="server" Height="25px" HorizontalAlign="Right">
                                Previous Step Position
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell342" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:TextBox ID="prev_step_posTextBox" runat="server" 
                                    Text='<%# Bind("prev_step_pos") %>' />
                                </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow35" runat="server">
                                <asp:TableCell ID="TableCell351" runat="server" Height="25px" HorizontalAlign="Right">
                                Next Step Position
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell352" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="next_step_posTextBox" runat="server" 
                               Text='<%# Bind("next_step_pos") %>' />
                               </asp:TableCell>
                            </asp:TableRow>   
                            <asp:TableRow ID="TableRow36" runat="server">
                                <asp:TableCell ID="TableCell361" runat="server" Height="25px" HorizontalAlign="Right">
                                Step Position on Faulse Result:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell362" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="false_step_posTextBox" runat="server" 
                               Text='<%# Bind("false_step_pos") %>' />
                               </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="TableRow39" runat="server">
                                <asp:TableCell ID="TableCell391" runat="server" Height="25px" HorizontalAlign="Right">
                                Rework Limit:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell11" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="rework_limitTextBox" runat="server" 
                               Text='<%# Bind("rework_limit") %>' />
                               </asp:TableCell>
                            </asp:TableRow> 
                            <asp:TableRow ID="TableRow40" runat="server">
                                <asp:TableCell ID="TableCell401" runat="server" Height="25px" HorizontalAlign="Right">
                                Prompt:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell402" runat="server" Height="25px" HorizontalAlign="Left">
                                <asp:TextBox ID="promptTextBox" runat="server" 
                               Text='<%# Bind("prompt") %>' />
                               </asp:TableCell>
                            </asp:TableRow> 
                            <asp:TableRow ID="TableRow41" runat="server">
                                <asp:TableCell ID="TableCell15" ColumnSpan="2" runat="server" Height="25px" HorizontalAlign="Center">
                                <asp:CheckBox ID="chkIfAutoStart2" runat="server" Text="Automatically Start the Step?" />
                                <asp:TextBox ID="if_autostartTextBox" runat="server" 
                                Text='<%# Bind("if_autostart") %>' Visible="False" />
                                </asp:TableCell>                               
                            </asp:TableRow>                                                                                   
                            <asp:TableRow ID="TableRow37" runat="server">
                                <asp:TableCell ID="TableCell371" ColumnSpan="2" runat="server" Height="25px" HorizontalAlign="Center">
                                <asp:CheckBox ID="chkApproval2" runat="server" Text="Need Approval?" />
                                <asp:TextBox ID="need_approvalTextBox" runat="server" 
                                Text='<%# Bind("need_approval") %>' Visible="False" />
                                </asp:TableCell>
                            </asp:TableRow>

                            <asp:TableRow ID="tbrApprove2" runat="server">
                                <asp:TableCell ID="TableCell381" runat="server" Height="25px" HorizontalAlign="Right">
                                Approved By:
                                </asp:TableCell>
                                <asp:TableCell ID="TableCell382" runat="server" Height="25px" HorizontalAlign="Left">
                                    <asp:DropDownList ID="ddApproval2" runat="server" 
                                    DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                                    Height="25px" Width="166px">
                                    </asp:DropDownList>
                                    <asp:TextBox ID="approve_emp_idTextBox" runat="server" 
                                    Text='<%# Bind("approve_emp_id") %>' Visible="False" />
                                 </asp:TableCell>
                            </asp:TableRow>
                       </asp:Table>    

                     </EditItemTemplate>
                     <InsertItemTemplate>
                         position_id:
                         <asp:TextBox ID="position_idTextBox" runat="server" 
                             Text='<%# Bind("position_id") %>' />
                         <br />
                         step_id:
                         <asp:TextBox ID="step_idTextBox" runat="server" 
                             Text='<%# Bind("step_id") %>' />
                         <br />
                         prev_step_pos:
                         <asp:TextBox ID="prev_step_posTextBox" runat="server" 
                             Text='<%# Bind("prev_step_pos") %>' />
                         <br />
                         next_step_pos:
                         <asp:TextBox ID="next_step_posTextBox" runat="server" 
                             Text='<%# Bind("next_step_pos") %>' />
                         <br />
                         false_step_pos:
                         <asp:TextBox ID="false_step_posTextBox" runat="server" 
                             Text='<%# Bind("false_step_pos") %>' />
                         <br />
                         if_sub_process:
                         <asp:TextBox ID="if_sub_processTextBox" runat="server" 
                             Text='<%# Bind("if_sub_process") %>' />
                         <br />
                         need_approval:
                         <asp:TextBox ID="need_approvalTextBox" runat="server" 
                             Text='<%# Bind("need_approval") %>' />
                         <br />
                         approve_emp_id:
                         <asp:TextBox ID="approve_emp_idTextBox" runat="server" 
                             Text='<%# Bind("approve_emp_id") %>' />
                         <br />
                         <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                             CommandName="Insert" Text="Insert" />
                         &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                             CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                     </InsertItemTemplate>
                     <ItemTemplate>
                         position_id:
                         <asp:Label ID="position_idLabel" runat="server" 
                             Text='<%# Eval("position_id") %>' />
                         <br />
                         step_id:
                         <asp:Label ID="step_idLabel" runat="server" 
                             Text='<%# Eval("step_id") %>' />
                         <br />
                         prev_step_pos:
                         <asp:Label ID="prev_step_posLabel" runat="server" 
                             Text='<%# Bind("prev_step_pos") %>' />
                         <br />
                         next_step_pos:
                         <asp:Label ID="next_step_posLabel" runat="server" 
                             Text='<%# Bind("next_step_pos") %>' />
                         <br />
                         false_step_pos:
                         <asp:Label ID="false_step_posLabel" runat="server" 
                             Text='<%# Bind("false_step_pos") %>' />
                         <br />
                         if_sub_process:
                         <asp:Label ID="if_sub_processLabel" runat="server" 
                             Text='<%# Bind("if_sub_process") %>' />
                         <br />
                         need_approval:
                         <asp:Label ID="need_approvalLabel" runat="server" 
                             Text='<%# Bind("need_approval") %>' />
                         <br />
                         approve_emp_id:
                         <asp:Label ID="approve_emp_idLabel" runat="server" 
                             Text='<%# Bind("approve_emp_id") %>' />
                         <br />
                         <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" 
                             CommandName="Edit" Text="Edit" />
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
                 InsertCommand="insert into product_group (name, prefix, surfix, create_time, created_by, description, comment) values (@name, @prefix, @surfix, now(), 1, @description, @comment)" 
                 ProviderName="System.Data.Odbc"       
                 SelectCommand="SELECT position_id, step_id, prev_step_pos, next_step_pos, false_step_pos, rework_limit, if_sub_process, prompt, if_autostart, need_approval, approve_emp_id FROM process_step WHERE process_id=? and position_id = ?">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="txtID" Name="process_id" 
                         PropertyName="Text" DefaultValue="0" />
                     <asp:ControlParameter ControlID="gvTable" DefaultValue="0" Name="position_id" 
                         PropertyName="SelectedValue" />
                 </SelectParameters>
             </asp:SqlDataSource>
                   <asp:SqlDataSource ID="sdsMain" runat="server" 
                      ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                      ProviderName="System.Data.Odbc" 
                 SelectCommand="select p.id, prg.name as process_group, p.prg_id, p.name, p.start_pos_id, concat(e3.firstname, ' ', e3.lastname) as owner, p.owner_id,  
                 p.usage, case p.usage when 'main process only' then 'main workflow only' when 'sub process only' then 'sub workflow only' else p.usage end as usage_t,
                  p.description, p.comment, p.create_time, concat(e.firstname, ' ',e.lastname) as created_by, p.state_change_time as update_time, 
                  concat(e2.firstname, ' ', e2.lastname) as updated_by  
                  from process p left join employee e on p.created_by = e.id 
                  left join employee e2 on p.state_changed_by=e2.id 
                  left join process_group prg on p.prg_id = prg.id 
                  left join employee e3 on p.owner_id=e3.id where p.id=?">
                      <SelectParameters>
                          <asp:ControlParameter ControlID="txtID" DefaultValue="0" Name="Id" 
                              PropertyName="Text" />
                      </SelectParameters>
                  </asp:SqlDataSource> 
             <asp:SqlDataSource ID="sdsSteps" runat="server" 
                 SelectCommand="select id, name from step" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc"></asp:SqlDataSource>
             <asp:SqlDataSource ID="sdsProcess_group" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc" 
                 SelectCommand="select id, name from process_group"></asp:SqlDataSource> 
             <asp:SqlDataSource ID="sdsSubProcess" runat="server" 
                 ConnectionString="<%$ ConnectionStrings:ezmesConnectionString %>" 
                 ProviderName="System.Data.Odbc" 
                 
                 SelectCommand="select id, name from process where id!=? and `usage`!='main process only'">
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
   ID="InsertPanel" runat="server" Height="460px" CssClass="detail" 
                 style="display:none" Width="350px" 
                 HorizontalAlign="Left" >
             <asp:UpdatePanel ID="insertBufferPanel" runat="server" UpdateMode="Conditional">          
 

          <ContentTemplate>

       <asp:Table ID="Table1" runat="server" BorderWidth="0" Width="100%" Height="398px">
           <asp:TableRow ID="TableRow1" runat="server">
               <asp:TableCell ID="TableCell1" runat="server" Height="30px" HorizontalAlign="Center">
                   Add New Step or Sub Workflow to Current Workflow
               </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow ID="TableRow2" runat="server">
               <asp:TableCell ID="TableCell2" runat="server" HorizontalAlign="Center">
               <asp:Table ID="Table2" runat="server" CssClass="detailgrid">
                   <asp:TableRow ID="TableRow22" runat="server">
                       <asp:TableCell ID="TableCell23" runat="server" Height="25px" HorizontalAlign="Right">
                           Position:</asp:TableCell>
                       <asp:TableCell ID="TableCell24" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="positionTextBox" runat="server" ToolTip="integer only"></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>
                    <asp:TableRow ID="TableRow25" runat="server">

                       <asp:TableCell  ColumnSpan="2" ID="TableCell5" runat="server" Height="25px"  HorizontalAlign="Center">
                           <asp:RadioButtonList ID="rblStepOrProcess" runat="server" RepeatDirection="Horizontal" >
                               <asp:ListItem  Value="step" Selected="True" >step</asp:ListItem>
                               <asp:ListItem  Value="sub process" > sub workflow </asp:ListItem>
                           </asp:RadioButtonList>
                       </asp:TableCell>     
                   </asp:TableRow>                                    
                   <asp:TableRow ID="TableRow21" runat="server">
                       <asp:TableCell ID="TableCell21" runat="server" Height="25px" HorizontalAlign="Right">
                           Name:</asp:TableCell>
                       <asp:TableCell ID="TableCell22" runat="server" Height="25px"  HorizontalAlign="Left">
                           <asp:DropDownList ID="ddStep" runat="server" 
                               DataSourceID="sdsSteps" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList>
                           <asp:DropDownList ID="ddSubProcess" runat="server" 
                               DataSourceID="sdsSubProcess" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px" style="display:none;">
                           </asp:DropDownList>
                       </asp:TableCell>
                   </asp:TableRow>
                    <asp:TableRow ID="TableRow26" runat="server">
                       <asp:TableCell ID="TableCell6" runat="server" Height="25px" HorizontalAlign="Right">
                           Previous Step Position:</asp:TableCell>
                       <asp:TableCell ID="TableCell7" runat="server" Height="25px"  HorizontalAlign="Left">
                           <asp:TextBox ID="prevpositionTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>                  
                   <asp:TableRow  ID="TableRow23" runat="server">
                       <asp:TableCell ID="TableCell25" runat="server" Height="25px" HorizontalAlign="Right">
                           Next Step Position:</asp:TableCell>
                       <asp:TableCell ID="TableCell26" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="nextpositionTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>
                    <asp:TableRow  ID="TableRow5" runat="server">
                       <asp:TableCell ID="TableCell4" runat="server" Height="25px" HorizontalAlign="Right">
                           Step Position on False Result:</asp:TableCell>
                       <asp:TableCell ID="TableCell9" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="falsepositionTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>    
                   <asp:TableRow  ID="TableRow6" runat="server">
                       <asp:TableCell ID="TableCell10" runat="server" Height="25px" HorizontalAlign="Right">
                           Rework Limit:</asp:TableCell>
                       <asp:TableCell ID="TableCell12" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="reworklimitTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>  
                    <asp:TableRow  ID="TableRow7" runat="server">
                       <asp:TableCell ID="TableCell13" runat="server" Height="25px" HorizontalAlign="Right">
                           Prompt:</asp:TableCell>
                       <asp:TableCell ID="TableCell14" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:TextBox ID="promptTextBox" runat="server" ></asp:TextBox>
                       </asp:TableCell>
                   </asp:TableRow>  
                   <asp:TableRow  ID="TableRow8" runat="server">
                       <asp:TableCell ID="TableCell16" ColumnSpan="2" runat="server" Height="25px" HorizontalAlign="Center">
                           <asp:CheckBox ID="chkIfAutoStart" runat="server" Text="Automatically Start the Step?" />
                       </asp:TableCell>
                   </asp:TableRow>                                                 
                   <asp:TableRow  ID="TableRow4" runat="server">
                       <asp:TableCell ID="TableCell8" ColumnSpan="2" runat="server" Height="25px" HorizontalAlign="Center">
                           <asp:CheckBox ID="chkApproval" runat="server" Text="Need Approval?" />
                       </asp:TableCell>
                   </asp:TableRow>                   
                   <asp:TableRow ID="tbrApprove" runat="server" style="display:none" >
                       <asp:TableCell ID="TableCell27" runat="server" Height="25px" HorizontalAlign="Right">
                           Approve By:</asp:TableCell>
                       <asp:TableCell ID="TableCell28" runat="server" Height="25px" HorizontalAlign="Left">
                           <asp:DropDownList ID="ddApproval" runat="server" 
                               DataSourceID="sdsEmployee" DataTextField="name" DataValueField="id" 
                               Height="25px" Width="166px">
                           </asp:DropDownList>
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
