using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using MSConnection;


namespace MSTest
{
    public partial class KeyBoardTest01 : Form
    {
        public static MSClient Wrapper = new MSClient("127.0.0.1");
        //定义所需存储VR值的数组
        double[] VRList = new double[151];
        double[] AxState = new double[4];
        double[] AxDPOS = new double[4];

        //a1表示VR(0)-VR(50) U16类型，a2表示VR(51)-VR(100) F32类型，a3表示VR(101)-VR(150) U16类型
        ushort[] a1 = new ushort[51];
        float[] a2 = new float[50];
        ushort[] a3 = new ushort[50];

        public KeyBoardTest01()
        {
            InitializeComponent();
            timer1.Enabled = true;
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            refresh();
        }

        private void refresh()
        {
            //如果函数返回false，说明读取失败
            if (!Wrapper.ReadList_U16(ref a1,51,40001))
            {
                return;
            }

            if (!Wrapper.ReadList_F32(ref a2, 50, 40052))
            {
                return;
            }

            if (!Wrapper.ReadList_U16(ref a3, 50, 40152))
            {
                return;
            }   

            Array.Copy(a1, 0, VRList, 0, 51);
            Array.Copy(a2, 0, VRList, 51, 50);
            Array.Copy(a3, 0, VRList, 101, 50);

            txt_next.Text = Convert.ToChar(Convert.ToInt16(VRList[123])).ToString();

            //通过程序的run_btn的状态判断Run按钮是否可用
            if (VRList[135] == 0)
            {
                btn_auto.Enabled = false;
                btn_auto.BackColor = Color.LightGray;
            }
            else
            {
                btn_auto.Enabled = true;
                btn_auto.BackColor = Color.SkyBlue;
            }

            //单步
            if (VRList[137] == 0)
            {
                btn_step.Enabled = false;
                btn_step.BackColor = Color.LightGray;
            }
            else
            {
                btn_step.Enabled = true;
                btn_step.BackColor = Color.SteelBlue;
            }

            //暂停
            if (VRList[136] == 0)
            {
                btn_pause.Enabled = false;
                btn_pause.BackColor = Color.LightGray;
            }
            else
            {
                btn_pause.Enabled = true;
                btn_pause.BackColor = Color.DarkOrange;
            }

            //恢复
            if (VRList[138] == 0)
            {
                btn_resume.Enabled = false;
                btn_resume.BackColor = Color.LightGray;
            }
            else
            {
                btn_resume.Enabled = true;
                btn_resume.BackColor = Color.Green;
            }

            //home
            if (VRList[139] == 0)
            {
                btn_home.Enabled = false;
                btn_home.BackColor = Color.LightGray;
            }
            else
            {
                btn_home.Enabled = true;
                btn_home.BackColor = Color.Gold;
            }

            //debug
            if (VRList[141] == 0)
            {
                btn_debug.Enabled = false;
            }
            else
            {
                btn_debug.Enabled = true;
            }

            //teach
            if (VRList[140] == 0)
            {
                btn_teach.Enabled = false;
            }
            else
            {
                btn_teach.Enabled = true;
            }

            //refresh()---读取三轴的dpos
            for (int i = 0; i < 3; i++)
            {
                AxDPOS[i] = Wrapper.GetAxDPOS(i);
            }

            txt_x_dpos.Text = AxDPOS[0].ToString();
            txt_y_dpos.Text = AxDPOS[1].ToString();
            txt_z_dpos.Text = AxDPOS[2].ToString();

            //refresh()---获取三轴的state
            for (int i = 0; i < 3; i++)
            {
                AxState[i] = Wrapper.GetAxState(i);
            }
            getaxstate(txt_x_state, 0);
            getaxstate(txt_y_state, 1);
            getaxstate(txt_z_state, 2);

            getErrAndWrong();
        }

        //获取警告和错误信息
        public void getErrAndWrong()
        {
            TextBox a = txt_warning;
            TextBox b = txt_wrong;
            //警告
            switch (Convert.ToInt32(VRList[8]))
            {
                case 0:
                    a.Text = "Success";
                    a.BackColor = Color.Lime;
                    break;
                case 1:
                    a.Text = "No Command";
                    a.BackColor = Color.Yellow;
                    break;
                case 2:
                    a.Text = "Invalid Operation";
                    a.BackColor = Color.Yellow;
                    break;
                case 3:
                    a.Text = "Home Not Finish";
                    a.BackColor = Color.Yellow;
                    break;
                case 4:
                    a.Text = "Not Finish";
                    a.BackColor = Color.Yellow;
                    break;
                case 5:
                    a.Text = "Unkonow Command";
                    a.BackColor = Color.Yellow;
                    break;               
            }

            //报警
            switch (Convert.ToInt32(VRList[9]))
            {
                case 0:
                    b.Text = "Success";
                    b.BackColor = Color.Lime;
                    break;
                case 1:
                    b.Text = "Axis Error";
                    b.BackColor = Color.Red;
                    break;
                case 2:
                    b.Text = "Axis AlmError";
                    b.BackColor = Color.Red;
                    break;
                case 3:
                    b.Text = "Axis PelError";
                    b.BackColor = Color.Red;
                    break;
                case 4:
                    b.Text = "Axis NelError";
                    b.BackColor = Color.Red;
                    break;
                case 5:
                    b.Text = "Axis EmgError";
                    b.BackColor = Color.Red;
                    break;
            }
        }
        //获取轴状态
        public void getaxstate(TextBox a, int index)
        {
            switch (Convert.ToInt32(AxState[index]))
            {
                case 0:
                    a.Text = "Disable";
                    a.BackColor = Color.Red;
                    break;
                case 1:
                    a.Text = "Ready";
                    a.BackColor = Color.Lime;
                    break;
                case 2:
                    a.Text = "Stopping";
                    a.BackColor = Color.Gray;
                    break;
                case 3:
                    a.Text = "Error";
                    a.BackColor = Color.Red;
                    break;
                case 4:
                    a.Text = "Homing";
                    a.BackColor = Color.Lime;
                    break;
                case 5:
                    a.Text = "PTP Driving";
                    a.BackColor = Color.Lime;
                    break;
                case 6:
                    a.Text = "Continus Driving";
                    a.BackColor = Color.Lime;
                    break;
                case 7:
                    a.Text = "Group interpolation motion";
                    a.BackColor = Color.Lime;
                    break;
                case 8:
                    a.Text = "JOG mode motion";
                    a.BackColor = Color.Gray;
                    break;
                case 9:
                    a.Text = "MPG mode motion";
                    a.BackColor = Color.Gray;
                    break;
            }
        }

        private void txt_into_TextChanged(object sender, EventArgs e)
        {
            
        }

        private void btn_auto_Click(object sender, EventArgs e)
        {
            VRList[7] = 1;
            //btn_auto.BackColor = Color.LightGreen;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
           
        }

        private void btn_home_Click(object sender, EventArgs e)
        {
            VRList[7] = 6;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void btn_stop_Click(object sender, EventArgs e)
        {
            VRList[7] = 5;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void btn_step_Click(object sender, EventArgs e)
        {
            VRList[7] = 4;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void btn_clear_Click(object sender, EventArgs e)
        {
            VRList[7] = 10;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            refresh();
        }

        private void btn_shijiao_Click(object sender, EventArgs e)
        {
            KeyBoardTest02 frm = new KeyBoardTest02();
            frm.StartPosition = FormStartPosition.CenterScreen;
            timer1.Enabled = false;
            this.Hide();
            frm.ShowDialog();
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Show();
            timer1.Enabled = true;
        }

        private void btn_DIDO_Click(object sender, EventArgs e)
        {
            KeyBoardTest03 frm = new KeyBoardTest03();
            frm.StartPosition = FormStartPosition.CenterScreen;
            timer1.Enabled = false;
            this.Hide();
            frm.ShowDialog();
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Show();
            timer1.Enabled = true;
        }

        private void KeyBoardTest01_FormClosing(object sender, FormClosingEventArgs e)
        {
            Wrapper.Dispose();
        }

        private void KeyBoardTest01_FormClosed(object sender, FormClosedEventArgs e)
        {

        }

        private void btn_pause_Click(object sender, EventArgs e)
        {
            VRList[7] = 2;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void btn_resume_Click(object sender, EventArgs e)
        {
            VRList[7] = 3;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];
            if (Wrapper.CheckStatus())
            {
                Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void txt_into_Validated(object sender, EventArgs e)
        {
            for (int i = 0; i < 20; i++)
            {
                VRList[102 + i] = 0;
            }
            VRList[124] = 0;
            if (txt_into.Text == "")
            {
                VRList[122] = 0;
            }

            string s = txt_into.Text.ToString();
            for (int i = 0; i < s.Length; i++)
            {
                VRList[102 + i] = s[i];
            }

            ushort[] b = new ushort[21];
            for (int i = 0; i < b.Length; i++)
            {
                b[i] = (ushort)VRList[102 + i];
            }

            Wrapper.WriteList_U16(b, 0, 40153, b.Length);
        }
    }
}
