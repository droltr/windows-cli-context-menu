@{
    Name = "GitHub Copilot"
    Command = "gh"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; gh copilot explain`""
    Icon = "icon.png" 
    Description = "Open GitHub Copilot in PowerShell"
}