namespace MSTest
{
    partial class KeyBoardTest03
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(KeyBoardTest03));
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btn_svoff = new System.Windows.Forms.Button();
            this.btn_svon = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.mio_svon_2 = new System.Windows.Forms.Button();
            this.mio_svon_1 = new System.Windows.Forms.Button();
            this.mio_svon_0 = new System.Windows.Forms.Button();
            this.btn_return = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btn_svoff);
            this.groupBox1.Controls.Add(this.btn_svon);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.mio_svon_2);
            this.groupBox1.Controls.Add(this.mio_svon_1);
            this.groupBox1.Controls.Add(this.mio_svon_0);
            this.groupBox1.Font = new System.Drawing.Font("微软雅黑", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.groupBox1.ForeColor = System.Drawing.Color.Cyan;
            this.groupBox1.Location = new System.Drawing.Point(106, 103);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(436, 248);
            this.groupBox1.TabIndex = 24;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "SVON/SVFF";
            // 
            // btn_svoff
            // 
            this.btn_svoff.BackColor = System.Drawing.Color.Yellow;
            this.btn_svoff.ForeColor = System.Drawing.Color.Black;
            this.btn_svoff.Location = new System.Drawing.Point(94, 149);
            this.btn_svoff.Name = "btn_svoff";
            this.btn_svoff.Size = new System.Drawing.Size(84, 43);
            this.btn_svoff.TabIndex = 11;
            this.btn_svoff.Text = "SVOFF";
            this.btn_svoff.UseVisualStyleBackColor = false;
            this.btn_svoff.Click += new System.EventHandler(this.btn_svoff_Click);
            // 
            // btn_svon
            // 
            this.btn_svon.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.btn_svon.ForeColor = System.Drawing.Color.Black;
            this.btn_svon.Location = new System.Drawing.Point(94, 90);
            this.btn_svon.Name = "btn_svon";
            this.btn_svon.Size = new System.Drawing.Size(84, 43);
            this.btn_svon.TabIndex = 10;
            this.btn_svon.Text = "SVON";
            this.btn_svon.UseVisualStyleBackColor = false;
            this.btn_svon.Click += new System.EventHandler(this.btn_svon_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(258, 170);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(56, 19);
            this.label5.TabIndex = 9;
            this.label5.Text = "AXIS 2";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(258, 130);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(56, 19);
            this.label4.TabIndex = 8;
            this.label4.Text = "AXIS 1";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.Color.Lime;
            this.label3.Location = new System.Drawing.Point(306, 53);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(84, 19);
            this.label3.TabIndex = 7;
            this.label3.Text = "MIO.SVON";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(258, 90);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(56, 19);
            this.label2.TabIndex = 6;
            this.label2.Text = "AXIS 0";
            // 
            // mio_svon_2
            // 
            this.mio_svon_2.BackColor = System.Drawing.Color.Green;
            this.mio_svon_2.Font = new System.Drawing.Font("微软雅黑", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.mio_svon_2.ForeColor = System.Drawing.Color.Black;
            this.mio_svon_2.Location = new System.Drawing.Point(320, 167);
            this.mio_svon_2.Name = "mio_svon_2";
            this.mio_svon_2.Size = new System.Drawing.Size(51, 27);
            this.mio_svon_2.TabIndex = 5;
            this.mio_svon_2.UseVisualStyleBackColor = false;
            // 
            // mio_svon_1
            // 
            this.mio_svon_1.BackColor = System.Drawing.Color.Green;
            this.mio_svon_1.Font = new System.Drawing.Font("微软雅黑", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.mio_svon_1.ForeColor = System.Drawing.Color.Black;
            this.mio_svon_1.Location = new System.Drawing.Point(320, 127);
            this.mio_svon_1.Name = "mio_svon_1";
            this.mio_svon_1.Size = new System.Drawing.Size(51, 27);
            this.mio_svon_1.TabIndex = 5;
            this.mio_svon_1.UseVisualStyleBackColor = false;
            // 
            // mio_svon_0
            // 
            this.mio_svon_0.BackColor = System.Drawing.Color.Green;
            this.mio_svon_0.Font = new System.Drawing.Font("微软雅黑", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.mio_svon_0.ForeColor = System.Drawing.Color.Black;
            this.mio_svon_0.Location = new System.Drawing.Point(320, 87);
            this.mio_svon_0.Name = "mio_svon_0";
            this.mio_svon_0.Size = new System.Drawing.Size(51, 27);
            this.mio_svon_0.TabIndex = 5;
            this.mio_svon_0.UseVisualStyleBackColor = false;
            // 
            // btn_return
            // 
            this.btn_return.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.btn_return.Font = new System.Drawing.Font("微软雅黑", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btn_return.ForeColor = System.Drawing.Color.Black;
            this.btn_return.Location = new System.Drawing.Point(571, 375);
            this.btn_return.Name = "btn_return";
            this.btn_return.Size = new System.Drawing.Size(75, 38);
            this.btn_return.TabIndex = 25;
            this.btn_return.Text = "Main";
            this.btn_return.UseVisualStyleBackColor = false;
            this.btn_return.Click += new System.EventHandler(this.btn_return_Click);
            // 
            // timer1
            // 
            this.timer1.Interval = 200;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(12, 25);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(229, 52);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 22;
            this.pictureBox1.TabStop = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("微软雅黑", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(247, 37);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(442, 26);
            this.label1.TabIndex = 21;
            this.label1.Text = "Advantech MAS Controller-KeyBoard routine";
            // 
            // KeyBoardTest03
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Teal;
            this.ClientSize = new System.Drawing.Size(694, 439);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btn_return);
            this.MaximizeBox = false;
            this.Name = "KeyBoardTest03";
            this.Text = "DI/DO";
            this.Load += new System.EventHandler(this.KeyBoardTest03_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button mio_svon_2;
        private System.Windows.Forms.Button mio_svon_1;
        private System.Windows.Forms.Button mio_svon_0;
        private System.Windows.Forms.Button btn_return;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btn_svoff;
        private System.Windows.Forms.Button btn_svon;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
    }
}