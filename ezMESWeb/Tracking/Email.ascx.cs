using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using CommonLib.Data.EzSqlClient;
using AjaxControlToolkit;

namespace ezMESWeb.Tracking
{
  public partial class Email : System.Web.UI.UserControl
  {

    protected EzSqlConnection ezConn;
    protected EzSqlCommand ezCmd;
    protected ezDataAdapter ezAdapter;
    protected System.Data.Common.DbDataReader ezReader;

    protected Label lblFrom,lblError, lblMessage, lblIntro;
    protected TextBox txtTo, txtCc, txtSubject, txtText;
    protected Button btnEmail;

    protected ModalPopupExtender MessagePopupExtender;


    public string MailContent
    {
      set { txtText.Text = value; }
      get { return txtText.Text; }
    }
    public string Subject
    {
      set { txtSubject.Text = value; }
      get { return txtSubject.Text; }
    }
    public string Introduction
    {
      set { lblIntro.Text = value; }
      get { return lblIntro.Text; }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
      string dbConnKey;
      string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString;
      DbConnectionType ezType;

      //txtSubject.Text = "Batch " + Session["lot_alias"].ToString() + " was put on hold. Please check.";
      //txtText.Text = mailContent;

      try
      {
        if (ezConn == null)
        {
          dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
          if (dbConnKey.Equals("ODBC"))
          {
            ezType = DbConnectionType.MySqlODBC;

          }
          else if (dbConnKey.Equals("MySql"))
          {
            ezType = DbConnectionType.MySqlADO;

          }
          else
            ezType = DbConnectionType.Unknown;
          ezConn = new EzSqlConnection(ezType, connStr);
        }

        if (ezConn.State != ConnectionState.Open)
          ezConn.Open();
        ezCmd = new EzSqlCommand();
        ezCmd.Connection = ezConn;
        ezCmd.CommandText = "SELECT email FROM employee WHERE id='" + Session["UserID"].ToString() + "'";
        ezCmd.CommandType = CommandType.Text;
        lblFrom.Text = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
       
        txtCc.Text = ezCmd.ExecuteScalar().ToString();
        lblFrom.ToolTip = txtCc.Text;
      }
      catch (Exception ex)
      {
        lblError.Text = "<h3>Error</h3><hr width=100% size=1 color=silver /><ul><li>There was an unexpected exception encountered while getting sender information.<br>" + ex.Message + "</li></ul><hr width=100% size=1 color=silver />";
      }
      ezCmd.Dispose();
      ezConn.Dispose();
    }
    protected void btnEmail_Click(object sender, EventArgs e)
    {
      string[] strArray;
      try
      {
      //Create instance of main mail message class.
      System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();

      //Get From address in web.config
      mailMessage.From = new System.Net.Mail.MailAddress(lblFrom.ToolTip);

      //Set additional addresses
      strArray = txtTo.Text.Split(',');
      foreach (string strTo in strArray)
        mailMessage.To.Add(new System.Net.Mail.MailAddress(strTo));

      strArray = txtCc.Text.Split(',');
      foreach (string strCc in strArray)
        mailMessage.CC.Add(new System.Net.Mail.MailAddress(strCc));

      mailMessage.Priority = System.Net.Mail.MailPriority.High;

      mailMessage.IsBodyHtml = false;

      //Set the subjet and body text
      mailMessage.Subject =txtSubject.Text;
      mailMessage.Body = txtText.Text;

      //Create an instance of the SmtpClient class for sending the email
      System.Net.Mail.SmtpClient smtpClient = new System.Net.Mail.SmtpClient();
      smtpClient.Credentials = new System.Net.NetworkCredential(System.Configuration.ConfigurationManager.AppSettings["username"],
      System.Configuration.ConfigurationManager.AppSettings["password"]);
      smtpClient.Port = 25;


        smtpClient.Send(mailMessage);
        lblMessage.Text = "The email has been sent out successfully. Please click below OK button to cotinue.";
        MessagePopupExtender.Show();
      }
      catch (Exception ex)
      {
        lblMessage.Text="Failed to send out email. Please contact administrator or try it later. " + ex.Message;
        MessagePopupExtender.Show();

      }
     
    }
    protected void btnOK_Click(object sender, EventArgs e)
    {
      lblMessage.Text = "";
      MessagePopupExtender.Hide();
    }
  }
}