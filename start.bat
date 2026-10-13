@echo off
setlocal
title Obaid Weds Samra - Wedding Website
cd /d "%~dp0"

echo.
echo  ===============================================
echo    Obaid ^& Samra - Wedding Invitation Website
echo  ===============================================
echo.

set "NODE_EXE="
where node >nul 2>nul && set "NODE_EXE=node"
if not defined NODE_EXE if exist "%ProgramFiles%\nodejs\node.exe" set "NODE_EXE=%ProgramFiles%\nodejs\node.exe"

if not defined NODE_EXE (
  echo  Node.js is needed to run the site. Installing it automatically...
  echo  ^(one time only, about a minute - click Yes if Windows asks permission^)
  echo.
  where winget >nul 2>nul
  if errorlevel 1 (
    echo  Automatic install is not available on this PC.
    echo  Please install "LTS" from https://nodejs.org and then double-click this file again.
    start "" "https://nodejs.org"
    echo.
    pause
    exit /b 1
  )
  winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
  if exist "%ProgramFiles%\nodejs\node.exe" set "NODE_EXE=%ProgramFiles%\nodejs\node.exe"
)

if not defined NODE_EXE (
  echo.
  echo  Node.js was installed but this window cannot see it yet.
  echo  Please close this window and double-click start.bat once more.
  echo.
  pause
  exit /b 1
)

echo  Starting the website...
echo.
start "" cmd /c "timeout /t 2 /nobreak >nul & start http://localhost:3000"
"%NODE_EXE%" server.js
echo.
pause
