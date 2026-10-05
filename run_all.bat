@echo off
cd /d "%~dp0"
start "AcademicPilot Backend" cmd /k call "%~dp0run_backend.bat"
timeout /t 2 /nobreak >nul
start "AcademicPilot Frontend" cmd /k call "%~dp0run_frontend.bat"
timeout /t 3 /nobreak >nul
start "" "http://localhost:5173"
