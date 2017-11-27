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
    public partial class FixedPointMotion03 : Form
    {
        public delegate void myDelegate();
        public myDelegate mydelegate = null;
        public Thread myThread;
        ModBusClient MClient = new ModBusClient();

        public FixedPointMotion03()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void FixedPointMotion03_Load(object sender, EventArgs e)
        {
            mydelegate = new myDelegate(GetIOState);
            myThread = new Thread(MyEvent);
            myThread.Start();
        }

        public void GetIOState()
        {
            //Get the button state
            if (MClient.GetUserCmd((int)UserCommand.Dbg_btn) == 1)//Run
            {
                btnSvOn.Enabled = true;
                btnSvOn.BackColor = Color.LightGreen;
                btnSvOff.Enabled = true;
                btnSvOff.BackColor = Color.Gold;
            }
            else
            {
                btnSvOn.Enabled = false;
                btnSvOn.BackColor = Color.LightGray;
                btnSvOff.Enabled = false;
                btnSvOff.BackColor = Color.LightGray;
            }
            //Get the signals of Servo IO
            switch (MClient.GetUserCmd((ushort)UserCommand.AX0_SVON))
            {
                case 0: picMIOAx1.BackColor = Color.Gray; break;
                case 1: picMIOAx1.BackColor = Color.Green; break;
            }
            switch (MClient.GetUserCmd((ushort)UserCommand.AX1_SVON))
            {
                case 0: picMIOAx2.BackColor = Color.Gray; break;
                case 1: picMIOAx2.BackColor = Color.Green; break;
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


        private void btnMainForm_Click(object sender, EventArgs e)
        {
            //Open main form
            this.myThread.Abort();
            this.Owner.Show();
            this.Dispose();    
  
        }

        private void FixedPointMotion03_FormClosed(object sender, FormClosedEventArgs e)
        {
            this.myThread.Abort();//Close thread
            ModBusClient.Wrapper.Dispose();           
            this.Owner.Dispose();
        }


        private void btnSvOn_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.SvOn);
        }

        private void btnSvOff_Click(object sender, EventArgs e)
        {
            MClient.SetSysCmd((int)SystemCommand.H_BtnType, (short)btnType.SvOff);
        }


    }
}
