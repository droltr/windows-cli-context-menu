@{
    Name = "GitHub Copilot"
    Command = "copilot"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; copilot`""
    Icon = "icon.ico" 
    Description = "Open GitHub Copilot in PowerShell"
}
