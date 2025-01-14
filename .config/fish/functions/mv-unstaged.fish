# Examples
# `mv-unstaged destination/` - moves all unstaged files
# `mv-unstaged destination/ "\.txt$"` - moves only unstaged .txt files
# `mv-unstaged destination/ "pattern"` - moves only unstaged files matching "pattern"
function mv-unstaged --description "Move unstaged files to a destination folder" -a destination -a filter
    if test -z "$destination"
        echo "Please provide a destination folder."
        return 1
    end

    if not test -d "$destination"
        echo "Destination folder does not exist. Creating it..."
        mkdir -p "$destination"
    end

    set -l unstaged_files
    if test -n "$filter"
        # If filter is provided, use rg to filter the results
        set unstaged_files (git ls-files --others --exclude-standard | rg "$filter")
    else
        # If no filter, get all unstaged files
        set unstaged_files (git ls-files --others --exclude-standard)
    end

    if test -z "$unstaged_files"
        echo "No unstaged files found."
        return 0
    end

    for file in $unstaged_files
        mv "$file" "$destination/"
        echo "Moved: $file"
    end

    echo "All unstaged files have been moved to $destination"
end
