@{
    Name = "Git Bash"
    Command = "git"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -LiteralPath \""%V\"\"; git status`""
    Icon = "git.ico"
    Description = "Open Git in PowerShell"
}

