# Security Policy

## Supported Versions

Only the latest version of this project is currently supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

Use this project responsibly. Since this tool requires Administrator privileges and modifies the Windows Registry, improper usage or malicious modifications could harm your system.

If you discover a security vulnerability within this project (e.g., a way for the script to be exploited to escalate privileges unintendedly), please do **not** open a public issue.

Instead, please contact the maintainer directly via email or GitHub private reporting (if enabled).

### Security Best Practices for Users
- **Review Scripts**: Always review `.ps1` and `.bat` files before running them with Administrator privileges.
- **Trusted Sources**: Only download this tool from the official repository.
- **Access Control**: Ensure your `tools/` directory is writable only by trusted users to prevent injection of malicious tool configurations.
