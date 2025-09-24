#!/bin/zsh
# Interactive window picker using FZF

# Get all windows with details
windows=$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{workspace}')

# Use fzf to select a window
selected=$(echo "$windows" | fzf \
    --delimiter='|' \
    --with-nth=2,3,4 \
    --preview='echo "App: {2}\nTitle: {3}\nWorkspace: {4}"' \
    --preview-window=up:3:wrap \
    --header='Select window to focus' \
    --prompt='Window> ')

# Focus the selected window
if [[ -n "$selected" ]]; then
    window_id=$(echo "$selected" | cut -d'|' -f1)
    aerospace focus --window-id "$window_id"
fi