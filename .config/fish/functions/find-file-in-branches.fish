function find-file-in-branches
    for b in (git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads | head -n 15)
        echo "===== $b"
        if git cat-file -e "$b:server/spec/factories/users.rb" 2>/dev/null
            git show "$b:server/spec/factories/users.rb"
        else
            echo "server/spec/factories/users.rb not found in $b"
        end
        echo
    end
end
