<#
.SYNOPSIS
    Windows 11 CLI Context Menu Manager v0.8
.DESCRIPTION
    Adds PowerShell, GitHub Copilot, Claude CLI and Git Init to context menu
.PARAMETER Uninstall
    Remove menu items
.EXAMPLE
    .\Install-CLIContextMenu.ps1
    .\Install-CLIContextMenu.ps1 -Uninstall
#>

[CmdletBinding()]
param([switch]$Uninstall)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message, [string]$Type = "Info")
    $colors = @{"Success"="Green";"Error"="Red";"Warning"="Yellow";"Info"="Cyan"}
    Write-Host "[$Type] $Message" -ForegroundColor $colors[$Type]
}

function Set-RegistryValue {
    param([string]$Path, [string]$Name, [string]$Value, [string]$Type = "String")
    try {
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        return $true
    }
    catch {
        Write-Status "Registry write error: $Path\$Name - $_" "Error"
        return $false
    }
}

function Find-ToolPath {
    param([string]$ToolName, [string[]]$Commands, [string[]]$AdditionalPaths = @())
    
    foreach ($cmd in $Commands) {
        $found = Get-Command $cmd -ErrorAction SilentlyContinue
        if ($found) { return $found.Source }
    }
    
    foreach ($path in $AdditionalPaths) {
        $expandedPath = [Environment]::ExpandEnvironmentVariables($path)
        if (Test-Path $expandedPath) { return $expandedPath }
    }
    
    switch ($ToolName) {
        "GitHub Copilot CLI" {
            $copilotCmd = Get-Command copilot -ErrorAction SilentlyContinue
            if ($copilotCmd) { return "$($copilotCmd.Source)|copilot-standalone" }
            
            $ghPath = Get-Command gh.exe -ErrorAction SilentlyContinue
            if ($ghPath) {
                $ghTest = & gh copilot --help 2>&1
                if ($LASTEXITCODE -eq 0 -or $ghTest -match "copilot") {
                    return "$($ghPath.Source)|gh-copilot"
                }
            }
            
            try {
                $npmPrefix = npm config get prefix 2>$null
                if ($npmPrefix) {
                    $npmCopilot = Join-Path $npmPrefix "github-copilot-cli.cmd"
                    if (Test-Path $npmCopilot) { return $npmCopilot }
                }
            } catch {}
        }
        
        "Claude CLI" {
            try {
                $npmPrefix = npm config get prefix 2>$null
                if ($npmPrefix) {
                    $npmClaude = Join-Path $npmPrefix "claude.cmd"
                    if (Test-Path $npmClaude) { return $npmClaude }
                }
            } catch {}
        }
    }
    
    return $null
}

function Test-CLITools {
    Write-Status "Checking CLI tools..." "Info"
    
    $toolDefinitions = @{
        "PowerShell" = @{
            Commands = @("pwsh.exe", "powershell.exe")
            Paths = @("C:\Program Files\PowerShell\7\pwsh.exe")
        }
        "GitHub Copilot CLI" = @{
            Commands = @("copilot", "github-copilot-cli.cmd")
            Paths = @("%APPDATA%\npm\github-copilot-cli.cmd")
        }
        "Claude CLI" = @{
            Commands = @("claude.exe", "claude.cmd", "claude")
            Paths = @("%APPDATA%\npm\claude.cmd")
        }
        "Git" = @{
            Commands = @("git.exe")
            Paths = @("C:\Program Files\Git\cmd\git.exe")
        }
    }
    
    $results = @{}
    foreach ($tool in $toolDefinitions.GetEnumerator()) {
        $name = $tool.Key
        $definition = $tool.Value
        
        $path = Find-ToolPath -ToolName $name -Commands $definition.Commands -AdditionalPaths $definition.Paths
        
        if ($path) {
            Write-Status "OK $name found: $path" "Success"
            $results[$name] = $path
        }
        else {
            Write-Status "NOT FOUND $name" "Warning"
            $results[$name] = $null
        }
    }
    
    return $results
}

function Install-ContextMenu {
    param($Tools)
    
    Write-Status "Configuring context menu..." "Info"
    
    $baseKey = "HKCU:\Software\Classes\Directory\Background\shell"
    $cliMenuKey = "$baseKey\CLITools"
    
    Set-RegistryValue -Path $cliMenuKey -Name "MUIVerb" -Value "CLI Tools"
    Set-RegistryValue -Path $cliMenuKey -Name "SubCommands" -Value ""
    Set-RegistryValue -Path $cliMenuKey -Name "Icon" -Value "shell32.dll,-16826"
    
    $shellKey = "$cliMenuKey\shell"
    $installed = 0
    
    if ($Tools["PowerShell"]) {
        $psKey = "$shellKey\PowerShellAdmin"
        Set-RegistryValue -Path $psKey -Name "MUIVerb" -Value "PowerShell Here"
        Set-RegistryValue -Path $psKey -Name "Icon" -Value "powershell.exe"
        Set-RegistryValue -Path "$psKey\command" -Name "(Default)" -Value "pwsh.exe -NoExit -Command `"Set-Location '%V'`""
        $installed++
    }
    
    if ($Tools["GitHub Copilot CLI"]) {
        $copilotKey = "$shellKey\CopilotCLI"
        $copilotPath = $Tools["GitHub Copilot CLI"]
        
        Set-RegistryValue -Path $copilotKey -Name "MUIVerb" -Value "Copilot Here"
        
        if ($copilotPath -match '\|copilot-standalone$') {
            $actualPath = $copilotPath -replace '\|copilot-standalone$', ''
            Set-RegistryValue -Path $copilotKey -Name "Icon" -Value "powershell.exe"
            Set-RegistryValue -Path "$copilotKey\command" -Name "(Default)" -Value "pwsh.exe -NoExit -Command `"Set-Location '%V'; copilot`""
        }
        elseif ($copilotPath -match '\|gh-copilot$') {
            $ghPath = $copilotPath -replace '\|gh-copilot$', ''
            Set-RegistryValue -Path $copilotKey -Name "Icon" -Value "$ghPath"
            Set-RegistryValue -Path "$copilotKey\command" -Name "(Default)" -Value "pwsh.exe -NoExit -Command `"Set-Location '%V'; copilot`""
        }
        else {
            Set-RegistryValue -Path $copilotKey -Name "Icon" -Value "cmd.exe"
            Set-RegistryValue -Path "$copilotKey\command" -Name "(Default)" -Value "pwsh.exe -NoExit -Command `"Set-Location '%V'; copilot`""
        }
        $installed++
    }
    
    if ($Tools["Claude CLI"]) {
        $claudeKey = "$shellKey\ClaudeCLI"
        Set-RegistryValue -Path $claudeKey -Name "MUIVerb" -Value "Claude Here"
        Set-RegistryValue -Path $claudeKey -Name "Icon" -Value "cmd.exe"
        Set-RegistryValue -Path "$claudeKey\command" -Name "(Default)" -Value "cmd.exe /k `"cd /d `"%V`" & claude`""
        $installed++
    }
    
    if ($Tools["Git"]) {
        $gitKey = "$shellKey\GitInit"
        Set-RegistryValue -Path $gitKey -Name "MUIVerb" -Value "Git Init Here"
        Set-RegistryValue -Path $gitKey -Name "Icon" -Value "$($Tools['Git'])"
        Set-RegistryValue -Path "$gitKey\command" -Name "(Default)" -Value "pwsh.exe -NoExit -Command `"Set-Location '%V'; git init; Write-Host 'Git initialized' -ForegroundColor Green; git status`""
        $installed++
    }
    
    if ($installed -gt 0) {
        Write-Status "OK $installed tools added to menu" "Success"
    }
    else {
        Write-Status "No CLI tools found" "Error"
        return $false
    }
    
    return $true
}

function Uninstall-ContextMenu {
    Write-Status "Removing context menu..." "Info"
    
    $cliMenuKey = "HKCU:\Software\Classes\Directory\Background\shell\CLITools"
    
    if (Test-Path $cliMenuKey) {
        try {
            Remove-Item -Path $cliMenuKey -Recurse -Force
            Write-Status "OK CLI menu removed" "Success"
            return $true
        }
        catch {
            Write-Status "Menu removal error: $_" "Error"
            return $false
        }
    }
    else {
        Write-Status "CLI menu not installed" "Warning"
        return $true
    }
}

function Main {
    Write-Host "`n============================================================" -ForegroundColor Cyan
    Write-Host " Windows 11 CLI Context Menu Manager v0.8" -ForegroundColor Cyan
    Write-Host "============================================================`n" -ForegroundColor Cyan
    
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Status "This script must be run as Administrator" "Error"
        Write-Host "Please right-click PowerShell and select Run as Administrator`n" -ForegroundColor Yellow
        exit 1
    }
    
    if ($Uninstall) {
        $confirm = Read-Host "`nRemove CLI menu? (Y/N)"
        if ($confirm -eq "Y" -or $confirm -eq "y") {
            if (Uninstall-ContextMenu) {
                Write-Status "`nOperation completed" "Success"
            }
            else {
                Write-Status "`nErrors occurred" "Error"
                exit 1
            }
        }
        else {
            Write-Status "Operation cancelled" "Info"
        }
    }
    else {
        $tools = Test-CLITools
        
        Write-Host "`n"
        $confirm = Read-Host "Continue with installation? (Y/N)"
        
        if ($confirm -eq "Y" -or $confirm -eq "y") {
            if (Install-ContextMenu -Tools $tools) {
                Write-Status "`nInstallation completed" "Success"
                Write-Host "`nRight-click in a folder to see CLI Tools menu`n" -ForegroundColor Cyan
            }
            else {
                Write-Status "`nInstallation failed" "Error"
                exit 1
            }
        }
        else {
            Write-Status "Operation cancelled" "Info"
        }
    }
}

Main