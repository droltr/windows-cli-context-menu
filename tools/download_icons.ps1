# Download Icons for AI Tools and Convert to ICO (Reliable Favicon Source)

$toolsDir = $PSScriptRoot
$converter = Join-Path $toolsDir "utils\IconConverter.ps1"

$icons = @{
    "gemini"         = "https://www.google.com/s2/favicons?domain=gemini.google.com&sz=128"
    "github-copilot" = "https://www.google.com/s2/favicons?domain=github.com&sz=128"
    "powershell"     = "https://www.google.com/s2/favicons?domain=microsoft.com&sz=128"
    "claude"         = "https://www.google.com/s2/favicons?domain=claude.ai&sz=128"
    "git"            = "https://www.google.com/s2/favicons?domain=git-scm.com&sz=128"
}

Write-Host "Downloading and Converting icons..." -ForegroundColor Cyan

foreach ($tool in $icons.Keys) {
    $url = $icons[$tool]
    $destDir = Join-Path $toolsDir $tool
    $pngFile = Join-Path $destDir "icon.png"
    $icoFile = Join-Path $destDir "icon.ico"

    if (-not (Test-Path $destDir)) { New-Item -Path $destDir -ItemType Directory -Force | Out-Null }

    if (Test-Path $icoFile) {
        Write-Host "  [Skip] Icon for $tool already exists." -ForegroundColor Gray
        continue
    }

    try {
        Invoke-WebRequest -Uri $url -OutFile $pngFile -UseBasicParsing -ErrorAction Stop
        Write-Host "  [OK] Downloaded $tool" -ForegroundColor Green
        
        if (Test-Path $pngFile) {
            powershell.exe -ExecutionPolicy Bypass -File $converter -InputPath $pngFile -OutputPath $icoFile | Out-Null
            if (Test-Path $icoFile) {
                Write-Host "  [OK] Converted $tool to ICO" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "  [Error] $tool - $_" -ForegroundColor Red
    }
}