function git-grep-author --argument-names query
    git grep -l $query | xargs -n1 git blame -f -l | rg $query | tail -n 10
end
