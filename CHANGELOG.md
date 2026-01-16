# Changelog

All notable changes to this project will be documented in this file.

## [0.6.0] - 2026-01-16

### Added
- **High-Quality Icon Engine**: Introduced `IconConverter.ps1` which preserves full color depth and transparency by using PNG-in-ICO encoding.
- **Automated Asset Management**: `Menu.bat` now automatically downloads and converts missing icons during installation.
- **Improved Plugin System**: Centralized all AI tools into the `tools/` directory with a standardized configuration format.
- **Security Hardening**: Replaced `Invoke-Expression` with `Import-PowerShellDataFile` and implemented `-LiteralPath` with escaped quoting for directory placeholders to prevent RCE and injection vulnerabilities.
- **Dynamic Shell Detection**: Automatically detects and uses PowerShell 7 (`pwsh`) if available, falling back to `powershell.exe`.

### Changed
- Reorganized project structure for better modularity.
- Updated `README.md` with new installation instructions and credits.

### Fixed
- Fixed color distortion in context menu icons.
- Fixed GitHub Copilot command to use the standalone `copilot` CLI.
- Fixed `tool.conf.ps1` syntax to be compatible with strict `Import-PowerShellDataFile` parsing.

---

## [0.5.0] - 2025-12-22
- Initial development and structure.
