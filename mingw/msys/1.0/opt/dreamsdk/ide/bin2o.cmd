@echo off
pushd %cd%

set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

set Runner=%ScriptPath%\..\dreamsdk-runner.exe
if not exist %Runner% goto error_runner

set DirHash=%ScriptPath%\..\helpers\dirhash.exe
if not exist %DirHash% goto error_dirhash

set ProjectPath=%1
call :dequote ProjectPath
if "%ProjectPath%"=="" goto error_params
if not exist "%ProjectPath%" goto error_params

set ObjectBinaryPath=%2
call :dequote ObjectBinaryPath

set ObjectPath=%ProjectPath%%ObjectBinaryPath%
if "%ObjectPath%"=="" goto error_params
if not exist "%ObjectPath%" mkdir "%ObjectPath%"

set OutputBinaryFile=%3
call :dequote OutputBinaryFile
if not "%OutputBinaryFile%"=="" set OutputBinaryFile="%ProjectPath%%OutputBinaryFile%"

set ObjectName=%4
if "%ObjectName%"=="" goto error_params

set ObjectInput=%ObjectName%.bin
set ObjectOutput=%ObjectName%.o
set ObjectHash=%ObjectName%.hash

cd /D "%ProjectPath%"

if not exist %ObjectInput% goto error_object_input

rem check if generation is necessary
%DirHash% %ObjectInput% -nowait -quiet > %ObjectHash%
set /p ObjectCurrentHash=<%ObjectHash%

set ObjectPreviousHash=
set ObjectPreviousHashFile=%ObjectPath%%ObjectHash%
if exist "%ObjectPreviousHashFile%" set /p ObjectPreviousHash=<"%ObjectPreviousHashFile%"

rem check hash
if "%ObjectCurrentHash%"=="%ObjectPreviousHash%" goto check_romdisk_obj
goto start_generation

:check_romdisk_obj
rem check if the romdisk file exists
if exist "%ObjectPath%\%ObjectOutput%" goto no_action_needed
goto start_generation

rem start romdisk generation
:start_generation
if exist %OutputBinaryFile% del %OutputBinaryFile%
goto bin2o

:bin2o
echo Processing: %ObjectName%
%Runner% /opt/toolchains/dc/kos/utils/bin2o/bin2o %ObjectInput% %ObjectName% %ObjectOutput%
goto finalize

:finalize
if exist %ObjectOutput% move %ObjectOutput% "%ObjectPath%" > nul
if exist %ObjectHash% move %ObjectHash% "%ObjectPath%" > nul
goto end

:no_action_needed
if exist %ObjectHash% del %ObjectHash%
goto end

:usage
echo Usage: %~n0 ^<ProjectPath^> ^<ObjectPath^> ^<OutputBinaryFile^> ^<ObjectName^>
goto end

:error_runner
echo DreamSDK Runner is not available...
echo Have you moved %~n0 elsewhere?
goto end

:error_dirhash
echo DirHash is not available...
echo Have you moved %~n0 elsewhere?
goto end

:error_params
goto usage

:error_object_input
echo The object input file does not exist...
echo File: "%ObjectInput%"
cmd /c exit /b 1
goto end

:end
popd
goto :eof

rem Thanks: https://ss64.com/nt/syntax-dequote.html
:dequote
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
goto :eof
