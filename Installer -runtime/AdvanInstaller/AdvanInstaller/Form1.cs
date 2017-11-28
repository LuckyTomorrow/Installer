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
        public string RuntimePath = @"C:\Advantech\";
        //开始菜单
        public string StartMenu = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\";
        //启动菜单
        public string BeginMenu = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\";
        public string test = "";
        public int processValue = 0;
        //用于窗体右上角X的功能分情况
        public int processFlag = 0;

        public int flag_png = 0;
        public int flag_png_times = 0;

        public Form1()
        {
            InitializeComponent();
        }
        
        //初始化的操作
        //包括对目标路径的检测，如果不存在则创建，如果存在，则先删除不应该存在的文件夹
        public uint InitAction(string[] rootDir)
        {
            try
            {
                if (Directory.Exists(RuntimePath))
                {

                    for (int i = 0; i < rootDir.Length; i++)
                    {
                        string ss = RuntimePath + rootDir[i];
                        if (Directory.Exists(ss))
                        {
                            Directory.Delete(ss, true);
                        }
                    }
                }
                else
                {
                    Directory.CreateDirectory(RuntimePath);
                }

                return 0;
            }
            catch (Exception e)
            {
                MessageBox.Show("Step 1 Error! \r\n" + e.ToString());
                return 1;
            }
            
        }

        //Runtime的注册表操作
        public uint doRegedit()
        {
            try
            {
                //让system32文件夹可读可写
                RegistryKey hkml = Registry.LocalMachine;
                RegistryKey software = hkml.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Environment", true);
                string path = software.GetValue("Path").ToString();
                if (!path.Contains(@";C:\Windows\System32;") && !path.Contains(@"C:\Windows\System32;") && !path.Contains(@";C:\Windows\System32"))
                {
                    path = path + @";C:\Windows\System32";
                    software.SetValue("Path", path);
                }

                //public--用于studio查找DAQ板卡
                software = hkml.OpenSubKey(@"SOFTWARE\Advantech\Public", true);
                if (null == software)
                {
                    software = hkml.CreateSubKey(@"SOFTWARE\Advantech\Public");
                }
                software.SetValue("RootPath", "C:\\Advantech");

                //记录版本和路径
                software = hkml.OpenSubKey(@"SOFTWARE\Advantech\Motion_Runtime", true);
                if (null == software)
                {
                    software = hkml.CreateSubKey(@"SOFTWARE\Advantech\Motion_Runtime");
                }
                software.SetValue("Path", "C:\\Advantech\\Motion_Runtime");
                software.SetValue("Version", "V1.6.0.2");

                return 0;
            }
            catch (Exception e)
            {
                MessageBox.Show("Step 2 Error! \r\n" + e.ToString());
                return 2;
            }
            
        }

        //复制与解压资源内的zip包
        public uint CopyAndUnzip(int proValue)
        {
            try
            {
                FileStream writer = null;
                string sourcePath = RuntimePath + "Runtime.zip";
                string targetPath = RuntimePath;

                //先复制解压Runtime.zip，用于先卸载可能正在运行的虚拟轴卡和DAQ卡
                writer = new FileStream(sourcePath, FileMode.OpenOrCreate);
                writer.Write(Properties.Resources.Runtime1, 0, Properties.Resources.Runtime1.Length);
                writer.Dispose();
                UnpackFileRarOrZip(sourcePath, targetPath);
                System.IO.File.Delete(sourcePath);

                //不管存不存在，都先调用bat文件卸载虚拟轴卡和DAQ卡，再删除
                UninstallDriver();
                if (Directory.Exists(RuntimePath + "DAQNavi"))
                {                    
                    Directory.Delete(RuntimePath + "DAQNavi", true);
                }

                string[] str = { "Dll&Sys.zip", "Driver_x32.zip", "Driver_x64.zip", "DAQNavi.zip", "System32.zip", "System64.zip" };
                for (int i = 0; i < str.Length; i++)
                {
                    sourcePath = RuntimePath + str[i];

                    writer = new FileStream(sourcePath, FileMode.OpenOrCreate);
                    switch (i)
                    {
                        case 0:
                            writer.Write(Properties.Resources.Dll_Sys, 0, Properties.Resources.Dll_Sys.Length);
                            break;
                        case 1:
                            writer.Write(Properties.Resources.Driver_x32, 0, Properties.Resources.Driver_x32.Length);
                            break;
                        case 2:
                            writer.Write(Properties.Resources.Driver_x64, 0, Properties.Resources.Driver_x64.Length);
                            break;
                        case 3:
                            writer.Write(Properties.Resources.DAQNavi, 0, Properties.Resources.DAQNavi.Length);
                            break;
                        case 4:
                            writer.Write(Properties.Resources.System32, 0, Properties.Resources.System32.Length);
                            break;
                        case 5:
                            writer.Write(Properties.Resources.System64, 0, Properties.Resources.System64.Length);
                            break;
                    }
                    writer.Dispose();

                    UnpackFileRarOrZip(sourcePath, targetPath);
                    System.IO.File.Delete(sourcePath);                    
                    processValue += proValue / str.Length;
                }

                return 0;
            }
            catch (Exception e)
            {
                MessageBox.Show("Step 3 Error! \r\n" + e.ToString());
                return 3;
            }           

        }

        //判断是32位还是64位系统
        public uint checkWin32Or64(int proValue)
        {
            try
            {
                string sourceDir = null;
                string targetDir = null;

                if (Environment.Is64BitOperatingSystem)
                {
                    //复制AdvEncryption.dll到Motion_Runtime\Motion_Runtime文件夹
                    string sourceFile = RuntimePath + @"Dll&Sys\x64\AdvEncryption.dll";
                    string targetFile = RuntimePath + @"Motion_Runtime\Motion_Runtime\AdvEncryption.dll";
                    System.IO.File.Copy(sourceFile, targetFile);

                    //驱动文件的复制
                    sourceDir = RuntimePath + "Driver_x64";
                    targetDir = RuntimePath + "Motion_Runtime";
                    CopyOldLabFilesToNewLab(sourceDir, targetDir);

                    //驱动PCI1245
                    string driverName = "PCI1245-MAS";
                    if (!publicVar.flag_1245)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1265.dll", targetDir + "\\" + driverName + "\\PCI1265.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1265s.sys", targetDir + "\\" + driverName + "\\PCI1265s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1265.dll", @"C:\Windows\System32\PCI1265.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1265.dll", @"C:\Windows\SysWOW64\PCI1265.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1265s.sys", @"C:\Windows\System32\drivers\PCI1265s.sys", true);

                    }

                    //驱动PCI1245L
                    driverName = "PCI1245L&LIO-MAS";
                    if (!publicVar.flag_1245L)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1245L.dll", targetDir + "\\" + driverName + "\\PCI1245L.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1245L.sys", targetDir + "\\" + driverName + "\\PCI1245L.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1245L.dll", @"C:\Windows\System32\PCI1245L.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1245L.dll", @"C:\Windows\SysWOW64\PCI1245L.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1245L.sys", @"C:\Windows\System32\drivers\PCI1245L.sys", true);

                    }

                    //驱动PCI1285
                    driverName = "PCI1285-MAS";
                    if (!publicVar.flag_1285)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1285.dll", targetDir + "\\" + driverName + "\\PCI1285.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1285s.sys", targetDir + "\\" + driverName + "\\PCI1285s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1285.dll", @"C:\Windows\System32\PCI1285.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1285.dll", @"C:\Windows\SysWOW64\PCI1285.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\PCI1285s.sys", @"C:\Windows\System32\drivers\PCI1285s.sys", true);

                    }

                    //驱动MVP3245
                    driverName = "MVP3245-MAS";
                    if (!publicVar.flag_3245)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\MVP3245.dll", targetDir + "\\" + driverName + "\\MVP3245.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\MVP3245s.sys", targetDir + "\\" + driverName + "\\MVP3245s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\MVP3245.dll", @"C:\Windows\System32\MVP3245.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\MVP3245.dll", @"C:\Windows\SysWOW64\MVP3245.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\MVP3245s.sys", @"C:\Windows\System32\drivers\MVP3245s.sys", true);

                    }

                    //驱动PCI1750
                    driverName = "PCI1750";
                    if (!publicVar.flag_1750)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1750.dll", targetDir + "\\" + driverName + "\\Bio1750.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1750s.sys", targetDir + "\\" + driverName + "\\Bio1750s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1750.dll", @"C:\Windows\System32\Bio1750.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1750.dll", @"C:\Windows\SysWOW64\Bio1750.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1750s.sys", @"C:\Windows\System32\drivers\Bio1750s.sys", true);

                    }

                    //驱动PCI1756
                    driverName = "PCI1756";
                    if (!publicVar.flag_1756)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1756.dll", targetDir + "\\" + driverName + "\\Bio1756.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1756s.sys", targetDir + "\\" + driverName + "\\Bio1756s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1756.dll", @"C:\Windows\System32\Bio1756.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1756.dll", @"C:\Windows\SysWOW64\Bio1756.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\Bio1756s.sys", @"C:\Windows\System32\drivers\Bio1756s.sys", true);

                    }

                    //驱动PCIGPDC
                    driverName = "PCIGPDC";
                    if (!publicVar.flag_1730)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\WdfCoInstaller01009.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01009.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\BioGPDC.dll", targetDir + "\\" + driverName + "\\BioGPDC.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\BioGPDCs.sys", targetDir + "\\" + driverName + "\\BioGPDCs.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\BioGPDC.dll", @"C:\Windows\System32\BioGPDC.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\BioGPDC.dll", @"C:\Windows\SysWOW64\BioGPDC.dll", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x64\BioGPDCs.sys", @"C:\Windows\System32\drivers\BioGPDCs.sys", true);

                    }
                    processValue += proValue / 3;

                    //System32文件夹操作
                    sourceDir = RuntimePath + "System64";
                    targetDir = @"C:\Windows\System32";
                    CopySystem32File(sourceDir, targetDir);

                    //Syswow64文件夹操作
                    sourceDir = RuntimePath + "System32";
                    targetDir = @"C:\Windows\SysWOW64";
                    CopySystem32File(sourceDir, targetDir);
                    processValue += proValue / 3;

                }
                else   //32位系统
                {
                    //复制AdvEncryption.dll到Motion_Runtime\Motion_Runtime文件夹
                    string sourceFile = RuntimePath + @"Dll&Sys\x86\AdvEncryption.dll";
                    string targetFile = RuntimePath + @"Motion_Runtime\Motion_Runtime\AdvEncryption.dll";
                    System.IO.File.Copy(sourceFile, targetFile);

                    //驱动文件的复制
                    sourceDir = RuntimePath + "Driver_x32";
                    targetDir = RuntimePath + "Motion_Runtime";
                    CopyOldLabFilesToNewLab(sourceDir, targetDir);

                    //驱动PCI1245
                    string driverName = "PCI1245-MAS";
                    if (!publicVar.flag_1245)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1265.dll", targetDir + "\\" + driverName + "\\PCI1265.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1265s.sys", targetDir + "\\" + driverName + "\\PCI1265s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1265.dll", @"C:\Windows\System32\PCI1265.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1265s.sys", @"C:\Windows\System32\drivers\PCI1265s.sys", true);

                    }

                    //驱动PCI1245L
                    driverName = "PCI1245L&LIO-MAS";
                    if (!publicVar.flag_1245L)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1245L.dll", targetDir + "\\" + driverName + "\\PCI1245L.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1245L.sys", targetDir + "\\" + driverName + "\\PCI1245L.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1245L.dll", @"C:\Windows\System32\PCI1245L.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1245L.sys", @"C:\Windows\System32\drivers\PCI1245L.sys", true);

                    }

                    //驱动PCI1285
                    driverName = "PCI1285-MAS";
                    if (!publicVar.flag_1285)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1285.dll", targetDir + "\\" + driverName + "\\PCI1285.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1285s.sys", targetDir + "\\" + driverName + "\\PCI1285s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1285.dll", @"C:\Windows\System32\PCI1285.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\PCI1285s.sys", @"C:\Windows\System32\drivers\PCI1285s.sys", true);

                    }

                    //驱动MVP3245
                    driverName = "MVP3245-MAS";
                    if (!publicVar.flag_3245)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\MVP3245.dll", targetDir + "\\" + driverName + "\\MVP3245.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\MVP3245s.sys", targetDir + "\\" + driverName + "\\MVP3245s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\MVP3245.dll", @"C:\Windows\System32\MVP3245.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\MVP3245s.sys", @"C:\Windows\System32\drivers\MVP3245s.sys", true);

                    }

                    //驱动PCI1750
                    driverName = "PCI1750";
                    if (!publicVar.flag_1750)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1750.dll", targetDir + "\\" + driverName + "\\Bio1750.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1750s.sys", targetDir + "\\" + driverName + "\\Bio1750s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1750.dll", @"C:\Windows\System32\Bio1750.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1750s.sys", @"C:\Windows\System32\drivers\Bio1750s.sys", true);

                    }

                    //驱动PCI1756
                    driverName = "PCI1756";
                    if (!publicVar.flag_1756)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1756.dll", targetDir + "\\" + driverName + "\\Bio1756.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1756s.sys", targetDir + "\\" + driverName + "\\Bio1756s.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1756.dll", @"C:\Windows\System32\Bio1756.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\Bio1756s.sys", @"C:\Windows\System32\drivers\Bio1756s.sys", true);

                    }

                    //驱动PCIGPDC
                    driverName = "PCIGPDC";
                    if (!publicVar.flag_1730)
                    {
                        Directory.Delete(targetDir + "\\" + driverName, true);
                    }
                    else
                    {
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\DPInst.exe", targetDir + "\\" + driverName + "\\DPInst.exe", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\WdfCoInstaller01005.dll", targetDir + "\\" + driverName + "\\WdfCoInstaller01005.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\BioGPDC.dll", targetDir + "\\" + driverName + "\\BioGPDC.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\BioGPDCs.sys", targetDir + "\\" + driverName + "\\BioGPDCs.sys", true);

                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\BioGPDC.dll", @"C:\Windows\System32\BioGPDC.dll", true);
                        System.IO.File.Copy(RuntimePath + @"Dll&Sys\x86\BioGPDCs.sys", @"C:\Windows\System32\drivers\BioGPDCs.sys", true);

                    }
                    processValue += proValue / 3;

                    //System32文件夹操作
                    sourceDir = RuntimePath + "System32";
                    targetDir = @"C:\Windows\System32";
                    CopySystem32File(sourceDir, targetDir);
                    processValue += proValue / 3;
                }

                //删除多余的文件夹
                string[] Folder = { "Dll&Sys", "Driver_x32", "Driver_x64", "System32", "System64" };
                for (int i = 0; i < Folder.Length; i++)
                {
                    if (Directory.Exists(RuntimePath + Folder[i]))
                    {
                        Directory.Delete(RuntimePath + Folder[i], true);
                    }
                }

                //在操作完system32和64文件夹后，再调用DAQNavi安装bat，如果在之前就调用bat，可能
                //会导致复制daq相关dll到system32和64出问题
                InstallDAQNavi();
                processValue += proValue / 3;

                return 0;
            }
            catch (Exception e)
            {
                MessageBox.Show("Step 4 Error! \r\n" + e.ToString());
                return 4;
            }
            
        }

        /// <summary>
        /// 拷贝oldlab的文件到newlab下面
        /// </summary>
        /// <param name="sourcePath">lab文件所在目录(@"~\labs\oldlab")</param>
        /// <param name="savePath">保存的目标目录(@"~\labs\newlab")</param>
        /// <returns>返回:true-拷贝成功;false:拷贝失败</returns>
        public bool CopyOldLabFilesToNewLab(string sourcePath, string savePath)
        {
            if (!Directory.Exists(savePath))
            {
                Directory.CreateDirectory(savePath);
            }

            #region //拷贝labs文件夹到savePath下
            try
            {
                string[] labDirs = Directory.GetDirectories(sourcePath);//目录
                string[] labFiles = Directory.GetFiles(sourcePath);//文件
                if (labFiles.Length > 0)
                {
                    for (int i = 0; i < labFiles.Length; i++)
                    {
                        if (Path.GetFileName(labFiles[i]) != ".lab")//排除.lab文件
                        {
                            System.IO.File.Copy(sourcePath + "\\" + Path.GetFileName(labFiles[i]), savePath + "\\" + Path.GetFileName(labFiles[i]), true);
                        }
                    }
                }
                if (labDirs.Length > 0)
                {
                    for (int j = 0; j < labDirs.Length; j++)
                    {
                        Directory.GetDirectories(sourcePath + "\\" + Path.GetFileName(labDirs[j]));

                        //递归调用
                        CopyOldLabFilesToNewLab(sourcePath + "\\" + Path.GetFileName(labDirs[j]), savePath + "\\" + Path.GetFileName(labDirs[j]));
                    }
                }
            }
            catch (Exception )
            {
                return false;
            }
            #endregion
            return true;
        }

        public bool CopySystem32File(string sourcePath, string savePath)
        {
            #region //拷贝labs文件夹到savePath下
            try
            {
                string[] labFiles = Directory.GetFiles(sourcePath);//文件
                for (int i = 0; i < labFiles.Length; i++)
                {
                    string s = Path.GetFileName(labFiles[i]);
                    if (System.IO.File.Exists(savePath + "\\" + s))
                    {
                        if (s == "mfc100.dll" || s == "mfc100u.dll" || s == "msvcp100.dll" || s == "msvcr100.dll" || s == "msvcr100_clr0400.dll")
                        {
                            continue;
                        }
                    }
                    System.IO.File.Copy(sourcePath + "\\" + Path.GetFileName(labFiles[i]), savePath + "\\" + Path.GetFileName(labFiles[i]), true);
                }
            }
            catch (Exception e )
            {
                MessageBox.Show(e.ToString());
                return false;
            }
            #endregion
            return true;
        }

        //安装驱动程序
        public uint InstallDriver(int proValue)
        {
            try
            {
                Process t = null;
                string[] dirName = { "PCI1245-MAS", "PCI1245L&LIO-MAS", "PCI1285-MAS", "MVP3245-MAS", "PCI1750", "PCI1756", "PCIGPDC" };
                for (int i = 0; i < dirName.Length; i++)
                {
                    if (Directory.Exists(RuntimePath + @"Motion_Runtime\" + dirName[i]))
                    {
                        t = new Process();
                        t.StartInfo.FileName = RuntimePath + @"Motion_Runtime\" + dirName[i] + @"\DPInst.exe";
                        t.StartInfo.Arguments = "/L 0x409 /sw /se /sa";
                        t.StartInfo.UseShellExecute = false;

                        t.Start();
                        t.WaitForExit();
                        t.Close();
                        t.Dispose();
                    }

                    processValue += proValue / dirName.Length;
                }

                return 0;
            }
            catch (Exception e)
            {
                MessageBox.Show("Step 5 Error! \r\n" + e.ToString());
                return 5;
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
            //初始化设置---Step 0ne
            string[] rootDir = { "Motion_Runtime"};
            InitAction(rootDir);
            processValue += 6;

            //先进行注册表相关操作---Step Two
            doRegedit();
            processValue += 5;

            //复制压缩包至指定目录，并解压---Step Three
            CopyAndUnzip(30);

            //判断系统32位还是64位，用于相应文件的复制、删除---Step Four
            checkWin32Or64(15);

            //安装驱动程序---Step Five
            InstallDriver(35);

            #region 创建开始菜单   Motion_Runtime.exe 快捷键
            //创建Motion_Runtime.exe 快捷键---Step Six
            string iconpath = StartMenu + @"Advantech Automation\Motion_Studio\Motion_Runtime.lnk";
            string startmenupath = Path.GetDirectoryName(iconpath);
            string description = "";
            string targetPath = RuntimePath + @"Motion_Runtime\Motion_Runtime\Motion_Runtime.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 2;

            # region 创建开始菜单   Motion_Runtime.exe 卸载快捷键
            //创建Motion_Runtime.exe 卸载快捷键---Step Seven
            iconpath = StartMenu + @"Advantech Automation\Motion_Studio\RuntimeUninst.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = RuntimePath + @"Motion_Runtime\Motion_Runtime\RuntimeUninst.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 2;

            # region 创建启动菜单   Motion_Runtime.exe 启动快捷键
            //创建Motion_Runtime.exe 卸载快捷键---Step Eight
            iconpath = BeginMenu + @"Motion_Runtime.lnk";
            startmenupath = Path.GetDirectoryName(iconpath);
            description = "";
            targetPath = RuntimePath + @"Motion_Runtime\Motion_Runtime\Motion_Runtime.exe";
            CreateStartmenuShortcuts(iconpath, targetPath, startmenupath, description);
            #endregion
            processValue += 1;

            //将卸载程序加入控制面板/程序卸载---Step Night  
            RegistryKey hkml = Registry.LocalMachine;
            RegistryKey software = hkml.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", true);
            if (software.OpenSubKey("Motion Runtime") != null)
            {
                software.DeleteSubKey("Motion Runtime");
            }
            software.CreateSubKey("Motion Runtime");
            software = software.OpenSubKey("Motion Runtime", true);
            software.SetValue("DisplayName", "Motion Runtime 1.6.0.1");
            software.SetValue("UninstallString", RuntimePath + @"Motion_Runtime\Motion_Runtime\RuntimeUninst.exe");
            software.SetValue("DisplayIcon", RuntimePath + @"Motion_Runtime\Motion_Runtime\Motion_Runtime.exe");
            software.SetValue("Publisher", "Advantech");
            //software.SetValue("InstallLocation", RuntimePath + "Motion Studio");
            //software.SetValue("InstallDate", DateTime.Now.ToString());
            software.SetValue("DisplayVersion", "1.6.0.1");

            long size = GetDirectoryLength(RuntimePath + "Motion_Runtime");
            size += GetDirectoryLength(RuntimePath + "DAQNavi");
            int ss = (int)size / 1024;  //转为千字节 kb
            software.SetValue("EstimatedSize", ss);
            software.SetValue("sEstimatedSize2", 0);            
            //software.SetValue("NoModify", 1);
            //software.SetValue("NoRepair", 1);
            processValue += 2;

            removeDll();
            processValue += 2;

        }

        int flag_text = 0;
        private void timer1_Tick_1(object sender, EventArgs e)
        {
            if (flag_png_times%20==0)
            {
                switch (flag_png)
                {
                    case 0:
                        this.BackgroundImage = Properties.Resources.runtime01;
                        this.BackgroundImageLayout = ImageLayout.Stretch;
                        flag_png++;
                        break;
                    case 1:
                        this.BackgroundImage = Properties.Resources.runtime02;
                        flag_png++;
                        break;
                    case 2:
                        this.BackgroundImage = Properties.Resources.runtime03;
                        flag_png++;
                        break;
                    case 3:
                        this.BackgroundImage = Properties.Resources.runtime04;
                        flag_png++;
                        break;
                    case 4:
                        this.BackgroundImage = Properties.Resources.runtime05;
                        flag_png=0;
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
                    if (processValue>=50 && processValue<75)
                    {
                        label1.Text = "正在加载驱动.  ";
                    }
                    else
                    {
                        label1.Text = "正在安装.  ";
                    }
                    flag_text += 1;
                    break;
                case 2:
                    if (processValue >= 50 && processValue < 75)
                    {
                        label1.Text = "正在加载驱动.. ";
                    }
                    else
                    {
                        label1.Text = "正在安装.. ";
                    }
                    flag_text += 1;
                    break;
                case 3:
                    if (processValue >= 50 && processValue < 75)
                    {
                        label1.Text = "正在加载驱动...";
                    }
                    else
                    {
                        label1.Text = "正在安装...";
                    }
                    flag_text = 1;
                    break;
            }

            if (processValue == 100)
            {
                //进度条到顶，进度条不可见
                progressBar1.Visible = false;
                pictureBox2.Visible = false;
                button1.Visible = true;
                button2.Visible = true;
                pictureBox3.Visible = true;
                processValue = 0;
                flag_text = 0;
                processFlag = 2;
                label1.Visible = false;
                timer1.Enabled = false;
                this.BackgroundImage = Properties.Resources.finish_bg;
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
                    removeDll();
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
            deviceSelect ds = new deviceSelect();
            ds.ShowDialog();
            if (publicVar.endflag == 1)
            {
                removeDll();
                this.Close();
                return;
            }

            processFlag = 1;
            
            pictureBox2.Hide();
            button1.Hide();
            button2.Hide();        
            timer1.Enabled = true;
            //this.progressBar1.Visible = true;
            processValue = 0;
            Thread fThread = new Thread(new ThreadStart(SleepT));//开辟一个新的线程
            fThread.Start();
            label1.Visible = true;
            flag_text = 1;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Process[] proc = Process.GetProcessesByName("Motion_Runtime");
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
            flag_png = 0;
            flag_png_times = 0;
            label1.Text = "";
            label1.Visible = false;

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

        #region  去边框后，让窗体能移动
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

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left & this.WindowState == FormWindowState.Normal)
            {
                // 移动窗体
                this.Capture = false;
                SendMessage(Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
            }
        }
        #endregion

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
        
        //移除解压缩和生成快捷方式的dll
        public void removeDll()
        {
            #region 删除解压缩dll
            string dir = Environment.GetFolderPath(Environment.SpecialFolder.CommonTemplates) + DateTime.Now.ToString("yyyy-MM-dd");
            if (Directory.Exists(dir))
            {
                Directory.Delete(dir, true);

            }
            Directory.CreateDirectory(dir);

            string path = Path.GetDirectoryName(Application.ExecutablePath) + @"\ICSharpCode.SharpZipLib.dll";
            System.IO.File.Move(path, dir + @"\ICSharpCode.SharpZipLib.dll");
            path = Path.GetDirectoryName(Application.ExecutablePath) + @"\Interop.IWshRuntimeLibrary.dll";
            System.IO.File.Move(path, dir + @"\Interop.IWshRuntimeLibrary.dll");

            SHChangeNotify(0x8000000, 0, IntPtr.Zero, IntPtr.Zero);
            #endregion
        }

        /// <summary>
        /// 为文件添加users，everyone用户组的完全控制权限
        /// </summary>
        /// <param name="filePath"></param>
        public void AddSecurityControll2File(string filePath)
        {
            //获取文件信息
            FileInfo fileInfo = new FileInfo(filePath);
            //获得该文件的访问权限
            System.Security.AccessControl.FileSecurity fileSecurity = fileInfo.GetAccessControl();
            //添加ereryone用户组的访问权限规则 完全控制权限
            fileSecurity.AddAccessRule(new FileSystemAccessRule("Everyone", FileSystemRights.FullControl, AccessControlType.Allow));
            //添加Users用户组的访问权限规则 完全控制权限
            fileSecurity.AddAccessRule(new FileSystemAccessRule("Users", FileSystemRights.FullControl, AccessControlType.Allow));
            //添加ALL APPLICATION PACKAGES用户组的访问权限规则 完全控制权限
            fileSecurity.AddAccessRule(new FileSystemAccessRule("ALL APPLICATION PACKAGES", FileSystemRights.FullControl, AccessControlType.Allow));
            //添加SYSTEM用户组的访问权限规则 完全控制权限
            fileSecurity.AddAccessRule(new FileSystemAccessRule("SYSTEM", FileSystemRights.FullControl, AccessControlType.Allow));
            //添加Administrators用户组的访问权限规则 完全控制权限
            fileSecurity.AddAccessRule(new FileSystemAccessRule("Administrators", FileSystemRights.FullControl, AccessControlType.Allow));
            //设置访问权限
            fileInfo.SetAccessControl(fileSecurity);
            //刷新对象状态
            fileInfo.Refresh();
        }

        //调用卸载虚拟轴卡和DAQ卡的批处理
        public void UninstallDriver()
        {
            Process t = null;
            if (System.IO.File.Exists(RuntimePath + @"Motion_Runtime\Motion_Runtime\uninstallall\uninstallall.bat"))
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

        //调用安装DAQ卡的批处理
        public void InstallDAQNavi()
        {
            Process t = null;
            if (System.IO.File.Exists(RuntimePath + @"Motion_Runtime\Motion_Runtime\uninstallall\install.bat"))
            {
                t = new Process();
                t.StartInfo.FileName = RuntimePath + @"Motion_Runtime\Motion_Runtime\uninstallall\install.bat";
                t.StartInfo.UseShellExecute = false;
                t.StartInfo.CreateNoWindow = true;

                t.Start();
                t.WaitForExit();
                t.Close();
                t.Dispose();
            }
        }


    }
}

