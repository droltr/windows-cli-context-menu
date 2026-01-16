# Centralized Icon Converter & Mover

$projectRoot = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
$iconsDir = Join-Path $projectRoot "icons"
$toolsDir = Join-Path $projectRoot "tools"
$converter = Join-Path $projectRoot "tools\utils\IconConverter.ps1"

if (-not (Test-Path $iconsDir)) { New-Item -ItemType Directory -Force $iconsDir | Out-Null }

$mapping = @{
    "claude"         = "claude.png"
    "gemini"         = "googlegemini.png"
    "git"            = "git.png"
    "github-copilot" = "githubcopilot.png"
    "powershell"     = "powershell.png"
}

Write-Host "Centralizing and Converting Icons..." -ForegroundColor Cyan

foreach ($tool in $mapping.Keys) {
    $pngName = $mapping[$tool]
    $pngPath = Join-Path $toolsDir "$tool\$pngName"
    
    if (Test-Path $pngPath) {
        $icoName = $pngName -replace "\.png$", ".ico"
        $icoPath = Join-Path $iconsDir $icoName
        
        Write-Host "Processing $tool..." -ForegroundColor Gray
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File $converter -InputPath $pngPath -OutputPath $icoPath | Out-Null
        
        if (Test-Path $icoPath) {
            Write-Host "  [OK] Converted to $icoPath" -ForegroundColor Green
        } else {
            Write-Host "  [Error] Conversion failed for $tool" -ForegroundColor Red
        }
    } else {
        Write-Host "  [Skip] PNG not found for $tool at $pngPath" -ForegroundColor Yellow
    }
}
