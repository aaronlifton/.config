#!/opt/homebrew/bin/fish
# Fuzzy search Git branches in a repo
# Looks for local and remote branches
function fsb
    set -l pattern (string join ' ' $argv)
    set -l branches (git branch --all | awk 'tolower($0) ~ /'"$pattern"'/')

    if test -z "$branches"
        echo "[fsb] No branches match the provided pattern"
        return 1
    end

    set -l branch (echo "$branches" | fzf-tmux -p --reverse -1 -0 +m)

    if test -z "$branch"
        echo "[fsb] No branch selected"
        return 1
    end

    # Extract branch name, removing leading whitespace and remote prefix
    set -l branch_name (echo "$branch" | sed 's/.* //' | sed 's#remotes/[^/]*/##')
    git checkout "$branch_name"
end
