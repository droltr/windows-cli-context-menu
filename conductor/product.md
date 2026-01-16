# Initial Concept

Powershell-based utility to add AI CLI tools (Claude, Gemini, Copilot, etc.) to Windows Explorer context menu.

# Product Definition

## Vision
To provide a seamless and extensible way for Windows users, especially developers and power users, to access their favorite AI command-line interfaces directly from the Windows Explorer context menu, improving workflow efficiency and reducing friction.

## Core Features
- **Context-Aware Launch:** Open AI tools in the correct directory context from folder backgrounds, folder icons, or drive roots.
- **Extensible Architecture:** Plugin-based system where new tools are added by simply creating a folder in `tools/` with a configuration file.
- **Automated Setup:** Simple installation and uninstallation via PowerShell and Batch scripts.
- **Visual Integration:** Support for custom icons to make the menu visually distinct.

## Target Audience
- **Developers:** Who need quick access to AI coding assistants in specific project directories.
- **Power Users:** Who want to optimize their system interaction and streamline CLI tool usage.
- **System Administrators:** Who might want to deploy standard toolsets across machines (future scope).

## User Experience
- **Installation:** One-click `install.bat` execution with admin prompt.
- **Usage:** Right-click context menu -> "AI Tools" submenu -> Select Tool.
- **Customization:** Edit the PowerShell script to add or remove tools.
