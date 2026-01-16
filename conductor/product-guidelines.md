# Product Guidelines

## Tone and Voice
- **Professional & Technical:** Documentation and user messages should be clear, concise, and professional.
- **Assumed Knowledge:** Assume the user has a basic understanding of Windows and CLI tools, but provide clear instructions for administrative tasks.
- **No Fluff:** Avoid excessive emoji use or overly casual language in system messages.

## Design Principles
- **Native Integration:** The context menu should feel like a native part of the Windows OS.
- **Windows Standards:** Adhere to Windows 10/11 design guidelines for context menus.
- **Visual Consistency:** Ensure submenu items align correctly and use standard spacing.

## Visual Identity
- **Distinctive Icons:** Use official brand logos (e.g., Claude, Gemini) for each tool entry to maximize recognition.
- **Quality:** Ensure icons are crisp and recognizable at standard menu sizes (16x16 or similar).
- **Fallback:** While brand icons are prioritized, the system must handle missing icons gracefully (though this guide emphasizes the preference for brand assets).

## Engineering Standards
- **Robust Error Handling:**
    - Explicitly check for Administrator privileges before attempting registry modifications.
    - Provide clear, actionable error messages if an operation fails (e.g., "Access Denied").
    - Validate paths and tool existence where possible.
- **Safety First:** Never modify registry keys outside the scoped `AI_Menu` keys without explicit user consent/warning.
- **Idempotency:** Installation scripts should be safe to run multiple times without creating duplicate entries or corruption.
