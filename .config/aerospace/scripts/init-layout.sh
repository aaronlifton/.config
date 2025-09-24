#!/bin/zsh
# AeroSpace Layout Presets
# Usage: layout-preset.sh [preset-name]

preset=$1

case $preset in
"dev")
  # Development layout: VSCode left 70%, terminal right 30%
  aerospace flatten-workspace-tree
  windows=$(aerospace list-windows --workspace focused --json)

  vscode_id=$(echo "$windows" | jq -r '.[] | select(.["app-name"] == "Code") | .["window-id"]' | head -1)
  terminal_id=$(echo "$windows" | jq -r '.[] | select(.["app-name"] == "ghostty" or .["app-name"] == "Terminal") | .["window-id"]' | head -1)

  if [[ -n "$vscode_id" && -n "$terminal_id" ]]; then
    aerospace focus --window-id "$vscode_id"
    aerospace move left
    aerospace resize width 1400

    aerospace focus --window-id "$terminal_id"
    aerospace move right
  fi
  ;;

"web")
  # Web research: Browser left 60%, notes right 40%
  aerospace flatten-workspace-tree
  windows=$(aerospace list-windows --workspace focused --json)

  browser_id=$(echo "$windows" | jq -r '.[] | select(.["app-name"] | test("Chrome|Firefox|Safari")) | .["window-id"]' | head -1)
  notes_id=$(echo "$windows" | jq -r '.[] | select(.["app-name"] == "Obsidian" or .["app-name"] == "Notes") | .["window-id"]' | head -1)

  if [[ -n "$browser_id" && -n "$notes_id" ]]; then
    aerospace focus --window-id "$browser_id"
    aerospace move left
    aerospace resize width 1200

    aerospace focus --window-id "$notes_id"
    aerospace move right
  fi
  ;;

"comm")
  # Communication: Slack/Discord in grid
  aerospace flatten-workspace-tree
  aerospace layout tiles
  ;;

"focus")
  # Single window focus mode
  aerospace close-all-windows-but-current
  aerospace fullscreen on
  ;;

*)
  echo "Available presets:"
  echo "  dev   - Development (VSCode + Terminal)"
  echo "  web   - Web research (Browser + Notes)"
  echo "  comm  - Communication grid"
  echo "  focus - Single window focus"
  ;;
esac
