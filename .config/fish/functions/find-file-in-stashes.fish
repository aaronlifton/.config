function find-file-in-stashes --argument-names path
    for s in (git stash list --format='%gd')
        if git cat-file -e "$s:$path" 2>/dev/null
            echo "===== $s"
            echo "git checkout $s -- $path"
            echo
        else if git cat-file -e "$s^3:$path" 2>/dev/null
            echo "===== $s"
            echo "# untracked file stored in stash's third parent"
            echo "git checkout $s^3 -- $path"
            echo
        end
    end
end
