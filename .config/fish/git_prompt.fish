function fish_right_prompt

    if is_git
        set_color yellow
        echo -n (git_branch)
        set_color normal
        echo -n ' '
    end

    set_color blue
    echo -n (basename (pwd | sed "s#$HOME#\~#"))
    set_color normal
end

function git_branch
    if is_git
        echo (git rev-parse --abbrev-ref HEAD 2> /dev/null)
    end
end

function is_status_okay
    [ $status = 0 ]
end

function is_git_dirty
    is_git; and [ (git status | tail -n1) != "nothing to commit, working directory clean" ]
end

function is_git_ahead
    set -l revs (git rev-list origin/(git_branch)..HEAD ^ /dev/null)
    [ "$revs" != "" ]
end

function is_git
    git symbolic-ref HEAD >/dev/null 2>&1
end
