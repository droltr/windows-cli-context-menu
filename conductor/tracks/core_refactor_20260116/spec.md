# Track Specification: Core Logic Refactor & Copilot Support

## 1. Goal
To improve the reliability of the context menu installation process and officially support GitHub Copilot CLI in the menu options.

## 2. Scope
- **Refactoring:** Modularize the installation script to handle errors more gracefully (e.g., existing keys, permission issues).
- **New Feature:** Add a predefined configuration for `gh copilot` in the tools array.
- **Verification:** Ensure both Claude and Copilot entries appear and function correctly.

## 3. Requirements
- **Robustness:** The script must verify if a registry key exists before attempting to create it.
- **Error Feedback:** Provide clear console output if a step fails (e.g., "Failed to create registry key for X").
- **Copilot Config:**
    - Name: "GitHub Copilot"
    - Command: `gh copilot`
    - Icon: Fallback to a suitable terminal icon or fetch if possible.
