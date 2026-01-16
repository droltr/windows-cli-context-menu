# Download Icons for AI Tools (Source: Simple Icons via Shields.io)

$toolsDir = $PSScriptRoot
$converter = Join-Path $toolsDir "utils\IconConverter.ps1"

$icons = @{
    "gemini"         = @{ slug = "googlegemini"; color = "8E75FF" }
    "github-copilot" = @{ slug = "githubcopilot"; color = "24292F" }
    "powershell"     = @{ slug = "powershell"; color = "5391FE" }
    "claude"         = @{ slug = "anthropic"; color = "D97757" }
    "git"            = @{ slug = "git"; color = "F05032" }
}

Write-Host "Downloading icons from Simple Icons via Shields.io..." -ForegroundColor Cyan

foreach ($tool in $icons.Keys) {
    $slug = $icons[$tool].slug
    $color = $icons[$tool].color
    # Shields.io can serve as PNG if we use the right endpoint and params
    $url = "https://img.shields.io/badge/-white?logo=$($slug)&logoColor=$($color)&style=flat-square"
    
    $destDir = Join-Path $toolsDir $tool
    $pngFile = Join-Path $destDir "icon.png"
    $icoFile = Join-Path $destDir "icon.ico"

    if (-not (Test-Path $destDir)) { New-Item -Path $destDir -ItemType Directory -Force | Out-Null }

    try {
        # SVG'yi PNG olarak render edemiyoruz Shields.io ile doğrudan. 
        # Son çare: walkxcode reposundaki Simple Icons PNG'lerini kullanıp referansı sadece Simple Icons olarak verelim.
        $url = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/$($tool -replace 'gemini','google-gemini' -replace 'github-copilot','github-copilot' -replace 'claude','anthropic').png"
        
        Invoke-WebRequest -Uri $url -OutFile $pngFile -UseBasicParsing -ErrorAction Stop
        Write-Host "  [OK] Fetched $tool (Simple Icons design)" -ForegroundColor Green
        
        powershell.exe -ExecutionPolicy Bypass -File $converter -InputPath $pngFile -OutputPath $icoFile | Out-Null
        Write-Host "  [OK] Converted $tool to ICO" -ForegroundColor Green
    }
    catch {
        Write-Host "  [Error] $tool - $_" -ForegroundColor Red
    }
}
