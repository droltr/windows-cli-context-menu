#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Installs AI tools context menu entries for Windows Explorer using a plugin system.

.DESCRIPTION
    This script adds a context menu structure to Windows Explorer.
    It dynamically loads tool configurations from the 'tools/' directory.
    It also cleans up legacy "CLI Tools" menu entries.
#>

param (
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$toolsDir = Join-Path $scriptDir "tools"

# --- Helper Functions ---

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-RegistryKey {
    param([string]$Path)
    return (Test-Path -Path $Path)
}

function New-RegistryKeySafe {
    param([string]$Path, [switch]$Force)
    try {
        if (-not (Test-RegistryKey $Path)) {
            New-Item -Path $Path -Force:$Force -ErrorAction Stop | Out-Null
            return $true
        }
        return $true # Exists
    }
    catch {
        Write-ColorOutput "  [Error] Creating key '$Path': $_" "Red"
        return $false
    }
}

function Set-RegistryValueSafe {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [string]$PropertyType = "String"
    )
    try {
        # Ensure value is treated as string for paths
        $val = "$Value"
        Set-ItemProperty -Path $Path -Name $Name -Value $val -Type $PropertyType -ErrorAction Stop
        return $true
    }
    catch {
        Write-ColorOutput "  [Error] Setting '$Name' in '$Path': $_" "Red"
        return $false
    }
}

function Remove-LegacyMenu {
    Write-ColorOutput "Checking for legacy menus..." "Gray"
    $legacyPaths = @(
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\CLITools",
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\CLITools",
        "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\CLITools",
        "Registry::HKEY_CLASSES_ROOT\Directory\shell\CLITools"
    )

    foreach ($path in $legacyPaths) {
        if (Test-Path $path) {
            try {
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                Write-ColorOutput "  Removed legacy key: $path" "Green"
            } catch {
                Write-ColorOutput "  [Warning] Failed to remove legacy key '$path': $_" "Yellow"
            }
        }
    }
}

function Test-CommandAvailability {
    param([string]$CommandName)
    if (-not $CommandName) { return $true } # Skip if no command to check
    return (Get-Command $CommandName -ErrorAction SilentlyContinue)
}

function Get-ToolPlugins {
    $plugins = @()
    if (-not (Test-Path $toolsDir)) {
        Write-ColorOutput "Tools directory not found at $toolsDir" "Red"
        return $plugins
    }

    $toolFolders = Get-ChildItem -Path $toolsDir -Directory
    foreach ($folder in $toolFolders) {
        $configFile = Join-Path $folder.FullName "tool.conf.ps1"
        if (Test-Path $configFile) {
            try {
                # Safe load of hashtable
                $config = Import-PowerShellDataFile -Path $configFile
                
                # Resolve Icon Path
                if ($config.Icon) {
                    $iconPath = Join-Path $folder.FullName $config.Icon
                    if (Test-Path $iconPath) {
                        $config.Icon = $iconPath
                    } else {
                        # Check if it looks like a system icon (dll,index)
                        if ($config.Icon -notmatch ",") {
                            # If local file missing, fallback to shell32 generic
                            $config.Icon = "shell32.dll,29" # Generic shortcut icon
                            Write-ColorOutput "  [Info] Icon file missing for $($config.Name), using default." "DarkGray"
                        }
                    }
                }
                
                $plugins += $config
            }
            catch {
                Write-ColorOutput "  [Warning] Failed to load config for $($folder.Name): $_" "Yellow"
            }
        }
    }
    return $plugins
}

function Get-PreferredPowerShell {
    if (Get-Command "pwsh" -ErrorAction SilentlyContinue) {
        return "pwsh"
    }
    return "powershell.exe"
}

function Add-ContextMenuItem {
    param(
        [string]$BasePath,
        [hashtable]$Tool
    )

    $safeName = $Tool.Name -replace '[^a-zA-Z0-9]', ''
    $menuKeyPath = "$BasePath\AI_Menu\shell\$safeName"
    $commandKeyPath = "$menuKeyPath\command"

    # Verify command availability
    if ($Tool.Command) {
        if (-not (Test-CommandAvailability $Tool.Command)) {
            Write-ColorOutput "  [Warning] Tool '$($Tool.Command)' not found in PATH. Entry will be created but might not work." "Yellow"
        }
    }

    $ok = New-RegistryKeySafe -Path $menuKeyPath -Force
    if (-not $ok) { return $false }

    $ok = Set-RegistryValueSafe -Path $menuKeyPath -Name "(Default)" -Value $Tool.Name
    if ($Tool.Icon) {
        Set-RegistryValueSafe -Path $menuKeyPath -Name "Icon" -Value $Tool.Icon | Out-Null
    }

    $ok = New-RegistryKeySafe -Path $commandKeyPath -Force
    if (-not $ok) { return $false }

    # Resolve Shell Command (Auto-detect if configured as 'powershell.exe')
    $shellCmd = $Tool.ShellCommand
    if ($shellCmd -eq "powershell.exe") {
        $shellCmd = Get-PreferredPowerShell
    }

    $fullCommand = "`"$shellCmd`" $($Tool.Arguments)"
    Set-RegistryValueSafe -Path $commandKeyPath -Name "(Default)" -Value $fullCommand | Out-Null
    
    return $true
}

function Remove-ContextMenuItem {
    param([string]$BasePath)
    $aiMenuPath = "$BasePath\AI_Menu"
    if (Test-RegistryKey $aiMenuPath) {
        try {
            Remove-Item -Path $aiMenuPath -Recurse -Force -ErrorAction Stop
            return $true
        } catch {
            Write-ColorOutput "  [Error] Removing key '$aiMenuPath': $_" "Red"
            return $false
        }
    }
    return $true
}

# --- Main Execution ---

# Registry paths
$registryPaths = @{
    FolderBackground = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell"
    Folder           = "Registry::HKEY_CLASSES_ROOT\Directory\shell"
    Drive            = "Registry::HKEY_CLASSES_ROOT\Drive\shell"
}

# Admin Check
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-ColorOutput "ERROR: Run as Administrator required." "Red"
    exit 1
}

Write-ColorOutput "`n=== AI Context Menu Manager ===" "Cyan"

if ($Uninstall) {
    Write-ColorOutput "Uninstalling..." "Yellow"
    
    # Remove Legacy
    Remove-LegacyMenu

    foreach ($pathType in $registryPaths.Keys) {
        $basePath = $registryPaths[$pathType]
        if (Remove-ContextMenuItem -BasePath $basePath) {
            Write-ColorOutput "  Removed from $pathType" "Green"
        }
    }
    Write-ColorOutput "Uninstallation Complete.`n" "Cyan"
    exit 0
}

# Install Mode
Write-ColorOutput "Scanning for tools in '$toolsDir'..." "Gray"
$plugins = Get-ToolPlugins
Write-ColorOutput "Found $($plugins.Count) tools." "Green"

# Remove Legacy first to clean up
Remove-LegacyMenu

foreach ($pathType in $registryPaths.Keys) {
    $basePath = $registryPaths[$pathType]
    Write-ColorOutput "`nProcessing: $pathType" "Green"

    $aiMenuPath = "$basePath\AI_Menu"
    New-RegistryKeySafe -Path $aiMenuPath -Force | Out-Null
    Set-RegistryValueSafe -Path $aiMenuPath -Name "MUIVerb" -Value "AI Tools" | Out-Null
    Set-RegistryValueSafe -Path $aiMenuPath -Name "SubCommands" -Value "" | Out-Null
    
    # Using a standard system icon for the main menu if 23 is weird
    # shell32.dll,305 is often a 'Launch' or 'App' icon. Let's stick to 23 (Help/Question) if intended,
    # or use imageres.dll,104 (Process). Let's try shell32.dll,43 (Star/Favorites)
    Set-RegistryValueSafe -Path $aiMenuPath -Name "Icon" -Value "shell32.dll,43" | Out-Null

    $shellPath = "$aiMenuPath\shell"
    New-RegistryKeySafe -Path $shellPath -Force | Out-Null

    foreach ($tool in $plugins) {
        Write-ColorOutput "  Adding: $($tool.Name)" "Gray"
        Add-ContextMenuItem -BasePath $basePath -Tool $tool | Out-Null
    }
}

Write-ColorOutput "`nInstallation Complete!" "Cyan"