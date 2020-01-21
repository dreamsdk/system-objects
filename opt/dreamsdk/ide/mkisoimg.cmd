@echo off
pushd %cd%

set VirtualCompactDiscName=cd_root
set VirtualCompactDiscLabel=CDFS

set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

set MakeIsoFileSystem=%ScriptPath%\..\addons\mkisofs.exe
if not exist %MakeIsoFileSystem% goto error_mkisofs

set DirHash=%ScriptPath%\..\helpers\dirhash.exe
if not exist %DirHash% goto error_dirhash

rem Project path
set ProjectPath=%1
call :dequote ProjectPath
if "%ProjectPath%"=="" goto error_params
if not exist "%ProjectPath%" goto error_params

rem Object path
set ObjectBinaryPath=%2
call :dequote ObjectBinaryPath
set ObjectPath=%ProjectPath%%ObjectBinaryPath%
if "%ObjectPath%"=="" goto error_params
if not exist "%ObjectPath%" mkdir "%ObjectPath%"

rem CDFS files
set VirtualCompactDiscImageFile=%VirtualCompactDiscName%.iso
set VirtualCompactDiscHash=%VirtualCompactDiscName%.hash

cd /D "%ProjectPath%"

rem check if generation is necessary
%DirHash% %VirtualCompactDiscName% -nowait -quiet > %VirtualCompactDiscHash%
set /p VirtualCompactDiscCurrentHash=<%VirtualCompactDiscHash%

set VirtualCompactDiscPreviousHash=
if exist "%ObjectPath%%VirtualCompactDiscHash%" set /p VirtualCompactDiscPreviousHash=<"%ObjectPath%%VirtualCompactDiscHash%"

rem check romdisk hash
if "%VirtualCompactDiscCurrentHash%"=="%VirtualCompactDiscPreviousHash%" goto no_action_needed
goto genisofs

:genisofs
if not exist %VirtualCompactDiscName% goto error_source
%MakeIsoFileSystem% -V %VirtualCompactDiscLabel% -l -o %VirtualCompactDiscImageFile% %VirtualCompactDiscName%
goto finalize

:finalize
if exist %VirtualCompactDiscImageFile% move %VirtualCompactDiscImageFile% "%ObjectPath%" > nul
if exist %VirtualCompactDiscHash% move %VirtualCompactDiscHash% "%ObjectPath%" > nul
goto end

:no_action_needed
if exist %VirtualCompactDiscHash% del %VirtualCompactDiscHash%
goto end

:usage
echo Usage: %~n0 ^<ProjectPath^> ^<ObjectPath^>
goto end

:error_mkisofs
echo Make ISO File System – ISO9660 image generator (mkisofs) is not available.
echo Have you moved %~n0 elsewhere or do you have disabled the installation of this
echo component during the installation?
goto end

:error_dirhash
echo DirHash was not found...
echo Have you moved %~n0 elsewhere?
goto end

:error_params
goto usage

:error_genromfs
echo Unable to generate the ISO9660 image file!
cmd /c exit /b 1
goto end

:error_source
echo The source directory was not found!
cmd /c exit /b 1
goto end

:end
popd
goto :eof

rem Thanks: https://ss64.com/nt/syntax-dequote.html
:dequote
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
goto :eof
