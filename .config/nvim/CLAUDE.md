# CLAUDE.md - Neovim Configuration Architecture Guide

This document provides a comprehensive overview of this Neovim configuration architecture to help future Claude instances understand the codebase structure and be productive quickly.

## Overview

This is a sophisticated Neovim configuration built on top of **LazyVim** as the base framework. The configuration is highly modular, extensively customized, and focuses on a full-featured development environment with strong emphasis on:

- **Language Support**: Ruby, Go, TypeScript/JavaScript, Python, Lua, and many others
- **AI Integration**: Multiple AI providers (Copilot, Avante, Model.nvim, etc.)
- **Development Workflows**: Git integration, testing, debugging, formatting, linting
- **Performance**: Optimized for large codebases with smart lazy loading

## Core Architecture

### 1. Entry Point & Bootstrap
- **`init.lua`**: Main entry point that bootstraps lazy.nvim and loads the configuration
- **`lua/config/lazy.lua`**: Lazy.nvim setup with LazyVim as base, imports plugins from `lua/plugins/`
- **Pre-lazy functionality**: Special environment detection (VSCode, Neovide, Cursor)

### 2. Configuration Structure

```
lua/
├── config/           # Core LazyVim configuration overrides
│   ├── autocmds.lua  # Custom autocommands
│   ├── keymaps.lua   # Global keybindings (extensive customizations)
│   ├── lazy.lua      # Plugin manager setup
│   └── options.lua   # Neovim options and global variables
├── plugins/          # Plugin specifications
│   ├── dev.lua       # Development plugins (plugins being developed)
│   └── extras/       # Modular plugin configurations
└── util/             # Utility functions and modules
```

### 3. Plugin Organization

The plugin system is highly modular using a categorized extras system:

```
lua/plugins/extras/
├── ai/              # AI integrations (20+ AI tools)
├── coding/          # Code completion, snippets, treesitter
├── dap/             # Debug Adapter Protocol
├── editor/          # File managers, search, navigation
├── formatting/      # Code formatters (conform, prettier, etc.)
├── lang/            # Language-specific configurations
├── linting/         # Linters and diagnostics
├── lsp/             # LSP enhancements
├── mini/            # Mini.nvim ecosystem plugins
├── ui/              # Themes, statuslines, UI enhancements
└── util/            # Utility plugins
```

## Key Technologies & Package Management

### Primary Package Manager
- **lazy.nvim**: Main plugin manager with lazy loading
- **lazy-lock.json**: Lockfile with 130+ plugins pinned to specific commits

### Additional Package Managers
- **rocks.toml**: For Lua rocks (currently: fugit2.nvim with libgit2)
- **package.json**: For Node.js dependencies (React Query dev tools)
- **mason.nvim**: LSP server, DAP server, linter, formatter management

## Language Support Architecture

The configuration provides extensive language support through a layered approach:

### Core Languages (Fully Featured)
- **Ruby**: ruby-lsp, rubocop, rspec testing, rails support
- **Go**: gopls, gopher.nvim, testing with ginkgo
- **TypeScript/JavaScript**: typescript-language-server, ESLint, Prettier
- **Python**: pyright, black, pytest
- **Lua**: lua-language-server, stylua, selene linting

### Configuration Patterns
Each language typically includes:
1. LSP server configuration
2. Formatter setup (via conform.nvim)
3. Linter integration (via nvim-lint)
4. Debugging support (nvim-dap)
5. Testing integration (neotest)
6. Language-specific keybindings
7. Custom utilities and helpers

## Development Tools & Workflows

### Git Integration
- **LazyGit**: Primary git interface
- **Gitsigns**: Git hunks, blame, staging
- **Diffview**: Advanced diff views
- **Git browsing**: GitHub integration with URL generation

### Testing
- **Neotest**: Universal testing interface with adapters for:
  - Jest (JavaScript/TypeScript)
  - RSpec (Ruby)
  - Go test
  - Playwright
  - Python pytest

### Debugging
- **nvim-dap**: Debug Adapter Protocol with language-specific setups
- **Persistent breakpoints**: Custom breakpoint management
- **Language-specific debuggers**: rdbg (Ruby), delve (Go), etc.

### AI Integration
Multiple AI providers configured:
- **GitHub Copilot**: Code completion
- **Avante.nvim**: Claude integration for code chat
- **Model.nvim**: Multiple model providers
- **Custom AI utilities**: Context extraction, prompt generation

## Utility Framework

The `lua/util/` directory contains a comprehensive utility framework:

### Key Utility Modules
- **`util.git`**: Git operations, GitHub integration
- **`util.lsp`**: LSP enhancements and helpers
- **`util.fzf`**: Custom fuzzy finder functions
- **`util.treesitter`**: Treesitter utilities (path copying, etc.)
- **`util.ai`**: AI integration helpers
- **`util.ruby`**: Ruby-specific development tools
- **`util.path`**: Path manipulation and clipboard operations

### Global Access
- Utilities are globally accessible via `_G.Util`
- Lazy-loaded on first access to maintain performance

## Configuration Patterns

### Plugin Configuration Pattern
Plugins follow a consistent structure:
```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  opts = { ... },
  config = function(_, opts)
    -- Custom setup
  end,
  keys = { ... },        -- Lazy loading via keybindings
  ft = { ... },          -- Lazy loading via filetype
  event = { ... },       # Lazy loading via events
}
```

### Custom Keybinding Philosophy
- **Leader key**: `<space>` (LazyVim default)
- **Local leader**: `\`
- **Heavy use of which-key**: Organized, discoverable keybindings
- **Mac-specific mappings**: Cmd+key support for macOS
- **Mode-specific bindings**: Different behaviors in normal/visual/insert modes

## Development Commands & Scripts

### Formatting & Linting
- **StyLua**: Lua code formatting (`stylua.toml`)
- **Selene**: Lua linting (`selene.toml`)
- **Conform.nvim**: Multi-language formatting
- **nvim-lint**: Multi-language linting

### Testing Setup
- **Busted**: Lua testing framework setup in `tests/busted.lua`
- **Test utilities**: Custom test runners and helpers
- **CI-ready**: Minimal test environment bootstrap

### Build Tools
- Language-specific build configurations
- Custom overseer templates for task running
- Integration with external tools (npm, cargo, go, bundle)

## Performance Optimizations

### Lazy Loading Strategy
- Most plugins are lazy-loaded via:
  - Keybindings
  - File types
  - Commands
  - Events
- Critical startup time optimization

### Large File Handling
- **Snacks.bigfile**: Automatic detection and optimization for large files
- Custom patterns for known large files
- Syntax highlighting optimizations

### Startup Optimizations
- Disabled unnecessary runtime plugins
- Optimized treesitter configurations
- Minimal startup dependencies

## Environment-Specific Features

### Editor Detection
- **VSCode**: Special configuration for vscode-neovim
- **Neovide**: GUI-specific settings and optimizations
- **Cursor**: Custom integration features
- **Kitty terminal**: Terminal-specific features and integration

### Platform Support
- **macOS**: Primary development platform with Cmd key support
- **Cross-platform**: Compatible with Linux and Windows
- **SSH**: Clipboard integration over SSH

## Development Workflow

### Configuration Development
1. **Local development**: `dev = true` in plugin specs for local development
2. **Hot reloading**: Automatic module reloading for utility functions
3. **Configuration testing**: Built-in testing framework
4. **Documentation**: Extensive inline documentation and comments

### Plugin Management
1. **Lock file management**: `lazy-lock.json` for reproducible builds
2. **Update workflows**: Systematic plugin updates
3. **Development plugins**: Special handling for plugins under development

## Key Files to Understand

### Critical Configuration Files
- **`init.lua`**: Entry point and environment detection
- **`lua/config/lazy.lua`**: Plugin system setup
- **`lua/config/options.lua`**: Global configuration and feature flags
- **`lua/config/keymaps.lua`**: Global keybinding definitions
- **`lua/util/init.lua`**: Utility framework entry point

### Important Plugin Files
- **`lua/plugins/extras/lang/ruby-extended.lua`**: Ruby development setup
- **`lua/plugins/extras/ai/avante.lua`**: AI integration example
- **`lua/plugins/extras/editor/fzf-extended.lua`**: Search and navigation
- **`lua/plugins/extras/ui/lualine-extended.lua`**: Statusline configuration

## Getting Started for Development

### Understanding the Codebase
1. Start with `init.lua` to understand bootstrap process
2. Review `lua/config/options.lua` for feature flags and global settings
3. Explore `lua/plugins/extras/` for specific functionality
4. Check `lua/util/` for available utility functions

### Making Changes
1. **Plugin additions**: Add to appropriate `extras/` category
2. **Utility functions**: Add to relevant `util/` module
3. **Keybindings**: Add to `lua/config/keymaps.lua` or plugin-specific configs
4. **Options**: Modify `lua/config/options.lua`

### Testing Changes
1. Use the built-in testing framework in `tests/`
2. Test with different environments (VSCode, terminal, etc.)
3. Verify performance impact with startup time measurement

## Notable Features & Innovations

### Custom Utilities
- **Path operations**: Sophisticated path copying and manipulation
- **AI integration**: Custom prompt generation and context extraction
- **Git workflows**: Advanced Git operations and GitHub integration
- **Language-specific tools**: Ruby gems, Go modules, etc.

### UI/UX Enhancements
- **Multiple statusline configurations**: Lualine with extensive customizations
- **Theme system**: 20+ color schemes with smart switching
- **Window management**: Advanced split and tab management
- **File navigation**: Multiple file managers (neo-tree, oil, yazi)

### Performance Features
- **Smart loading**: Context-aware plugin loading
- **Memory management**: Efficient resource usage
- **Large file optimization**: Automatic performance adjustments

This configuration represents a mature, production-ready Neovim setup with extensive customization and optimization for professional development workflows.