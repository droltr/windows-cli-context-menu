@echo off
setlocal enabledelayedexpansion

:MAIN_MENU
cls
echo.
echo ============================================================
echo    Windows 11 CLI Context Menu Manager v0.6.0 (Modular)
echo    Created by https://github.com/droltr
echo ============================================================
echo.

reg query "HKCR\Directory\Background\shell\AI_Menu" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] CLI Menu is Installed
    echo.
    echo Options:
    echo   [1] Uninstall Menu
    echo   [2] Reinstall Menu
    echo   [3] Check Tools
    echo   [4] Exit
    echo.
    set /p "choice=Your choice (1-4): "
    
    if "!choice!"=="1" goto UNINSTALL
    if "!choice!"=="2" goto REINSTALL
    if "!choice!"=="3" goto CHECK_TOOLS
    if "!choice!"=="4" goto END
    goto MAIN_MENU
) else (
    echo [!] CLI Menu is Not Installed
    echo.
    echo Options:
    echo   [1] Install Menu
    echo   [2] Check Tools
    echo   [3] Exit
    echo.
    set /p "choice=Your choice (1-3): "
    
    if "!choice!"=="1" goto INSTALL
    if "!choice!"=="2" goto CHECK_TOOLS
    if "!choice!"=="3" goto END
    goto MAIN_MENU
)

:INSTALL
echo.
echo ============================================================
echo Starting installation...
echo.
echo [1/2] Checking/Downloading Icons...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\download_icons.ps1"
echo.
echo [2/2] Registering Context Menu...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-context-menu.ps1"
echo.
pause
goto MAIN_MENU

:UNINSTALL
echo.
echo ============================================================
echo Starting uninstallation...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-context-menu.ps1" -Uninstall
echo.
pause
goto MAIN_MENU

:REINSTALL
echo.
echo ============================================================
echo Uninstalling first...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0install-context-menu.ps1' -Uninstall" 2>nul
timeout /t 2 >nul
echo.
echo Reinstalling now...
echo.
echo [1/2] Checking/Downloading Icons...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\download_icons.ps1"
echo.
echo [2/2] Registering Context Menu...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-context-menu.ps1"
echo.
pause
goto MAIN_MENU

:CHECK_TOOLS
echo.
echo ============================================================
echo Checking CLI Tools (Dynamically Loaded)...
echo ============================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& { $toolsDir = Join-Path '%~dp0' 'tools'; if(-not (Test-Path $toolsDir)) { Write-Error 'Tools directory not found!'; exit 1 }; $tools = Get-ChildItem -Path $toolsDir -Directory; foreach($t in $tools) { $confPath = Join-Path $t.FullName 'tool.conf.ps1'; if(Test-Path $confPath) { $conf = Import-PowerShellDataFile -Path $confPath; $cmd = $conf.Command; if($cmd) { $found = Get-Command $cmd -ErrorAction SilentlyContinue; if($found) { Write-Host ('[OK] {0} ({1}) found at {2}' -f $conf.Name, $cmd, $found.Source) -ForegroundColor Green } else { Write-Host ('[ X] {0} ({1}) not found' -f $conf.Name, $cmd) -ForegroundColor Red } } } } }"
echo.
echo ============================================================
pause
goto MAIN_MENU

:END
echo.
echo Goodbye!
timeout /t 2 >nul
exit /b 0