#!/usr/bin/env fish

# Function to set up the yadm shell prompt
function fish_prompt
    set -l normal (set_color normal)
    set -l blue (set_color blue)
    echo -n "$blue""yadm shell ($YADM_REPO) $PWD > ""$normal"
end

# Main script
if not test -x "$SHELL"
    echo "ERROR: \$SHELL does not refer to an executable." >&2
    exit 1
end

if not test -d "$YADM_REPO"
    echo "ERROR: Git repo does not exist. did you forget to run 'init' or 'clone'?" >&2
    exit 1
end

# Export required git variables
set -gx GIT_WORK_TREE "$YADM_WORK"

if test (count $argv) -eq 0
    echo "Entering yadm repo"
    # Start interactive shell
    fish
    set -l return_code $status
    echo "Leaving yadm repo"
    exit $return_code
else
    # Execute command and exit
    fish -c "$argv"
    exit $status
end
