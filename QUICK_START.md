# Quick Start Guide

Get up and running with AI Tools Context Menu in 2 minutes!

## Prerequisites Check

Before you start, make sure you have:
- ✅ Windows 10 or 11
- ✅ Claude CLI installed (test by running `claude --version` in PowerShell)

If you don't have Claude CLI, install it first: [Claude CLI Installation](https://docs.anthropic.com/claude/docs/cli)

## Installation (Choose One Method)

### Method 1: Double-Click Installation (Easiest)

1. **Download** this repository
2. **(Optional)** Double-click `download-claude-logo.ps1` to get Claude's icon
3. **Double-click** `install.bat`
4. **Click "Yes"** when prompted for admin privileges
5. **Done!** The AI Tools menu is now in your context menu

### Method 2: PowerShell Installation

1. Open PowerShell **as Administrator**
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. Navigate to the downloaded folder:
   ```powershell
   cd "path\to\Ai Right Click menu"
   ```

3. Run the installer:
   ```powershell
   .\install-context-menu.ps1
   ```

4. Done!

## First Use

1. **Open any folder** in Windows Explorer
2. **Right-click** on empty space (or on a folder)
3. Look for **"AI Tools"** in the menu
4. Click **"Claude CLI"**
5. PowerShell opens with Claude running!

## Uninstall

### Quick Method:
Double-click `uninstall.bat`

### PowerShell Method:
```powershell
.\uninstall-context-menu.ps1
```

## Troubleshooting

### "Cannot run scripts" error
Run this in PowerShell (as Admin):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Menu doesn't appear
- Press `F5` in Explorer to refresh
- Or restart Explorer: `Ctrl+Shift+Esc` → Find "Windows Explorer" → Restart

### "claude: command not found"
- Install Claude CLI first
- Make sure it's in your PATH
- Restart PowerShell/Explorer after installing

## Next Steps

- ✨ **Add more AI tools**: See [EXAMPLES.md](EXAMPLES.md)
- 📖 **Full documentation**: See [README.md](README.md)
- 🤝 **Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md)

## One-Liner Summary

**Install**: Double-click `install.bat` → Click "Yes"
**Use**: Right-click in any folder → "AI Tools" → "Claude CLI"
**Uninstall**: Double-click `uninstall.bat`

---

**Having issues?** Check the [Troubleshooting](README.md#troubleshooting) section in README.md
