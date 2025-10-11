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
ctrl-x:jump,jump-cancel:abort"

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

# For `zoxide query -i`
set -xg _ZO_FZF_OPTS $FZF_DEFAULT_OPTS --no-sort --exact

# set -xg fzf_preview_dir_cmd eza --long --header --icons --all --color=always --group-directories-first --hyperlink
set -xg fzf_preview_dir_cmd lsd --color always --tree --depth 1
set -xg fzf_fd_opts --hidden --color=always
