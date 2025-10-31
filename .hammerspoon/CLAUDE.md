# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hammerspoon configuration for macOS automation and window management. Hammerspoon uses Lua scripting to provide powerful automation capabilities through system APIs.

## Architecture

### Core Structure
- `init.lua` - Main entry point that loads all modules and sets up global configuration
- `hyper_apps.lua` - Application launcher bindings mapped to Hyper key combinations
- `configurator.lua` - Dynamic configuration management, especially for Aerospace window manager integration
- `foundation_remapping.lua` - Low-level keyboard remapping functionality

### Module Organization
- `functions/` - Core functionality modules:
  - `window.lua` - Window management utilities
  - `application_watcher.lua` - App state monitoring
  - `browser.lua` - Browser-specific automation
  - `logger.lua` - Logging utilities
  - `process_manager.lua` - Process management
  - `better_display.lua` - Display configuration management
- `keys/` - Keyboard binding definitions:
  - `init.lua` - Main key binding coordinator
  - `window.lua` - Window layout definitions
  - `browser.lua`, `function.lua`, `chars.lua`, etc. - Specific binding categories
- `Spoons/` - Hammerspoon extensions (community modules)
- `Helpers/` - Utility modules (App.lua, Clipboard.lua)

### Key Concepts

**Hyper Key System**: Uses F18/F19 as modifier keys for complex key bindings. The `hyper_apps.lua` file defines a nested structure of application shortcuts accessible via Hyper+letter combinations.

**Modal System**: Utilizes ModalMgr spoon for creating nested key sequences. Allows for contextual key bindings (e.g., Hyper+a opens AI submenu with further options).

**Window Management**: Integrates with external tools like Aerospace and provides built-in tiling layouts. The system detects Aerospace presence and adjusts behavior accordingly.

**Multi-Monitor Support**: Automatically detects screen count and adjusts window management behavior for single vs multi-monitor setups.

**OmarchyOSX Integration**: The main init.lua can optionally load the OmarchyOSX spoon (located in Spoons/OmarchyOSX.spoon/) which provides Hyprland/i3-inspired tiling window management with vim-style navigation. This is controlled by `Config.useOmarchy` flag.

## Configuration

### Global Variables
- `K` - Key modifier combinations
- `Config` - Runtime configuration (screen count, Aerospace status, etc.)
- `Screens` - Display name mappings
- `HyperBinding` - Main hyper key modifier combination
- `Grid` - Window grid layout definitions

### Spoon Management
Uses SpoonInstall for managing extensions:
- ReloadConfiguration - Auto-reload on config changes  
- ModalMgr - Modal key sequence management
- MouseFollowsFocus - Mouse cursor follows window focus
- AppWindowSwitcher - Application window cycling

## Development Commands

### Reloading Configuration
- Hyper+h+r - Reload Hammerspoon configuration
- The config auto-reloads when files change (via ReloadConfiguration spoon)
- `hs.reload()` - Programmatic reload from console

### Console Access
- Hyper+x - Open Hammerspoon console
- Hyper+h+c - Open console via Raycast extension
- `hs.console()` - Open from command line or code

### Testing and Debugging
No formal test framework is used. Test individual functions by:
1. Opening Hammerspoon console (`hs.console()`)
2. Requiring modules manually: `local win = require("functions.window")`
3. Calling functions directly to test behavior
4. Using `hs.inspect(obj)` to examine object contents
5. Using `Logger.d("message")` for debug output (see functions/logger.lua)

### Hammerspoon CLI
The configuration auto-installs the Hammerspoon CLI tool via Homebrew integration. Use `hs` command from terminal for various operations.

## Integration Points

### External Tools
- **Aerospace** - Window manager (automatically detected)
- **Raycast** - Command launcher (various URL scheme integrations)
- **BetterDisplay** - Display management
- **Kitty** - Terminal with quick-access integration

### Application Management
The system tracks application states and provides intelligent window switching. Many apps have specific logic for multi-window or multi-monitor behavior.

## Key Customization Areas

When modifying this configuration:
1. **App Bindings** - Edit `hyper_apps.lua` for application shortcuts
2. **Window Layouts** - Modify grid definitions in `init.lua` and layout functions in `keys/window.lua`
3. **External Integrations** - Update URL schemes and bundle IDs as applications change
4. **Keyboard Remapping** - Adjust foundation remapping in `foundation_remapping.lua`

## Common Development Tasks

### Adding New Application Shortcuts
1. Edit `hyper_apps.lua` to add bundle IDs or functions
2. For nested menus, use table structures with further key mappings
3. Bundle IDs can be found using: `hs.application.frontmostApplication():bundleID()`

### Modifying Window Layouts
1. Edit grid definitions in `init.lua` (Grid variable)
2. Add layout functions in `keys/window.lua` 
3. Or modify OmarchyOSX spoon layouts in `Spoons/OmarchyOSX.spoon/lib/layouts.lua`

### Debugging Keybind Issues
1. Check if key conflicts with system shortcuts
2. Use `hs.hotkey.showHotkeys()` to see active bindings
3. Check application-specific logic in `functions/application_watcher.lua`

## Notes

- This configuration assumes macOS with specific applications installed
- Many features depend on accessibility permissions for Hammerspoon
- The system gracefully degrades when external tools like Aerospace aren't available
- Bundle IDs are used instead of application names for reliability
- OmarchyOSX spoon is a custom window manager that can be toggled via `Config.useOmarchy`