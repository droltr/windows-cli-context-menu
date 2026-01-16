<#
.SYNOPSIS
    CLI Context Menu Test Script
.DESCRIPTION
    Install-CLIContextMenu.ps1 script'ini test eder ve doğrular.
#>

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  CLI Context Menu Test Suite            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

$testsPassed = 0
$testsFailed = 0

function Test-Feature {
    param(
        [string]$Name,
        [scriptblock]$Test
    )
    
    try {
        Write-Host "Testing: $Name..." -NoNewline
        & $Test
        Write-Host " ✓ PASSED" -ForegroundColor Green
        $script:testsPassed++
    }
    catch {
        Write-Host " ✗ FAILED" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Yellow
        $script:testsFailed++
    }
}

# Test 1: Script dosyası var mı?
Test-Feature "Script file exists" {
    if (-not (Test-Path ".\Install-CLIContextMenu.ps1")) {
        throw "Install-CLIContextMenu.ps1 not found"
    }
}

# Test 2: Script syntax kontrolü
Test-Feature "PowerShell syntax validation" {
    $errors = $null
    [void][System.Management.Automation.PSParser]::Tokenize((Get-Content ".\Install-CLIContextMenu.ps1" -Raw), [ref]$errors)
    if ($errors.Count -gt 0) {
        throw "Syntax errors found: $($errors.Count)"
    }
}

# Test 3: Required functions var mı?
Test-Feature "Required functions exist" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    $requiredFunctions = @('Write-Status', 'Set-RegistryValue', 'Test-CLITools', 'Install-ContextMenu', 'Uninstall-ContextMenu', 'Main')
    
    foreach ($func in $requiredFunctions) {
        if ($content -notmatch "function $func") {
            throw "Function '$func' not found"
        }
    }
}

# Test 4: Admin kontrolü var mı?
Test-Feature "Admin check exists" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch "#Requires -RunAsAdministrator") {
        throw "Admin requirement not found"
    }
}

# Test 5: Help content var mı?
Test-Feature "Help content exists" {
    $help = Get-Help ".\Install-CLIContextMenu.ps1" -ErrorAction SilentlyContinue
    if (-not $help.Synopsis) {
        throw "Help synopsis not found"
    }
}

# Test 6: CLI araçları test fonksiyonu çalışıyor mu?
Test-Feature "CLI tools detection" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch 'Get-Command.*-ErrorAction SilentlyContinue') {
        throw "Tool detection logic not found"
    }
}

# Test 7: Registry anahtarı doğru mu?
Test-Feature "Registry path validation" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch 'HKCU:\\Software\\Classes\\Directory\\Background\\shell') {
        throw "Correct registry path not found"
    }
}

# Test 8: Uninstall parametresi var mı?
Test-Feature "Uninstall parameter exists" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch '\[switch\]\$Uninstall') {
        throw "Uninstall parameter not found"
    }
}

# Test 9: Hata yönetimi var mı?
Test-Feature "Error handling exists" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch '\$ErrorActionPreference') {
        throw "ErrorActionPreference not found"
    }
    if ($content -notmatch 'try\s*\{') {
        throw "Try-catch blocks not found"
    }
}

# Test 10: README.md var mı ve içerik kontrolü
Test-Feature "README.md exists and valid" {
    if (-not (Test-Path ".\README.md")) {
        throw "README.md not found"
    }
    $readme = Get-Content ".\README.md" -Raw
    if ($readme.Length -lt 500) {
        throw "README.md too short"
    }
}

# Test 11: LICENSE var mı?
Test-Feature "LICENSE exists" {
    if (-not (Test-Path ".\LICENSE")) {
        throw "LICENSE not found"
    }
}

# Test 12: .gitignore var mı?
Test-Feature ".gitignore exists" {
    if (-not (Test-Path ".\.gitignore")) {
        throw ".gitignore not found"
    }
}

# Test 13: Encoding doğru mu?
Test-Feature "UTF-8 encoding check" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    if ($content -notmatch '\$OutputEncoding.*UTF8') {
        throw "UTF-8 encoding setting not found"
    }
}

# Test 14: CLI araçları listesi doğru mu?
Test-Feature "CLI tools list validation" {
    $content = Get-Content ".\Install-CLIContextMenu.ps1" -Raw
    $tools = @('pwsh.exe', 'github-copilot-cli.exe', 'claude.exe', 'git.exe')
    
    foreach ($tool in $tools) {
        if ($content -notmatch [regex]::Escape($tool)) {
            throw "Tool '$tool' not referenced in script"
        }
    }
}

# Özet
Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
Write-Host "Test Results:" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Passed: $testsPassed" -ForegroundColor Green
Write-Host "Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -gt 0) { "Red" } else { "Green" })
Write-Host ("=" * 50) + "`n" -ForegroundColor Cyan

if ($testsFailed -eq 0) {
    Write-Host "✓ All tests passed!" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "✗ Some tests failed. Please review." -ForegroundColor Red
    exit 1
}
