@echo off
pushd %cd%

set RomdiskName=romdisk

set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

set Runner=%ScriptPath%\..\dreamsdk-runner.exe
if not exist %Runner% goto error_runner

set WorkingPath=%1
if "%WorkingPath%"=="" goto error_working_path
if not exist %WorkingPath% goto error_working_path

cd /D %WorkingPath%
%Runner% /opt/toolchains/dc/kos/utils/genromfs/genromfs -f %RomdiskName%.img -d %RomdiskName% -v -x .svn
%Runner% /opt/toolchains/dc/kos/utils/bin2o/bin2o %RomdiskName%.img %RomdiskName% %RomdiskName%.o
goto end

:usage
echo Usage: %~n0 ^<ProjectPath^>
goto end

:error_runner
echo DreamSDK Runner is not available...
echo Have you moved %~n0 elsewhere?
goto end

:error_working_path
goto usage

:end
popd
