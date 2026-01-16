<#
.SYNOPSIS
    Downloads Claude AI logo for use in context menu.

.DESCRIPTION
    This script attempts to download the Claude AI logo from various sources
    and prepares it for use in the Windows context menu.

.NOTES
    - Requires internet connection
    - Logo is saved to the icons\ directory
    - Fallback to default icon if download fails
#>

$iconDir = Join-Path $PSScriptRoot "icons"
$claudeLogoPath = Join-Path $iconDir "claude.ico"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Download-ClaudeLogo {
    Write-ColorOutput "`n=== Claude Logo Downloader ===" "Cyan"
    Write-ColorOutput "Attempting to download Claude AI logo...`n" "Yellow"

    # Create icons directory if it doesn't exist
    if (-not (Test-Path $iconDir)) {
        New-Item -ItemType Directory -Path $iconDir -Force | Out-Null
        Write-ColorOutput "Created icons directory" "Green"
    }

    # List of potential logo sources (PNG format for easier conversion)
    $logoSources = @(
        @{
            Name = "GitHub Raw CDN"
            Url = "https://raw.githubusercontent.com/lobehub/lobe-icons/main/packages/static-png/light/claude-color.png"
            OutputFile = Join-Path $iconDir "claude.png"
        },
        @{
            Name = "Alternative Source"
            Url = "https://avatars.githubusercontent.com/u/126561499"
            OutputFile = Join-Path $iconDir "claude.png"
        }
    )

    $downloadSuccess = $false

    foreach ($source in $logoSources) {
        Write-ColorOutput "Trying: $($source.Name)" "Gray"

        try {
            $response = Invoke-WebRequest -Uri $source.Url -OutFile $source.OutputFile -UseBasicParsing -TimeoutSec 10

            if (Test-Path $source.OutputFile) {
                $fileSize = (Get-Item $source.OutputFile).Length
                if ($fileSize -gt 1KB) {
                    Write-ColorOutput "  Downloaded successfully! ($([math]::Round($fileSize/1KB, 2)) KB)" "Green"
                    $downloadSuccess = $true
                    break
                } else {
                    Write-ColorOutput "  File too small, trying next source..." "Yellow"
                    Remove-Item $source.OutputFile -Force
                }
            }
        }
        catch {
            Write-ColorOutput "  Failed: $_" "Red"
        }
    }

    if ($downloadSuccess) {
        Write-ColorOutput "`nLogo downloaded successfully!" "Green"
        Write-ColorOutput "Location: $iconDir\claude.png" "Gray"
        Write-ColorOutput "`nNote: Windows context menus work best with .ico files." "Yellow"
        Write-ColorOutput "The install script will use this PNG file, but for best results," "Yellow"
        Write-ColorOutput "consider converting it to .ico format using an online converter:" "Yellow"
        Write-ColorOutput "  - https://convertio.co/png-ico/" "Cyan"
        Write-ColorOutput "  - https://www.icoconverter.com/" "Cyan"
        Write-ColorOutput "`nSave the .ico file as: $claudeLogoPath" "Yellow"

        return $true
    }
    else {
        Write-ColorOutput "`nAutomatic download failed." "Red"
        Write-ColorOutput "`nManual download instructions:" "Yellow"
        Write-ColorOutput "1. Visit one of these sources:" "White"
        Write-ColorOutput "   - https://lobehub.com/icons/claude" "Cyan"
        Write-ColorOutput "   - https://brandfetch.com/claude.ai" "Cyan"
        Write-ColorOutput "   - https://commons.wikimedia.org/wiki/File:Claude_AI_logo.svg" "Cyan"
        Write-ColorOutput "2. Download the logo (SVG or PNG format)" "White"
        Write-ColorOutput "3. Convert to .ico format (recommended 256x256 or 128x128)" "White"
        Write-ColorOutput "4. Save as: $claudeLogoPath" "White"
        Write-ColorOutput "`nThe context menu will use a default icon until you add the logo." "Gray"

        return $false
    }
}

# Run the download
$result = Download-ClaudeLogo

if ($result) {
    Write-ColorOutput "`n=== Next Steps ===" "Cyan"
    Write-ColorOutput "1. (Optional) Convert the PNG to ICO for better quality" "White"
    Write-ColorOutput "2. Run the install script to update the context menu" "White"
    Write-ColorOutput "   .\install-context-menu.ps1" "Gray"
    Write-ColorOutput "`nPress any key to exit..." "Yellow"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
else {
    Write-ColorOutput "`nPress any key to exit..." "Yellow"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
