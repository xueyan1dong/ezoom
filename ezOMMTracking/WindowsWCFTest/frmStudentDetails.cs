using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ezOMMClient.DispatchServiceReference;

namespace ezOMMClient
{
    public partial class frmStudentDetails : Form
    {
        public frmStudentDetails()
        {
            InitializeComponent();
        }




        private void btnStartStep_Click(object sender, EventArgs e)
        {
            string lotAlias = txtLotId.Text.Trim();
            if(lotAlias.Length > 0)
            {

                // create the proxy to access the service
                DispatchServiceClient studClient = new DispatchServiceClient("WSHttpBinding_IDispatchService");

                //// Get Fullname of the Student through the proxy from service
                ////lblFullName.Text = studClient.GetStudentFullName(stud_id);


                //// Get details of the Student through the proxy from service
                //LotInformation x = studClient.GetLotInfo(lotAlias);
                //lblID.Text = x.LotId.ToString();
                //lblStatus.Text = x.Status;
                //lblCurQuantity.Text = x.CurQuantity + " " + x.UomName;
                //lblContact.Text = x.ContactEmployeeName;
                //lblPriority.Text = x.PriorityName;
                //lblProcess.Text = x.ProcessName;
                //lblCurSubProcess.Text = x.LastSubProcessName;
                //lblLastPos.Text = x.LastPositionId;
                //lblLastSubPos.Text = x.LastSubPositionId;
                //lblLastStep.Text = x.LastStepName;
                //lblLastEq.Text = x.LastEquipmentName;
                //lblNextSubProcess.Text = x.NextSubProcessName;
                //lblNextPos.Text = x.NextPositionId;
                //lblNextSubPos.Text = x.NextSubPositionId;
                //lblNextStep.Text = x.NextStepName;
                //lblNextEqUsage.Text = x.NextEquipmentUsage;
                //lblNextEq.Text = x.NextEquipmentName;
                //lblComment.Text = x.Comment;
                string test = studClient.test();
                MessageBox.Show(test);
              
                studClient.Close();
            }
            else
            {
                MessageBox.Show("Please enter valid Lot Alias Name.");
            }
        }

        private void txtLotId_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
