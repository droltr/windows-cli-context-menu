#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Installs AI tools context menu entries for Windows Explorer.

.DESCRIPTION
    This script adds a context menu structure to Windows Explorer that provides
    quick access to AI CLI tools. Currently supports Claude CLI.

    The menu appears when right-clicking on:
    - Folder backgrounds (inside a folder)
    - Folders themselves (in Explorer or Desktop)

.NOTES
    - Requires Administrator privileges
    - Modifies Windows Registry
    - Can be easily extended with additional AI tools
#>

# Detect Claude logo path (supports multiple formats)
$scriptDir = $PSScriptRoot
$claudeIconPath = $null

# Check for logo files in order of preference
$possibleIcons = @(
    (Join-Path $scriptDir "icons\claude.ico"),
    (Join-Path $scriptDir "icons\claude.png"),
    (Join-Path $scriptDir "icons\claude-color.png"),
    (Join-Path $scriptDir "icons\claude.svg")
)

foreach ($iconPath in $possibleIcons) {
    if (Test-Path $iconPath) {
        $claudeIconPath = $iconPath
        break
    }
}

# Fallback to PowerShell icon if no Claude logo found
if (-not $claudeIconPath) {
    $claudeIconPath = "powershell.exe,0"
    Write-Host "Note: Claude logo not found in icons\ directory. Using default icon." -ForegroundColor Yellow
    Write-Host "Run .\download-claude-logo.ps1 to download the Claude logo." -ForegroundColor Yellow
    Write-Host ""
}

# Configuration: Define AI tools to add to context menu
$aiTools = @(
    @{
        Name = "Claude CLI"
        Command = "powershell.exe"
        Arguments = "-NoExit -Command `"Set-Location -Path '%V'; claude`""
        Icon = $claudeIconPath
        Description = "Open Claude AI in PowerShell"
    }
    # Add more AI tools here following the same structure:
    # @{
    #     Name = "Another AI Tool"
    #     Command = "cmd.exe"
    #     Arguments = "/k cd /d `"%V`" && your-command"
    #     Icon = "cmd.exe,0"
    #     Description = "Description of the tool"
    # }
)

# Registry paths for context menu integration
$registryPaths = @{
    # Right-click on folder background (inside folder)
    FolderBackground = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell"
    # Right-click on folder itself
    Folder = "Registry::HKEY_CLASSES_ROOT\Directory\shell"
    # Right-click on drive
    Drive = "Registry::HKEY_CLASSES_ROOT\Drive\shell"
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Add-ContextMenuItem {
    param(
        [string]$BasePath,
        [hashtable]$Tool
    )

    $safeName = $Tool.Name -replace '[^a-zA-Z0-9]', ''
    $menuKeyPath = "$BasePath\AI_Menu\shell\$safeName"
    $commandKeyPath = "$menuKeyPath\command"

    try {
        # Create the menu item key
        if (-not (Test-Path $menuKeyPath)) {
            New-Item -Path $menuKeyPath -Force | Out-Null
        }

        # Set display name
        Set-ItemProperty -Path $menuKeyPath -Name "(Default)" -Value $Tool.Name

        # Set icon if provided
        if ($Tool.Icon) {
            Set-ItemProperty -Path $menuKeyPath -Name "Icon" -Value $Tool.Icon
        }

        # Create command subkey
        if (-not (Test-Path $commandKeyPath)) {
            New-Item -Path $commandKeyPath -Force | Out-Null
        }

        # Set the command to execute
        $fullCommand = "`"$($Tool.Command)`" $($Tool.Arguments)"
        Set-ItemProperty -Path $commandKeyPath -Name "(Default)" -Value $fullCommand

        return $true
    }
    catch {
        Write-ColorOutput "  Error adding $($Tool.Name): $_" "Red"
        return $false
    }
}

function Initialize-AIContextMenu {
    Write-ColorOutput "`n=== AI Context Menu Installer ===" "Cyan"
    Write-ColorOutput "This will add AI tools to your Windows context menu.`n" "Yellow"

    $successCount = 0
    $failCount = 0

    foreach ($pathType in $registryPaths.Keys) {
        $basePath = $registryPaths[$pathType]
        Write-ColorOutput "Processing: $pathType" "Green"

        # Create main AI menu container
        $aiMenuPath = "$basePath\AI_Menu"

        try {
            # Create the main AI menu key
            if (-not (Test-Path $aiMenuPath)) {
                New-Item -Path $aiMenuPath -Force | Out-Null
            }

            # Set the display name for the main menu
            Set-ItemProperty -Path $aiMenuPath -Name "MUIVerb" -Value "AI Tools"
            Set-ItemProperty -Path $aiMenuPath -Name "SubCommands" -Value ""

            # Set icon for main menu (using a brain/AI-like icon from shell32)
            Set-ItemProperty -Path $aiMenuPath -Name "Icon" -Value "shell32.dll,23"

            # Create shell subkey for submenu items
            $shellPath = "$aiMenuPath\shell"
            if (-not (Test-Path $shellPath)) {
                New-Item -Path $shellPath -Force | Out-Null
            }

            # Add each AI tool
            foreach ($tool in $aiTools) {
                Write-ColorOutput "  Adding: $($tool.Name)" "Gray"
                if (Add-ContextMenuItem -BasePath $basePath -Tool $tool) {
                    $successCount++
                } else {
                    $failCount++
                }
            }
        }
        catch {
            Write-ColorOutput "  Error creating AI menu for $pathType`: $_" "Red"
            $failCount += $aiTools.Count
        }

        Write-Host ""
    }

    # Summary
    Write-ColorOutput "=== Installation Complete ===" "Cyan"
    Write-ColorOutput "Successfully added: $successCount items" "Green"
    if ($failCount -gt 0) {
        Write-ColorOutput "Failed: $failCount items" "Red"
    }
    Write-ColorOutput "`nThe AI Tools menu should now appear in your context menu." "Yellow"
    Write-ColorOutput "Right-click on a folder or inside a folder to see it.`n" "Yellow"
}

# Check for admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-ColorOutput "ERROR: This script requires Administrator privileges!" "Red"
    Write-ColorOutput "Please run PowerShell as Administrator and try again." "Yellow"
    exit 1
}

# Run the installation
Initialize-AIContextMenu
