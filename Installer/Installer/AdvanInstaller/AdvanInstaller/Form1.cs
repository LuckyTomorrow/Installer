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

namespace AdvanInstaller
{
    public partial class Form1 : Form
    {
        public string StudioPath = "C:/Advantech/";
        public string StartMenu = "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/";
        public string test = "";
        public Form1()
        {
            InitializeComponent();
           
            FileStream writer = new FileStream("ICSharpCode.SharpZipLib.dll", FileMode.OpenOrCreate);
            writer.Write(Properties.Resources.ICSharpCode_SharpZipLib, 0, Properties.Resources.ICSharpCode_SharpZipLib.Length);
            writer.Close();

            writer = new FileStream("Interop.IWshRuntimeLibrary.dll", FileMode.OpenOrCreate);
            writer.Write(Properties.Resources.Interop_IWshRuntimeLibrary, 0, Properties.Resources.Interop_IWshRuntimeLibrary.Length);
            writer.Close();
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


        //最开始的操作
        //包括对目标路径的检测，如果不存在则创建，如果存在，则先删除不应该存在的文件夹
        public void InitAction()
        {
            if (Directory.Exists(StudioPath))
            {
                string[] totalPath = { "Motion Studio", "Libraries", "Example", "Documents" };
                for (int i = 0; i < totalPath.Length; i++)
                {
                    string ss = StudioPath + totalPath[i];
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
            string fromPath = StudioPath + @"Motion Studio/Client.zip";
            string targetPaht = StudioPath + @"Motion Studio/";

            if (Environment.Is64BitOperatingSystem)
            {
                //复制64位文件压缩包至指定目录，并解压   
                //复制studio压缩包
                FileStream writer = new FileStream(fromPath, FileMode.OpenOrCreate);
                writer.Write(Properties.Resources.Client_x64, 0, Properties.Resources.Client_x64.Length);
                writer.Close();

                //解压studio
                UnpackFileRarOrZip(fromPath, targetPaht);
                System.IO.File.Delete(fromPath);
                
            }
            else
            {
                //复制studio压缩包
                FileStream writer = new FileStream(fromPath, FileMode.OpenOrCreate);
                writer.Write(Properties.Resources.Client_x86, 0, Properties.Resources.Client_x86.Length);
                writer.Close();

                //解压studio
                UnpackFileRarOrZip(fromPath, targetPaht);
                System.IO.File.Delete(fromPath);
            }
        }

        //根据系统语言是简中还是繁中，对相应文件进行复制操作
        public void checkSampleOrTradition()
        {
            string[] manual = { "CodingHelp.xlsx", "Motion BASIC.pdf", "Motion Studio.pdf", "MSConnection.pdf", "Release Notes.HTM", "Template Framework.pdf" };
            string formpath = "";
            string topath = "";
            if (System.Globalization.CultureInfo.InstalledUICulture.Name == "zh-CN")
            {
                formpath = StudioPath + @"Motion Studio\zh-Hans\" + manual[3];
                topath = StudioPath + @"Documents\Application Manual\" + manual[3];
                System.IO.File.Copy(formpath, topath, true);

                formpath = StudioPath + @"Motion Studio\zh-Hans\" + manual[5];
                topath = StudioPath + @"Documents\Application Manual\" + manual[5];
                System.IO.File.Copy(formpath, topath, true);

                formpath = StudioPath + @"Motion Studio\zh-Hans\" + manual[4];
                topath = StudioPath + @"Documents\Release Note\" + manual[4];
                System.IO.File.Copy(formpath, topath, true);

                for (int i = 0; i < 3; i++)
                {
                    formpath = StudioPath + @"Motion Studio\zh-Hans\" + manual[i];
                    topath = StudioPath + @"Documents\Software Manual\" + manual[i];
                    System.IO.File.Copy(formpath, topath, true);
                }                

            }
            else if (System.Globalization.CultureInfo.InstalledUICulture.Name == "zh-TW")
            {
                formpath = StudioPath + @"Motion Studio\zh-TW\" + manual[3];
                topath = StudioPath + @"Documents\Application Manual\" + manual[3];
                System.IO.File.Copy(formpath, topath, true);

                formpath = StudioPath + @"Motion Studio\zh-TW\" + manual[5];
                topath = StudioPath + @"Documents\Application Manual\" + manual[5];
                System.IO.File.Copy(formpath, topath, true);

                formpath = StudioPath + @"Motion Studio\zh-TW\" + manual[4];
                topath = StudioPath + @"Documents\Release Note\" + manual[4];
                System.IO.File.Copy(formpath, topath, true);

                for (int i = 0; i < 3; i++)
                {
                    formpath = StudioPath + @"Motion Studio\zh-TW\" + manual[i];
                    topath = StudioPath + @"Documents\Software Manual\" + manual[i];
                    System.IO.File.Copy(formpath, topath, true);
                }
            }
        }

        private void btn_install_Click(object sender, EventArgs e)
        {
            MessageBox.Show("开始");
            if (!HasFramework4())
            {
                MessageBox.Show("请先安装Framework 4.0");
                Application.Exit();
            }
           
            //初始化设置
            InitAction();

            # region 复制压缩包至指定目录，并解压

            string sourcePath = StudioPath + "studio.zip";
            string targetPaht = StudioPath;

            //复制studio压缩包
            FileStream writer = new FileStream(sourcePath, FileMode.OpenOrCreate);
            writer.Write(Properties.Resources.motion_studio, 0, Properties.Resources.motion_studio.Length);
            writer.Close();

            //解压studio
            UnpackFileRarOrZip(sourcePath, targetPaht);
            System.IO.File.Delete(sourcePath);

            checkWin32Or64();
            checkSampleOrTradition();
            #endregion

            #region 创建桌面快捷键
            //创建桌面快捷键
            string name = "Motion Studio";            
            string targetPath = StudioPath + @"Motion Studio/Motion Studio.exe";
            string description = "Motion Studio V1.6";
            //创建桌面快捷键，参数1为快捷键对应的程序实际位置，参数2为快捷键名字，参数3为快捷键描述
            CreateDesktopShortcuts(targetPath, name, description);
            #endregion

            # region 创建开始菜单   Motion Studio.exe 快捷键
            //创建Motion Studio.exe 快捷键
            string iconpath = StartMenu + "Advantech Automation/Motion_Studio/Mlotion Studio.lnk";
            string startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Motion Studio/Motion Studio.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion

            # region 创建开始菜单   Motion Studio.exe 卸载快捷键
            //创建Motion Studio.exe 快捷键
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Uninstall.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Motion Studio/Uninstall.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion

            #region 创建开始菜单  Example文件夹快捷键
            //创建开始菜单快捷键------Example/Normal/Single Axis
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Example/Normal/Single Axis.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Example/Normal/Single Axis";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Normal/Gluing Machine
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Example/Normal/Gluing Machine.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Example/Normal/Gluing Machine";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Template/KeyBoard Test
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Example/Template/KeyBoard Test.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Example/Template/KeyBoard Test";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Example/Template/FixedPoint Motion
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Example/Template/FixedPoint Motion.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Example/Template/FixedPoint Motion";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion

            #region 创建开始菜单  Documents文件夹快捷键
            //创建开始菜单快捷键------Documents/DSP
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/DSP.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/DSP";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Application Manual/MSConnection.pdf
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Application Manual/MSConnection.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Application Manual/MSConnection.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Application Manual/Template Framework.pdf
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Application Manual/Template Framework.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Application Manual/Template Framework.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Release Note/Release Notes.HTM
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Release Note/Release Notes.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Release Note/Release Notes.HTM";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Software Manual/CodingHelp.xlsx
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Software Manual/CodingHelp.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Software Manual/CodingHelp.xlsx";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Software Manual/Motion BASIC.pdf
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Software Manual/Motion BASIC.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Software Manual/Motion BASIC.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            //创建开始菜单快捷键------Documents/Software Manual/Motion Studio.pdf
            iconpath = StartMenu + "Advantech Automation/Motion_Studio/Documents/Software Manual/Motion Studio.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = StudioPath + "Documents/Software Manual/Motion Studio.pdf";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);

            #endregion


            MessageBox.Show("结束");
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
                the_Info = "x " + Path.GetFileName(fileFromUnZip) + " " + fileToUnZip + " -y";

                ProcessStartInfo the_StartInfo = new ProcessStartInfo();
                the_StartInfo.FileName = the_rar;
                the_StartInfo.Arguments = the_Info;
                the_StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
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

                        streamWriter = System.IO.File.Create(fileName);
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
            finally
            {
                if (streamWriter != null)
                {
                    streamWriter.Close();
                    streamWriter = null;
                }
                if (theEntry != null)
                {
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

    }
}

