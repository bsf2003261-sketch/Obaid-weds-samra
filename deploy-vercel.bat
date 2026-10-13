@echo off
setlocal
title Publish Obaid Weds Samra to Vercel
cd /d "%~dp0"

echo.
echo  ===============================================
echo    Publish the invitation to Vercel (free link)
echo  ===============================================
echo.

set "NODE_DIR="
where node >nul 2>nul || (
  if exist "%ProgramFiles%\nodejs\node.exe" (set "PATH=%ProgramFiles%\nodejs;%PATH%") else (
    echo  Node.js is not installed yet. Please double-click start.bat first ^(it installs Node.js^),
    echo  then run this file again.
    echo.
    pause
    exit /b 1
  )
)

echo  Step 1 of 2: sign in to Vercel. A browser page opens - log in or create a free account.
echo.
call npx --yes vercel@latest login
if errorlevel 1 (
  echo.
  echo  Sign-in did not finish. Run this file again to retry.
  pause
  exit /b 1
)

echo.
echo  Step 2 of 2: publishing...
echo.
call npx --yes vercel@latest --prod --yes --scope shahzaib-cfeb
echo.
echo  If it worked, your live link is printed above (it ends with .vercel.app).
echo  To update the site later, change public\js\config.js and run this file again.
echo.
pause
