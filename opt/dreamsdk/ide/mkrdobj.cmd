@echo off
pushd %cd%

set RomdiskName=romdisk

set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

set Runner=%ScriptPath%\..\dreamsdk-runner.exe
if not exist %Runner% goto error_runner

set ProjectPath=%1
if "%ProjectPath%"=="" goto error_params
if not exist %ProjectPath% goto error_params

set ObjectPath=%ProjectPath%\%2
if "%ObjectPath%"=="" goto error_params
if not exist %ObjectPath% goto error_params

set RomdiskImage=%RomdiskName%.img
set RomdiskObject=%RomdiskName%.o
set GenRomFsStackDumpFile=genromfs.exe.stackdump

cd /D %ProjectPath%

rem genromfs
if not exist %RomdiskName% goto error_romdisk
if exist %GenRomFsStackDumpFile% del %GenRomFsStackDumpFile%
%Runner% /opt/toolchains/dc/kos/utils/genromfs/genromfs -f %RomdiskImage% -d %RomdiskName% -v -x .svn -x .git -x .gitkeep -x .keepme
if exist %GenRomFsStackDumpFile% goto error_genromfs

rem bin2o
%Runner% /opt/toolchains/dc/kos/utils/bin2o/bin2o %RomdiskImage% %RomdiskName% %RomdiskObject%

rem finalize
if exist %RomdiskImage% move %RomdiskImage% %ObjectPath% > nul
if exist %RomdiskObject% move %RomdiskObject% %ObjectPath% > nul
goto end

:usage
echo Usage: %~n0 ^<ProjectPath^> ^<ObjectPath^>
goto end

:error_runner
echo DreamSDK Runner is not available...
echo Have you moved %~n0 elsewhere?
goto end

:error_params
goto usage

:error_genromfs
echo genromfs: unable to generate the romdisk file!
cmd /c exit /b 1
goto end

:error_romdisk
echo The romdisk directory was not found!
cmd /c exit /b 2
goto end

:end
popd