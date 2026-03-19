function git-blame --argument-names root line --description "View diff for a commit with difftastic"
    if not test -z $root
        set root $(pwd)
    end
    if not test -z $line
        echo "Please provide a line argument"
        exit 1
    end
    if not test -z $file
        echo "Please provide a file argument"
        exit 1
    end

    set commit $(git -C $root log --no-patch --format=%H -n 1 -L $line,+1:$file)

    command git -C $root --no-pager dshow "$commit" -- $file
end
