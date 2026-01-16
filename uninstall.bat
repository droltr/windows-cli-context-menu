@echo off
REM Convenience batch file to run the PowerShell uninstallation script with admin privileges

echo ========================================
echo AI Tools Context Menu - Uninstaller
echo ========================================
echo.
echo This will remove AI tools from your Windows context menu.
echo You will be prompted for Administrator privileges.
echo.
pause

REM Request admin privileges and run the PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0uninstall-context-menu.ps1""' -Verb RunAs}"

echo.
echo Uninstallation script has been launched.
echo Check the PowerShell window for results.
echo.
pause
