# Technology Stack

## Core Technologies
- **PowerShell (v5.1+):** The primary scripting engine for registry manipulation, path validation, and setup logic.
- **Windows Batch (.bat):** Used as a simple wrapper to launch PowerShell scripts with appropriate flags (like `-ExecutionPolicy Bypass`).
- **Windows Registry:** The storage backend for context menu definitions (`HKEY_CLASSES_ROOT\Directory`, `HKEY_CLASSES_ROOT\Drive`).

## Development Environment
- **Operating System:** Windows 10 or Windows 11.
- **Permissions:** Administrative privileges are required for all installation and uninstallation tasks.

## Tools & Utilities
- **Git:** For version control and managing the repository.
- **Claude CLI / gh copilot:** Example target AI tools that the utility integrates into the shell.
