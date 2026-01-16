# Testing Guide

This project uses Pester for testing PowerShell scripts.

## Prerequisites

- **Pester**: The PowerShell testing framework. It comes pre-installed on Windows 10/11 (older versions) or can be installed manually.

To install the latest version of Pester:
```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
```

## Running Tests

To run the full test suite, execute the following command in PowerShell from the project root:

```powershell
Invoke-Pester tests/InstallScript.Tests.ps1
```

## Test Structure

- `tests/InstallScript.Tests.ps1`: Contains unit and integration tests for `install-context-menu.ps1`.
  - **Helper Function Tests**: Verifies logic of internal helper functions.
  - **Tool Discovery Tests**: Verifies that the script can correctly identify and parse plugins in the `tools/` directory.

## Manual Testing

Since the project interacts heavily with the Windows Registry, automated tests are limited to non-destructive logic. Full validation requires manual testing:

1.  Run `Menu.bat` -> **Check Tools**
2.  Run `Menu.bat` -> **Install Menu**
3.  Right-click a folder and verify the "AI Tools" menu appears.
