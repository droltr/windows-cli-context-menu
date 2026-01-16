# AI Tools Context Menu for Windows

A PowerShell-based utility that adds AI CLI tools to the Windows Explorer context menu for quick and easy access.

> **🚀 New here?** Check out the [Quick Start Guide](QUICK_START.md) for a 2-minute setup!

## Features

- 🎯 **Quick Access**: Launch AI tools directly from Windows Explorer
- 📁 **Multiple Contexts**: Works on folders, inside folders, and drives
- 🔧 **Extensible**: Easily add more AI tools to the menu
- 🎨 **Clean Interface**: Organized submenu structure
- ⚡ **Automatic Setup**: Opens PowerShell in the correct directory

## Currently Supported Tools

- **Claude CLI**: Opens Claude AI assistant in PowerShell at the selected location

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges
- Claude CLI installed and accessible via PATH (for Claude functionality)

## Installation

### Option 1: Easy Installation (Recommended)

1. **Download or clone this repository**
2. **(Optional) Download Claude logo** for a better visual experience:
   ```powershell
   .\download-claude-logo.ps1
   ```
3. **Double-click `install.bat`**
4. **Click "Yes"** when prompted for Administrator privileges
5. **Done!** Verify by right-clicking in any folder to see "AI Tools" menu

### Option 2: Manual PowerShell Installation

1. **Open PowerShell as Administrator**
   - Press `Win + X` and select "Windows PowerShell (Admin)"

2. **Navigate and run the script**:
   ```powershell
   cd "path\to\Ai Right Click menu"
   .\install-context-menu.ps1
   ```

3. **Verify installation**:
   - Right-click on any folder or inside any folder
   - You should see an "AI Tools" menu with Claude CLI option

## Usage

### Launching Claude CLI

**Method 1: Inside a folder**
1. Open any folder in Windows Explorer
2. Right-click on empty space
3. Navigate to **AI Tools → Claude CLI**
4. PowerShell opens in that folder with Claude running

**Method 2: On a folder**
1. Right-click on any folder icon
2. Navigate to **AI Tools → Claude CLI**
3. PowerShell opens inside that folder with Claude running

**Method 3: On a drive**
1. Right-click on any drive in "This PC"
2. Navigate to **AI Tools → Claude CLI**
3. PowerShell opens at the drive root with Claude running

## Uninstallation

### Easy Method
Double-click `uninstall.bat` and click "Yes" when prompted.

### Manual Method
```powershell
# Run PowerShell as Administrator, then:
.\uninstall-context-menu.ps1
```

## Adding More AI Tools

> **📚 See [EXAMPLES.md](EXAMPLES.md) for ready-to-use configurations for popular AI tools!**

You can easily extend the menu by editing `install-context-menu.ps1`:

1. Open the script in a text editor
2. Find the `$aiTools` array (around line 20)
3. Add a new tool following this template:

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
        Name = "Your AI Tool"
        Command = "powershell.exe"  # or cmd.exe, wt.exe, etc.
        Arguments = "-NoExit -Command `"Set-Location -Path '%V'; your-command`""
        Icon = "path\to\icon.ico,0"
        Description = "Description of your tool"
    }
)
```

4. Run the installation script again

### Examples for Other AI Tools

**GitHub Copilot CLI (if using `gh copilot`)**:
```powershell
@{
    Name = "GitHub Copilot CLI"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; gh copilot`""
    Icon = "powershell.exe,0"
    Description = "Open GitHub Copilot CLI"
}
```

**Custom Python AI Script**:
```powershell
@{
    Name = "Custom AI Assistant"
    Command = "powershell.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; python ai_assistant.py`""
    Icon = "python.exe,0"
    Description = "Launch custom AI assistant"
}
```

## How It Works

The scripts modify the Windows Registry to add custom context menu entries:

- **Registry Locations**:
  - `HKEY_CLASSES_ROOT\Directory\Background\shell\AI_Menu` - For folder backgrounds
  - `HKEY_CLASSES_ROOT\Directory\shell\AI_Menu` - For folder icons
  - `HKEY_CLASSES_ROOT\Drive\shell\AI_Menu` - For drives

- **Menu Structure**:
  ```
  AI Tools (Main Menu)
  ├── Claude CLI
  ├── [Your Tool 1]
  └── [Your Tool 2]
  ```

- **Variable Used**:
  - `%V` - Expands to the full path of the selected folder/location

## Using Custom Icons

### Claude Logo

The project includes a download script to automatically fetch the Claude logo:

```powershell
.\download-claude-logo.ps1
```

This will:
- Attempt to download the official Claude logo
- Save it to the `icons\` directory
- Provide instructions if automatic download fails

**Supported formats**: `.ico` (recommended), `.png`, `.svg`

**Manual download**:
1. Download Claude logo from:
   - [Brandfetch](https://brandfetch.com/claude.ai)
   - [LobeHub Icons](https://lobehub.com/icons/claude)
   - [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Claude_AI_logo.svg)
2. Convert to `.ico` format (256x256 or 128x128) using:
   - [Convertio](https://convertio.co/png-ico/)
   - [ICO Converter](https://www.icoconverter.com/)
3. Save as `icons\claude.ico`
4. Run the install script to apply

### Custom Icons for Other Tools

When adding your own AI tools, you can specify custom icons:

```powershell
Icon = "C:\Path\To\Your\icon.ico"  # Full path
Icon = "icons\your-tool.ico"        # Relative path
Icon = "shell32.dll,23"             # System icon
```

## Troubleshooting

### "Script requires Administrator privileges" error
- Right-click PowerShell and select "Run as Administrator"
- Try running the script again

### Menu doesn't appear after installation
- Try refreshing Explorer (press F5 or restart Explorer.exe)
- Verify the script completed without errors
- Check if you have proper permissions

### Claude command not found
- Ensure Claude CLI is installed: `claude --version`
- Verify Claude is in your system PATH
- Restart PowerShell after installing Claude CLI

### Want to modify an existing entry
- Run the uninstall script first
- Edit the install script with your changes
- Run the install script again

## Security Considerations

- These scripts require Administrator privileges as they modify system registry
- Only run scripts from trusted sources
- Review the script contents before running
- The scripts only modify context menu entries, not core system functionality

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Feel free to:
- Add support for more AI tools
- Improve error handling
- Enhance documentation
- Report bugs or suggest features

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### Version 1.0.0
- Initial release
- Support for Claude CLI
- Install and uninstall scripts
- Modular architecture for easy extension
- Claude logo integration with automatic download script
- Support for custom icons (ICO, PNG, SVG formats)
- Comprehensive documentation and examples
- GitHub-ready with issue templates and contribution guidelines

## Credits

Created to simplify access to AI CLI tools on Windows systems.
