# Personal Configuration Repository

A comprehensive collection of configuration files for development tools, editors, terminals, and system utilities.

## 🖥️ Terminal Emulators
- **kitty** - Feature-rich GPU-based terminal with custom scripts, sessions, and keybindings
- **alacritty** - GPU-accelerated terminal emulator with custom themes and keyboard configurations
- **wezterm** - GPU-accelerated cross-platform terminal with Lua configuration

## 🐚 Shell & Prompt
- **fish** - Modern shell with extensive configuration, functions, abbreviations, and completions
- **starship** - Cross-shell prompt with Git integration, language detection, and custom symbols
- **atuin** - Enhanced shell history with sync and search capabilities

## ✏️ Text Editors & IDEs
### Primary Neovim Configuration
- **nvim** - Main Neovim setup with comprehensive language support for:
  - **Languages**: TS, JS, Ruby, MD, MDX, Go, Rust, Lua, Docker, Ansible, Elixir, SQL, XML, Bash, Fennel, JSON, Terraform, Git
  - **Frameworks**: React, Angular, Astro, Svelte, Vue
  - **Testing**: RSpec, Jest, Vitest, Mocha, Playwright, Gotests
  - **Go**: gopls+gofumpt, ray-x/go, gotests.nvim
  - **Ruby**: Custom treesitter objects, vim-rails, vim-bundler, ruby-lsp with plugins (ruby-lsp-rails, ruby-lsp-rubyfmt), Rubocop, Solargraph, Sorbet, Standardrb, Neotest RSpec integration, custom Rails AI prompts
  - **YAML**: Auto-complete for Argo CD, Kustomization, Github workflows, SealedSecrets, Github actions
  - **Tailwind**: Highlighting and class concealment (toggle with `<leader>uc`)
  - **Formatting/Linting**: Biome+Dprint for TS, auto-detects prettier+eslint
  - **AI Integration**: OpenAI via ChatGPT, CodeGPT, NeoAI, Copilot, Codeium, Sourcegraph, Huggingface, wtf.nvim

### Alternative Editor Configurations
- **helix** - Modal editor with LSP integration and custom themes
- **zed** - Modern collaborative editor with custom settings and keymaps
- **nvimpager** - Neovim-based pager for enhanced terminal output

### Additional Neovim Distributions (Archived/Experimental)
Multiple Neovim configurations for different use cases:
- astrovim, astro-vim, cosmic-nvim, kickstart.nvim, lazy-starter
- nvchad, doom-nvim, lvim (LunarVim)
- Specialized configs: nvim-Primeagen, nvim-Cpp, nvim-Lazyman, nvim-olical
- Custom builds: km-nvim, matt-nvim, modern-neovim, nyoom.nvim
- IDE-focused: nv-ide, neovim-pde, CyberNvim, CodeArt

## 🛠️ Development Tools
- **lazygit** - Terminal UI for Git with custom themes and configuration
- **tmux** - Terminal multiplexer with custom plugins and keybindings
- **lazydocker** - Terminal UI for Docker management

## 📁 File Management & Navigation
- **yazi** - Modern terminal file manager with plugins, themes, and custom keymaps
- **ranger** - Console file manager
- **bat** - Cat replacement with syntax highlighting
- **fd** - Find replacement
- **rg** (ripgrep) - Grep replacement

## ⚙️ System & Productivity
- **karabiner** - macOS keyboard customization with complex modifications
- **btop** - Resource monitor
- **htop** - Process viewer
- **skhd** - macOS hotkey daemon
- **newsboat** - RSS/Atom feed reader

## 🌐 Cloud & Infrastructure Tools
- **gcloud** - Google Cloud Platform CLI configuration
- **op** - 1Password CLI configuration
- **nixos-config** - NixOS system configuration
- **home-manager** - Nix-based dotfile management
- **flox** - Development environment manager

## 📝 Additional Configurations
- **git** - Version control configuration
- **tmuxinator** - Tmux session management
- **configu** - Configuration management
- **efm-langserver** - General purpose language server
- **ollama** - Local LLM configuration
- **github-copilot** - AI pair programming setup
- **VSCodium** - Free/libre distribution of VSCode
- **emacs/.spacemacs** - Emacs configuration (archived)

## 🎨 Themes & Appearance
- Custom color schemes and themes across all applications
- Consistent theming with Catppuccin variants
- Custom fonts configuration in `fonts/` directory

## 📋 Package Management
- **uv** - Python package manager configuration
- **flutter** - Flutter SDK configuration
- **nixpkgs** - Nix package configurations

