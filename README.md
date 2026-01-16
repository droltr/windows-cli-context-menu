# AI Tools Context Menu for Windows

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/droltr/windows-cli-context-menu/test.yml?label=tests)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/droltr/windows-cli-context-menu/lint.yml?label=lint)
![GitHub license](https://img.shields.io/github/license/droltr/windows-cli-context-menu)

A PowerShell-based utility that adds AI CLI tools (Claude, Gemini, GitHub Copilot, Git, etc.) to the Windows Explorer context menu for quick and easy access.

## Features

- 🎯 **Quick Access**: Launch AI tools directly from Windows Explorer
- 📁 **Multiple Contexts**: Works on folders, inside folders, and drives
- 🔧 **Modular Plugin System**: Easily add more AI tools by creating a folder in `tools/`
- 🎨 **Clean Interface**: Organized submenu structure
- ⚡ **Automatic Setup**: Managed via `Menu.bat`

## Supported Tools

- **Claude CLI**
- **Gemini CLI**
- **GitHub Copilot CLI**
- **Git Bash**
- **PowerShell 7**

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges
- The respective CLI tools must be installed (e.g., `npm install -g @anthropic-ai/claude-cli`)

## Installation

1. **Download or clone this repository**
2. **Double-click `Menu.bat`**
3. Select **[1] Install Menu**
4. Done! Verify by right-clicking in any folder to see "AI Tools" menu

## Adding New Tools

To add a new tool:
1. Create a new folder in `tools/` (e.g., `tools/my-tool/`).
2. Add a `tool.conf.ps1` file inside:
   ```powershell
   @{
       Name = "My Tool"
       Command = "mytool"
       ShellCommand = "powershell.exe"
       Arguments = "-NoExit -Command `"Set-Location -Path '%V'; mytool`""
       Icon = "icon.png" # Optional, relative to folder
       Description = "Launch My Tool"
   }
   ```
3. (Optional) Add an `icon.png` or `.ico` to the same folder.
4. Run `Menu.bat` and select **[2] Reinstall Menu**.

## Uninstallation

1. Run `Menu.bat`
2. Select **[1] Uninstall Menu**

## Troubleshooting

### "Script requires Administrator privileges"
The script should request them automatically. If not, right-click `Menu.bat` and "Run as Administrator".

### Icons missing
Ensure your icon paths are correct in `tool.conf.ps1`. If missing, a default system icon is used.

## License

MIT License.

## Credits

- Icons provided by [walkxcode/dashboard-icons](https://github.com/walkxcode/dashboard-icons) and [Simple Icons](https://simpleicons.org/).