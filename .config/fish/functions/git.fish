function git-mr
    if test (count $argv) -gt 0
        git log --oneline --name-only HEAD~$ARGV[1]..HEAD
    else
        git log --oneline --name-only HEAD~10..HEAD
    end
end
