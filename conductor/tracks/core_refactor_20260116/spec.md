# Track Specification: Core Logic Refactor & Copilot Support

## 1. Goal
To improve the reliability of the context menu installation process, transition to a modular folder-based structure for tool definitions, and officially support GitHub Copilot CLI.

## 2. Scope
- **Refactoring:** Modularize the installation script to handle errors gracefully.
- **Architecture:** Implement a plugin-style system where each AI tool has its own folder in `tools/` containing a config file and icon.
- **New Feature:** Add a default "plugin" folder for `gh copilot`.
- **Migration:** Move the existing hardcoded Claude configuration into a `tools/claude/` folder.
- **Verification:** Ensure the script correctly discovers and installs tools from folders.

## 3. Requirements
- **Robustness:** The script must verify if a registry key exists before attempting to create it.
- **Modularity:**
    - Tools must be defined in `tools/<tool-name>/tool.conf.ps1`.
    - Icons must be resolved relative to the tool's folder.
- **Error Feedback:** Provide clear console output if a step fails or a tool config is invalid.
- **Copilot Config:**
    - Name: "GitHub Copilot"
    - Command: `gh copilot`
    - Folder: `tools/github-copilot/`