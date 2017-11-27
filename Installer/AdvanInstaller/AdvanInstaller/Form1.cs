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
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Checksums;
using System.Diagnostics;
using Microsoft.Win32;
using System.Runtime.InteropServices;//互动服务 
using IWshRuntimeLibrary;
using System.Threading;
using System.Runtime.InteropServices;
using System.Security.AccessControl;

namespace AdvanInstaller
{
    public partial class Form1 : Form
    {
        public string StudioPath = @"C:\Advantech\";
        public string StartMenu = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\";
        public string test = "";
        public int processValue = 0;
        public int flag_png = 0;
        public int flag_png_times = 0;
        //用于窗体右上角X的功能分情况
        public int processFlag = 0;

        public Form1()
        {
            InitializeComponent();           

        }

        //用于判断电脑是否安装了Framework4
        public bool HasFramework4()
        {
            string key = "SOFTWARE\\Microsoft\\.NETFramework";
            using (RegistryKey reg = Registry.LocalMachine.OpenSubKey(key, false))
            {
                if (reg == null)
                    return false;
                bool result = reg.GetSubKeyNames().Any(s => s.StartsWith("v4.0"));
                return result;
            }
        }


        //初始化的操作
        //包括对目标路径的检测，如果不存在则创建，如果存在，则先删除不应该存在的文件夹
        public void InitAction(string[] rootDir)
        {
            if (Directory.Exists(StudioPath))
            {                
                for (int i = 0; i < rootDir.Length; i++)
                {
                    string ss = StudioPath + rootDir[i];
                    if (Directory.Exists(ss))
                    {
                        Directory.Delete(ss, true);
                    }
                }
            }
            else
            {
                Directory.CreateDirectory(StudioPath);
            }
        }

        //判断是32位还是64位系统
        public void checkWin32Or64()
        {
            string fromPath = StudioPath + @"Motion Studio\Client.zip";
            string targetPaht = StudioPath + @"Motion Studio\";

            //复制64位文件压缩包至指定目录，并解压 
            FileStream writer = new FileStream(fromPath, FileMode.OpenOrCreate);
            if (Environment.Is64BitOperatingSystem)
            {
                //Client_x64压缩包复制到本地                
                writer.Write(Properties.Resources.Client_x64, 0, Properties.Resources.Client_x64.Length);               
            }
            else
            {
                //Client_x86压缩包复制到本地              
                writer.Write(Properties.Resources.Client_x86, 0, Properties.Resources.Client_x86.Length);
            }
            writer.Dispose();
            //解压studio
            UnpackFileRarOrZip(fromPath, targetPaht);
            System.IO.File.Delete(fromPath);
        }

        //根据系统语言是简中还是繁中，对相应文件进行复制操作
        public void checkSampleOrTradition()
        {
            try
            {
                string[] manual = { "CodingHelp.xlsx", "Motion BASIC.pdf", "Motion Studio.pdf", "MSConnection.pdf", "Release Notes.HTM", "Template Framework.pdf" };
                string formpath = "";
                string topath = "";
                string formwhere = "";
                if (System.Globalization.CultureInfo.InstalledUICulture.Name == "zh-CN")
                {
                    formwhere = StudioPath + @"Motion Studio\zh-Hans\";
                    
                }
                else if (System.Globalization.CultureInfo.InstalledUICulture.Name == "zh-TW")
                {
                    formwhere = StudioPath + @"Motion Studio\zh-TW\";
                }

                formpath = formwhere + manual[3];
                topath = StudioPath + @"Documents\Application Manual\" + manual[3];
                System.IO.File.Copy(formpath, topath, true);

                formpath = formwhere + manual[5];
                topath = StudioPath + @"Documents\Application Manual\" + manual[5];
                System.IO.File.Copy(formpath, topath, true);

                formpath = formwhere + manual[4];
                topath = StudioPath + @"Documents\Release Note\" + manual[4];
                System.IO.File.Copy(formpath, topath, true);

                for (int i = 0; i < 3; i++)
                {
                    formpath = formwhere + manual[i];
                    topath = StudioPath + @"Documents\Software Manual\" + manual[i];
                    System.IO.File.Copy(formpath, topath, true);
                }
            }
            catch(Exception e)
            {
                MessageBox.Show(e.ToString());
            }
            
        }
        
        #region  解压文件 包括.rar 和zip
        /// <summary>
        ///解压文件
        /// </summary>
        /// <param name="fileFromUnZip">解压前的文件路径（绝对路径）</param>
        /// <param name="fileToUnZip">解压后的文件目录（绝对路径）</param>
        public static void UnpackFileRarOrZip(string fileFromUnZip, string fileToUnZip)
        {
            //获取压缩类型
            string unType = fileFromUnZip.Substring(fileFromUnZip.LastIndexOf(".") + 1, 3).ToLower();

            switch (unType)
            {
                case "rar":
                    UnRar(fileFromUnZip, fileToUnZip);
                    break;
                default:
                    UnZip(fileFromUnZip, fileToUnZip);
                    break;
            }
        }


        #endregion



        #region  解压文件 .rar文件

        /// <summary>
        /// 解压
        /// </summary>
        /// <param name="unRarPatch"></param>
        /// <param name="rarPatch"></param>
        /// <param name="rarName"></param>
        /// <returns></returns>
        public static void UnRar(string fileFromUnZip, string fileToUnZip)
        {

            string the_rar;
            RegistryKey the_Reg;
            object the_Obj;
            string the_Info;

            try
            {
                the_Reg = Registry.LocalMachine.OpenSubKey(
                         @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe");
                the_Obj = the_Reg.GetValue("");
                the_rar = the_Obj.ToString();
                the_Reg.Close();
                //the_rar = the_rar.Substring(1, the_rar.Length - 7);

                if (Directory.Exists(fileToUnZip) == false)
                {
                    Directory.CreateDirectory(fileToUnZip);
                }
                the_Info = "x -ibck " + Path.GetFileName(fileFromUnZip) + " " + fileToUnZip + " -y";

                ProcessStartInfo the_StartInfo = new ProcessStartInfo();
                the_StartInfo.FileName = the_rar;
                the_StartInfo.Arguments = the_Info;
                the_StartInfo.WindowStyle = ProcessWindowStyle.Minimized;
                the_StartInfo.WorkingDirectory = Path.GetDirectoryName(fileFromUnZip);//获取压缩包路径

                Process the_Process = new Process();
                the_Process.StartInfo = the_StartInfo;
                the_Process.Start();
                the_Process.WaitForExit();
                the_Process.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            //return unRarPatch;
        }

        #endregion



        #region  解压文件 .zip文件

        /// <summary>
        /// 解压功能(解压压缩文件到指定目录)
        /// </summary>
        /// <param name="FileToUpZip">待解压的文件</param>
        /// <param name="ZipedFolder">指定解压目标目录</param>
        public static void UnZip(string FileToUpZip, string ZipedFolder)
        {
            if (!System.IO.File.Exists(FileToUpZip))
            {
                return;
            }

            if (!Directory.Exists(ZipedFolder))
            {
                Directory.CreateDirectory(ZipedFolder);
            }

            ICSharpCode.SharpZipLib.Zip.ZipInputStream s = null;
            ICSharpCode.SharpZipLib.Zip.ZipEntry theEntry = null;

            string fileName;
            FileStream streamWriter = null;
            try
            {
                s = new ICSharpCode.SharpZipLib.Zip.ZipInputStream(System.IO.File.OpenRead(FileToUpZip));
                while ((theEntry = s.GetNextEntry()) != null)
                {

                    if (theEntry.Name != String.Empty)
                    {
                        fileName = Path.Combine(ZipedFolder, theEntry.Name);
                        ///判断文件路径是否是文件夹

                        if (fileName.EndsWith("/") || fileName.EndsWith("\\"))
                        {
                            Directory.CreateDirectory(fileName);
                            continue;
                        }

                        using (streamWriter = System.IO.File.Create(fileName))
                        {
                            int size = 2048;
                            byte[] data = new byte[2048];
                            while (true)
                            {
                                size = s.Read(data, 0, data.Length);
                                if (size > 0)
                                {
                                    streamWriter.Write(data, 0, size);
                                }
                                else
                                {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            finally
            {
                if (streamWriter != null)
                {
                    streamWriter.Close();
                    streamWriter.Dispose();
                    streamWriter = null;
                }
                if (theEntry != null)
                {
                    streamWriter.Close();
                    streamWriter.Dispose();
                    theEntry = null;
                }
                if (s != null)
                {
                    s.Close();
                    s = null;
                }
                GC.Collect();
                GC.Collect(1);
            }
        }

        #endregion


        /// <summary> 
        /// 生成桌面快捷方式 
        /// </summary>   
        /// <param name="targetPath">原目标位置</param> 
        /// /// <param name="savePath">保存快捷方式的位置</param> 
        protected void CreateDesktopShortcuts(string targetPath,string name,string description)
        {
            string iconpath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "//" + name+".lnk";
            if (System.IO.File.Exists(iconpath))
            {
                System.IO.File.Delete(iconpath);
            }

            //实例化WshShell对象 
            WshShell shell = new WshShell();

            //通过该对象的 CreateShortcut 方法来创建 IWshShortcut 接口的实例对象 
            IWshShortcut shortcut = (IWshShortcut)shell.CreateShortcut(iconpath);

            //设置快捷方式的目标所在的位置(源程序完整路径) 
            shortcut.TargetPath = targetPath;

            //设置应用程序起始位置         
            shortcut.WorkingDirectory = Path.GetDirectoryName(targetPath);

            //目标应用程序窗口类型(1.Normal window普通窗口,3.Maximized最大化窗口,7.Minimized最小化) 
            shortcut.WindowStyle = 1;

            //快捷方式的描述 
            shortcut.Description = description;

            //可以自定义快捷方式图标.(如果不设置,则将默认源文件图标.) 
            shortcut.IconLocation = targetPath;
            //shortcut.Arguments = "/myword /d4s"; 

            //设置快捷键(如果有必要的话.) 
            //shortcut.Hotkey = "CTRL+ALT+D"; 

            //保存快捷方式 
            shortcut.Save();

        }
                

        /// <summary> 
        /// 生成开始菜单快捷方式 
        /// </summary>   
        /// <param name="iconpath">快捷键放置位置</param> 
        /// <param name="targetPath">目标文件/文件夹位置</param> 
        /// <param name="startmenupath">快捷键所处目录位置</param> 
        /// <param name="Description">快捷键描述</param> 
        protected void CreateStartmenuShortcuts(string iconpath, string targetPath,  string startmenupath, string Description)
        {
            //创建快捷键时，如果快捷键所在的上层目录已经存在，判断快捷键是否存在，存在就先删除
            //如果快捷键所在的文件夹不存在，则先创建文件夹
            if (Directory.Exists(startmenupath))
            {
                if (System.IO.File.Exists(iconpath))
                {
                    System.IO.File.Delete(iconpath);
                }
            }
            else
            {
                Directory.CreateDirectory(startmenupath);
            }

            //实例化WshShell对象 
            WshShell shell = new WshShell();

            //通过该对象的 CreateShortcut 方法来创建 IWshShortcut 接口的实例对象             
            IWshShortcut shortcut = (IWshShortcut)shell.CreateShortcut(iconpath);

            //设置快捷方式的目标所在的位置(源程序完整路径)
            //划重点。。。关键点：目标路径如果有空格，在调用IWshRuntimeLibrary创建快捷方式时，
            //目标路径会自动前后加上双引号，导致系统不认识此文件类型
            shortcut.TargetPath = @Path.GetFullPath(targetPath);
            
            //设置快捷键的起始位置
            shortcut.WorkingDirectory = @Path.GetDirectoryName(targetPath);

            //目标应用程序窗口类型(1.Normal window普通窗口,3.Maximized最大化窗口,7.Minimized最小化) 
            shortcut.WindowStyle = 1;

            //快捷方式的描述 
            shortcut.Description = Description;

            //快捷方式图标
            if (System.IO.File.Exists(@Path.GetFullPath(targetPath)))
            {
                //如果目标路径为文件,则为默认设置(源文件图标)
            }
            else
            {
                //如果为目录，则设置为系统默认的文件夹图标
                shortcut.IconLocation = System.Environment.SystemDirectory + "\\" + "shell32.dll, 3"; 
            }
            
            //shortcut.Arguments = "/myword /d4s"; 

            //设置快捷键(如果有必要的话.) 
            //shortcut.Hotkey = "CTRL+ALT+D"; 

            //保存快捷方式 
            shortcut.Save();
        }

        public static long GetDirectoryLength(string dirPath)
        {
            //判断给定的路径是否存在,如果不存在则退出
            if (!Directory.Exists(dirPath))
                return 0;
            long len = 0;
            //定义一个DirectoryInfo对象
            DirectoryInfo di = new DirectoryInfo(dirPath);
            //通过GetFiles方法,获取di目录中的所有文件的大小
            foreach (FileInfo fi in di.GetFiles())
            {
                len += fi.Length;
            }
            //获取di中所有的文件夹,并存到一个新的对象数组中,以进行递归
            DirectoryInfo[] dis = di.GetDirectories();
            if (dis.Length > 0)
            {
                for (int i = 0; i < dis.Length; i++)
                {
                    len += GetDirectoryLength(dis[i].FullName);
                }
            }
            return len;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.progressBar1.Value = processValue;
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }       

        //新线程实时刷新进度条
        private void SleepT()
        {
            RegistryKey hkml = Registry.LocalMachine;
            RegistryKey software = hkml.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy", true);

            processValue += 5;

            //初始化设置
            string[] rootDir = { "Motion Studio", "Libraries", "Example", "Documents" };
            InitAction(rootDir);

            # region 复制压缩包至指定目录，并解压
            string sourcePath = StudioPath + "studio.zip";
            string targetPaht = StudioPath;

            //复制studio压缩包
            FileStream writer = new FileStream(sourcePath, FileMode.OpenOrCreate);
            writer.Write(Properties.Resources.studio1, 0, Properties.Resources.studio1.Length);
            writer.Dispose();
            processValue += 15;

            //解压studio
            UnpackFileRarOrZip(sourcePath, targetPaht);
            System.IO.File.Delete(sourcePath);
            processValue += 10;

            //判断系统32位还是64位，用于下一步对应系统的压缩包解压
            checkWin32Or64();
            processValue += 5;
            //判断系统简中还是繁中，用于下一步对应系统的文件复制
            checkSampleOrTradition();
            #endregion
            processValue += 5;

            #region 创建桌面快捷键
            //创建桌面快捷键
            string name = "Motion Studio";
            string targetPath = StudioPath + @"Motion Studio\Motion Studio.exe";
            string description = "Motion Studio V1.6";
            //创建桌面快捷键，参数1为快捷键对应的程序实际位置，参数2为快捷键名字，参数3为快捷键描述
            CreateDesktopShortcuts(targetPath, name, description);
            #endregion
            processValue += 10;

            # region 创建开始菜单   Motion Studio.exe 快捷键
            //创建Motion Studio.exe 快捷键
            string iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Motion Studio.lnk";
            string startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Motion Studio\Motion Studio.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 10;

            # region 创建开始菜单   Motion Studio.exe 卸载快捷键
            //创建Motion Studio.exe 快捷键
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\StudioUninst.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Motion Studio\StudioUninst.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 10;

            #region 创建开始菜单  Example文件夹快捷键
            //创建开始菜单快捷键------Example/Normal/Single Axis
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Example\Normal\Single Axis.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Example\Normal\Single Axis";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Normal/Gluing Machine
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Example\Normal\Gluing Machine.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Example\Normal\Gluing Machine";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Template/KeyBoard Test
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Example\Template\KeyBoard Test.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Example\Template\KeyBoard Test";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Template/FixedPoint Motion
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Example\Template\FixedPoint Motion.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Example\Template\FixedPoint Motion";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 10;
            
            #region 创建开始菜单  Documents文件夹快捷键
            //创建开始菜单快捷键------Documents/DSP
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\DSP.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\DSP";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Application Manual/MSConnection.pdf
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Application Manual\MSConnection.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Application Manual\MSConnection.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents\Application Manual\Template Framework.pdf
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Application Manual\Template Framework.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Application Manual\Template Framework.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents\Release Note\Release Notes.HTM
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Release Note\Release Notes.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Release Note\Release Notes.HTM";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents\Software Manual\CodingHelp.xlsx
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Software Manual\CodingHelp.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Software Manual\CodingHelp.xlsx";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents\Software Manual\Motion BASIC.pdf
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Software Manual\Motion BASIC.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Software Manual\Motion BASIC.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents\Software Manual\Motion Studio.pdf
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Documents\Software Manual\Motion Studio.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + @"Documents\Software Manual\Motion Studio.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            #endregion
            processValue += 10;

            //将卸载程序加入控制面板/程序卸载
            software = hkml.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", true);
            if (software.OpenSubKey("Motion Studio") != null)
            {
                software.DeleteSubKey("Motion Studio");
            }
            software.CreateSubKey("Motion Studio");
            software = software.OpenSubKey("Motion Studio", true);
            software.SetValue("DisplayName", "Motion Studio 1.6.0.1");
            software.SetValue("UninstallString", StudioPath + @"Motion Studio\StudioUninst.exe");
            software.SetValue("DisplayIcon", StudioPath + @"Motion Studio\Motion Studio.exe");
            software.SetValue("Publisher", "Advantech");
            //software.SetValue("InstallLocation", StudioPath + "Motion Studio");
            //software.SetValue("InstallDate", DateTime.Now.ToString());
            software.SetValue("DisplayVersion", "1.6.0.1");

            long size = GetDirectoryLength(StudioPath + "Motion Studio");
            size += GetDirectoryLength(StudioPath + "Documents");
            size += GetDirectoryLength(StudioPath + "Example");
            size += GetDirectoryLength(StudioPath + "Libraries");
            int ss = (int)size / 1024;  //转为千字节 kb
            software.SetValue("EstimatedSize", ss);
            software.SetValue("sEstimatedSize2", 0);
            
            //software.SetValue("NoModify", 1);
            //software.SetValue("NoRepair", 1);

            processValue += 5;

            #region 删除解压缩dll
            string dir = Environment.GetFolderPath(Environment.SpecialFolder.CommonTemplates) + DateTime.Now.ToString("yyyy-MM-dd");
            if (Directory.Exists(dir))
            {
                Directory.Delete(dir, true);
                
            }
            Directory.CreateDirectory(dir);
            
            string path = Path.GetDirectoryName(Application.ExecutablePath) + @"\ICSharpCode.SharpZipLib.dll";
            System.IO.File.Move(path, dir+ @"\ICSharpCode.SharpZipLib.dll");
            path = Path.GetDirectoryName(Application.ExecutablePath) + @"\Interop.IWshRuntimeLibrary.dll";
            System.IO.File.Move(path, dir + @"\Interop.IWshRuntimeLibrary.dll");            

            SHChangeNotify(0x8000000, 0, IntPtr.Zero, IntPtr.Zero);
            #endregion
            processValue += 5;

        }

        int flag_text = 0;
        private void timer1_Tick_1(object sender, EventArgs e)
        {
            //timer1每300ms触发一次，累计10次即3秒更换一次图片
            if (flag_png_times%10==0)
            {
                switch (flag_png)
                {
                    case 0:                        
                        this.BackgroundImage = Properties.Resources.studio01;
                        this.BackgroundImageLayout = ImageLayout.Stretch;
                        flag_png++;
                        break;
                    case 1:
                        this.BackgroundImage = Properties.Resources.studio02;
                        this.BackgroundImageLayout = ImageLayout.Stretch;
                        flag_png++;
                        break;
                    case 2:
                        this.BackgroundImage = Properties.Resources.studio03;
                        this.BackgroundImageLayout = ImageLayout.Stretch;
                        flag_png =0;
                        break;
                }
            }
            flag_png_times++;

            this.progressBar1.Value = processValue;
            switch (flag_text)
            {
                case 0:
                    label1.Text = "";
                    label1.Visible = false;
                    break;
                case 1:
                    progressBar1.Visible = true;
                    label1.Visible = true;
                    label1.Text = "正在安装.   ";
                    flag_text += 1;
                    break;
                case 2:
                    label1.Text = "正在安装..  ";
                    flag_text += 1;
                    break;
                case 3:
                    label1.Text = "正在安装... ";
                    flag_text = 1;
                    break;
            }

            if (processValue == 100)
            {
                //进度条到顶，进度条不可见
                progressBar1.Visible = false;
                pictureBox2.Visible = false;
                timer1.Enabled = false;

                label1.Visible = false;
                button1.Visible = true;
                button2.Visible = true;
                this.BackgroundImage = Properties.Resources.finish_bg;
                pictureBox3.Visible = true;
                processValue = 0;
                
                flag_text = 0;
                processFlag = 2;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (processFlag == 0)
            {
                endBox t = new endBox();
                t.ShowDialog();
                if (publicVar.endflag ==1)
                {
                    Application.Exit();
                }
            }
            else if (processFlag == 2)
            {
                Application.Exit();
            }
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            processFlag = 1;
            //注册表操作
            if (!HasFramework4())
            {
                MessageBox.Show("请先安装Framework 4.0");
                Application.Exit();
            }

            pictureBox2.Hide();
            button1.Hide();
            button2.Hide();        
            timer1.Enabled = true;
            //this.progressBar1.Visible = true;
            processValue = 0;

            Thread fThread = new Thread(new ThreadStart(SleepT));//开辟一个新的线程
            fThread.Start();
            
            flag_text = 1;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Process[] proc = Process.GetProcessesByName("Motion Studio");
            if (proc.Length != 0)
            {
                judgeRunning jr = new judgeRunning();
                jr.ShowDialog();
                this.Close();
                return;
            }

            //窗体背景图
            this.BackgroundImage = Properties.Resources.xy;
            //准备安装按钮的背景图
            pictureBox2.Image = Properties.Resources.btn_out;
            pictureBox2.SizeMode = PictureBoxSizeMode.Normal;
            //完成安装按钮的背景图
            pictureBox3.Image = Properties.Resources.finish_out;
            pictureBox3.SizeMode = PictureBoxSizeMode.Normal;

            progressBar1.Visible = false;
            timer1.Enabled = false;
            pictureBox2.Visible = true;
            pictureBox3.Visible = false;
            label1.Text = "";
            label1.Visible = false;
            flag_png = 0;
            flag_png_times = 0;        

            string path = Path.GetDirectoryName(Application.ExecutablePath) + @"\ICSharpCode.SharpZipLib.dll";
            FileStream writer = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Write, FileShare.ReadWrite);
            writer.Write(Properties.Resources.ICSharpCode_SharpZipLib, 0, Properties.Resources.ICSharpCode_SharpZipLib.Length);
            writer.Dispose();

            path = Path.GetDirectoryName(Application.ExecutablePath) + @"\Interop.IWshRuntimeLibrary.dll";
            writer = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Write, FileShare.ReadWrite);
            writer.Write(Properties.Resources.Interop_IWshRuntimeLibrary, 0, Properties.Resources.Interop_IWshRuntimeLibrary.Length);
            writer.Dispose();
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            Application.Exit();
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

        private void pictureBox2_MouseLeave(object sender, EventArgs e)
        {
            this.pictureBox2.Image = Properties.Resources.btn_out;
        }        

        private void pictureBox2_MouseEnter(object sender, EventArgs e)
        {
            this.pictureBox2.Image = Properties.Resources.btn_in;
        }

        private void pictureBox3_MouseEnter(object sender, EventArgs e)
        {
            this.pictureBox3.Image = Properties.Resources.finish_in;
        }

        private void pictureBox3_MouseLeave(object sender, EventArgs e)
        {
            this.pictureBox3.Image = Properties.Resources.finish_out;
        }

        //刷新桌面
        [DllImport("shell32.dll")]
        public static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
        


    }
}

