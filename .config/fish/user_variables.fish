set -g fish_output_env_vars false
set -x nvm_default_version v21.7.1
set -x fish_config_path /Users/$USER/.config/fish

# Setting PATH for node
# fish_add_path /Users/$USER/.local/share/nvm/v19.7.0/bin
fish_add_path /usr/local/bin/
fish_add_path -m /Users/$USER/.asdf/shims
fish_add_path -m /opt/homebrew/bin
# fish_add_path -m /Users/$USER/.local/share/bob/nvim-bin
fish_add_path -m /Users/$USER/Code/venv/bin
# fish_add_path /opt/homebrew/opt/asdf/lib/exec/bin
# fish_add_path /opt/homebrew/opt/ccache/libexec
# fish_add_path /usr/local/llvm/bin 
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/libpq/bin
fish_add_path -m /Users/$USER/.local/bin
fish_add_path /Users/$USER/.cargo/bin
fish_add_path /Users/$USER/.asdf/installs/rust/1.80/bin

# bass source /Users/$USER/.cargo/env
fish_add_path /usr/local/texlive/2024/bin/universal-darwin
# fish_add_path /Users/$USER/Library/Python/3.11/bin 
# fish_add_path /Users/$USER/.rubies/truffleruby-23.1.1/bin/ 
fish_add_path /Users/$USER/go/bin
fish_add_path /usr/local/go/bin
fish_add_path /Users/$USER/.deno/bin
# fish_add_path /Users/$USER/.luarocks/bin 
fish_add_path /opt/homebrew/opt/postgresql@16/bin
fish_add_path /usr/sbin # for chown
if test -d "/Applications/Emacs.app/Contents/MacOS/bin"
    fish_add_path "/Applications/Emacs.app/Contents/MacOS/bin"
    alias emacs="emacs -nw" # Always launch "emacs" in terminal mode.
end
fish_add_path /Users/$USER/.config/emacs/bin
# fish_add_path /opt/homebrew/sbin
fish_add_path /Users/$USER/.pixi/bin

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"

set -x LUA_PATH '/opt/homebrew/lib/luarocks/rocks-5.4/?.lua;/opt/homebrew/Cellar/luarocks/3.9.2/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;/opt/homebrew/lib/lua/5.4/?.lua;/opt/homebrew/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/Users/$USER/.luarockw/share/lua/5.4/?.lua;/Users/$USER/.luarocks/share/lua/5.4/?/init.lua;/Users/$USER/.luarockw/share/lua/5.1/?.lua;/Users/$USER/.luarocks/share/lua/5.1/?/init.lua;'
# set -x LUA_PATH '/Users/$USER/.local/share/nvim/site/pack/packer/opt/packer.nvim/?.lua;' $LUA_PATH
set -x LUA_CPATH '/opt/homebrew/lib/lua/5.4/?.so;/opt/homebrew/lib/lua/5.4/loadall.so;./?.so;/Users/$USER/.luarocks/lib/lua/5.4/?.so'

# so compilers can find postgres
set -lx POSTGRES_LDFLAG "-L/opt/homebrew/opt/postgresql@16/lib"
set -lx LLVM_LDFLAG "-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib"
# set -x LDFLAGS $LLVM_LDFLAG $POSTGRES_LDFLAG
#               -L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib, -L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib, -L/opt/homebrew/opt/postgresql@16/lib
set -x CPPFLAGS "-I/opt/homebrew/opt/llvm/include,-I/opt/homebrew/opt/postgresql@16/include"

# set -x lazy_path /Users/$USER/.local/share/nvim/lazy
set -x lazy_path /Users/$USER/.local/share/nvim/lazy
# set -x lazyvim_path /Users/$USER/.local/share/nvim/lazy/LazyVim
set -x lazyvim_path /Users/$USER/.local/share/nvim/lazy/LazyVim
set -x texlocalpath /usr/local/texlive/texmf-local

## Variables
# set -gx WX_WIDGETS_PATH /Users/$USER/Code/ios-cpp-app/wxWidgets-3.2.2.1/build-cocoa-debug/wx-config
set -gx CC clang
set -gx CXX clang++
# set -U fish_history always


# Nvim
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx NVIM_APPNAME nvim

# lunarvim
# set -gx LUNARVIM_RUNTIME_DIR /Users/$USER/.local/share/lunarvim
set -gx LUNARVIM_CONFIG_DIR $LUNARVIM_CONFIG_DIR
set -gx LUNARVIM_CACHE_DIR $LUNARVIM_CACHE_DIR
set -gx LUNARVIM_BASE_DIR $LUNARVIM_BASE_DIR

# astrovim
# set -gx ASTROVIM_RUNTIME_DIR /Users/$USER/.local/share/astrovim
set -gx ASTROVIM_CONFIG_DIR $ASTROVIM_CONFIG_DIR
set -gx ASTROVIM_CACHE_DIR $ASTROVIM_CACHE_DIR
set -gx ASTROVIM_BASE_DIR $ASTROVIM_BASE_DIR

# doomvim
# set -gx DOOMVIM_RUNTIME_DIR /Users/$USER/.config/doom-nvim
set -gx DOOMVIM_CONFIG_DIR $DOOMVIM_CONFIG_DIR
set -gx DOOMVIM_CACHE_DIR $DOOMVIM_CACHE_DIR
set -gx DOOMVIM_BASE_DIR $DOOMVIM_BASE_DIR

# nyoom.nvim
# set -gx NYOOM_RUNTIME_DIR /Users/$USER/.config/nyoom.nvim

set -gx CMAKE_MAKE_PROGRAM /opt/homebrew/bin/cmake
# set -gx OBSIDIAN_VAULT_PATH "/Users/$USER/Documents/$USERs Vault"
# set -gx OBSIDIAN_VAULT_CONFIG_PATH $OBSIDIAN_VAULT_PATH/.obsidian
set -gx FONT_PATH /Users/$USER/Library/Fonts
set -gx EDITOR nvim
# set -gx TMUXINATION_LAYOUTS "/Users/$USER/.config/tmuxinator/layouts"
# set -gx TLDR_CONFIG_1AATH "/Users/$USER/Library/Application Support/tealdeer/pages"
set -gx OLLAMA_API_HOST "http://localhost:11434" # "https://api.ollama.com"
set -gx NPM_CLIENT /opt/homebrew/bin/npm
set -gx TERM xterm-256color
# set -gx ANDROID_HOME /Users/$USER/Library/Android/sdk
set -gx GOPROXY https://proxy.golang.org/cached-only
set -gx RUBY_CONFIGURE_OPTS --enable-yjit
# set -gx DOCKER_DEFAULT_PLATFORM linux/amd64

# Themes
source "fzf.fish"

## Pager
set -gx PAGER nvimpager
# Doesn't work with bob nvim
set -gx NVIMPAGER_NVIM /opt/homebrew/bin/nvim
# set -gx MANPAGER "PAGER=less col -bx | bat -l man -p"

## Bat
set -gx BAT_PAGER "less -RFX"
if type -q vivid
    # set -xg LS_COLORS (vivid generate catppuccin-macchiato)
    set -xg LS_COLORS (vivid generate tokyonight-moon)
end
set -xg BAT_THEME tokyonight_moon #Catppuccin-macchiato

## Starship
set -xg STARSHIP_LOG error


if test -f "work_variabes.fish"
    source "work_variabes.fish"
end
# TODO: move into above file
set -xg GOPRIVATE git.synack.com
# set -xg PRETTIERD_DEFAULT_CONFIG /Users/alifton/.config/nvim/rules/.prettierrc.json

if type -q hx
    # For helix-gpt
    set -xg HANDLER copilot
    set -xg MODULITH_RULES /Users/alifton/synack/client-modulith/.cursor/
end
