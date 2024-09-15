function fzf-dh -d "Fuzzy search directory history"
    set -l result (
        dirh |
        grep -v '^\s*$' |
        fzf --ansi --with-nth=2 --tiebreak=end --preview='tree -C -L 1 -hp --dirsfirst {1}' |
        string split -f2 ') '
    ); and cd "$result"
end
