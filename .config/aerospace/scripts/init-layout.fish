#!/usr/bin/env fish
# AeroSpace Layout Presets
# Usage: init-layout.fish [preset-name]

set preset $argv[1]

switch $preset
    case dev
        # Development layout: VSCode left 70%, terminal right 30%
        aerospace flatten-workspace-tree
        set windows (aerospace list-windows --workspace focused --json)

        set vscode_id (echo "$windows" | jq -r '.[] | select(.["app-name"] == "Code") | .["window-id"]' | head -1)
        set terminal_id (echo "$windows" | jq -r '.[] | select(.["app-name"] == "ghostty" or .["app-name"] == "Terminal") | .["window-id"]' | head -1)

        if test -n "$vscode_id" -a -n "$terminal_id"
            aerospace focus --window-id "$vscode_id"
            aerospace move left
            aerospace resize width 1400

            aerospace focus --window-id "$terminal_id"
            aerospace move right
        end

    case web
        # Web research: Browser left 60%, notes right 40%
        aerospace flatten-workspace-tree
        set windows (aerospace list-windows --workspace focused --json)

        set browser_id (echo "$windows" | jq -r '.[] | select(.["app-name"] | test("Chrome|Firefox|Safari")) | .["window-id"]' | head -1)
        set notes_id (echo "$windows" | jq -r '.[] | select(.["app-name"] == "Obsidian" or .["app-name"] == "Notes") | .["window-id"]' | head -1)

        if test -n "$browser_id" -a -n "$notes_id"
            aerospace focus --window-id "$browser_id"
            aerospace move left
            aerospace resize width 1200

            aerospace focus --window-id "$notes_id"
            aerospace move right
        end

    case comm
        # Communication: Slack/Discord in grid
        aerospace flatten-workspace-tree
        aerospace layout tiles

    case focus
        # Single window focus mode
        aerospace close-all-windows-but-current
        aerospace fullscreen on

    case "*"
        echo "Available presets:"
        echo "  dev   - Development (Kitty)"
        echo "  web   - Web research (Browser + Obsidian)"
        echo "  comm  - Communications"
        echo "  focus - Single window focus"
end
