# Download Icons for AI Tools (Final Manual Map)

$toolsDir = $PSScriptRoot
$converter = Join-Path $toolsDir "utils\IconConverter.ps1"

# Manually verified working links from walkxcode (which mirrors Simple Icons)
$icons = @{
    "gemini"         = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/google-gemini.png"
    "github-copilot" = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/github-copilot.png"
    "claude"         = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/claude.png"
    "git"            = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/git.png"
    "powershell"     = "https://icons-for-free.com/iff/png/512/powershell-1324440216431460950.png"
}

Write-Host "Updating all icons..." -ForegroundColor Cyan

foreach ($tool in $icons.Keys) {
    $url = $icons[$tool]
    $destDir = Join-Path $toolsDir $tool
    $pngFile = Join-Path $destDir "icon.png"
    $icoFile = Join-Path $destDir "icon.ico"

    try {
        Invoke-WebRequest -Uri $url -OutFile $pngFile -UseBasicParsing -ErrorAction Stop
        powershell.exe -ExecutionPolicy Bypass -File $converter -InputPath $pngFile -OutputPath $icoFile | Out-Null
        Write-Host "  [OK] $tool" -ForegroundColor Green
    }
    catch {
        Write-Host "  [Error] $tool - $_" -ForegroundColor Red
    }
}
