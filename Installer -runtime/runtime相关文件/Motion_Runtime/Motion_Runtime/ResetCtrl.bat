@echo off 
%systemroot%\system32\taskkill /f /im Motion_Runtime.exe
 
ping -n 3 127.0.0.1>nul
start Motion_Runtime.exe