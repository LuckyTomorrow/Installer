using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;
namespace MSTest
{
    public partial class FixedPointMotion02 : Form
    {
        //Using a thread
        public delegate void myDelegate();
        public myDelegate mydelegate = null;
        public Thread myThread;
        public bool Result;
        ModBusClient MClient = new ModBusClient();
        public float[] AxTeachPosList =new float[8];

        public FixedPointMotion02()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void FixedPointMotion02_Load(object sender, EventArgs e)
        {
            GetTeachPointPos();
            mydelegate = new myDelegate(GetState);
            myThread = new Thread(MyEvent);
            myThread.Start();
            
        }

        public void MyEvent()
        {
            try
            {
                while (true)
                {
                    Thread.Sleep(200);
                    this.BeginInvoke(mydelegate);
                }
            }
            catch (System.Exception ex)
            {

            }
        }

        public void GetTeachPointPos()
        {
            //Get teach point's position
             AxTeachPosList = MClient.GetAxTeachPos((int)AxPosition.PointX1);
            foreach (Control ctl in groupBox1.Controls)
            {
               
                if (ctl is TextBox)
                {
                    TextBox tb = new TextBox();
                    tb = ctl as TextBox;
                    for (int i = 1; i < 5; i++)
                    {
                        if (tb.Name == "txt_P" + i + "_x")
                        {
                            tb.Text = AxTeachPosList[2 * (i - 1)].ToString();
                        }
                        else if (tb.Name == "txt_P" + i + "_y")
                        {
                            tb.Text = AxTeachPosList[2 * (i - 1) + 1].ToString();
                        }
                    }
                }
            }
            
        }
        public void SetTeachPointPos()
        {
            //Get teach point's position
            
            foreach (Control ctl in groupBox1.Controls)
            {
                if (ctl is TextBox)
                {
                    TextBox tb = new TextBox();
                    tb = ctl as TextBox;
                    for (int i = 1; i < 5; i++)
                    {
                        if (tb.Name == "txt_P" + i + "_x")
                        {
                            AxTeachPosList[2 * (i - 1)] =float.Parse(tb.Text);
                        }
                        else if (tb.Name == "txt_P" + i + "_y")
                        {
                            AxTeachPosList[2 * (i - 1) + 1] = float.Parse(tb.Text);
                        }
                    }
                }
            }
            MClient.SetAxTeachPos((int)AxPosition.PointX1, AxTeachPosList);
        }
       
        public void GetState()
        {
            //Get the button state
            if (MClient.GetUserCmd((int)UserCommand.Teach_btn) == 1)//Teach
            {

                btnMoveP1.Enabled = true;
                btnMoveP1.BackColor = Color.DarkOrange;
                btnMoveP2.Enabled = true;
                btnMoveP2.BackColor = Color.DarkOrange;
                btnMoveP3.Enabled = true;
                btnMoveP3.BackColor = Color.DarkOrange;
                btnMoveP4.Enabled = true;
                btnMoveP4.BackColor = Color.DarkOrange;
            }
            else
            {
                btnMoveP1.Enabled = false;
                btnMoveP1.BackColor = Color.LightGray;
                btnMoveP2.Enabled = false;
                btnMoveP2.BackColor = Color.LightGray;
                btnMoveP3.Enabled = false;
                btnMoveP3.BackColor = Color.LightGray;
                btnMoveP4.Enabled = false;
                btnMoveP4.BackColor = Color.LightGray;
            }
            //Get the command position of axis
            this.txtXDpos.Text = ModBusClient.Wrapper.GetAxDPOS(0).ToString();
            this.txtYDpos.Text = ModBusClient.Wrapper.GetAxDPOS(1).ToString();

            //Get the current state of axis
            MClient.GetSysCmd((int)SystemCommand.CR_JogAxId);
            MClient.GetAxState(txtAxisState, MClient.GetSysCmd((int)SystemCommand.CR_JogAxId));


            //Get axis number for Jog motion
            switch (MClient.GetSysCmd((int)SystemCommand.CR_JogAxId))
            {
                case 0:
                    radioButton1.Checked = true;
                    break;
                case 1:
                    radioButton2.Checked = true;
                    break;
            }

            //SetTeachPointPos();
        }

        private void btnMainForm_Click(object sender, EventArgs e)
        {
            //Open main form
            this.myThread.Abort();
            this.Owner.Show();
            this.Dispose();               
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked)
            {
                MClient.SetSysCmd((int)SystemCommand.CR_JogAxId,0);
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked)
            {
                MClient.SetSysCmd((int)SystemCommand.CR_JogAxId,1);
            }
        }

        private void btnTeachP1_Click(object sender, EventArgs e)
        {
           Result = MClient.SetSysCmd((int)SystemCommand.H_BtnType,(short)btnType.Teach_P1);
           if (Result == true)
           {
               Thread.Sleep(200);
               GetTeachPointPos();
           }
        }

        private void btnTeachP2_Click(object sender, EventArgs e)
        {

            Result = MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Teach_P2);
            if (Result == true)
            {
                Thread.Sleep(200);
                GetTeachPointPos();
            }
        }

        private void btnTeachP3_Click(object sender, EventArgs e)
        {
            Result = MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Teach_P3);
            if (Result == true)
            {
                Thread.Sleep(200);
                GetTeachPointPos();
            }
        }

        private void btnTeachP4_Click(object sender, EventArgs e)
        {
            Result = MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Teach_P4);
            if (Result == true)
            {
                Thread.Sleep(200);
                GetTeachPointPos();
            }
        }

        private void btnMoveP1_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.PtP_P1);
        }

        private void btnMoveP2_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.PtP_P2);
        }

        private void btnMoveP3_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.PtP_P3);
        }

        private void btnMoveP4_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.PtP_P4);
        }

        private void btnJogNeg_MouseDown(object sender, MouseEventArgs e)
        {
            btnJogNeg.BackColor = Color.Lime;
            MClient.SetSysCmd((int)SystemCommand.H_BtnType,(short)btnType.JogAxNeg );
        }

        private void btnJogNeg_MouseUp(object sender, MouseEventArgs e)
        {

            btnJogNeg.BackColor = Color.DarkOrange;
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.JogAxStop);
        }

        private void btnJogPos_MouseDown(object sender, MouseEventArgs e)
        {

            btnJogPos.BackColor = Color.Lime;
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.JogAxPos);
        }

        private void btnJogPos_MouseUp(object sender, MouseEventArgs e)
        {
            btnJogPos.BackColor = Color.DarkOrange;
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.JogAxStop);
        }

        private void FixedPointMotion02_FormClosed(object sender, FormClosedEventArgs e)
        {
            this.myThread.Abort();   
            this.Owner.Dispose();
            ModBusClient.Wrapper.Dispose();
                 
        }

        private void txtPointPos_Leave(object sender, EventArgs e)
        {
            TextBox txtPos = (TextBox)sender;
            if (txtPos.Text.ToString() == "")
                return;
            SetTeachPointPos();
        }

        private void txtPointPos_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsNumber(e.KeyChar) && e.KeyChar != (char)8)//键盘只允许数字
            {
                e.Handled = true;
            }
        }
    }
}
