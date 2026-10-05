@echo off
setlocal
cd /d "%~dp0"

echo === AcademicPilot AI Windows Setup ===
where py >nul 2>nul
if %errorlevel%==0 (
  set "PY=py"
) else (
  set "PY=python"
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating Python virtual environment...
  %PY% -m venv .venv
)

echo Installing backend dependencies...
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt

if not exist ".env" copy ".env.example" ".env" >nul

set "NODE_DIR=C:\Program Files\nodejs"
if exist "%NODE_DIR%\node.exe" set "PATH=%NODE_DIR%;%PATH%"

if exist "%NODE_DIR%\npm.cmd" (
  set "NPM=%NODE_DIR%\npm.cmd"
) else (
  set "NPM=npm.cmd"
)

echo Installing frontend dependencies...
pushd frontend
call "%NPM%" install
popd

echo.
echo Optional scanned-PDF OCR: install Tesseract OCR if you need image/scanned PDFs.
echo Text PDFs work without Tesseract.
echo.
echo Setup complete.
echo Double-click run_all.bat to start AcademicPilot AI.
pause
endlocal
