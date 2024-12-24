function ls-modified-dirs --description "List all modified directories"
    fd --type d --max-depth 1 | while read -l dir
        if test -d "$dir/.git"; or git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1
            set -l git_status (git -C "$dir" status --porcelain)
            if test -n "$git_status"
                echo $dir
            end
        end
    end
end
