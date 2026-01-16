# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-01-16

### Added
- **Modular Plugin System**: Tools are now defined in standalone folders within the `tools/` directory.
- **Dynamic Tool Discovery**: `Menu.bat` and the installation script now automatically detect tools from the `tools/` directory.
- **Gemini CLI Support**: Added a new plugin for Gemini CLI.
- **Robust Error Handling**: Improved registry manipulation with safe create/set functions and explicit error reporting.
- **External Tool Validation**: Check Tools feature now warns if a tool's executable is missing from the system PATH.
- **Absolute Path Icons**: Icons are now resolved to absolute paths to ensure they render correctly in the Windows Context Menu.
- **Cleanup**: Automatic removal of legacy "CLI Tools" registry keys during installation.

### Changed
- Refactored `install-context-menu.ps1` to be modular and plugin-aware.
- Updated `Menu.bat` to version 1.0 with dynamic tool checking.
- Centralized all assets and configurations into the `tools/` folder.

### Fixed
- Fixed icon display issues by ensuring absolute paths and String value types in the registry.
- Fixed syntax error in PowerShell `param` block placement.

---

## [0.8.0] - 2025-12-22

### Added
- Initial public release
- Interactive menu manager (`Menu.bat`)
- Install/Uninstall/Reinstall functionality  
- Check Tools feature with full path detection
- Support for 4 CLI tools: PowerShell 7, GitHub Copilot CLI, Claude CLI, Git.