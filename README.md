# AI Tools Context Menu for Windows

![Version](https://img.shields.io/badge/version-v0.6.0-blue)
![Platform](https://img.shields.io/badge/platform-windows-lightgrey)
![Language](https://img.shields.io/badge/language-powershell-blue)
![GitHub license](https://img.shields.io/github/license/droltr/windows-cli-context-menu)
![Repo Size](https://img.shields.io/github/repo-size/droltr/windows-cli-context-menu)

A PowerShell-based utility that adds AI CLI tools (Claude, Gemini, GitHub Copilot, Git, etc.) to the Windows Explorer context menu for quick and easy access.

## Features

- 🎯 **Quick Access**: Launch AI tools directly from Windows Explorer
- 📁 **Multiple Contexts**: Works on folders, inside folders, and drives
- 🔧 **Modular Plugin System**: Easily add more AI tools by creating a folder in `tools/`
- 🎨 **High-Quality Icons**: Support for full-color brand icons using your own PNG files.
- ⚡ **Automatic Setup**: Managed via `Menu.bat`

## How it Works (Step-by-Step)

The tool follows a modular and secure process to integrate AI tools into your system:

### 1. Project Management via `Menu.bat`
`Menu.bat` serves as the central control panel. It checks for administrative privileges and provides a user-friendly interface to install, uninstall, or check the status of your tools.

### 2. Secure Plugin Discovery
The installation script (`install-context-menu.ps1`) automatically scans the `tools/` directory. Each subfolder is treated as a standalone plugin.
- **Security:** It uses `Import-PowerShellDataFile` instead of `Invoke-Expression` to safely parse configuration files without executing arbitrary code.
- **Metadata:** It reads `tool.conf.ps1` to determine the tool name, command, and visual settings.

### 3. High-Quality Icon Engine
Windows Context Menus require `.ico` files for perfect rendering. The system includes a custom `IconConverter.ps1`:
- **Conversion:** It takes your manually provided `icon.png` and wraps it in a 32-bit PNG-encoded ICO container.
- **Centralization:** Converted icons are stored in a root-level `icons/` folder, ensuring reliable and fast loading by the Windows Shell.
- **Fidelity:** This ensures that colors, transparency, and high resolutions are preserved perfectly, avoiding the low-quality artifacts common in standard conversions.

### 4. Dynamic Shell Detection
When you launch a tool, the system automatically detects the best environment:
- **Default Shell:** It prioritizes **PowerShell 7 (`pwsh`)** if installed, otherwise falling back to standard Windows PowerShell.
- **Context-Aware:** It automatically injects the path of the folder you right-clicked into the terminal using the `%V` variable.

### 5. Registry Integration
The final step registers the configuration in the Windows Registry (`HKEY_CLASSES_ROOT`). It sets up the main "AI Tools" group and populates it with your configured plugins, ensuring absolute paths are used for icons and executables to prevent broken links.

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



- Icons sourced and inspired by [Simple Icons](https://simpleicons.org/) (Licensed under CC0 1.0 Universal).
