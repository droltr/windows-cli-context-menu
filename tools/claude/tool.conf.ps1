@{
    Name = "Claude CLI"
    Command = "claude"
    ShellCommand = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -LiteralPath \""%V\"\"; claude`""
    Icon = "claude.ico"
    Description = "Open Claude AI in PowerShell"
}

