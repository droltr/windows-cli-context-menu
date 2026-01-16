#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Removes AI tools context menu entries from Windows Explorer.

.DESCRIPTION
    This script removes all AI context menu entries that were added by the
    install-context-menu.ps1 script.

.NOTES
    - Requires Administrator privileges
    - Modifies Windows Registry
    - Safe to run even if menu entries don't exist
#>

# Registry paths where AI menu was installed
$registryPaths = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\AI_Menu"
    "Registry::HKEY_CLASSES_ROOT\Directory\shell\AI_Menu"
    "Registry::HKEY_CLASSES_ROOT\Drive\shell\AI_Menu"
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Remove-AIContextMenu {
    Write-ColorOutput "`n=== AI Context Menu Uninstaller ===" "Cyan"
    Write-ColorOutput "This will remove AI tools from your Windows context menu.`n" "Yellow"

    $removedCount = 0
    $notFoundCount = 0

    foreach ($path in $registryPaths) {
        $pathName = $path -replace '.*\\(.*)$', '$1'

        if (Test-Path $path) {
            try {
                Write-ColorOutput "Removing: $path" "Gray"
                Remove-Item -Path $path -Recurse -Force
                $removedCount++
                Write-ColorOutput "  Removed successfully" "Green"
            }
            catch {
                Write-ColorOutput "  Error removing: $_" "Red"
            }
        }
        else {
            Write-ColorOutput "Not found: $path (already removed or never installed)" "DarkGray"
            $notFoundCount++
        }
    }

    Write-Host ""
    Write-ColorOutput "=== Uninstallation Complete ===" "Cyan"
    Write-ColorOutput "Removed: $removedCount entries" "Green"

    if ($notFoundCount -gt 0) {
        Write-ColorOutput "Not found: $notFoundCount entries (already clean)" "Gray"
    }

    Write-ColorOutput "`nThe AI Tools menu has been removed from your context menu.`n" "Yellow"
}

# Check for admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-ColorOutput "ERROR: This script requires Administrator privileges!" "Red"
    Write-ColorOutput "Please run PowerShell as Administrator and try again." "Yellow"
    exit 1
}

# Run the uninstallation
Remove-AIContextMenu
