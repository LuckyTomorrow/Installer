using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace AdvanInstaller
{
    public partial class deviceSelect : Form
    {
        public deviceSelect()
        {
            InitializeComponent();
        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
           
        }

        const int WM_NCLBUTTONDOWN = 0xA1;
        const int HT_CAPTION = 0x2;
        [System.Runtime.InteropServices.DllImport("user32.dll")]
        static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        // 窗体上鼠标按下时
        private void deviceSelect_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left & this.WindowState == FormWindowState.Normal)
            {
                // 移动窗体
                this.Capture = false;
                SendMessage(Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            foreach (Control control in this.groupBox1.Controls)
            {
                if (control is CheckBox)
                {
                    CheckBox t = (CheckBox)control;
                    t.Checked = true;
                }
            }
            foreach (Control control in this.groupBox2.Controls)
            {
                if (control is CheckBox)
                {
                    CheckBox t = (CheckBox)control;
                    t.Checked = true;
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            foreach (Control control in this.groupBox1.Controls)
            {
                if (control is CheckBox)
                {
                    CheckBox t = (CheckBox)control;
                    t.Checked = false;
                }
            }
            foreach (Control control in this.groupBox2.Controls)
            {
                if (control is CheckBox)
                {
                    CheckBox t = (CheckBox)control;
                    t.Checked = false;
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            publicVar.flag_1245 = checkBox_1245.Checked;
            publicVar.flag_1245L = checkBox_1245L.Checked;
            publicVar.flag_1285 = checkBox_1285.Checked;
            publicVar.flag_3245 = checkBox_3245.Checked;

            publicVar.flag_1750 = checkBox_1750.Checked;
            publicVar.flag_1756 = checkBox_1756.Checked;
            publicVar.flag_1730 = checkBox_1730.Checked;

            publicVar.endflag = 0;
            this.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            publicVar.endflag = 1;
            this.Close();
        }
    }
}
