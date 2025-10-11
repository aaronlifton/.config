# Disable conflicting keybinding with Nvim
# bind \cr true
bind --erase --preset \cr

## Already bound to <C-u> ?
# Unbind Ctrl+k and rebind to Alt+k
# bind --erase --preset \ck
# bind \ek backward-kill-line

# alt+shift+q
# bind \eQ fzf-zoxide
# alt+q
bind \eq fzf-zoxide

bind \ey yazi

# fish_vi_key_bindings --no-erase

# Workaround for https://github.com/zellij-org/zellij/issues/3852
if not string match --entire -- "$ZELLIJ_SESSION_NAME" "" >/dev/null
    bind ctrl-h backward-kill-token
end
