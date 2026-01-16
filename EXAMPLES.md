# Examples: Adding More AI Tools

This document provides ready-to-use examples for adding popular AI tools to your context menu.

## How to Use These Examples

1. Open `install-context-menu.ps1` in a text editor
2. Find the `$aiTools` array (around line 20)
3. Add any of the examples below to the array
4. Save the file
5. Run `.\install-context-menu.ps1` as Administrator

## Example Configurations

### Claude CLI (Already Included)

```powershell
@{
    Name = "Claude CLI"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; claude`""
    Icon = "powershell.exe,0"
    Description = "Open Claude AI in PowerShell"
}
```

### ChatGPT CLI (using unofficial CLI)

```powershell
@{
    Name = "ChatGPT CLI"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; chatgpt`""
    Icon = "powershell.exe,0"
    Description = "Open ChatGPT in PowerShell"
}
```

### GitHub Copilot CLI

```powershell
@{
    Name = "GitHub Copilot"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; gh copilot suggest`""
    Icon = "powershell.exe,0"
    Description = "Get GitHub Copilot suggestions"
}
```

### Ollama (Local AI)

```powershell
@{
    Name = "Ollama Chat"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; ollama run llama2`""
    Icon = "powershell.exe,0"
    Description = "Chat with local Llama model"
}
```

### Python-based AI Assistant

```powershell
@{
    Name = "Custom AI Assistant"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; python -m ai_assistant`""
    Icon = "python.exe,0"
    Description = "Launch Python AI assistant"
}
```

### Windows Terminal with AI Tool

```powershell
@{
    Name = "Claude in Windows Terminal"
    Command = "wt.exe"
    Arguments = "-d `"%V`" pwsh.exe -NoExit -Command claude"
    Icon = "wt.exe,0"
    Description = "Open Claude in Windows Terminal"
}
```

### Node.js AI CLI Tool

```powershell
@{
    Name = "AI Code Helper"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; npx ai-code-helper`""
    Icon = "node.exe,0"
    Description = "AI-powered code assistance"
}
```

### Custom Script with Parameters

```powershell
@{
    Name = "AI Analyzer"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; & 'C:\Scripts\analyze.ps1' -Path '%V'`""
    Icon = "powershell.exe,0"
    Description = "Analyze folder with AI"
}
```

### Aider (AI Pair Programming)

```powershell
@{
    Name = "Aider"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; aider`""
    Icon = "powershell.exe,0"
    Description = "AI pair programming assistant"
}
```

### Continue.dev CLI

```powershell
@{
    Name = "Continue"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; continue`""
    Icon = "powershell.exe,0"
    Description = "Continue AI assistant"
}
```

## Advanced Configurations

### Multiple Commands in Sequence

```powershell
@{
    Name = "Setup AI Environment"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; conda activate ai-env; claude`""
    Icon = "powershell.exe,0"
    Description = "Activate conda env and start Claude"
}
```

### With Custom Environment Variables

```powershell
@{
    Name = "Claude with API Key"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"`$env:ANTHROPIC_API_KEY='your-key'; Set-Location -Path '%V'; claude`""
    Icon = "powershell.exe,0"
    Description = "Claude with custom API configuration"
}
```

### Opening in Specific Directory with Prompt

```powershell
@{
    Name = "AI Code Review"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; Write-Host 'Starting code review...' -ForegroundColor Green; claude --prompt 'Review the code in this directory'`""
    Icon = "powershell.exe,0"
    Description = "Start AI code review session"
}
```

## Icon Options

### Using Custom Logo Files

The best approach is to use the actual logo of the AI tool:

```powershell
# Claude logo (after running download-claude-logo.ps1)
Icon = "$PSScriptRoot\icons\claude.ico"

# Relative path to your custom icon
Icon = "icons\your-tool.ico"

# Full path to icon file
Icon = "C:\Path\To\Icon.ico"
```

**Note**: Windows context menus work best with `.ico` files (256x256 or 128x128).

### Using System Icons

You can use icons from Windows system files:

```powershell
Icon = "shell32.dll,23"      # Brain/thinking icon
Icon = "shell32.dll,277"     # Star icon
Icon = "shell32.dll,41"      # Help icon
Icon = "imageres.dll,108"    # Lightning bolt
Icon = "imageres.dll,73"     # Settings gear
Icon = "imageres.dll,190"    # Chat bubble
Icon = "powershell.exe,0"    # PowerShell icon
Icon = "cmd.exe,0"           # Command prompt icon
Icon = "wt.exe,0"            # Windows Terminal icon
Icon = "python.exe,0"        # Python icon (if installed)
Icon = "node.exe,0"          # Node.js icon (if installed)
```

### Finding More System Icons

To browse Windows system icons:
1. Open `C:\Windows\System32\shell32.dll` in a resource editor
2. Or use online icon viewers for shell32.dll
3. Icon numbers start at 0 and go up to 300+

### Getting Logos for AI Tools

**GitHub Copilot**:
- Download from: [GitHub Octicons](https://github.com/logos)
- Convert to .ico format

**ChatGPT**:
- Download from: [OpenAI Brand](https://openai.com/brand/)
- Save to `icons\chatgpt.ico`

**Ollama**:
- Download from: [Ollama GitHub](https://github.com/ollama/ollama)
- Save to `icons\ollama.ico`

**Aider**:
- Download from: [Aider GitHub](https://github.com/paul-gauthier/aider)
- Save to `icons\aider.ico`

## Template for New Tools

Use this template to add your own AI tool:

```powershell
@{
    Name = "Tool Display Name"          # Name shown in context menu
    Command = "executable.exe"          # Program to run
    Arguments = "args here"             # Command-line arguments
    Icon = "path\to\icon.ico,0"        # Icon to display
    Description = "What this tool does" # Description (for documentation)
}
```

## Complete Example with Multiple Tools

Here's how your `$aiTools` array might look with multiple tools:

```powershell
$aiTools = @(
    @{
        Name = "Claude CLI"
        Command = "powershell.exe"
        Arguments = "-NoExit -Command `"Set-Location -Path '%V'; claude`""
        Icon = "powershell.exe,0"
        Description = "Open Claude AI in PowerShell"
    },
    @{
        Name = "GitHub Copilot"
        Command = "powershell.exe"
        Arguments = "-NoExit -Command `"Set-Location -Path '%V'; gh copilot suggest`""
        Icon = "shell32.dll,23"
        Description = "GitHub Copilot suggestions"
    },
    @{
        Name = "Ollama Chat"
        Command = "powershell.exe"
        Arguments = "-NoExit -Command `"Set-Location -Path '%V'; ollama run llama2`""
        Icon = "shell32.dll,277"
        Description = "Local AI chat"
    },
    @{
        Name = "Aider"
        Command = "wt.exe"
        Arguments = "-d `"%V`" pwsh.exe -NoExit -Command aider"
        Icon = "wt.exe,0"
        Description = "AI pair programming"
    }
)
```

## Testing Your Configuration

After adding a new tool:

1. Run the install script
2. Right-click in a folder
3. Check if your tool appears under "AI Tools"
4. Click it to verify it works correctly
5. If issues occur, check PowerShell error messages

## Troubleshooting

### Tool not appearing in menu
- Run install script as Administrator
- Refresh Explorer (F5 or restart Explorer.exe)
- Check for syntax errors in your configuration

### Tool launches but doesn't work
- Verify the tool is installed and in PATH
- Test the command manually in PowerShell
- Check if the tool requires additional setup

### Icon not showing
- Use a valid icon path
- Try a different icon from the examples above
- Omit the Icon property to use default

## Need Help?

If you need help adding a specific AI tool, please open an issue on GitHub with:
- The tool name
- How you normally launch it
- What you'd like it to do when launched from context menu
