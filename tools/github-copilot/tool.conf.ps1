@{
    Name = "GitHub Copilot"
    Command = "copilot"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -LiteralPath \""%V\"\"; copilot`""
    Icon = "githubcopilot.ico" 
    Description = "Open GitHub Copilot in PowerShell"
}

