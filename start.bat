@echo off
title Obaid Weds Samra - Wedding Website
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo.
  echo  Node.js is not installed on this laptop.
  echo  Please install it from https://nodejs.org  ^(choose the LTS version^),
  echo  then double-click this file again.
  echo.
  pause
  exit /b 1
)

echo Starting the wedding website...
start "" "http://localhost:3000"
node server.js
pause
