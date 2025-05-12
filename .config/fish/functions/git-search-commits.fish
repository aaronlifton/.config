function git-search-commits --argument-names query --description "Find text in commit history and show matches from the N most recent commits"
    if not set -q query
        echo "Usage: git-search-commits <query_string>"
        return 1
    end

    set -l num_commits 5 # How many recent commits containing matches to show

    # 1. Find the N most recent commits that contain the search query.
    #    -G "$query": Find commits where the diff includes added/removed lines matching the pattern.
    #    --pretty=format:"%H": Output just the commit hash.
    #    -n $num_commits: Limit to the N most recent *of the commits found by -G*.
    #    --all: Ensure we search all reachable history (if not default).
    #    Use -- to separate options from potential file paths if you ever added those.
    set -l matching_commits (git log -G "$query" --pretty=format:"%H" -n $num_commits --all --color=never --)

    # Check if git log found any matching commits
    # Check exit status first for actual errors
    if test $pipestatus[1] -ne 0
        echo "Error running git log to find matching commits. Check your query." >&2
        # Optionally print stderr from git log: begin; git log ... end 2>&1
        return 1
    end
    # Then check if the list is empty
    if test (count $matching_commits) -eq 0
        echo "No commits found containing the query: '$query'"
        return 0
    end

    echo # Add a blank line before the first commit output

    # 2. For each matching commit (most recent first), run git grep
    #    to get the specific matches and format them with heading/break.
    #    git log -n outputs the newest commits first, so this loop processes them in the correct order.
    for commit_hash in $matching_commits
        # Run git grep on this specific commit hash.
        # --heading --break: Format output with commit info and file breaks.
        # --color=always: Keep color in piped output.
        # -n: Show line numbers.
        # -e "$query": The pattern.
        # "$commit_hash": The specific commit tree to search.
        # Use -- to separate options from files/refs.
        git grep --heading --break --color=always -n -e "$query" "$commit_hash" --

        # Check git grep exit status - 0 means found matches, 1 means no matches in *this* commit
        # (which shouldn't happen if git log -G worked correctly, but good practice)
        # >1 usually indicates an error.
        if test $pipestatus[1] -gt 1
            echo "Error running git grep on commit $commit_hash" >&2
            # Continue to the next commit, don't necessarily exit the function
        end

        # Add a blank line between commit outputs unless it's the last one
        if test $commit_hash != $matching_commits[-1]
            echo
        end
    end

    echo # Final blank line

    # Optional: Add a note about the limit if we found the maximum number
    if test (count $matching_commits) -eq $num_commits
        echo "(Showing matches from the $num_commits most recent commits found containing the query.)"
    end
end
