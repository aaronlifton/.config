set -x ATUIN_NOBIND true

if status is-interactive
    if type -q atuin
        atuin init fish | source
    end
end

bind \er _atuin_search
# bind \eup _atuin_bind_up
# bind \eOA _atuin_bind_up
# shift-up (via fish_key_reader)
bind \e\[1\;2A _atuin_bind_up

if bind -M insert >/dev/null 2>&1
    bind -M insert \er _atuin_search
    # bind -M insert up _atuin_bind_up
    # bind -M insert \eOA _atuin_bind_up
    bind -M insert \e\[1\;2A _atuin_bind_up
end
