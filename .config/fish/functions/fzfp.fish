function fzfp --argument-names query filename --description "fzf with basic preview"
    if test -z $query
        echo "Must provide a query"
        return
    end

    # set -l preview 'bat $argv[1]{}'
    set -l preview 'ext=${{}:-%{}}; ext=${ext##*.}; if [[ -n $ext ]]; then bat -l $ext $argv[1]{}; else bat $argv[1]{}; fi'
    if test -n $filename
        rg -uu "$query" -g $filename --files-with-matches | fzf --preview "$preview"
    else
        rg -uu "$query" --files-with-matches | fzf --preview "$preview"
    end
end
