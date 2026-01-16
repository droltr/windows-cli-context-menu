# AI Tools Plugins

This directory contains the configurations for the supported AI tools. Each folder represents a "plugin" that is dynamically loaded by the installation script.

## Directory Structure

```text
tools/
├── claude/
│   ├── tool.conf.ps1   <-- Configuration file
│   └── icon.png        <-- Tool icon
├── gemini/
│   ...
└── [your-tool-name]/
```

## Adding a New Tool

1.  **Create a Folder**: Name it after your tool (e.g., `my-tool`).
2.  **Create Configuration**: Add a `tool.conf.ps1` file inside the folder.
3.  **Add Icon**: (Optional) Add an image file (PNG/ICO) inside the folder.

### Configuration Format (`tool.conf.ps1`)

The configuration file must return a PowerShell hashtable:

```powershell
@{
    # Display Name in the Context Menu
    Name = "My Tool Name"

    # Command to check in PATH (used for validation)
    Command = "mytool"

    # The actual executable to run (usually powershell.exe to wrap the call)
    ShellCommand = "powershell.exe"

    # Arguments passed to ShellCommand.
    # %V is the placeholder for the selected directory path.
    Arguments = "-NoExit -Command `"Set-Location -Path '%V'; mytool`""

    # Icon filename (relative to this folder) or system icon path (e.g. "shell32.dll,23")
    Icon = "icon.png"

    # Description (internal documentation)
    Description = "Launches My Tool in the current directory"
}
```
