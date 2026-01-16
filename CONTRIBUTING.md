# Contributing to AI Tools Context Menu

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Windows version and PowerShell version
- Error messages (if any)

### Suggesting Features

Feature suggestions are welcome! Please create an issue describing:
- The feature you'd like to see
- Why it would be useful
- How it might work

### Adding New AI Tools

To add support for a new AI tool:

1. **Test locally first**:
   - Edit `install-context-menu.ps1`
   - Add your tool to the `$aiTools` array
   - Run the install script
   - Verify it works as expected

2. **Update documentation**:
   - Add an example to README.md
   - Document any prerequisites
   - Include usage instructions

3. **Submit a pull request**:
   - Fork the repository
   - Make your changes
   - Test thoroughly
   - Submit PR with clear description

### Code Style Guidelines

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow PowerShell best practices
- Include error handling
- Test on multiple Windows versions if possible

### PowerShell Script Guidelines

- Use proper parameter validation
- Include help documentation (comment-based help)
- Handle errors gracefully
- Provide colored output for better UX
- Require admin privileges only when necessary

## Development Setup

1. Clone the repository
2. Make your changes
3. Test the installation script
4. Test the uninstallation script
5. Verify no registry artifacts remain after uninstall

## Testing Checklist

Before submitting changes, please verify:

- [ ] Script runs without errors
- [ ] Menu appears in all contexts (folder, background, drive)
- [ ] Tool launches correctly
- [ ] Uninstall removes all entries
- [ ] No errors in PowerShell console
- [ ] Works on Windows 10 and/or 11
- [ ] Documentation is updated
- [ ] Code follows existing style

## Pull Request Process

1. Update README.md with details of changes
2. Update CHANGELOG in README.md
3. Ensure all tests pass
4. Request review from maintainers
5. Address any feedback

## Questions?

Feel free to open an issue for any questions about contributing.

## Code of Conduct

- Be respectful and constructive
- Focus on what's best for the project
- Show empathy toward other contributors
- Accept constructive criticism gracefully

Thank you for contributing!
