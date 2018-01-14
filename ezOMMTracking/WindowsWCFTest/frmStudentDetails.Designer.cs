namespace ezOMMClient
{
    partial class frmStudentDetails
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
          this.txtLotId = new System.Windows.Forms.TextBox();
          this.btnStartStep = new System.Windows.Forms.Button();
          this.label1 = new System.Windows.Forms.Label();
          this.label2 = new System.Windows.Forms.Label();
          this.label3 = new System.Windows.Forms.Label();
          this.lblID = new System.Windows.Forms.Label();
          this.lblStatus = new System.Windows.Forms.Label();
          this.label4 = new System.Windows.Forms.Label();
          this.lblCurQuantity = new System.Windows.Forms.Label();
          this.label5 = new System.Windows.Forms.Label();
          this.lblContact = new System.Windows.Forms.Label();
          this.label6 = new System.Windows.Forms.Label();
          this.lblPriority = new System.Windows.Forms.Label();
          this.label7 = new System.Windows.Forms.Label();
          this.lblProcess = new System.Windows.Forms.Label();
          this.label8 = new System.Windows.Forms.Label();
          this.lblCurSubProcess = new System.Windows.Forms.Label();
          this.label9 = new System.Windows.Forms.Label();
          this.lblLastPos = new System.Windows.Forms.Label();
          this.label10 = new System.Windows.Forms.Label();
          this.lblLastSubPos = new System.Windows.Forms.Label();
          this.label11 = new System.Windows.Forms.Label();
          this.lblLastStep = new System.Windows.Forms.Label();
          this.label12 = new System.Windows.Forms.Label();
          this.lblLastEq = new System.Windows.Forms.Label();
          this.label13 = new System.Windows.Forms.Label();
          this.lblNextSubProcess = new System.Windows.Forms.Label();
          this.label14 = new System.Windows.Forms.Label();
          this.label15 = new System.Windows.Forms.Label();
          this.lblNextPos = new System.Windows.Forms.Label();
          this.lblNextSubPos = new System.Windows.Forms.Label();
          this.label16 = new System.Windows.Forms.Label();
          this.label17 = new System.Windows.Forms.Label();
          this.label18 = new System.Windows.Forms.Label();
          this.lblNextStep = new System.Windows.Forms.Label();
          this.lblNextEqUsage = new System.Windows.Forms.Label();
          this.lblNextEq = new System.Windows.Forms.Label();
          this.label19 = new System.Windows.Forms.Label();
          this.lblComment = new System.Windows.Forms.Label();
          this.btnStart = new System.Windows.Forms.Button();
          this.SuspendLayout();
          // 
          // txtLotId
          // 
          this.txtLotId.AcceptsReturn = true;
          this.txtLotId.AcceptsTab = true;
          this.txtLotId.Location = new System.Drawing.Point(127, 27);
          this.txtLotId.MaxLength = 21;
          this.txtLotId.Name = "txtLotId";
          this.txtLotId.Size = new System.Drawing.Size(109, 21);
          this.txtLotId.TabIndex = 0;
          this.txtLotId.TextChanged += new System.EventHandler(this.txtLotId_TextChanged);
          // 
          // btnStartStep
          // 
          this.btnStartStep.BackColor = System.Drawing.Color.Gainsboro;
          this.btnStartStep.FlatAppearance.BorderColor = System.Drawing.Color.AliceBlue;
          this.btnStartStep.FlatAppearance.BorderSize = 0;
          this.btnStartStep.FlatAppearance.MouseDownBackColor = System.Drawing.Color.AliceBlue;
          this.btnStartStep.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
          this.btnStartStep.Font = new System.Drawing.Font("Courier New", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.btnStartStep.ForeColor = System.Drawing.Color.Black;
          this.btnStartStep.Location = new System.Drawing.Point(301, 25);
          this.btnStartStep.Name = "btnStartStep";
          this.btnStartStep.Size = new System.Drawing.Size(161, 28);
          this.btnStartStep.TabIndex = 4;
          this.btnStartStep.Text = "&Get Lot Info";
          this.btnStartStep.UseVisualStyleBackColor = false;
          this.btnStartStep.Click += new System.EventHandler(this.btnStartStep_Click);
          // 
          // label1
          // 
          this.label1.AutoSize = true;
          this.label1.BackColor = System.Drawing.Color.Transparent;
          this.label1.Font = new System.Drawing.Font("Courier New", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label1.ForeColor = System.Drawing.Color.White;
          this.label1.Location = new System.Drawing.Point(33, 32);
          this.label1.Name = "label1";
          this.label1.Size = new System.Drawing.Size(96, 16);
          this.label1.TabIndex = 5;
          this.label1.Text = "Lot Alias :";
          // 
          // label2
          // 
          this.label2.AutoSize = true;
          this.label2.BackColor = System.Drawing.Color.Transparent;
          this.label2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label2.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label2.ForeColor = System.Drawing.Color.White;
          this.label2.Location = new System.Drawing.Point(228, 76);
          this.label2.Name = "label2";
          this.label2.Size = new System.Drawing.Size(64, 16);
          this.label2.TabIndex = 7;
          this.label2.Text = "Lot ID:";
          // 
          // label3
          // 
          this.label3.AutoSize = true;
          this.label3.BackColor = System.Drawing.Color.Transparent;
          this.label3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label3.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label3.ForeColor = System.Drawing.Color.White;
          this.label3.Location = new System.Drawing.Point(228, 93);
          this.label3.Name = "label3";
          this.label3.Size = new System.Drawing.Size(64, 16);
          this.label3.TabIndex = 9;
          this.label3.Text = "Status:";
          // 
          // lblID
          // 
          this.lblID.AutoSize = true;
          this.lblID.BackColor = System.Drawing.Color.Transparent;
          this.lblID.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblID.Location = new System.Drawing.Point(298, 76);
          this.lblID.Name = "lblID";
          this.lblID.Size = new System.Drawing.Size(0, 16);
          this.lblID.TabIndex = 10;
          // 
          // lblStatus
          // 
          this.lblStatus.AutoSize = true;
          this.lblStatus.BackColor = System.Drawing.Color.Transparent;
          this.lblStatus.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblStatus.Location = new System.Drawing.Point(298, 93);
          this.lblStatus.Name = "lblStatus";
          this.lblStatus.Size = new System.Drawing.Size(0, 16);
          this.lblStatus.TabIndex = 11;
          // 
          // label4
          // 
          this.label4.AutoSize = true;
          this.label4.BackColor = System.Drawing.Color.Transparent;
          this.label4.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label4.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label4.ForeColor = System.Drawing.Color.White;
          this.label4.Location = new System.Drawing.Point(148, 109);
          this.label4.Name = "label4";
          this.label4.Size = new System.Drawing.Size(144, 16);
          this.label4.TabIndex = 12;
          this.label4.Text = "Current Quantity:";
          // 
          // lblCurQuantity
          // 
          this.lblCurQuantity.AutoSize = true;
          this.lblCurQuantity.BackColor = System.Drawing.Color.Transparent;
          this.lblCurQuantity.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblCurQuantity.Location = new System.Drawing.Point(298, 109);
          this.lblCurQuantity.Name = "lblCurQuantity";
          this.lblCurQuantity.Size = new System.Drawing.Size(0, 16);
          this.lblCurQuantity.TabIndex = 13;
          // 
          // label5
          // 
          this.label5.AutoSize = true;
          this.label5.BackColor = System.Drawing.Color.Transparent;
          this.label5.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label5.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label5.ForeColor = System.Drawing.Color.White;
          this.label5.Location = new System.Drawing.Point(148, 125);
          this.label5.Name = "label5";
          this.label5.Size = new System.Drawing.Size(144, 16);
          this.label5.TabIndex = 14;
          this.label5.Text = "Contact Employee:";
          // 
          // lblContact
          // 
          this.lblContact.AutoSize = true;
          this.lblContact.BackColor = System.Drawing.Color.Transparent;
          this.lblContact.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblContact.Location = new System.Drawing.Point(298, 125);
          this.lblContact.Name = "lblContact";
          this.lblContact.Size = new System.Drawing.Size(0, 16);
          this.lblContact.TabIndex = 15;
          // 
          // label6
          // 
          this.label6.AutoSize = true;
          this.label6.BackColor = System.Drawing.Color.Transparent;
          this.label6.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label6.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label6.ForeColor = System.Drawing.Color.White;
          this.label6.Location = new System.Drawing.Point(212, 141);
          this.label6.Name = "label6";
          this.label6.Size = new System.Drawing.Size(80, 16);
          this.label6.TabIndex = 16;
          this.label6.Text = "Priority:";
          // 
          // lblPriority
          // 
          this.lblPriority.AutoSize = true;
          this.lblPriority.BackColor = System.Drawing.Color.Transparent;
          this.lblPriority.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblPriority.Location = new System.Drawing.Point(298, 141);
          this.lblPriority.Name = "lblPriority";
          this.lblPriority.Size = new System.Drawing.Size(0, 16);
          this.lblPriority.TabIndex = 17;
          // 
          // label7
          // 
          this.label7.AutoSize = true;
          this.label7.BackColor = System.Drawing.Color.Transparent;
          this.label7.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label7.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label7.ForeColor = System.Drawing.Color.White;
          this.label7.Location = new System.Drawing.Point(220, 157);
          this.label7.Name = "label7";
          this.label7.Size = new System.Drawing.Size(72, 16);
          this.label7.TabIndex = 18;
          this.label7.Text = "Process:";
          // 
          // lblProcess
          // 
          this.lblProcess.AutoSize = true;
          this.lblProcess.BackColor = System.Drawing.Color.Transparent;
          this.lblProcess.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblProcess.Location = new System.Drawing.Point(298, 157);
          this.lblProcess.Name = "lblProcess";
          this.lblProcess.Size = new System.Drawing.Size(0, 16);
          this.lblProcess.TabIndex = 19;
          // 
          // label8
          // 
          this.label8.AutoSize = true;
          this.label8.BackColor = System.Drawing.Color.Transparent;
          this.label8.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label8.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label8.ForeColor = System.Drawing.Color.White;
          this.label8.Location = new System.Drawing.Point(148, 173);
          this.label8.Name = "label8";
          this.label8.Size = new System.Drawing.Size(144, 16);
          this.label8.TabIndex = 20;
          this.label8.Text = "Last Sub Process:";
          // 
          // lblCurSubProcess
          // 
          this.lblCurSubProcess.AutoSize = true;
          this.lblCurSubProcess.BackColor = System.Drawing.Color.Transparent;
          this.lblCurSubProcess.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblCurSubProcess.Location = new System.Drawing.Point(298, 173);
          this.lblCurSubProcess.Name = "lblCurSubProcess";
          this.lblCurSubProcess.Size = new System.Drawing.Size(0, 16);
          this.lblCurSubProcess.TabIndex = 21;
          // 
          // label9
          // 
          this.label9.AutoSize = true;
          this.label9.BackColor = System.Drawing.Color.Transparent;
          this.label9.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label9.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label9.ForeColor = System.Drawing.Color.White;
          this.label9.Location = new System.Drawing.Point(148, 189);
          this.label9.Name = "label9";
          this.label9.Size = new System.Drawing.Size(144, 16);
          this.label9.TabIndex = 22;
          this.label9.Text = "Last Position Id:";
          // 
          // lblLastPos
          // 
          this.lblLastPos.AutoSize = true;
          this.lblLastPos.BackColor = System.Drawing.Color.Transparent;
          this.lblLastPos.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblLastPos.Location = new System.Drawing.Point(298, 189);
          this.lblLastPos.Name = "lblLastPos";
          this.lblLastPos.Size = new System.Drawing.Size(0, 16);
          this.lblLastPos.TabIndex = 23;
          // 
          // label10
          // 
          this.label10.AutoSize = true;
          this.label10.BackColor = System.Drawing.Color.Transparent;
          this.label10.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label10.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label10.ForeColor = System.Drawing.Color.White;
          this.label10.Location = new System.Drawing.Point(116, 205);
          this.label10.Name = "label10";
          this.label10.Size = new System.Drawing.Size(176, 16);
          this.label10.TabIndex = 24;
          this.label10.Text = "Last Sub Position Id:";
          // 
          // lblLastSubPos
          // 
          this.lblLastSubPos.AutoSize = true;
          this.lblLastSubPos.BackColor = System.Drawing.Color.Transparent;
          this.lblLastSubPos.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblLastSubPos.Location = new System.Drawing.Point(298, 205);
          this.lblLastSubPos.Name = "lblLastSubPos";
          this.lblLastSubPos.Size = new System.Drawing.Size(0, 16);
          this.lblLastSubPos.TabIndex = 25;
          // 
          // label11
          // 
          this.label11.AutoSize = true;
          this.label11.BackColor = System.Drawing.Color.Transparent;
          this.label11.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label11.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label11.ForeColor = System.Drawing.Color.White;
          this.label11.Location = new System.Drawing.Point(204, 221);
          this.label11.Name = "label11";
          this.label11.Size = new System.Drawing.Size(88, 16);
          this.label11.TabIndex = 26;
          this.label11.Text = "Last Step:";
          // 
          // lblLastStep
          // 
          this.lblLastStep.AutoSize = true;
          this.lblLastStep.BackColor = System.Drawing.Color.Transparent;
          this.lblLastStep.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblLastStep.Location = new System.Drawing.Point(298, 221);
          this.lblLastStep.Name = "lblLastStep";
          this.lblLastStep.Size = new System.Drawing.Size(0, 16);
          this.lblLastStep.TabIndex = 27;
          // 
          // label12
          // 
          this.label12.AutoSize = true;
          this.label12.BackColor = System.Drawing.Color.Transparent;
          this.label12.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label12.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label12.ForeColor = System.Drawing.Color.White;
          this.label12.Location = new System.Drawing.Point(164, 237);
          this.label12.Name = "label12";
          this.label12.Size = new System.Drawing.Size(128, 16);
          this.label12.TabIndex = 28;
          this.label12.Text = "Last Equipment:";
          // 
          // lblLastEq
          // 
          this.lblLastEq.AutoSize = true;
          this.lblLastEq.BackColor = System.Drawing.Color.Transparent;
          this.lblLastEq.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblLastEq.Location = new System.Drawing.Point(298, 237);
          this.lblLastEq.Name = "lblLastEq";
          this.lblLastEq.Size = new System.Drawing.Size(0, 16);
          this.lblLastEq.TabIndex = 29;
          // 
          // label13
          // 
          this.label13.AutoSize = true;
          this.label13.BackColor = System.Drawing.Color.Transparent;
          this.label13.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label13.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label13.ForeColor = System.Drawing.Color.White;
          this.label13.Location = new System.Drawing.Point(148, 253);
          this.label13.Name = "label13";
          this.label13.Size = new System.Drawing.Size(144, 16);
          this.label13.TabIndex = 30;
          this.label13.Text = "Next Sub Process:";
          // 
          // lblNextSubProcess
          // 
          this.lblNextSubProcess.AutoSize = true;
          this.lblNextSubProcess.BackColor = System.Drawing.Color.Transparent;
          this.lblNextSubProcess.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextSubProcess.Location = new System.Drawing.Point(298, 253);
          this.lblNextSubProcess.Name = "lblNextSubProcess";
          this.lblNextSubProcess.Size = new System.Drawing.Size(0, 16);
          this.lblNextSubProcess.TabIndex = 31;
          // 
          // label14
          // 
          this.label14.AutoSize = true;
          this.label14.BackColor = System.Drawing.Color.Transparent;
          this.label14.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label14.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label14.ForeColor = System.Drawing.Color.White;
          this.label14.Location = new System.Drawing.Point(148, 269);
          this.label14.Name = "label14";
          this.label14.Size = new System.Drawing.Size(144, 16);
          this.label14.TabIndex = 32;
          this.label14.Text = "Next Position Id:";
          // 
          // label15
          // 
          this.label15.AutoSize = true;
          this.label15.BackColor = System.Drawing.Color.Transparent;
          this.label15.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label15.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label15.ForeColor = System.Drawing.Color.White;
          this.label15.Location = new System.Drawing.Point(116, 285);
          this.label15.Name = "label15";
          this.label15.Size = new System.Drawing.Size(176, 16);
          this.label15.TabIndex = 33;
          this.label15.Text = "Next Sub Position Id:";
          // 
          // lblNextPos
          // 
          this.lblNextPos.AutoSize = true;
          this.lblNextPos.BackColor = System.Drawing.Color.Transparent;
          this.lblNextPos.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextPos.Location = new System.Drawing.Point(298, 269);
          this.lblNextPos.Name = "lblNextPos";
          this.lblNextPos.Size = new System.Drawing.Size(0, 16);
          this.lblNextPos.TabIndex = 34;
          // 
          // lblNextSubPos
          // 
          this.lblNextSubPos.AutoSize = true;
          this.lblNextSubPos.BackColor = System.Drawing.Color.Transparent;
          this.lblNextSubPos.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextSubPos.Location = new System.Drawing.Point(298, 285);
          this.lblNextSubPos.Name = "lblNextSubPos";
          this.lblNextSubPos.Size = new System.Drawing.Size(0, 16);
          this.lblNextSubPos.TabIndex = 35;
          // 
          // label16
          // 
          this.label16.AutoSize = true;
          this.label16.BackColor = System.Drawing.Color.Transparent;
          this.label16.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label16.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label16.ForeColor = System.Drawing.Color.White;
          this.label16.Location = new System.Drawing.Point(204, 301);
          this.label16.Name = "label16";
          this.label16.Size = new System.Drawing.Size(88, 16);
          this.label16.TabIndex = 36;
          this.label16.Text = "Next Step:";
          // 
          // label17
          // 
          this.label17.AutoSize = true;
          this.label17.BackColor = System.Drawing.Color.Transparent;
          this.label17.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label17.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label17.ForeColor = System.Drawing.Color.White;
          this.label17.Location = new System.Drawing.Point(116, 317);
          this.label17.Name = "label17";
          this.label17.Size = new System.Drawing.Size(176, 16);
          this.label17.TabIndex = 37;
          this.label17.Text = "Next Equipment Usage:";
          // 
          // label18
          // 
          this.label18.AutoSize = true;
          this.label18.BackColor = System.Drawing.Color.Transparent;
          this.label18.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label18.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label18.ForeColor = System.Drawing.Color.White;
          this.label18.Location = new System.Drawing.Point(12, 335);
          this.label18.Name = "label18";
          this.label18.Size = new System.Drawing.Size(280, 16);
          this.label18.TabIndex = 38;
          this.label18.Text = "Next Equipment Group or Equipment:";
          // 
          // lblNextStep
          // 
          this.lblNextStep.AutoSize = true;
          this.lblNextStep.BackColor = System.Drawing.Color.Transparent;
          this.lblNextStep.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextStep.Location = new System.Drawing.Point(298, 301);
          this.lblNextStep.Name = "lblNextStep";
          this.lblNextStep.Size = new System.Drawing.Size(0, 16);
          this.lblNextStep.TabIndex = 39;
          // 
          // lblNextEqUsage
          // 
          this.lblNextEqUsage.AutoSize = true;
          this.lblNextEqUsage.BackColor = System.Drawing.Color.Transparent;
          this.lblNextEqUsage.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextEqUsage.Location = new System.Drawing.Point(298, 317);
          this.lblNextEqUsage.Name = "lblNextEqUsage";
          this.lblNextEqUsage.Size = new System.Drawing.Size(0, 16);
          this.lblNextEqUsage.TabIndex = 40;
          // 
          // lblNextEq
          // 
          this.lblNextEq.AutoSize = true;
          this.lblNextEq.BackColor = System.Drawing.Color.Transparent;
          this.lblNextEq.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblNextEq.Location = new System.Drawing.Point(298, 335);
          this.lblNextEq.Name = "lblNextEq";
          this.lblNextEq.Size = new System.Drawing.Size(0, 16);
          this.lblNextEq.TabIndex = 41;
          // 
          // label19
          // 
          this.label19.AutoSize = true;
          this.label19.BackColor = System.Drawing.Color.Transparent;
          this.label19.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
          this.label19.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.label19.ForeColor = System.Drawing.Color.White;
          this.label19.Location = new System.Drawing.Point(220, 351);
          this.label19.Name = "label19";
          this.label19.Size = new System.Drawing.Size(72, 16);
          this.label19.TabIndex = 42;
          this.label19.Text = "Comment:";
          // 
          // lblComment
          // 
          this.lblComment.AutoSize = true;
          this.lblComment.BackColor = System.Drawing.Color.Transparent;
          this.lblComment.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.lblComment.Location = new System.Drawing.Point(298, 351);
          this.lblComment.Name = "lblComment";
          this.lblComment.Size = new System.Drawing.Size(0, 16);
          this.lblComment.TabIndex = 43;
          // 
          // btnStart
          // 
          this.btnStart.BackColor = System.Drawing.Color.Gainsboro;
          this.btnStart.FlatAppearance.BorderColor = System.Drawing.Color.AliceBlue;
          this.btnStart.FlatAppearance.BorderSize = 0;
          this.btnStart.FlatAppearance.MouseDownBackColor = System.Drawing.Color.AliceBlue;
          this.btnStart.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
          this.btnStart.Font = new System.Drawing.Font("Courier New", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.btnStart.ForeColor = System.Drawing.Color.Black;
          this.btnStart.Location = new System.Drawing.Point(301, 401);
          this.btnStart.Name = "btnStart";
          this.btnStart.Size = new System.Drawing.Size(161, 28);
          this.btnStart.TabIndex = 44;
          this.btnStart.Text = "&Start Next Step";
          this.btnStart.UseVisualStyleBackColor = false;
          // 
          // frmStudentDetails
          // 
          this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
          this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
          this.BackColor = System.Drawing.Color.CadetBlue;
          this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
          this.ClientSize = new System.Drawing.Size(579, 456);
          this.Controls.Add(this.btnStart);
          this.Controls.Add(this.lblComment);
          this.Controls.Add(this.label19);
          this.Controls.Add(this.lblNextEq);
          this.Controls.Add(this.lblNextEqUsage);
          this.Controls.Add(this.lblNextStep);
          this.Controls.Add(this.label18);
          this.Controls.Add(this.label17);
          this.Controls.Add(this.label16);
          this.Controls.Add(this.lblNextSubPos);
          this.Controls.Add(this.lblNextPos);
          this.Controls.Add(this.label15);
          this.Controls.Add(this.label14);
          this.Controls.Add(this.lblNextSubProcess);
          this.Controls.Add(this.label13);
          this.Controls.Add(this.lblLastEq);
          this.Controls.Add(this.label12);
          this.Controls.Add(this.lblLastStep);
          this.Controls.Add(this.label11);
          this.Controls.Add(this.lblLastSubPos);
          this.Controls.Add(this.label10);
          this.Controls.Add(this.lblLastPos);
          this.Controls.Add(this.label9);
          this.Controls.Add(this.lblCurSubProcess);
          this.Controls.Add(this.label8);
          this.Controls.Add(this.lblProcess);
          this.Controls.Add(this.label7);
          this.Controls.Add(this.lblPriority);
          this.Controls.Add(this.label6);
          this.Controls.Add(this.lblContact);
          this.Controls.Add(this.label5);
          this.Controls.Add(this.lblCurQuantity);
          this.Controls.Add(this.label4);
          this.Controls.Add(this.lblStatus);
          this.Controls.Add(this.lblID);
          this.Controls.Add(this.label3);
          this.Controls.Add(this.label2);
          this.Controls.Add(this.label1);
          this.Controls.Add(this.btnStartStep);
          this.Controls.Add(this.txtLotId);
          this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
          this.Name = "frmStudentDetails";
          this.Text = "ezOMMClient -- Start Step";
          this.ResumeLayout(false);
          this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtLotId;
        private System.Windows.Forms.Button btnStartStep;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lblID;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lblCurQuantity;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label lblContact;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label lblPriority;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label lblProcess;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label lblCurSubProcess;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label lblLastPos;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label lblLastSubPos;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label lblLastStep;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label lblLastEq;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label lblNextSubProcess;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label lblNextPos;
        private System.Windows.Forms.Label lblNextSubPos;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label lblNextStep;
        private System.Windows.Forms.Label lblNextEqUsage;
        private System.Windows.Forms.Label lblNextEq;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label lblComment;
        private System.Windows.Forms.Button btnStart;
    }
}

