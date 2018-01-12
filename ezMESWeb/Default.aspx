<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ezMESWeb._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ezOMM -- Online Manufacturing Management</title>
     <link rel="stylesheet" href="/CSS/general.css" type="text/css" media="screen" />  
    <style type="text/css" title="currentStyle" media="screen">
	    .style1
        {
            font-size: large;
        }
	</style>
</head>
<body bgcolor="#52514e">
    <form id="form1" runat="server">
    <div id="container">
    <div id="intro"></div>
       <div id="preamble" class="style1" >
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           A demonstration of Manufacturing Management systems that can be accomplished visually through web 
           site.
           </div>
           <div id="linkList">
    <table id="tblLogin" cellspacing="1" cellpadding="1" style="border: thin solid black; 
        width:300px; height:200px; font-size:10px; font-family:Arial; background-color:White" 
     >
          <tr style="background-color:#FFCC66; font-size:large ">
              <td colspan="2"  >
                  <div style="text-align: center">
                      <strong><span>Login Form</span></strong>
                  </div>
              </td>
          </tr>
          <tr >
              <td width="30%" style="padding-left:5px">User Name:</td>
              <td>
                  <asp:textbox id="txtUserId" runat="server" width="90%"></asp:textbox>
              </td>
          </tr>
          <tr>
              <td style="padding-left:5px">Password:</td>
              <td>
                  <asp:textbox id="txtPassword" runat="server" textmode="Password" width="90%"></asp:textbox>
              </td>
          </tr>    
          <tr>
          <td style="padding-left:5px" colspan="2">
           <asp:Label ID="lblResults" runat="server" ForeColor="Red" Visible="false">Results:</asp:label>
          </td>
          </tr>                
          <tr>
              <td style="TEXT-ALIGN: center" colspan="2">
                  <asp:button id="btnLogin" runat="server" text="Click to Login" OnClick="btnLogin_Click" />
              </td>
          </tr>
          <tr>
            <td colspan="2">
              <asp:Label ID="lblNumberOfAttempts" runat="server" Text=<%# "The application locks a user out after <B>" + Membership.Provider.MaxInvalidPasswordAttempts + " </B>failed login attempts."  %> />
             </td> 
          </tr>
        </table>

        <br />
        <asp:label id="asdf" runat="server"  ForeColor="Red" Visible="false">Results:</asp:label>&nbsp;<br />
   
    

            </div>
        </div>
    </form>
</body>
</html>
