#!/usr/bin/env fish
# AeroSpace Layout Presets
# Usage: aerospace-wm.fish [preset-name]

set preset $argv[1]

switch $preset
    case "center"
        open "raycast://extensions/raycast/window-management/center"
    case "center wide"
        open "raycast://extensions/raycast/window-management/center?width=1280&height=720"
    case "center small"
        open "raycast://extensions/raycast/window-management/center?width=800&height=600"
    case "center large"
        open "raycast://extensions/raycast/window-management/center?width=1600&height=1000"
    case "*"
        echo "Available presets:"
        echo "  center       - Center window"
        echo "  center wide  - Center wide (1280x720)"
        echo "  center small - Center small (800x600)"
        echo "  center large - Center large (1600x1000)"
        # echo "  comm         - Communications"
        # echo "  focus        - Single window focus"
end
