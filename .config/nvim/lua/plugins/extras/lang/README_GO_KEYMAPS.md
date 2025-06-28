# Go Development Keymaps

This document describes the keymaps available for Go development using the gopher.nvim plugin.

## Available Keymaps

### Testing

| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>cgx` | `GoTestAdd` | Generate test for function under cursor |
| `<leader>cgT` | `GoTestsAll` | Generate tests for all functions in current file |
| `<leader>cgE` | `GoTestsExp` | Generate tests for exported functions in current file |

### Code Generation

| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>cga` | `GoTagAdd` | Add struct tags (json, yaml, etc) |
| `<leader>cgr` | `GoTagRm` | Remove struct tags |
| `<leader>cge` | `GoIfErr` | Generate if err != nil check |
| `<leader>cgf` | `GoImpl` | Generate function implementation |
| `<leader>cgs` | `GoImpl` | Generate interface stubs |
| `<leader>cgc` | `GoCmt` | Generate doc comments for public package/function/interface/struct |

### Project Management

| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>cgp` | `GoGet` | Add imports |
| `<leader>cgm` | `GoMod tidy` | Run go mod tidy |
| `<leader>cgG` | `GoGenerate` | Run go generate |
| `<leader>cgg` | `GoGenerate %` | Run go generate for current file |

## Additional Commands

The gopher.nvim plugin provides several commands that may not have keymaps but are still useful:

- `:GoInstallDeps` - Install all dependencies for the plugin
- `:GoMod init [name]` - Initialize a new Go module
- `:GoMod tidy` - Run go mod tidy to clean up dependencies
- `:GoWork sync` - Sync go.work file
- `:GoGenerate [path]` - Run go generate on specified path or current directory

