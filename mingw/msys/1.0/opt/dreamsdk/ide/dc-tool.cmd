@echo off
cls

set Title=Dreamcast Tool
title %Title%

rem Initial configuration
set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%
set DreamcastToolPath=%ScriptPath%\..\..\toolchains\dc\bin
set ConfigurationFile=%ScriptPath%\..\..\..\etc\dreamsdk\dc-tool.conf
set HelpersDirectory=%ScriptPath%\..\helpers
set FastPing=%HelpersDirectory%\fastping.exe
set FastARP=%HelpersDirectory%\fastarp.exe

if not exist %FastARP% goto err_fastarp
if not exist %FastPing% goto err_fastping

rem Read Configuration
for /F "tokens=*" %%i in (%ConfigurationFile%) do (
	set %%i 2> nul
)

rem Sanitize configuration entries
call :trim Kind
call :trim Executable
call :trim CommandLine
call :trim MediaAccessControlEnabled
call :trim HostMediaAccessControlAddress
call :trim InternetProtocolAddress
call :trim MediaAccessControlAddress

rem Loader is undefined in the options
if "%Kind%"=="0" goto loader_undefined

rem This is a custom command...
if "%Kind%"=="3" goto run_loader_custom

rem Compute the real Dreamcast Tool filename location
rem In case of Serial/IP (Kind=1 or 2)
set DreamcastTool=%DreamcastToolPath%\%Executable%.exe
if not exist %DreamcastTool% goto loader_undefined

rem Check if we use ARP
if "%MediaAccessControlEnabled%"=="1" goto check_connectivity
goto run_loader

:check_connectivity
%FastPing% %InternetProtocolAddress%
if errorlevel 1 goto check_uac_status
goto run_loader

:check_uac_status
set is_uac_enabled=0
for /f "tokens=1" %%a in ('reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\ /v EnableLUA 2^> nul ^| find "0x1"') do (
set is_uac_enabled=1
)
if "%is_uac_enabled%"=="1" goto exec_arp_uac
goto exec_arp

:exec_arp_uac
echo Please confirm UAC to allow the ARP entry addition...
goto exec_arp

:exec_arp
%FastARP% %HostMediaAccessControlAddress% %InternetProtocolAddress% %MediaAccessControlAddress%
goto run_loader

:run_loader
%DreamcastTool% %CommandLine% %*
goto end

:run_loader_custom
%Executable% %CommandLine% %*
goto end

:loader_undefined
echo Dreamcast Tool (dc-tool) is not configured.
echo Please run DreamSDK Manager to do the configuration.
goto end

:err_fastarp
echo FastARP not found.
goto err_not_found

:err_fastping
echo FastPing not found.
goto err_not_found

:err_not_found
echo Did you move dc-tool elsewhere?
goto end

:end
pause
goto :EOF

:trim
rem Thanks to: https://stackoverflow.com/a/19686956/3726096
setlocal EnableDelayedExpansion
call :trimsub %%%1%%
endlocal & set %1=%tempvar%
goto :EOF

:trimsub
set tempvar=%*
goto :EOF
