using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using Microsoft.Win32;
using System.Threading;

namespace StudioUninst
{
    public partial class Form1 : Form
    {
        public static string StartMenu = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\";
        public static string BeginMenu = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\";
        public static string RuntimePath = @"C:\Advantech\";
        public static int processValue = 0;
        public static int flag_text = 0;


        public Form1()
        {
            InitializeComponent();
        }        

        /// <summary>
        /// 删除程序自身
        /// </summary>
        private static void DeleteItselfByCMD()
        {
            string vBatFile = @"C:\Advantech\Motion_Runtime\delete.bat";
            using (StreamWriter vStreamWriter = new StreamWriter(vBatFile, false, Encoding.Default))
            {
                vStreamWriter.Write(string.Format(
                   ":del\r\n" +
                    " del \"{0}\"\r\n" +
                    "if exist \"{0}\" goto del\r\n" + //如果存在uninstall.exe和uninstall.exe的上层目录

                     ":del2\r\n" +
                     "cd \"%~dp0\" & cd.. & rd /s /q \"{1}\" " +
                     "if exist \"{1}\" goto del2\r\n" +
                    //删除上面之后，删除bat文件自身              
                    "del %0\r\n", @"C:\Advantech\Motion_Runtime\Motion_Runtime\RuntimeUninst.exe", @"C:\Advantech\Motion_Runtime")
                );
            }

            WinExec(vBatFile, 0);

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Process[] proc = Process.GetProcessesByName("Motion_Runtime");
            if (proc.Length != 0)
            {
                JudgeForm jr = new JudgeForm();
                jr.ShowDialog();
                this.Close();
                return;
            }

            label1.Text = "确认卸载?";
            progressBar1.Visible = false;
            pictureBox3.Visible = false;
            timer1.Enabled = false;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
        }

        [DllImport("kernel32.dll")]
        public static extern uint WinExec(string lpCmdLine, uint uCmdShow);

        private void button1_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void button1_MouseEnter(object sender, EventArgs e)
        {
            button1.ForeColor = Color.LightGray;
        }

        private void button1_MouseLeave(object sender, EventArgs e)
        {
            button1.ForeColor = Color.White;
        }

        private void button2_MouseEnter(object sender, EventArgs e)
        {
            button2.ForeColor = Color.LightGray;
        }

        private void button2_MouseLeave(object sender, EventArgs e)
        {
            button2.ForeColor = Color.White;
        }

        //调用卸载虚拟轴卡的批处理
        public void UninstallDriver()
        {
            Process t = null;
            if (File.Exists(RuntimePath + @"Motion_Runtime\Motion_Runtime\uninstallall\uninstallall.bat"))
            {
                t = new Process();
                t.StartInfo.FileName = RuntimePath + @"Motion_Runtime\Motion_Runtime\uninstallall\uninstallall.bat";
                t.StartInfo.UseShellExecute = false;
                t.StartInfo.CreateNoWindow = true;

                t.Start();
                t.WaitForExit();
                t.Close();
                t.Dispose();
            }

        }

        public void sleepT()
        {
            //清除注册表
            RegistryKey hkml = Registry.LocalMachine;
            //清除注册表--advantech
            RegistryKey software = hkml.OpenSubKey(@"SOFTWARE\Advantech\", true);
            if (software.OpenSubKey("Public",true) != null)
            {
                software.DeleteSubKey("Public",false);
            }
            if (software.OpenSubKey("Motion_Runtime", true) != null)
            {
                software.DeleteSubKey("Motion_Runtime",false);
            }
            processValue += 5;

            //删除卸载面板的注册表信息
            software  = hkml.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", true);
            if (software.OpenSubKey("Motion Runtime", true) != null)
            {
                software.DeleteSubKey("Motion Runtime",false);
            }
            processValue += 5;

            //先删除开始菜单快捷键
            string path = StartMenu + @"Advantech Automation\Motion_Studio\Motion_Runtime.lnk";
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            path = StartMenu + @"Advantech Automation\Motion_Studio\RuntimeUninst.lnk";
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            processValue += 5;

            //删除开始菜单卸载快捷键
            path = StartMenu + @"Advantech Automation\Motion_Studio\RuntimeUninst.lnk";
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            processValue += 5;

            //删除启动菜单快捷键
            path = BeginMenu + @"Motion_Runtime.lnk";
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            processValue += 5;

            //删除虚拟轴卡
            UninstallDriver();
            processValue += 15;

            //删除system32\drivers文件夹下的sys文件
            string[] ss = {"PCI1245L.sys","PCI1265s.sys", "PCI1285s.sys", "MVP3245s.sys", "Bio1750s.sys", "Bio1756s.sys", "BioGPDCs.sys" };
            string driverFolder = @"C:\Windows\System32\drivers\";
            for (int i = 0; i < ss.Length; i++)
            {
                if (File.Exists(driverFolder + ss[i]))
                {
                    File.Delete(driverFolder + ss[i]);
                }
            }
            //删除system32文件夹下的文件
            string[] sa = {"PCI1265.dll","PCI1285.dll", "MVP3245.dll","PCI1245L.dll","Bio1750.dll","Bio1756.dll" ,"BioGPDC.dll", "AdvAMIBasic.dll", "ADVMOT.dll", "BDaqOcx.dll", "biodaq.dll", "biodaqutil.dll", "biosysteminfo.dll", "AdvVirtualMotionCardSvc.exe", "AdvVMCard.dll","simulatore.exe" };
            driverFolder = @"C:\Windows\System32\";
            for (int i = 0; i < sa.Length; i++)
            {
                if (File.Exists(driverFolder + sa[i]))
                {
                    File.Delete(driverFolder + sa[i]);
                }
            }
            //如果为64位系统，还需删除SySWOW文件夹下的文件
            if (Environment.Is64BitOperatingSystem)
            {
                driverFolder = @"C:\Windows\SysWOW64\";
                for (int i = 0; i < sa.Length; i++)
                {
                    if (File.Exists(driverFolder + sa[i]))
                    {
                        File.Delete(driverFolder + sa[i]);
                    }
                }
            }
            processValue += 15;

            /*
            //删除 除Motion_Runtime外的对应的文件夹
            if (Directory.Exists(RuntimePath + "DAQNavi"))
            {
                Directory.Delete(RuntimePath + "DAQNavi", true);
            }
            processValue += 15;
            */

            //删除Motion_Runtime文件夹下的除Motion_Runtime之外的所有文件夹和文件
            if (Directory.Exists(RuntimePath + "Motion_Runtime"))
            {
                //删除Motion_Runtime文件夹下的除Motion_Runtime之外的所有文件夹
                if (Directory.GetDirectories(RuntimePath + "Motion_Runtime") != null)
                {
                    string[] cc = Directory.GetDirectories(RuntimePath + "Motion_Runtime");
                    for (int i = 0; i < cc.Length; i++)
                    {
                        if (cc[i].Contains(@"Motion_Runtime\Motion_Runtime"))
                        {
                            continue;
                        }
                        Directory.Delete(cc[i], true);
                    }
                 }

                //删除Motion_Runtime文件夹下的所有文件
                if (Directory.GetFiles(RuntimePath + @"Motion_Runtime") != null)
                {
                    string[] cc = Directory.GetFiles(RuntimePath + @"Motion_Runtime");
                    for (int i = 0; i < cc.Length; i++)
                    {
                        File.Delete(cc[i]);
                    }
                }
            }
            processValue += 25;

            //删除Motion_Runtime\Motion_Runtime文件夹下的所有文件夹和文件
            if (Directory.Exists(RuntimePath + @"Motion_Runtime\Motion_Runtime"))
            {
                //删除Motion_Runtime\Motion_Runtime文件夹下的所有文件夹
                if (Directory.GetDirectories(RuntimePath + @"Motion_Runtime\Motion_Runtime") != null)
                {
                    string[] cc = Directory.GetDirectories(RuntimePath + @"Motion_Runtime\Motion_Runtime");
                    for (int i = 0; i < cc.Length; i++)
                    {
                        Directory.Delete(cc[i], true);
                    }
                }            

                //删除除Motion_Runtime\Motion_Runtime文件夹下的文件，如果为Uninstall程序本身，先跳过
                if (Directory.GetFiles(RuntimePath + @"Motion_Runtime\Motion_Runtime") != null)
                {
                    string[] cc = Directory.GetFiles(RuntimePath + @"Motion_Runtime\Motion_Runtime");
                    for (int i = 0; i < cc.Length; i++)
                    {
                        if (cc[i].Contains("RuntimeUninst.exe"))
                        {
                            continue;
                        }

                        File.Delete(cc[i]);
                    }
                    //删除程序本身
                    DeleteItselfByCMD();
                }
            }
            processValue += 20;
        }
        private void pictureBox1_Click(object sender, EventArgs e)
        {
            pictureBox1.Hide();
            pictureBox2.Hide();
            button1.Hide();
            button2.Hide();
            timer1.Enabled = true;
            //this.progressBar1.Visible = true;
            processValue = 0;
            Thread fThread = new Thread(new ThreadStart(sleepT));//开辟一个新的线程
            fThread.Start();

            label1.Visible = true;
            flag_text = 1;

            
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        //去边框后，让窗体能移动
        // 移动窗体
        const int WM_NCLBUTTONDOWN = 0xA1;
        const int HT_CAPTION = 0x2;
        [System.Runtime.InteropServices.DllImport("user32.dll")]
        static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        // 窗体上鼠标按下时
        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left & this.WindowState == FormWindowState.Normal)
            {
                // 移动窗体
                this.Capture = false;
                SendMessage(Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.progressBar1.Value = processValue;
            switch (flag_text)
            {
                case 0:
                    label1.Text = "确认卸载?";
                    break;
                case 1:
                    progressBar1.Visible = true;
                    label1.Text = "正在卸载.   ";
                    flag_text += 1;
                    break;
                case 2:
                    label1.Text = "正在卸载..  ";
                    flag_text += 1;
                    break;
                case 3:
                    label1.Text = "正在卸载... ";
                    flag_text = 1;
                    break;
                case 4:
                    label1.Visible = false;
                    break;
            }

            if (processValue == 100)
            {
                progressBar1.Visible = false;
                pictureBox1.Visible = false;
                pictureBox2.Visible = false;
                pictureBox3.Visible = true;
                button1.Visible = true;
                button2.Visible = true;
                this.BackgroundImage = Properties.Resources.finish_bg;

                processValue = 0;
                flag_text = 4;
            }
        }

        private void pictureBox1_MouseEnter(object sender, EventArgs e)
        {
            pictureBox1.Image = Properties.Resources.uninst_in;
        }

        private void pictureBox1_MouseLeave(object sender, EventArgs e)
        {
            pictureBox1.Image = Properties.Resources.uninst;
        }

        private void pictureBox2_MouseEnter(object sender, EventArgs e)
        {
            pictureBox2.Image = Properties.Resources.keep_in; 
        }

        private void pictureBox2_MouseLeave(object sender, EventArgs e)
        {
            pictureBox2.Image = Properties.Resources.keep;
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void pictureBox3_MouseEnter(object sender, EventArgs e)
        {
            pictureBox3.Image = Properties.Resources.end_in;
        }

        private void pictureBox3_MouseLeave(object sender, EventArgs e)
        {
            pictureBox3.Image = Properties.Resources.end;
        }
    }
}
