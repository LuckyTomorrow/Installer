
@echo off
:--------------------------------------
:: BatchGetAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    title 正在请求以管理员身份运行
    echo 正在请求临时管理员身份权限...
    goto UACPrompt
) else ( goto GetAdmin )
:UACPrompt
if not "%~1"=="" set file= ""%~1""
(echo Set UAC = CreateObject("Shell.Application"^)
echo UAC.ShellExecute "cmd.exe", "/c %~s0%file%", "", "runas", 1)> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:GetAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------
:StartCommand
C:\Advantech\DAQNavi\Daemon\daqnavi_daemon.exe UNInstall
for %%i in (0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f) do (

echo %%i
rem remove pci1245
echo remove pci1245
AdvVirtualMotionCardSvc.exe -UNInstall 0xA700%%i000
rem remove pci1245E
echo remove pci1245E
AdvVirtualMotionCardSvc.exe -UNInstall 0xA900%%i000
rem remove pci1245V
echo remove pci1245V
AdvVirtualMotionCardSvc.exe -UNInstall 0xAC00%%i000
rem remove pci1245L
echo remove pci1245L
AdvVirtualMotionCardSvc.exe -UNInstall 0xAd00%%i000
rem remove pci1265
echo remove pci1265
AdvVirtualMotionCardSvc.exe -UNInstall 0xA800%%i000
rem remove pci1285
echo remove pci1285
AdvVirtualMotionCardSvc.exe -UNInstall 0xAa00%%i000
rem remove pci1285E
echo remove pci1285E
AdvVirtualMotionCardSvc.exe -UNInstall 0xAb00%%i000
rem remove mas324xm
echo remove mas324xm
AdvVirtualMotionCardSvc.exe -UNInstall 0xB400%%i000
rem remove mas328xm
echo remove mas328xm
AdvVirtualMotionCardSvc.exe -UNInstall 0xB500%%i000
)
