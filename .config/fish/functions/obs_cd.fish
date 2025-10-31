function obs_cd --description "cd to default Obsidian vault"
    set result (obsidian-cli print-default --path-only)
    if test -n "$result"
        cd -- "$result"
    end
end
