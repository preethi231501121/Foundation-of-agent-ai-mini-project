@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo [AcademicPilot] Python virtual environment not found.
  echo Run setup_windows.bat first.
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m uvicorn backend.main:app --reload --port 8000
pause
