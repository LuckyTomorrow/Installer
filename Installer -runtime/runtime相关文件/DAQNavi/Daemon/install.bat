
@echo off
:--------------------------------------
:: BatchGetAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    title ���������Թ���Ա�������
    echo ����������ʱ����Ա���Ȩ��...
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
C:\Advantech\DAQNavi\Daemon\daqnavi_daemon.exe Install
 