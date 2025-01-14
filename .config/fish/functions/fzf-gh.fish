function fzf-gh --description 'Git log with fzf'
    set -l is_yadm (command yadm rev-parse --abbrev-ref HEAD)
    set -l git_command git
    if test -n $is_yadm
        # set git_command yadm
    end

    $git_command log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $argv |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --preview \
            'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || $git_command show --color=always $1 ; }; f {}' \
            --header "enter to view, ctrl-o to checkout" \
            --bind "q:abort,ctrl-f:preview-page-down,ctrl-b:preview-page-up" \
            --bind "ctrl-o:become:(echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs $git_command checkout)" \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c '$git_command show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:60%
end
