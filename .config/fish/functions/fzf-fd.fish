function fzf-fd --description "Fuzzy find files in the current directory using fd and fzf"
    set -l fd_args ""
    set -l fd_hidden -u # Initially include hidden files

    # Function to toggle -u flag
    function toggle_hidden
        if contains -q -u $fd_hidden
            set -l fd_hidden ""
            echo "Showing hidden files"
        else
            set fd_hidden -u
            echo "Hiding hidden files"
        end
    end

    # Keybinding for toggling hidden files
    string escape -- $fd_hidden | read escaped_fd_hidden
    fd . $escaped_fd_hidden --print0 |
        fzf --bind "alt-h:execute(toggle_hidden)" \
            --bind "alt-a:execute(open {})" \
            --bind "alt-e:execute(\$EDITOR {})" \
            --bind "alt-n:execute(nvim {})" \
            --bind "alt-c:execute(cat {})" \
            --prompt "Find file: " \
            --preview "bat --style=plain --color=always --wrap=character --line-range :500 {}" \
            --preview-window="right:50%" \
            --exit-0 \
            --reverse \
            --border \
            --height "50%" \
            --inline-info \
            --header "Use ALT-H to toggle hidden files" \
            --multi \
            --select-1 \
            --exit-0 \
            --tiebreak=index \
            --query "$READLINE_LINE" \
            --read0 \
            --print0 | while read -lz selected
        if test -n "$selected"
            switch $fzf_key
                case enter
                    # Open the selected file
                    open "$selected"
            end
        end
    end
end
