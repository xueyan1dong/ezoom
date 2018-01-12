/*--------------------------------------------------------------
*    Copyright 2009 Ambersoft LLC.
*    Source File            : Contactus.aspx.cs
*    Created By             : Fei Xue
*    Date Created           : 11/03/2009
*    Platform Dependencies  : .NET 2.0
*    Description            : 
*
----------------------------------------------------------------*/

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
namespace ezMESWeb
{
  public partial class ContactUs : ConfigTemplate
    {
      protected global::System.Web.UI.WebControls.SqlDataSource sdsFeedbackGrid;
      public DataColumnCollection colc;
      protected Label lblError, lblResults;
      protected TextBox txtFrom, txtContact, txtSubject, txtBody;
      protected override void OnInit(EventArgs e)
      {
        base.OnInit(e);

        {
          DataView dv = (DataView)sdsFeedbackGrid.Select(DataSourceSelectArguments.Empty);
          colc = dv.Table.Columns;

          //Initial insert template  
          FormView1.InsertItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.SelectedItem, colc, false, Server.MapPath(@"ContactUs.xml"));

          //Initial Edit template           
          FormView1.EditItemTemplate = new ezMES.ITemplate.FormattedTemplate(System.Web.UI.WebControls.ListItemType.EditItem, colc, true, Server.MapPath(@"ContactUs.xml"));

          //Event happens before the select index changed clicked.
          gvTable.SelectedIndexChanging += new GridViewSelectEventHandler(gvTable_SelectedIndexChanging);
          if (Session["FirstName"]!=null)
            txtFrom.Text = Session["FirstName"].ToString() + " " + Session["LastName"].ToString();
        }
      }

      protected void gvTable_SelectedIndexChanging(object sender, EventArgs e)
      {
        //modify the mode of form view
        FormView1.ChangeMode(FormViewMode.Edit);

      }


      protected void btnSubmit_Click(object sender, EventArgs e)
      {
        if (Page.IsValid)
        {
          string response;
          ConnectToDb();
          ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "issue_feedback";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezMES.ITemplate.FormattedTemplate fTemp;

          ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));
          if (FormView1.CurrentMode == FormViewMode.Insert)
          {
            ezCmd.Parameters.AddWithValue("@_feedback_id", DBNull.Value);

            fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.InsertItemTemplate;

            ezCmd.Parameters["@_feedback_id"].Direction = ParameterDirection.InputOutput;


          }
          else
          {
            ezCmd.Parameters.AddWithValue("@_feedback_id", gvTable.SelectedValue);
            ezCmd.Parameters["@_feedback_id"].Direction = ParameterDirection.InputOutput;
            fTemp = (ezMES.ITemplate.FormattedTemplate)FormView1.EditItemTemplate;
          }


          LoadSqlParasFromTemplate(ezCmd, fTemp);


          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
          ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

          ezCmd.ExecuteNonQuery();
          response = ezCmd.Parameters["@_response"].Value.ToString();

          ezCmd.Dispose();
          ezConn.Dispose();

          if (response.Length > 0)
          {
            lblError.Text = response;
            this.ModalPopupExtender.Show();
          }
          else
          {
            lblError.Text = "";
            this.FormView1.Visible = false;
            this.ModalPopupExtender.Hide();

            //  add the css class for our yellow fade
            ScriptManager.GetCurrent(this).RegisterDataItem(
              // The control I want to send data to
                this.gvTable,
              //  The data I want to send it (the row that was edited)
                this.gvTable.SelectedIndex.ToString()
            );

            gvTable.DataBind();
            this.gvTablePanel.Update();

          }
        }

      }


      protected void btnCancel_Click(object sender, EventArgs e)
      {
        lblError.Text = "";
        ModalPopupExtender.Hide();
      }

      protected void btn_Click(object sender, EventArgs e)
      {
        //  set it to true so it will render
        this.FormView1.Visible = true;
        FormView1.ChangeMode(FormViewMode.Insert);
        //  force databinding
        this.FormView1.DataBind();
        //  update the contents in the detail panel
        this.updateRecordPanel.Update();
        //  show the modal popup
        this.ModalPopupExtender.Show();
      }

      protected void btn_Send(object sender, EventArgs e)
      {
          string response, subject, contactInfo, body;
          ConnectToDb();
          ezCmd = new CommonLib.Data.EzSqlClient.EzSqlCommand();
          ezCmd.Connection = ezConn;
          ezCmd.CommandText = "issue_feedback";
          ezCmd.CommandType = CommandType.StoredProcedure;
          ezMES.ITemplate.FormattedTemplate fTemp;

          ezCmd.Parameters.AddWithValue("@_employee_id", Convert.ToInt32(Session["UserID"]));

          ezCmd.Parameters.AddWithValue("@_feedback_id", DBNull.Value);
          ezCmd.Parameters["@_feedback_id"].Direction = ParameterDirection.InputOutput;

        subject = txtSubject.Text.Trim();
          ezCmd.Parameters.AddWithValue("@_subject", subject);
          contactInfo = txtContact.Text.Trim();
          ezCmd.Parameters.AddWithValue("@_contact_info", contactInfo);
          body = txtBody.Text.Trim();
          ezCmd.Parameters.AddWithValue("@_note", body);


          ezCmd.Parameters.AddWithValue("@_response", DBNull.Value);
          ezCmd.Parameters["@_response"].Direction = ParameterDirection.Output;

          ezCmd.ExecuteNonQuery();
          response = ezCmd.Parameters["@_response"].Value.ToString();

          ezCmd.Dispose();
          ezConn.Dispose();

          if (response.Length > 0)
          {
            lblResults.Text = response;
            lblResults.Visible = true;
          }
          else
          {
            lblResults.Text = "";

            ////  add the css class for our yellow fade
            //ScriptManager.GetCurrent(this).RegisterDataItem(
            //  // The control I want to send data to
            //    this.gvTable,
            //  //  The data I want to send it (the row that was edited)
            //    this.gvTable.SelectedIndex.ToString()
            //);

            gvTable.DataBind();
            this.gvTablePanel.Update();

          }
        
        //Create instance of main mail message class.
        System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();

        //Get From address in web.config
        mailMessage.From = new System.Net.Mail.MailAddress(System.Configuration.ConfigurationManager.AppSettings["fromEmailAddress"]);

        //Set additional addresses
        mailMessage.To.Add(new System.Net.Mail.MailAddress(System.Configuration.ConfigurationManager.AppSettings["toEmailAddress"]));
        mailMessage.CC.Add(new System.Net.Mail.MailAddress(System.Configuration.ConfigurationManager.AppSettings["ccEmailAddress"]));

        mailMessage.Priority = System.Net.Mail.MailPriority.High;

        mailMessage.IsBodyHtml = false;

        //Set the subjet and body text
        mailMessage.Subject = "ezOMM Feedback: " + subject;
        mailMessage.Body = "From: " + txtFrom.Text.Trim() + "\n" + "Contact Info: " + contactInfo + "\n"
          + body;

        //Create an instance of the SmtpClient class for sending the email
        System.Net.Mail.SmtpClient smtpClient = new System.Net.Mail.SmtpClient();
        smtpClient.Credentials = new System.Net.NetworkCredential(System.Configuration.ConfigurationManager.AppSettings["username"],
        System.Configuration.ConfigurationManager.AppSettings["password"]);
        smtpClient.Port = 25;

        try
        {
          smtpClient.Send(mailMessage);
          lblResults.Visible = true;
          lblResults.Text += "Your feedback has been sent to our support staff successfully. Thanks!";

        }
        catch (Exception ex)
        {
          lblResults.Visible = true;
          lblResults.Text += "Email sent out failed. Please try it later. " + ex.Message;

        }

      }

    }
}
