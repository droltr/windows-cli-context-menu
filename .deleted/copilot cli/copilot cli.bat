@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===================================
echo GitHub Copilot CLI Context Menu Manager
echo ===================================
echo.

:: Check if context menu entries already exist
reg query "HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" >nul 2>&1
if %errorLevel% equ 0 (
    set "INSTALLED=1"
) else (
    set "INSTALLED=0"
)

if !INSTALLED! equ 1 (
    echo Current status: INSTALLED
    echo.
    echo [1] Uninstall context menu entries
    echo [2] Cancel
    echo.
    set /p choice="Enter your choice: "
    
    if "!choice!"=="1" (
        echo.
        echo Removing context menu entries...
        
        :: Remove background context menu
        reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" /f >nul 2>&1
        
        :: Remove folder context menu
        reg delete "HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" /f >nul 2>&1
        
        :: Remove drive context menu
        reg delete "HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" /f >nul 2>&1
        
        :: Remove desktop shortcut
        if exist "%USERPROFILE%\Desktop\GitHub Copilot CLI.lnk" (
            del "%USERPROFILE%\Desktop\GitHub Copilot CLI.lnk"
            echo Desktop shortcut removed.
        )
        
        :: Remove launcher script
        if exist "%ProgramData%\GitHubCopilotCLI\launch_copilot.bat" (
            del "%ProgramData%\GitHubCopilotCLI\launch_copilot.bat"
        )
        if exist "%ProgramData%\GitHubCopilotCLI" (
            rmdir "%ProgramData%\GitHubCopilotCLI"
        )
        
        echo Context menu entries removed successfully!
        echo.
        pause
        exit /b
    ) else (
        echo Operation cancelled.
        pause
        exit /b
    )
)

echo Current status: NOT INSTALLED
echo.
echo Checking GitHub Copilot CLI installation...
echo.

:: Check if copilot command is available
where copilot >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] GitHub Copilot CLI found!
    for /f "tokens=*" %%i in ('where copilot') do (
        echo Location: %%i
    )
    echo.
) else (
    echo [WARNING] GitHub Copilot CLI 'copilot' command not found!
    echo.
    echo Please install it using npm:
    echo   npm install -g @github/copilot
    echo.
    echo Or visit: https://github.com/github/copilot-cli
    echo.
    set /p install_copilot="Would you like to install it now using npm? (y/n): "
    if /i "!install_copilot!"=="y" (
        where npm >nul 2>&1
        if %errorLevel% neq 0 (
            echo.
            echo ERROR: npm not found! Please install Node.js first from: https://nodejs.org/
            echo.
            pause
            exit /b
        )
        echo.
        echo Installing GitHub Copilot CLI...
        npm install -g @github/copilot
        if %errorLevel% neq 0 (
            echo.
            echo Failed to install GitHub Copilot CLI. Please try manually.
            pause
            exit /b
        )
        echo.
        echo GitHub Copilot CLI installed successfully!
        echo.
    ) else (
        echo.
        echo Installation cancelled. Please install manually before continuing.
        pause
        exit /b
    )
)

echo.
echo [1] Install context menu entries and desktop shortcut
echo [2] Cancel
echo.
set /p choice="Enter your choice: "

if not "!choice!"=="1" (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
echo Installing context menu entries...

:: Create launcher script
set "SCRIPT_PATH=%ProgramData%\GitHubCopilotCLI\launch_copilot.bat"
if not exist "%ProgramData%\GitHubCopilotCLI" mkdir "%ProgramData%\GitHubCopilotCLI"

(
echo @echo off
echo if "%%~1"=="" ^(
echo     cd /d "%%USERPROFILE%%"
echo ^) else ^(
echo     cd /d "%%~1"
echo ^)
echo title GitHub Copilot CLI - %%CD%%
echo cls
echo echo ====================================
echo echo GitHub Copilot CLI
echo echo Current directory: %%CD%%
echo echo ====================================
echo echo.
echo copilot
) > "%SCRIPT_PATH%"

:: Add context menu for folder background
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" /ve /d "Open GitHub Copilot CLI here" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" /v "Icon" /d "cmd.exe,0" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI\command" /ve /d "cmd.exe /k \"call \"%SCRIPT_PATH%\" \"%%V\"\"" /f >nul

:: Add context menu for folders
reg add "HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" /ve /d "Open GitHub Copilot CLI here" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" /v "Icon" /d "cmd.exe,0" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI\command" /ve /d "cmd.exe /k \"call \"%SCRIPT_PATH%\" \"%%1\"\"" /f >nul

:: Add context menu for drives
reg add "HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" /ve /d "Open GitHub Copilot CLI here" /f >nul
reg add "HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" /v "Icon" /d "cmd.exe,0" /f >nul
reg add "HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI\command" /ve /d "cmd.exe /k \"call \"%SCRIPT_PATH%\" \"%%1\"\"" /f >nul

:: Create desktop shortcut using PowerShell
echo Creating desktop shortcut...
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\GitHub Copilot CLI.lnk'); $Shortcut.TargetPath = 'cmd.exe'; $Shortcut.Arguments = '/k \"call \"\"%SCRIPT_PATH%\"\" \"\"\"'; $Shortcut.WorkingDirectory = '%USERPROFILE%'; $Shortcut.IconLocation = 'cmd.exe,0'; $Shortcut.Description = 'Open GitHub Copilot CLI'; $Shortcut.Save()"

echo.
echo ===================================
echo Installation completed successfully!
echo ===================================
echo.
echo Desktop shortcut created: GitHub Copilot CLI.lnk
echo.
echo You can now:
echo - Right-click in any folder and select "Open GitHub Copilot CLI here"
echo - Right-click on any folder/drive and select "Open GitHub Copilot CLI here"
echo - Double-click the desktop shortcut to open Copilot CLI
echo.
echo IMPORTANT: On first launch, you may need to authenticate.
echo Use the /login command in the Copilot CLI to authenticate.
echo.
echo To uninstall, run this script again.
echo.
pause