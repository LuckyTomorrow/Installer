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
    public partial class KeyBoardTest03 : Form
    {
        //MSClient Wrapper = new MSClient("127.0.0.1");
        static int max_Axis_Cnt = 3;
        int[] state = new int[max_Axis_Cnt];
       
        public KeyBoardTest03()
        {
            InitializeComponent();
        }

        private void btn_return_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
            this.Close();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            
            refresh02();
        }

        /// <summary>
        /// 
        /// </summary>
        private void refresh02()
        {
            //依次读取各轴的MIO.SVON           
            for (int i = 0; i < max_Axis_Cnt; i++)
            {
                state[i] = KeyBoardTest01.Wrapper.GetMIOState(i, 14);
            }

            //根据state[i]对MIO显示按钮赋颜色
            foreach (Control ctl in groupBox1.Controls)
            {
                if (ctl is Button)
                {
                    Button tb = new Button();
                    tb = ctl as Button;
                    for (int i = 0; i < max_Axis_Cnt; i++)
                    {
                        if (tb.Name == "mio_svon_" + i)
                        {
                            if (state[i] == 1)
                            {
                                tb.BackColor = Color.Lime;
                            }
                            else if (state[i] == 0)
                            {
                                tb.BackColor = Color.Green;
                            }
                        }                        
                        
                    }
                }
            }
        }

        private void KeyBoardTest03_Load(object sender, EventArgs e)
        {
            timer1.Enabled = true;
        }
        

        private void KeyBoardTest03_FormClosing(object sender, FormClosingEventArgs e)
        {
            //KeyBoardTest01.Wrapper.Dispose();
        }

        private void btn_svon_Click(object sender, EventArgs e)
        {
            ushort[] a = new ushort[1];
            a[0] = 12;
            if (KeyBoardTest01.Wrapper.CheckStatus())
            {
                KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }

        private void btn_svoff_Click(object sender, EventArgs e)
        {
            ushort[] a = new ushort[1];
            a[0] = 13;
            if (KeyBoardTest01.Wrapper.CheckStatus())
            {
                KeyBoardTest01.Wrapper.WriteList_U16(a, 0, 40008, 1);
            }
        }
    }
    
}
