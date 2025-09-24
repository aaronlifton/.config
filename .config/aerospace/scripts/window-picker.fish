#!/usr/bin/env fish
# Interactive window picker using FZF

# Get all windows with details
set windows (aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{workspace}')

# Use fzf to select a window
set selected (echo $windows | fzf \
    --delimiter='|' \
    --with-nth=2,3,4 \
    --preview='echo "App: {2}\nTitle: {3}\nWorkspace: {4}"' \
    --preview-window=up:3:wrap \
    --header='Select window to focus' \
    --prompt='Window> ')

# Focus the selected window
if test -n "$selected"
    set window_id (echo $selected | cut -d'|' -f1)
    aerospace focus --window-id $window_id
end

