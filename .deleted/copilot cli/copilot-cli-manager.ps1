#Requires -RunAsAdministrator

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "GitHub Copilot CLI Context Menu Manager" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Check if context menu entries already exist
$installed = Test-Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI"

if ($installed) {
    Write-Host "Current status: INSTALLED" -ForegroundColor Green
    Write-Host ""
    Write-Host "[1] Uninstall context menu entries"
    Write-Host "[2] Cancel"
    Write-Host ""
    $choice = Read-Host "Enter your choice"
    
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "Removing context menu entries..." -ForegroundColor Yellow
        
        # Remove background context menu
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Remove folder context menu
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Remove drive context menu
        Remove-Item "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" -Recurse -Force -ErrorAction SilentlyContinue
        
        # Remove desktop shortcut
        $shortcutPath = "$env:USERPROFILE\Desktop\GitHub Copilot CLI.lnk"
        if (Test-Path $shortcutPath) {
            Remove-Item $shortcutPath -Force
            Write-Host "Desktop shortcut removed." -ForegroundColor Green
        }
        
        # Remove launcher script
        $launcherBat = "$env:ProgramData\GitHubCopilotCLI\launch_copilot.bat"
        $launcherPs1 = "$env:ProgramData\GitHubCopilotCLI\launch_copilot.ps1"
        if (Test-Path $launcherBat) {
            Remove-Item $launcherBat -Force
        }
        if (Test-Path $launcherPs1) {
            Remove-Item $launcherPs1 -Force
        }
        if (Test-Path "$env:ProgramData\GitHubCopilotCLI") {
            Remove-Item "$env:ProgramData\GitHubCopilotCLI" -Recurse -Force
        }
        
        Write-Host ""
        Write-Host "Context menu entries removed successfully!" -ForegroundColor Green
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit
    } else {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    }
}

Write-Host "Current status: NOT INSTALLED" -ForegroundColor Yellow
Write-Host ""
Write-Host "Checking GitHub Copilot CLI installation..." -ForegroundColor Cyan
Write-Host ""

# Check if copilot command is available
$copilotCmd = Get-Command copilot -ErrorAction SilentlyContinue
if ($copilotCmd) {
    Write-Host "[OK] GitHub Copilot CLI found!" -ForegroundColor Green
    Write-Host "Location: $($copilotCmd.Source)" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "[WARNING] GitHub Copilot CLI 'copilot' command not found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install it using npm:"
    Write-Host "  npm install -g @github/copilot" -ForegroundColor White
    Write-Host ""
    Write-Host "Or visit: https://github.com/github/copilot-cli"
    Write-Host ""
    $installCopilot = Read-Host "Would you like to install it now using npm? (y/n)"
    
    if ($installCopilot -ieq "y") {
        $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
        if (-not $npmCmd) {
            Write-Host ""
            Write-Host "ERROR: npm not found! Please install Node.js first from: https://nodejs.org/" -ForegroundColor Red
            Write-Host ""
            Read-Host "Press Enter to exit"
            exit
        }
        
        Write-Host ""
        Write-Host "Installing GitHub Copilot CLI..." -ForegroundColor Cyan
        npm install -g @github/copilot
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host ""
            Write-Host "Failed to install GitHub Copilot CLI. Please try manually." -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit
        }
        
        Write-Host ""
        Write-Host "GitHub Copilot CLI installed successfully!" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "Installation cancelled. Please install manually before continuing." -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    }
}

Write-Host ""
Write-Host "[1] Install context menu entries and desktop shortcut"
Write-Host "[2] Cancel"
Write-Host ""
$choice = Read-Host "Enter your choice"

if ($choice -ne "1") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host ""
Write-Host "Installing context menu entries..." -ForegroundColor Cyan

# Create launcher script directory
$scriptDir = "$env:ProgramData\GitHubCopilotCLI"
if (-not (Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
}

# Create launcher batch script (for cmd.exe compatibility)
$scriptPath = "$scriptDir\launch_copilot.bat"
$launcherScript = @'
@echo off
if "%~1"=="" (
    cd /d "%USERPROFILE%"
) else (
    cd /d "%~1"
)
title GitHub Copilot CLI - %CD%
cls
echo ====================================
echo GitHub Copilot CLI
echo Current directory: %CD%
echo ====================================
echo.
copilot
'@
Set-Content -Path $scriptPath -Value $launcherScript -Encoding ASCII

# Add context menu for folder background
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" -Name "(Default)" -Value "Open GitHub Copilot CLI here"
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI" -Name "Icon" -Value "cmd.exe,0" -Force | Out-Null
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI\command" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\GitHubCopilotCLI\command" -Name "(Default)" -Value "cmd.exe /k `"call `"$scriptPath`" `"%V`"`""

# Add context menu for folders
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" -Name "(Default)" -Value "Open GitHub Copilot CLI here"
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI" -Name "Icon" -Value "cmd.exe,0" -Force | Out-Null
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI\command" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\GitHubCopilotCLI\command" -Name "(Default)" -Value "cmd.exe /k `"call `"$scriptPath`" `"%1`"`""

# Add context menu for drives
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" -Name "(Default)" -Value "Open GitHub Copilot CLI here"
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI" -Name "Icon" -Value "cmd.exe,0" -Force | Out-Null
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI\command" -Force | Out-Null
Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Drive\shell\GitHubCopilotCLI\command" -Name "(Default)" -Value "cmd.exe /k `"call `"$scriptPath`" `"%1`"`""

# Create desktop shortcut
Write-Host "Creating desktop shortcut..." -ForegroundColor Cyan
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\GitHub Copilot CLI.lnk")
$Shortcut.TargetPath = "cmd.exe"
$Shortcut.Arguments = "/k `"call `"$scriptPath`" `"`""
$Shortcut.WorkingDirectory = $env:USERPROFILE
$Shortcut.IconLocation = "cmd.exe,0"
$Shortcut.Description = "Open GitHub Copilot CLI"
$Shortcut.Save()

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""
Write-Host "Desktop shortcut created: GitHub Copilot CLI.lnk" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now:" -ForegroundColor White
Write-Host "- Right-click in any folder and select 'Open GitHub Copilot CLI here'"
Write-Host "- Right-click on any folder/drive and select 'Open GitHub Copilot CLI here'"
Write-Host "- Double-click the desktop shortcut to open Copilot CLI"
Write-Host ""
Write-Host "IMPORTANT: On first launch, you may need to authenticate." -ForegroundColor Yellow
Write-Host "Use the /login command in the Copilot CLI to authenticate." -ForegroundColor Yellow
Write-Host ""
Write-Host "To uninstall, run this script again." -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to exit"
