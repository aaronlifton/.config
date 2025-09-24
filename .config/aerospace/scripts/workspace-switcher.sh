#!/bin/zsh
# Quick workspace switcher with preview

# Get current workspace
current=$(aerospace list-workspaces --focused)

# Get all workspaces with window counts
workspaces=$(aerospace list-workspaces --monitor all | while read -r ws; do
    count=$(aerospace list-windows --workspace "$ws" | wc -l | tr -d ' ')
    windows=$(aerospace list-windows --workspace "$ws" --format '%{app-name}' | tr '\n' ', ' | sed 's/,$//')
    if [[ "$ws" == "$current" ]]; then
        echo "* $ws ($count) - $windows"
    else
        echo "  $ws ($count) - $windows"
    fi
done)

# Select workspace with fzf
selected=$(echo "$workspaces" | fzf \
    --header="Select workspace (current: $current)" \
    --preview='workspace=$(echo {} | sed "s/[* ] //" | cut -d" " -f1); aerospace list-windows --workspace "$workspace" --format "%{app-name}: %{window-title}"' \
    --preview-window=right:50%:wrap \
    --height=40% \
    --prompt="Workspace> ")

# Switch to selected workspace
if [[ -n "$selected" ]]; then
    workspace=$(echo "$selected" | sed 's/[* ] //' | cut -d' ' -f1)
    aerospace workspace "$workspace"
fi