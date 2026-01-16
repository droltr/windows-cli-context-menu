# Icons Directory

This directory contains logo files for AI tools used in the context menu.

## Getting Started

### Automatic Download (Recommended)

Run the logo download script from the project root:

```powershell
.\download-claude-logo.ps1
```

This will automatically download the Claude logo to this directory.

## Manual Installation

### Claude Logo

1. **Download** the Claude logo from one of these sources:
   - [Brandfetch](https://brandfetch.com/claude.ai) - Official brand assets
   - [LobeHub Icons](https://lobehub.com/icons/claude) - SVG/PNG formats
   - [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Claude_AI_logo.svg) - SVG format

2. **Convert to ICO** (recommended):
   - Use [Convertio](https://convertio.co/png-ico/)
   - Or [ICO Converter](https://www.icoconverter.com/)
   - Recommended size: 256x256 or 128x128 pixels

3. **Save** the file as:
   - `claude.ico` (best quality for Windows)
   - OR `claude.png` (also supported)
   - OR `claude.svg` (also supported)

## Supported Formats

The installation script automatically detects logos in this order:
1. `.ico` files (best for Windows context menus)
2. `.png` files (good quality)
3. `.svg` files (vector format)

## Adding Other AI Tool Logos

You can add logos for other AI tools using the same naming convention:

```
icons/
├── claude.ico          # Claude AI
├── chatgpt.ico         # ChatGPT
├── copilot.ico         # GitHub Copilot
├── ollama.ico          # Ollama
└── aider.ico           # Aider
```

Then reference them in `install-context-menu.ps1`:

```powershell
Icon = "$PSScriptRoot\icons\chatgpt.ico"
```

## Icon Resources

### Popular AI Tools

- **ChatGPT**: [OpenAI Brand Assets](https://openai.com/brand/)
- **GitHub Copilot**: [GitHub Logos](https://github.com/logos)
- **Ollama**: [Ollama GitHub](https://github.com/ollama/ollama)
- **Aider**: [Aider GitHub](https://github.com/paul-gauthier/aider)

### Icon Converters

- [Convertio PNG to ICO](https://convertio.co/png-ico/)
- [ICO Converter](https://www.icoconverter.com/)
- [AConvert](https://www.aconvert.com/icon/)
- [CloudConvert](https://cloudconvert.com/png-to-ico)

## Best Practices

✅ **DO**:
- Use `.ico` format for best Windows compatibility
- Use 256x256 or 128x128 pixel dimensions
- Download official logos from brand resources
- Keep file names simple (lowercase, no spaces)

❌ **DON'T**:
- Use very large files (keep under 1MB)
- Use copyrighted logos without permission
- Use very small images (under 64x64)

## Troubleshooting

### Icon doesn't appear in context menu
- Make sure the file extension is correct (.ico, .png, or .svg)
- Check the file isn't corrupted by opening it
- Reinstall the context menu: `.\install-context-menu.ps1`
- Refresh Explorer (F5 or restart explorer.exe)

### Icon looks blurry
- Use `.ico` format instead of `.png`
- Ensure the source image is high resolution
- Try 256x256 pixel size for best results

### Script can't find the icon
- Check the file is in the `icons\` directory
- Verify the filename matches what's in the install script
- Ensure there are no extra spaces in the filename

## Git Notes

This directory is tracked in git, but logo files are ignored (see `.gitignore`). This means:
- The `icons/` folder structure is preserved
- Downloaded logos are NOT committed to git
- Each user downloads their own logo files

---

For more information, see the main [README.md](../README.md) or [EXAMPLES.md](../EXAMPLES.md).
