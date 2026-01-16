# Implementation Plan - Core Refactor & Copilot Support

## Phase 1: Analysis & Design
- [x] Task: Analyze existing `install-context-menu.ps1` for error handling gaps. [99ec0e7]
- [x] Task: Design the modular function structure for registry operations (Safe-Create, Safe-Delete). [cd48118]
- [ ] Task: Conductor - User Manual Verification 'Analysis & Design' (Protocol in workflow.md)

## Phase 2: Refactoring Core Logic
- [ ] Task: Implement `Test-RegistryKey`, `New-RegistryKeySafe`, and `Set-RegistryValueSafe` helper functions.
- [ ] Task: Implement `Get-ToolPlugins` function to scan `tools/` directory and load `tool.conf.ps1` files.
- [ ] Task: Refactor `Add-ContextMenuItem` to use the safe registry helpers.
- [ ] Task: Update main execution flow to use `Get-ToolPlugins` instead of hardcoded array.
- [ ] Task: Conductor - User Manual Verification 'Refactoring Core Logic' (Protocol in workflow.md)

## Phase 3: Migration & New Features
- [ ] Task: Create `tools/claude/` structure and migrate existing Claude config/icon.
- [ ] Task: Create `tools/github-copilot/` structure with `tool.conf.ps1` for `gh copilot`.
- [ ] Task: Add logic to `Initialize-AIContextMenu` to check `Test-CommandAvailability` for each tool.
- [ ] Task: Conductor - User Manual Verification 'Migration & New Features' (Protocol in workflow.md)

## Phase 4: Verification
- [ ] Task: Run installation and verify that both Claude and Copilot are detected and installed.
- [ ] Task: Run uninstallation to ensure clean removal (update uninstall script to respect new structure if needed).
- [ ] Task: Conductor - User Manual Verification 'Verification' (Protocol in workflow.md)