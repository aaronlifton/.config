#!/usr/bin/env sh

ws=${1:-$AEROSPACE_FOCUSED_WORKSPACE}

IFS='
' all_wins=$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{monitor-id}|%{workspace}')
IFS='
' all_ws=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# Array of possible window titles (POSIX-compliant)
floating_titles="Picture-in-Picture"

# Function to find matching PIP windows
find_windows_to_float() {
  titles="$1"
  result=""
  for title in $titles; do
    matches=$(printf '%s\n' "$all_wins" | rg "$title")
    if [ -n "$matches" ]; then
      if [ -z "$result" ]; then
        result="$matches"
      else
        result="$result
$matches"
      fi
    fi
  done
  echo "$result" | sed '/^\s*$/d' # Remove empty lines
}

pip_wins=$(find_windows_to_float "$floating_titles")
target_mon=$(printf '%s\n' "$all_ws" | rg "^$ws" | cut -d'|' -f2 | xargs)

move_win() {
  win="$1"

  [ -n "$win" ] || return 0

  win_mon=$(echo "$win" | cut -d'|' -f4 | xargs)
  win_id=$(echo "$win" | cut -d'|' -f1 | xargs)
  win_ws=$(echo "$win" | cut -d'|' -f5 | xargs)

  # Skip if the monitor is already the target monitor or if the workspace matches
  [ "$target_mon" != "$win_mon" ] && return 0
  [ "$ws" = "$win_ws" ] && return 0

  aerospace move-node-to-workspace --window-id "$win_id" "$ws"
}

# Process each PIP window found
IFS='
'
for win in $pip_wins; do
  move_win "$win"
done
