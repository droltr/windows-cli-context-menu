@echo off
REM Convenience batch file to run the PowerShell installation script with admin privileges

echo ========================================
echo AI Tools Context Menu - Installer
echo ========================================
echo.
echo This will install AI tools to your Windows context menu.
echo You will be prompted for Administrator privileges.
echo.
pause

REM Request admin privileges and run the PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0install-context-menu.ps1""' -Verb RunAs}"

echo.
echo Installation script has been launched.
echo Check the PowerShell window for results.
echo.
pause
