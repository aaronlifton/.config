function fzf-git-branches -d "Select a git branch"
    set -l branch (
        git --no-pager branch -v --color=always --sort=-committerdate |
        fzf --ansi --no-multi --preview='git log -5 {1} | bat --color=always --style=plain' |
        string trim |
        string split -f1 ' '
    )

    if test $status -eq 0
        if status is-interactive
            commandline -it "$branch"
        else
            git checkout "$branch"
        end
    end

    # Necessary to get the prompt back again otherwise you have to press enter
    # yourself or something similar to get the prompt back
    commandline --function repaint
end
fzf-git-branches
