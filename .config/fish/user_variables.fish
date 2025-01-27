set -g fish_output_env_vars false
set -x nvm_default_version v21.7.1

# Setting PATH for node
# fish_add_path /Users/$USER/.local/share/nvm/v19.7.0/bin
fish_add_path /usr/local/bin/
fish_add_path -m /Users/$USER/.asdf/shims
fish_add_path -m /opt/homebrew/bin
fish_add_path -m /Users/$USER/.local/share/bob/nvim-bin
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
# fish_add_path /opt/homebrew/sbin

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
## FZF
set -xg FZF_DEFAULT_COMMAND fd
# Catpuccion Mocha
# set -xg FZF_DEFAULT_OPTS "--height=90% --layout=reverse --info=inline --border rounded --margin=1 --padding=1 \
# --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
# --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
# --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
# --bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'"

# Tokyo night moon (/Users/$USER/.local/share/nvim/lazy/tokyonight.nvim/extras/fzf/tokyonight_moon.sh)
# set -xg FZF_DEFAULT_OPTS "--height=90% --layout=reverse --info=inline --border rounded --margin=1 --padding=1 \
set -xg FZF_DEFAULT_OPTS "--height=90% --layout=reverse --info=right --border rounded --margin=1 \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
  --bind=ctrl-b:preview-page-up,ctrl-f:preview-page-down,\
ctrl-u:half-page-up,ctrl-d:half-page-down,\
shift-up:preview-top,shift-down:preview-bottom,\
alt-up:half-page-up,alt-down:half-page-down,\
alt-g:first,\
ctrl-x:jump,jump-cancel:abort
"
#   --bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | pbcopy)' \
#   ctrl-y:preview-up,ctrl-e:preview-down,\
#   ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,\
#   ctrl-x:jump,jump:accept,jump-cancel:abort
# "

# Tried these for padding background
# --color=preview-border:#1e2030 \
# --color=preview-bg:#1e2030 \
# --color=label:#1e2030 \
# --color=preview-fg:#1e2030 \

# Transparent
# set -xg FZF_DEFAULT_OPTS "--height=90% --layout=reverse --info=right --border rounded --margin=1 \
#   --color=bg+:#2d3f76 \
#   --color=bg:-1 \
#   --color=border:#589ed7 \
#   --color=fg:#c8d3f5 \
#   --color=gutter:-1 \
#   --color=header:#ff966c \
#   --color=hl+:#65bcff \
#   --color=hl:#65bcff \
#   --color=info:#545c7e \
#   --color=marker:#ff007c \
#   --color=pointer:#ff007c \
#   --color=prompt:#65bcff \
#   --color=query:#c8d3f5:regular \
#   --color=scrollbar:#589ed7 \
#   --color=separator:#ff966c \
#   --color=spinner:#ff007c \
# "
set -xg _ZO_FZF_OPTS $FZF_DEFAULT_OPTS
# set -xg fzf_preview_dir_cmd eza --long --header --icons --all --color=always --group-directories-first --hyperlink
set -xg fzf_preview_dir_cmd lsd --color always --tree --depth 1
set -xg fzf_fd_opts --hidden --color=always

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

set -xg GOPRIVATE git.synack.com

# set -xg PRETTIERD_DEFAULT_CONFIG /Users/alifton/.config/nvim/rules/.prettierrc.json
