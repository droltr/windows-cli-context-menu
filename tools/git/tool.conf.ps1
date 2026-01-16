@{
    Name = "Git Bash"
    Command = "git"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; git status`""
    Icon = "git.png"
    Description = "Open Git in PowerShell"
}
