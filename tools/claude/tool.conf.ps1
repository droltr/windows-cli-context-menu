@{
    Name = "Claude CLI"
    Command = "claude"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; claude`""
    Icon = "icon.png"
    Description = "Open Claude AI in PowerShell"
}