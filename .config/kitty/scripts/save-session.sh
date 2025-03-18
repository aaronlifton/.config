#!/usr/bin/env bash

set -eou pipefail

#kitty @ ls | ./scripts/kitty-save-session.py > session.conf
kitty @ ls | "$HOME"/.config/kitty/scripts/kitty-save-session.py >"$HOME"/.config/kitty/session.conf

echo "  Kitty session saved  "

echo
read -r -p "Press <enter> to exit"
echo ""
