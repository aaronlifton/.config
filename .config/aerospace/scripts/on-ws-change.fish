#!/usr/bin/env fish

set ws (test -n "$argv[1]"; and echo $argv[1]; or echo $AEROSPACE_FOCUSED_WORKSPACE)

set all_wins (aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{monitor-id}|%{workspace}')
set all_ws (aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# Array of possible window titles
set floating_titles Picture-in-Picture

# Function to find matching PIP windows
function find_windows_to_float
    set titles $argv[1]
    set result ""
    for title in (string split " " $titles)
        set matches (printf '%s\n' $all_wins | rg $title)
        if test -n "$matches"
            if test -z "$result"
                set result $matches
            else
                set result $result\n$matches
            end
        end
    end
    echo $result | sed '/^\s*$/d' # Remove empty lines
end

set pip_wins (find_windows_to_float $floating_titles)
set target_mon (printf '%s\n' $all_ws | rg "^$ws" | cut -d'|' -f2 | string trim)

function move_win
    set win $argv[1]

    test -n "$win"; or return 0

    set win_mon (echo $win | cut -d'|' -f4 | string trim)
    set win_id (echo $win | cut -d'|' -f1 | string trim)
    set win_ws (echo $win | cut -d'|' -f5 | string trim)

    # Skip if the monitor is already the target monitor or if the workspace matches
    test "$target_mon" != "$win_mon"; or return 0
    test "$ws" != "$win_ws"; or return 0

    aerospace move-node-to-workspace --window-id $win_id $ws
end

# Process each PIP window found
for win in (string split \n $pip_wins)
    move_win $win
end
