# Design: Core Refactor & Copilot Support

## Modular Registry Functions

To improve robustness, we will introduce the following helper functions:

### 1. `Test-RegistryKey`
- **Purpose:** Verifies if a registry key exists.
- **Parameters:**
    - `$Path` (string): The full registry path (e.g., `HKCU:\Software\MyKey`).
- **Returns:** `[bool]` ($true if exists, $false otherwise).

### 2. `New-RegistryKeySafe`
- **Purpose:** Creates a registry key with error handling and idempotency.
- **Parameters:**
    - `$Path` (string): The path to create.
    - `$Force` (switch): If true, doesn't error if it already exists (standard behavior, but explicit).
- **Returns:** `[bool]` (Success status).
- **Logic:**
    - Wrap `New-Item` in `try/catch`.
    - Log specific error if creation fails.

### 3. `Set-RegistryValueSafe`
- **Purpose:** Sets a registry value/property with error handling.
- **Parameters:**
    - `$Path` (string): Key path.
    - `$Name` (string): Property name (e.g., "Icon").
    - `$Value` (string): Property value.
    - `$PropertyType` (string, optional): Registry value type (default String).
- **Returns:** `[bool]` (Success status).

## External Tool Validation

### `Test-CommandAvailability`
- **Purpose:** Checks if a command (like `gh` or `claude`) is available in the system PATH.
- **Parameters:**
    - `$CommandName` (string): executable name.
- **Returns:** `[bool]`
- **Usage:**
    - Before adding a tool to the menu, run this check.
    - If false, print a **WARNING** (Yellow) to the user: "Warning: '$CommandName' was not found in PATH. The context menu item may not work until it is installed."
    - **Do not block installation**, as the user might install it later.

## Refactored Main Loop
- The main `Initialize-AIContextMenu` function will call these helpers instead of raw `New-Item`/`Set-ItemProperty`.
- It will maintain a `$errors` array to print a summary at the end.
