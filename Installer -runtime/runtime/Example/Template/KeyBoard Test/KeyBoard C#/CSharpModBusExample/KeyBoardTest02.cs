using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using MSConnection;

namespace MSTest
{
    public partial class KeyBoardTest02 : Form
    {
        double[] VRList = new double[151];
        double[] AxState = new double[32];
        double[] AxDPOS = new double[32];

        //a1表示VR(0)-VR(50) U16类型，a2表示VR(51)-VR(100) F32类型，a3表示VR(101)-VR(150) U16类型
        ushort[] a1 = new ushort[51];
        float[] a2 = new float[50];
        ushort[] a3 = new ushort[50];

        bool JogFlag = false;
        bool ReadDPOS = false;

        //MSClient W =new MSClient("127.0.0.1");

        public KeyBoardTest02()
        {
            InitializeComponent();
        }

        private void init_ReadDPOS()
        {
            //读取示教点位读数
            foreach (Control ctl in groupBox1.Controls)
            {
                if (ctl is TextBox)
                {
                    TextBox tb = new TextBox();
                    tb = ctl as TextBox;
                    for (int i = 0; i < 10; i++)
                    {
                        if (tb.Name == "txt_" + i + "_x")
                        {
                            tb.Text = VRList[51 + 3 * i].ToString();                            
                        }
                        else if (tb.Name == "txt_" + i + "_y")
                        {
                            tb.Text = VRList[52 + 3 * i].ToString();                           
                        }
                        else if (tb.Name == "txt_" + i + "_z")
                        {
                            tb.Text = VRList[53 + 3 * i].ToString();                            
                        }
                    }
                }
            }
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            timer1.Enabled = true;
            refresh02();
            init_ReadDPOS();

            switch ((int)VRList[64])
            {
                case 0:
                    radioButton1.Checked = true;
                    break;
                case 1:
                    radioButton2.Checked = true;
                    break;
                case 2:
                    radioButton3.Checked = true;
                    break;
            }
        }

        private void refresh02()
        {
            //如果函数返回false，说明读取失败
            if (!KeyBoardTest01.Wrapper.ReadList_U16(ref a1,51, 40001))
            {
                return;
            }

            if (!KeyBoardTest01.Wrapper.ReadList_F32(ref a2, 50, 40052))
            {
                return;
            }

            if (!KeyBoardTest01.Wrapper.ReadList_U16(ref a3, 50, 40152))
            {
                return;
            }            

            Array.Copy(a1, 0, VRList, 0, 51);
            Array.Copy(a2, 0, VRList, 51, 50);
            Array.Copy(a3, 0, VRList, 101, 50);

            if (ReadDPOS)
            {
                ReadTeachDpos();
                ReadDPOS = false;
            }
            

            //refresh()---读取三轴的dpos
            for (int i = 0; i < 3; i++)
            {
                AxDPOS[i] = KeyBoardTest01.Wrapper.GetAxDPOS(i);
            }

            txt_x_dpos.Text = AxDPOS[0].ToString();
            txt_y_dpos.Text = AxDPOS[1].ToString();
            txt_z_dpos.Text = AxDPOS[2].ToString();

            //refresh()---获取三轴的state
            for (int i = 0; i < 3; i++)
            {
                AxState[i] = KeyBoardTest01.Wrapper.GetAxState(i);
            }
            
            getaxstate(txt_state, (int)VRList[33]);

            switch (Convert.ToInt32(VRList[33]))
            {
                case 0:
                    radioButton1.Checked = true;
                    break;
                case 1:
                    radioButton2.Checked = true;
                    break;
                case 2:
                    radioButton3.Checked = true;
                    break;                
            }

        }

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

        private void ReadTeachDpos()
        {
            //读取示教点位读数
            foreach (Control ctl in groupBox1.Controls)
            {
                if (ctl is TextBox)
                {
                    TextBox tb = new TextBox();
                    tb = ctl as TextBox;
                    for (int i = 0; i < 10; i++)
                    {
                        if (tb.Name == "txt_" + i + "_x")
                        {
                            tb.Text = VRList[51 + 3 * i].ToString();
                        }
                        else if (tb.Name == "txt_" + i + "_y")
                        {
                            tb.Text = VRList[52 + 3 * i].ToString();
                        }
                        else if (tb.Name == "txt_" + i + "_z")
                        {
                            tb.Text = VRList[53 + 3 * i].ToString();
                        }
                    }
                }
            }
        }
        //示教按钮通用方法
        public void shijiao(Button bt, int value)
        {
            VRList[7] = value;
            ushort[] a = new ushort[1];
            a[0] = (ushort)VRList[7];            
            if (KeyBoardTest01.Wrapper.CheckStatus())
            {
                KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
            }

            ReadDPOS = true;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            refresh02();
        }

        private void btn_0_Click(object sender, EventArgs e)
        {
            shijiao(btn_0, 20);
        }

        private void btn_1_Click(object sender, EventArgs e)
        {
            shijiao(btn_1, 21);
        }

        private void btn_2_Click(object sender, EventArgs e)
        {
            shijiao(btn_2, 22);
        }

        private void btn_3_Click(object sender, EventArgs e)
        {
            shijiao(btn_3, 23);
        }

        private void btn_4_Click(object sender, EventArgs e)
        {
            shijiao(btn_4, 24);
        }

        private void btn_5_Click(object sender, EventArgs e)
        {
            shijiao(btn_5, 25);
        }

        private void btn_6_Click(object sender, EventArgs e)
        {
            shijiao(btn_6, 26);
        }

        private void btn_7_Click(object sender, EventArgs e)
        {
            shijiao(btn_7, 27);
        }

        private void btn_8_Click(object sender, EventArgs e)
        {
            shijiao(btn_8, 28);
        }

        private void btn_9_Click(object sender, EventArgs e)
        {
            shijiao(btn_9, 29);
        }

        private void trackBar1_Scroll(object sender, EventArgs e)
        {
        }        

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked)
            {
                VRList[33] = 0;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[33];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40034, 1);
                }                
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked)
            {
                VRList[33] = 1;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[33];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40034, 1);
                }
            }
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton3.Checked)
            {
                VRList[33] = 2;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[33];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40034, 1);
                }
            }
        }

        private void btn_jog_neg_MouseDown(object sender, MouseEventArgs e)
        {
            if (JogFlag==false)
            {
                JogFlag = true;
                btn_jog_neg.BackColor = Color.Lime;
                VRList[7] = 8;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[7];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
                }                
            }
            
        }

        private void btn_jog_neg_MouseUp(object sender, MouseEventArgs e)
        {
            if (JogFlag==true)
            {
                JogFlag = false;
                btn_jog_neg.BackColor = Color.DarkOrange;
                VRList[7] = 9;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[7];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
                }
            }
            
        }

        private void btn_jog_pos_MouseDown(object sender, MouseEventArgs e)
        {
            if (JogFlag == false)
            {
                JogFlag = true;
                btn_jog_pos.BackColor = Color.Lime;
                VRList[7] = 7;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[7];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
                }
            }
            
        }

        private void btn_jog_pos_MouseUp(object sender, MouseEventArgs e)
        {
            if (JogFlag == true)
            {
                JogFlag = false;
                btn_jog_pos.BackColor = Color.DarkOrange;
                VRList[7] = 9;
                ushort[] a = new ushort[1];
                a[0] = (ushort)VRList[7];
                if (KeyBoardTest01.Wrapper.CheckStatus())
                {
                    KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
                }
            }
            
        }

        private void btn_return_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
            this.Close();
        }

        private void btn_jog_pos_Click(object sender, EventArgs e)
        {

        }

        private void KeyBoardTest02_FormClosing(object sender, FormClosingEventArgs e)
        {
            
        }

        private void btn_ptp0_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp0, 30);
        }

        private void btn_ptp1_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp1, 31);
        }

        private void btn_ptp2_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp2, 32);
        }

        private void btn_ptp3_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp3, 33);
        }

        private void btn_ptp4_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp4, 34);
        }

        private void btn_ptp5_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp5, 35);
        }

        private void btn_ptp6_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp6, 36);
        }

        private void btn_ptp7_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp7, 37);
        }

        private void btn_ptp8_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp8, 38);
        }

        private void btn_ptp9_Click(object sender, EventArgs e)
        {
            shijiao(btn_ptp9, 39);
        }

        private void setDPOSVR(TextBox tb)
        {
            for (int i = 0; i < 10; i++)
            {
                if (tb.Name == "txt_" + i + "_x")
                {
                    //VRList[51 + 3 * i] = Convert.ToSingle(tb.Text);
                    float[] a = { Convert.ToSingle(tb.Text) };
                    KeyBoardTest01.Wrapper.WriteList_F32(a, 0, 40001 + 51 + 3 * i * 2, 1);
                    break;
                }
                else if (tb.Name == "txt_" + i + "_y")
                {
                    //VRList[52 + 3 * i] = Convert.ToDouble(tb.Text);
                    float[] a = { Convert.ToSingle(tb.Text) };
                    KeyBoardTest01.Wrapper.WriteList_F32(a, 0, 40001 + 53 + 3 * i * 2, 1);
                    break;
                }
                else if (tb.Name == "txt_" + i + "_z")
                {
                    //VRList[53 + 3 * i] = Convert.ToDouble(tb.Text);
                    float[] a = { Convert.ToSingle(tb.Text) };
                    KeyBoardTest01.Wrapper.WriteList_F32(a, 0, 40001 + 55 + 3 * i * 2, 1);
                    break;
                }
            }            
            

        }
        
        private void txt_0_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_0_x);
        }

        private void txt_0_y_TextChanged(object sender, EventArgs e)
        {

        }

        private void txt_0_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_0_y);
        }

        private void txt_0_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_0_z);
        }

        private void txt_1_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_1_x);
        }

        private void txt_1_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_1_y);
        }

        private void txt_1_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_1_z);
        }

        private void txt_2_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_2_x);
        }

        private void txt_2_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_2_y);
        }

        private void txt_2_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_2_z);
        }

        private void txt_3_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_3_x);
        }

        private void txt_3_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_3_y);
        }

        private void txt_3_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_3_z);
        }

        private void txt_4_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_4_x);
        }

        private void txt_4_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_4_y);
        }

        private void txt_4_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_4_z);
        }

        private void txt_5_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_5_x);
        }

        private void txt_5_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_5_y);
        }

        private void txt_5_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_5_z);
        }

        private void txt_6_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_6_x);
        }

        private void txt_6_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_6_y);
        }

        private void txt_6_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_6_z);
        }

        private void txt_7_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_7_x);
        }

        private void txt_7_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_7_y);
        }

        private void txt_7_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_7_z);
        }

        private void txt_8_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_8_x);
        }

        private void txt_8_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_8_y);
        }

        private void txt_8_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_8_z);
        }

        private void txt_9_x_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_9_x);
        }

        private void txt_9_y_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_9_y);
        }

        private void txt_9_z_Validated(object sender, EventArgs e)
        {
            setDPOSVR(txt_9_z);
        }
    }
}
