# Implementation Plan - Core Refactor & Copilot Support

## Phase 1: Analysis & Design
- [x] Task: Analyze existing `install-context-menu.ps1` for error handling gaps. [99ec0e7]
- [ ] Task: Design the modular function structure for registry operations (Safe-Create, Safe-Delete).
- [ ] Task: Conductor - User Manual Verification 'Analysis & Design' (Protocol in workflow.md)

## Phase 2: Refactoring Core Logic
- [ ] Task: Implement `Test-RegistryKey` helper function.
- [ ] Task: Refactor `Add-ContextMenuItem` to use `Test-RegistryKey` and try-catch blocks.
- [ ] Task: Update main execution flow to provide summary of success/failures.
- [ ] Task: Conductor - User Manual Verification 'Refactoring Core Logic' (Protocol in workflow.md)

## Phase 3: Adding GitHub Copilot Support
- [ ] Task: Define the `gh copilot` configuration in the `$aiTools` array.
- [ ] Task: Verify the arguments for launching `gh copilot` correctly in a new window.
- [ ] Task: Add logic to check if `gh` CLI is installed (optional but recommended warning).
- [ ] Task: Conductor - User Manual Verification 'Adding GitHub Copilot Support' (Protocol in workflow.md)

## Phase 4: Verification
- [ ] Task: Run installation with both tools selected.
- [ ] Task: Verify context menu appearance and functionality.
- [ ] Task: Run uninstallation to ensure clean removal.
- [ ] Task: Conductor - User Manual Verification 'Verification' (Protocol in workflow.md)
