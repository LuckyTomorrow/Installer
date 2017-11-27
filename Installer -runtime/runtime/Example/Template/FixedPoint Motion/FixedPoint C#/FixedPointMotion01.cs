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
    public partial class FixedPointMotion01 : Form
    {
        //Using a thread
        public delegate void myDelegate();
        public myDelegate mydelegate = null;
        public Thread myThread;
   
        ModBusClient MClient = new ModBusClient();
        public FixedPointMotion01()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void FixedPointMotion01_Load(object sender, EventArgs e)
        {
            mydelegate = new myDelegate(GetState);
            myThread = new Thread(MyEvent);
            myThread.Start();//start thread
        }

        public void GetState()
        {
            //Get the button state
            if (MClient.GetUserCmd((int)UserCommand.Run_btn) == 1)//Run
            {
                btnAuto.Enabled = true;
                btnAuto.BackColor = Color.Green;
            }
            else
            {
                btnAuto.Enabled = false;
                btnAuto.BackColor = Color.LightGray;
            }
            if (MClient.GetUserCmd((int)UserCommand.Step_btn) == 1)//Step
            {
                btnStep.Enabled = true;
                btnStep.BackColor = Color.DarkTurquoise;
            }
            else
            {
                btnStep.Enabled = false;
                btnStep.BackColor = Color.LightGray;
            }
            if (MClient.GetUserCmd((int)UserCommand.Resume_btn) == 1)//Resume
            {
                btnResume.Enabled = true;
                btnResume.BackColor = Color.LightGreen;
            }
            else
            {
                btnResume.Enabled = false;
                btnResume.BackColor = Color.LightGray;
            }
            if (MClient.GetUserCmd((int)UserCommand.Pause_btn) == 1)//Pause
            {
                btnPause.Enabled = true;
                btnPause.BackColor = Color.DarkOrange;
            }
            else
            {
                btnPause.Enabled = false;
                btnPause.BackColor = Color.LightGray;
            }

            if (MClient.GetUserCmd((int)UserCommand.Home_btn) == 1)//Org
            {
                btnHome.Enabled = true;
                btnHome.BackColor = Color.Gold;
            }
            else
            {
                btnHome.Enabled = false;
                btnHome.BackColor = Color.LightGray;
            }
  
            //Get axis command position
            txtXDpos.Text = ModBusClient.Wrapper.GetAxDPOS(0).ToString();
            txtYDpos.Text = ModBusClient.Wrapper.GetAxDPOS(1).ToString();

            //Get  axis  current state
            MClient.GetAxState(txtXState, 0);
            MClient.GetAxState(txtYState, 1);
           
            //Get error infomation
           MClient.GetErrAndWrong(txtWarning,txtWrong);

            //Get current fixedpoint
            switch (MClient.GetUserCmd((int)UserCommand.Current_Point))
            {
                case 0:
                    txtCurrentPoint.Text = "?";
                    break;
                case 1:
                    txtCurrentPoint.Text = "P1";
                    break;
                case 2:
                    txtCurrentPoint.Text = "P2";
                    break;
                case 3:
                    txtCurrentPoint.Text = "P3";
                    break;
                case 4:
                    txtCurrentPoint.Text = "P4";
                    break;
            }
            
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

        private void btnAuto_Click(object sender, EventArgs e)
        {   
            MClient.SetSysCmd((int)SystemCommand.H_BtnType,(short)btnType.Run);
        }
        private void FixedPointMotion01_FormClosed(object sender, FormClosedEventArgs e)
        {
            myThread.Abort();//close thread
            ModBusClient.Wrapper.Dispose();
        }

        private void btnDebugForm_Click(object sender, EventArgs e)
        {
            //Open DebugFrom
            this.myThread.Abort();//close thread
           
            FixedPointMotion03 frm = new FixedPointMotion03();
            frm.Owner = this;
            this.Hide();
            frm.Show();
            
        }

        private void btnTeachForm_Click(object sender, EventArgs e)
        {
            //Open Teach Form
            this.myThread.Abort();
            
            FixedPointMotion02 frm = new FixedPointMotion02();
            frm.Owner = this;
            this.Hide();
            frm.Show();
             
        }
        private void btnStop_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Stop);
        }


        private void btnHome_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Home);
        }

        private void btnStep_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Step);
        }

        private void btnResume_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Resume);
        }

        private void btnPause_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.Pause);
        }

        private void btnResetErr_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.ResetErr);
        }

        private void FixedPointMotion01_Shown(object sender, EventArgs e)
        {
            mydelegate = new myDelegate(GetState);
            myThread = new Thread(MyEvent);
            myThread.Start();//start thread
        }
    }
}
