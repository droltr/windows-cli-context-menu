# Implementation Plan - Core Refactor & Plugin System

## Phase 1: Analysis & Design
- [x] Task: Analyze existing `install-context-menu.ps1` and `Menu.bat` for gaps. [99ec0e7]
- [x] Task: Design the modular function structure and plugin system. [7be92dc]
- [x] Task: Conductor - User Manual Verification 'Analysis & Design' (Protocol in workflow.md) [Manual Confirm]

## Phase 2: Restructuring & Cleanup [checkpoint: d1ef066]
- [x] Task: Create `tools/` directory structure for all tools (claude, gemini, copilot, git, powershell).
- [x] Task: Move/Create config and icons for **Claude**.
- [x] Task: Move/Create config and icons for **GitHub Copilot**.
- [x] Task: Create new config and icons for **Gemini**.
- [x] Task: Move/Create config and icons for **Git** and **PowerShell**.
- [x] Task: Move redundant files (`install-context-menu.ps1`, `Install-CLIContextMenu.ps1`, etc.) to `.deleted/` after migration logic is secured.
- [x] Task: Conductor - User Manual Verification 'Restructuring & Cleanup' (Protocol in workflow.md)

## Phase 3: Core Implementation
- [x] Task: Implement `Test-RegistryKey`, `New-RegistryKeySafe`, `Set-RegistryValueSafe`.
- [x] Task: Implement `Get-ToolPlugins` to scan `tools/` and load configs.
- [x] Task: Rewrite `install-context-menu.ps1` (or `Setup-Manager.ps1`) to use the new plugin system.
- [x] Task: Update `Menu.bat` to point to the new script and logic.
- [x] Task: Conductor - User Manual Verification 'Core Implementation' (Protocol in workflow.md)

## Phase 4: Verification & Polish [checkpoint: 08a1768]
- [x] Task: Update `install-context-menu.ps1` to remove legacy "CLI Tools" registry keys.
- [x] Task: Debug icon paths - ensure absolute paths are written to registry and valid.
- [x] Task: Conductor - User Manual Verification 'Verification & Polish' (Protocol in workflow.md)
