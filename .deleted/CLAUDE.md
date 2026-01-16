# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Windows PowerShell-based utility that adds AI CLI tools to the Windows Explorer context menu. The project modifies the Windows Registry to create context menu entries that appear when right-clicking on folders, inside folders, or on drives.

## Core Architecture

### Registry-Based Context Menu System

The project uses three main registry locations to provide context menu access:
- `HKEY_CLASSES_ROOT\Directory\Background\shell\AI_Menu` - For folder backgrounds (right-click inside a folder)
- `HKEY_CLASSES_ROOT\Directory\shell\AI_Menu` - For folder icons (right-click on a folder)
- `HKEY_CLASSES_ROOT\Drive\shell\AI_Menu` - For drives (right-click on drives in "This PC")

All three locations use the same menu structure with a main "AI Tools" submenu containing individual tool entries.

### Key Design Patterns

**Tool Configuration**: Tools are defined as PowerShell hashtables in the `$aiTools` array in `install-context-menu.ps1`:
```powershell
@{
    Name = "Tool Name"
    Command = "executable.exe"
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; command`""
    Icon = "path\to\icon.ico"
    Description = "Description"
}
```

**Registry Key Naming**: Tool names are sanitized by removing non-alphanumeric characters to create safe registry key names (see `Add-ContextMenuItem` function, line 91).

**Path Variable**: `%V` is the Windows shell variable that expands to the full path of the selected folder/location. This is critical for ensuring tools launch in the correct directory.

## Main Scripts

### install-context-menu.ps1
- Lines 21-46: Icon detection logic (checks for claude.ico, claude.png, claude-color.png, claude.svg)
- Lines 49-65: `$aiTools` array where new AI tools are added
- Lines 68-75: `$registryPaths` hashtable defining the three registry locations
- Lines 85-124: `Add-ContextMenuItem` function - creates registry keys for each tool
- Lines 126-185: `Initialize-AIContextMenu` function - main installation orchestrator
- Lines 147-148: Creates submenu structure using `MUIVerb` and `SubCommands` registry properties

### uninstall-context-menu.ps1
- Simple script that removes the `AI_Menu` registry keys from all three locations
- Safe to run even if entries don't exist

### download-claude-logo.ps1
- Downloads Claude logo from Wikimedia Commons
- Uses temporary file with move operation to handle potential permission issues
- Provides fallback instructions if automatic download fails

## Adding New AI Tools

To add a new AI tool, edit `install-context-menu.ps1` and add a new hashtable to the `$aiTools` array (around line 49). The structure must include Name, Command, and Arguments at minimum.

**PowerShell argument escaping**: When passing commands to PowerShell, use backtick escaping for quotes: `` `" `` becomes `"` in the final command.

**Command Prompt vs PowerShell**: For cmd.exe, use `/k cd /d "%V" && command`. For PowerShell, use `-NoExit -Command "Set-Location -Path '%V'; command"`.

## Testing

After making changes:
1. Run `.\install-context-menu.ps1` as Administrator
2. Refresh Windows Explorer (F5 or restart explorer.exe)
3. Right-click in a folder to verify the menu appears
4. Test that the tool launches in the correct directory
5. Run `.\uninstall-context-menu.ps1` to verify clean removal

## Common Development Commands

**Install context menu**:
```powershell
.\install-context-menu.ps1
# Or use: .\install.bat (auto-requests admin)
```

**Uninstall context menu**:
```powershell
.\uninstall-context-menu.ps1
# Or use: .\uninstall.bat (auto-requests admin)
```

**Download Claude logo** (optional):
```powershell
.\download-claude-logo.ps1
```

**Test manually in registry**: Use `regedit.exe` and navigate to the registry paths to inspect the created keys.

## Important Constraints

- **Admin privileges required**: All installation/uninstallation scripts require Administrator privileges
- **PowerShell 5.1+**: Scripts use modern PowerShell features
- **Icon formats**: Windows context menus work best with .ico files (256x256 or 128x128). PNG and SVG are supported but may not display properly in all contexts
- **No package dependencies**: This is pure PowerShell with no external dependencies

## Architecture Decisions

**Why three registry locations?**: Windows Explorer treats folder backgrounds, folder icons, and drives as separate contexts. All three must be modified to provide consistent UX.

**Why MUIVerb instead of default value?**: `MUIVerb` allows creation of submenus with the `SubCommands` property, enabling the hierarchical "AI Tools" → "Claude CLI" structure.

**Why sanitize tool names?**: Registry key names cannot contain spaces or special characters. The sanitization (line 91) ensures valid registry keys while preserving display names.

## File Organization

- Root level: Scripts (.ps1, .bat) and documentation (.md)
- `icons/`: Contains logo files for AI tools
- `.github/`: Issue templates for bug reports and feature requests

## Contributing Workflow

When adding support for a new AI tool:
1. Test the tool's CLI command manually
2. Add configuration to `$aiTools` array in install-context-menu.ps1
3. (Optional) Add icon to `icons/` directory
4. Test installation and verify it works
5. Update EXAMPLES.md with the new tool configuration
6. Update README.md changelog section

## Security Considerations

- Scripts modify system registry (requires admin privileges)
- No execution policy bypass - respects system security settings
- All commands are user-defined in the install script (no hidden behavior)
- Uninstall cleanly removes all registry entries
