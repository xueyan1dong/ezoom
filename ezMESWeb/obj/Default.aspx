<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ezMESWeb._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ezMES -- The next generation of MES</title>
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
       <div id="preamble" class="style1">
           &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           A demonstration of new MES systems that can be be&nbsp;&nbsp;&nbsp; accomplished visually through web 
           site.
           </div>
           <div id="linkList">
       		<asp:Login ID="Login1" runat="server" BackColor="#FFCC66" BorderColor="#CCCC99" 
        BorderStyle="Solid" BorderWidth="1px" Font-Names="Arial" Font-Size="10pt" 
        Height="226px" onauthenticate="Login1_Authenticate" Width="320px" 
                    style="font-size: large; font-family: Arial, Helvetica, sans-serif;" 
                    PasswordRecoveryText="Forgot Password?" 
                    PasswordRecoveryUrl="~/ForgetPassword.aspx" ForeColor="Black">
        <TitleTextStyle BackColor="#4F4E4A" Font-Bold="True" ForeColor="#FFFFFF" 
                    Font-Size="Large" />
                <TextBoxStyle Font-Size="Large" />
        <FailureTextStyle BorderStyle="Groove" />
    </asp:Login>
            </div>
        </div>
    </form>
</body>
</html>
