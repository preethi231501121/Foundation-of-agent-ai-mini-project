@echo off
cd /d "%~dp0frontend"
set "NODE_DIR=C:\Program Files\nodejs"
if exist "%NODE_DIR%\node.exe" set "PATH=%NODE_DIR%;%PATH%"
if exist "%NODE_DIR%\npm.cmd" (
  call "%NODE_DIR%\npm.cmd" run dev
) else (
  call npm.cmd run dev
)
pause
