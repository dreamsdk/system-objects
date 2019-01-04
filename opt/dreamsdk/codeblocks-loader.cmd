@echo off
taskkill /im dc-tool-ser.exe /f > nul 2> nul
taskkill /im dc-tool-ip.exe /f > nul 2> nul
dreamsdk-runner dc-tool %*
pause
