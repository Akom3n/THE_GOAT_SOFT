@echo off
rem Double-click this file to start the site on Windows.
cd /d "%~dp0"

rem For the real chatbot, remove "rem" below and paste your Claude API key (console.anthropic.com).
rem set ANTHROPIC_API_KEY=your-key
rem Or use Google Gemini instead: remove "rem" below and paste a key from aistudio.google.com.
rem set GOOGLE_API_KEY=your-key

rem Optional: for the studio male voice, remove "rem" below and paste your Azure Speech key.
rem set AZURE_SPEECH_KEY=your-key
rem set AZURE_SPEECH_REGION=westeurope

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is not installed. Get it from https://nodejs.org and run this file again.
  pause
  exit /b 1
)

echo Starting the library. Keep this window open; close it to stop the server.
start "" /b cmd /c "timeout /t 2 /nobreak >nul & start http://localhost:3000"
node server.js
pause
