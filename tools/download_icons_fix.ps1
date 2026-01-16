# Download Icons for AI Tools (Final Correction)

$toolsDir = $PSScriptRoot
$converter = Join-Path $toolsDir "utils\IconConverter.ps1"

$icons = @{
    "powershell" = "powershell"
    "claude"     = "claude"
}

foreach ($tool in $icons.Keys) {
    $slug = $icons[$tool]
    $url = "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/$($slug).png"
    
    $destDir = Join-Path $toolsDir $tool
    $pngFile = Join-Path $destDir "icon.png"
    $icoFile = Join-Path $destDir "icon.ico"

    try {
        Invoke-WebRequest -Uri $url -OutFile $pngFile -UseBasicParsing -ErrorAction Stop
        powershell.exe -ExecutionPolicy Bypass -File $converter -InputPath $pngFile -OutputPath $icoFile | Out-Null
        Write-Host "  [OK] $tool updated" -ForegroundColor Green
    }
    catch {
        Write-Host "  [Error] $tool failed" -ForegroundColor Red
    }
}
