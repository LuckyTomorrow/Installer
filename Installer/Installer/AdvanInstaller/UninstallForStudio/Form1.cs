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

namespace UninstallForStudio
{
    public partial class Form1 : Form
    {
        public static string StartMenu = "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/";
        public static string StudioPath = "C:/Advantech/";
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_cancle_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_sure_Click(object sender, EventArgs e)
        {
            //清除注册表
             //  #code
            //

            //先删除开始菜单快捷键
            string path = StartMenu + "Advantech Automation/Motion_Studio";
            if (Directory.Exists(path))
            {
                Directory.Delete(path, true);
            }

            //删除Motion Studio.exe 桌面快捷键
            path = Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "//Motion Studio.lnk";
            if (File.Exists(path))
            {
                File.Delete(path);
            }

            //删除除Motion Studio外的对应的文件夹
            if (Directory.Exists(StudioPath))
            {
                string[] totalPath = {"Libraries", "Example", "Documents" };
                for (int i = 0; i < totalPath.Length; i++)
                {
                    string ss = StudioPath + totalPath[i];
                    if (Directory.Exists(ss))
                    {
                        Directory.Delete(ss, true);
                    }
                }
            }
            //删除除Motion Studio文件夹下的文件夹
            string[] cc = Directory.GetDirectories(StudioPath + "Motion Studio");
            for (int i = 0; i < cc.Length; i++)
            {
                Directory.Delete(cc[i], true);
            }
            //删除除Motion Studio文件夹下的文件，如果为程序本身，先跳过
            cc = Directory.GetFiles(StudioPath + "Motion Studio");
            for (int i = 0; i < cc.Length; i++)
            {
                if (cc[i].Contains("Uninstall.exe"))
                {
                    continue;
                }

                File.Delete(cc[i]);
            }

            //删除程序本身
            DeleteItselfByCMD();
        }

        /// <summary>
        /// 删除程序自身（本文地址：http://www.cnblogs.com/Interkey/p/DeleteItself.html）
        /// </summary>
        private static void DeleteItselfByCMD()
        {
            ProcessStartInfo psi = new ProcessStartInfo("cmd.exe", "/C ping 1.1.1.1 -n 1 -w 1000 > Nul & Del " + Application.ExecutablePath);
            psi.WindowStyle = ProcessWindowStyle.Hidden;
            psi.CreateNoWindow = true;
            Process.Start(psi);
            Application.Exit();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
           
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
        }
    }
}
