function git-log-delta --description "Git log with delta diff of commits"
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $argv | while read -l line
        echo $line
        if string match -qr '^[*|/\s]*([a-f0-9]+)' -- $line
            set -l commit_hash (string match -r '^[*|/\s]*([a-f0-9]+)' $line)[2]
            git show -p $commit_hash --color=always | delta
            echo
        end
    end
end
