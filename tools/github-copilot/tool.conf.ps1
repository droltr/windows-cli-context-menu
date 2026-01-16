@{
    Name = "GitHub Copilot"
    Command = "copilot"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; copilot`""
    Icon = "githubcopilot.png" 
    Description = "Open GitHub Copilot in PowerShell"
}
