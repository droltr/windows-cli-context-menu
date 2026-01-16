# Git Context Menu Installation Script
# Run this script as Administrator

# Requires Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges!"
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
    pause
    exit
}

# Get the directory where this script is located
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$iconPath = Join-Path $scriptPath "git-logo.ico"

# Check if icon file exists
if (-not (Test-Path $iconPath)) {
    Write-Warning "Icon file not found: $iconPath"
    Write-Host "The menu will be created without icons." -ForegroundColor Yellow
    $iconPath = $null
}

Write-Host "Installing Git Context Menu..." -ForegroundColor Green

# Registry base path
$basePath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell"

# Create main Git menu
$gitMenuPath = "$basePath\GitMenu"
New-Item -Path $gitMenuPath -Force | Out-Null
Set-ItemProperty -Path $gitMenuPath -Name "MUIVerb" -Value "Git"
Set-ItemProperty -Path $gitMenuPath -Name "ExtendedSubCommandsKey" -Value "Directory\\Background\\shell\\GitMenu"
if ($iconPath) {
    Set-ItemProperty -Path $gitMenuPath -Name "Icon" -Value $iconPath
}

Write-Host "  Created main Git menu" -ForegroundColor Cyan

# Create Shell subfolder for submenus
$shellPath = "$gitMenuPath\shell"
New-Item -Path $shellPath -Force | Out-Null

# Git Init submenu
$initPath = "$shellPath\GitInit"
New-Item -Path $initPath -Force | Out-Null
Set-ItemProperty -Path $initPath -Name "(Default)" -Value "Init"
Set-ItemProperty -Path $initPath -Name "MUIVerb" -Value "Init"
if ($iconPath) {
    Set-ItemProperty -Path $initPath -Name "Icon" -Value $iconPath
}

$initCommandPath = "$initPath\command"
New-Item -Path $initCommandPath -Force | Out-Null
Set-ItemProperty -Path $initCommandPath -Name "(Default)" -Value 'cmd.exe /c "cd /d "%V" && git init && pause"'

Write-Host "  Created Git Init submenu" -ForegroundColor Cyan

# Git Commit submenu
$commitPath = "$shellPath\GitCommit"
New-Item -Path $commitPath -Force | Out-Null
Set-ItemProperty -Path $commitPath -Name "(Default)" -Value "Commit"
Set-ItemProperty -Path $commitPath -Name "MUIVerb" -Value "Commit"
if ($iconPath) {
    Set-ItemProperty -Path $commitPath -Name "Icon" -Value $iconPath
}

$commitCommandPath = "$commitPath\command"
New-Item -Path $commitCommandPath -Force | Out-Null
Set-ItemProperty -Path $commitCommandPath -Name "(Default)" -Value 'cmd.exe /c "cd /d "%V" && git add -A && git commit && pause"'

Write-Host "  Created Git Commit submenu" -ForegroundColor Cyan

# Git Commit -m submenu
$commitMPath = "$shellPath\GitCommitM"
New-Item -Path $commitMPath -Force | Out-Null
Set-ItemProperty -Path $commitMPath -Name "(Default)" -Value "Commit -m"
Set-ItemProperty -Path $commitMPath -Name "MUIVerb" -Value "Commit -m"
if ($iconPath) {
    Set-ItemProperty -Path $commitMPath -Name "Icon" -Value $iconPath
}

$commitMCommandPath = "$commitMPath\command"
New-Item -Path $commitMCommandPath -Force | Out-Null
Set-ItemProperty -Path $commitMCommandPath -Name "(Default)" -Value 'cmd.exe /c "cd /d "%V" && set /p msg="Commit message: " && git add -A && git commit -m "!msg!" && pause"'

Write-Host "  Created Git Commit -m submenu" -ForegroundColor Cyan

Write-Host ""
Write-Host "Git Context Menu installed successfully!" -ForegroundColor Green
Write-Host "Right-click on any folder background to access the Git menu." -ForegroundColor Yellow
Write-Host ""
pause
