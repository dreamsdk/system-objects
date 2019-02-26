@echo off
pushd %cd%

set RomdiskName=romdisk

set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

set Runner=%ScriptPath%\..\dreamsdk-runner.exe
if not exist %Runner% goto error_runner

set DirHash=%ScriptPath%\..\helpers\dirhash.exe
if not exist %DirHash% goto error_dirhash

set ProjectPath=%1
if "%ProjectPath%"=="" goto error_params
if not exist %ProjectPath% goto error_params

set ObjectPath=%ProjectPath%%2
if "%ObjectPath%"=="" goto error_params
if not exist %ObjectPath% mkdir %ObjectPath%

set OutputBinaryFile=%3
if not "%OutputBinaryFile%"=="" set OutputBinaryFile=%ProjectPath%%OutputBinaryFile%

set RomdiskImage=%RomdiskName%.img
set RomdiskObject=%RomdiskName%.o
set RomdiskHash=%RomdiskName%.hash
set GenRomFsStackDumpFile=genromfs.exe.stackdump

cd /D %ProjectPath%

rem check if generation is necessary
%DirHash% %RomdiskName% -nowait -quiet > %RomdiskHash%
set /p RomdiskCurrentHash=<%RomdiskHash%

set RomdiskPreviousHash=
if exist %ObjectPath%\%RomdiskHash% set /p RomdiskPreviousHash=<%ObjectPath%\%RomdiskHash%

if "%RomdiskCurrentHash%"=="%RomdiskPreviousHash%" goto no_action_needed

:delete_binary
if exist %OutputBinaryFile% del %OutputBinaryFile%
goto genromfs

:genromfs
if not exist %RomdiskName% goto error_romdisk
if exist %GenRomFsStackDumpFile% del %GenRomFsStackDumpFile%
%Runner% /opt/toolchains/dc/kos/utils/genromfs/genromfs -f %RomdiskImage% -d %RomdiskName% -v -x .svn -x .git -x .gitkeep -x .keepme
if exist %GenRomFsStackDumpFile% goto error_genromfs
goto bin2o

:bin2o
%Runner% /opt/toolchains/dc/kos/utils/bin2o/bin2o %RomdiskImage% %RomdiskName% %RomdiskObject%
goto finalize

:finalize
if exist %RomdiskImage% move %RomdiskImage% %ObjectPath% > nul
if exist %RomdiskObject% move %RomdiskObject% %ObjectPath% > nul
if exist %RomdiskHash% move %RomdiskHash% %ObjectPath% > nul
goto end

:no_action_needed
if exist %RomdiskHash% del %RomdiskHash%
goto end

:usage
echo Usage: %~n0 ^<ProjectPath^> ^<ObjectPath^>
goto end

:error_runner
echo DreamSDK Runner is not available...
echo Have you moved %~n0 elsewhere?
goto end

:error_dirhash
echo DirHash was not found...
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
