# Project Structure

This document explains the purpose of each file in this repository.

## Core Files

### Installation & Uninstallation

| File | Purpose |
|------|---------|
| `install-context-menu.ps1` | Main PowerShell script that adds AI tools to Windows context menu |
| `uninstall-context-menu.ps1` | PowerShell script that removes all context menu entries |
| `install.bat` | Convenience batch file for easy installation (auto-requests admin) |
| `uninstall.bat` | Convenience batch file for easy uninstallation (auto-requests admin) |
| `download-claude-logo.ps1` | Downloads Claude's official logo for use in context menu |

### Icons

| File/Directory | Purpose |
|----------------|---------|
| `icons/` | Directory containing logo files for AI tools |
| `icons/.gitkeep` | Placeholder to track the icons directory in git |
| `icons/claude.ico` | Claude logo in ICO format (downloaded by user) |

## Documentation

| File | Purpose |
|------|---------|
| `README.md` | Main project documentation with full details |
| `QUICK_START.md` | Fast 2-minute setup guide for new users |
| `EXAMPLES.md` | Ready-to-use configurations for various AI tools |
| `CONTRIBUTING.md` | Guidelines for contributing to the project |
| `PROJECT_STRUCTURE.md` | This file - explains the project organization |

## Configuration Files

| File | Purpose |
|------|---------|
| `.gitignore` | Specifies which files Git should ignore |
| `LICENSE` | MIT License for the project |

## GitHub Templates

| File | Purpose |
|------|---------|
| `.github/ISSUE_TEMPLATE/bug_report.md` | Template for reporting bugs |
| `.github/ISSUE_TEMPLATE/feature_request.md` | Template for requesting features |

## File Tree

```
Ai Right Click menu/
│
├── Core Scripts
│   ├── install-context-menu.ps1    (PowerShell installation script)
│   ├── uninstall-context-menu.ps1  (PowerShell uninstallation script)
│   ├── download-claude-logo.ps1    (Logo downloader script)
│   ├── install.bat                 (Batch installer)
│   └── uninstall.bat               (Batch uninstaller)
│
├── Icons
│   ├── .gitkeep                    (Keeps directory in git)
│   ├── claude.ico                  (Claude logo - downloaded by user)
│   └── *.png/svg                   (Other logo formats)
│
├── Documentation
│   ├── README.md                   (Main documentation)
│   ├── QUICK_START.md              (Quick setup guide)
│   ├── EXAMPLES.md                 (AI tool examples)
│   ├── CONTRIBUTING.md             (Contribution guidelines)
│   └── PROJECT_STRUCTURE.md        (This file)
│
├── Configuration
│   ├── .gitignore                  (Git ignore rules)
│   └── LICENSE                     (MIT License)
│
└── .github/
    └── ISSUE_TEMPLATE/
        ├── bug_report.md           (Bug report template)
        └── feature_request.md      (Feature request template)
```

## How Files Work Together

### Logo Download Flow (Optional)

```
User Action → download-claude-logo.ps1 → Internet Download
                                       → icons/claude.png
                                       → (User converts to .ico)
```

### Installation Flow

```
User Action → install.bat → install-context-menu.ps1 → Check for logo in icons/
                                                      ↓
                                                      → Windows Registry
                                                      → Context Menu Created (with logo if available)
```

### Uninstallation Flow

```
User Action → uninstall.bat → uninstall-context-menu.ps1 → Registry Cleanup
                                                          → Context Menu Removed
```

### Documentation Hierarchy

```
New User → QUICK_START.md ──→ README.md ──→ EXAMPLES.md
                               └──→ CONTRIBUTING.md (for contributors)
```

## Modifying the Project

### To add a new AI tool:
1. Edit `install-context-menu.ps1`
2. Add entry to `$aiTools` array
3. Optionally update `EXAMPLES.md` with the new tool
4. Update `README.md` changelog

### To improve documentation:
1. Edit relevant `.md` file
2. Ensure cross-references are updated
3. Check that examples still work

### To contribute:
1. Read `CONTRIBUTING.md`
2. Use issue templates in `.github/ISSUE_TEMPLATE/`
3. Follow the guidelines

## File Sizes (Approximate)

- PowerShell scripts: ~5-8 KB each
- Documentation files: ~3-15 KB each
- Batch files: ~1 KB each
- Total project: ~60-80 KB

## Maintenance Notes

### Files that need updates when adding features:
- ✅ `install-context-menu.ps1` - Add tool configuration
- ✅ `README.md` - Update changelog, feature list
- ✅ `EXAMPLES.md` - Add usage example
- ⚠️ `QUICK_START.md` - Only if it affects setup process

### Files rarely changed:
- `LICENSE` - Only if changing license
- `.gitignore` - Only if new file types are added
- `uninstall-context-menu.ps1` - Only if registry structure changes

## Dependencies

### External Dependencies:
- Windows 10/11
- PowerShell 5.1+
- Administrator privileges

### AI Tool Dependencies (Optional):
- Claude CLI (for Claude functionality)
- Other AI tools as configured by user

### No Package Manager Dependencies:
This project has zero npm, pip, or other package manager dependencies. It's pure PowerShell!

## Version Control

The main version number is tracked in:
- `README.md` (Changelog section)

When releasing a new version:
1. Update version in README.md changelog
2. Tag the git commit with version number
3. Create a GitHub release (if applicable)

## Support & Help

- Issues: Use `.github/ISSUE_TEMPLATE/` templates
- Questions: Open a discussion or issue on GitHub
- Contributions: Follow `CONTRIBUTING.md`

---

**Last Updated**: 2025-11-30
**Project Version**: 1.0.0
