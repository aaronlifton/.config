#!/usr/bin/env python3.13
"""Interactive window picker using FZF for AeroSpace"""

import subprocess
import sys

def get_windows():
    """Get all windows with details from aerospace"""
    try:
        result = subprocess.run(
            ['aerospace', 'list-windows', '--all', '--format', '%{window-id}|%{app-name}|%{window-title}|%{workspace}'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error getting windows: {e}", file=sys.stderr)
        return ""

def select_window(windows):
    """Use fzf to select a window"""
    if not windows:
        return None

    fzf_cmd = [
        'fzf',
        '--delimiter=|',
        '--with-nth=2,3,4',
        '--preview=echo "App: {2}\\nTitle: {3}\\nWorkspace: {4}"',
        '--preview-window=up:3:wrap',
        '--header=Select window to focus',
        '--prompt=Window> '
    ]
    
    try:
        result = subprocess.run(
            fzf_cmd,
            input=windows,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return None

def focus_window(window_id):
    """Focus the selected window"""
    try:
        subprocess.run(
            ['aerospace', 'focus', '--window-id', window_id],
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error focusing window: {e}", file=sys.stderr)


def main():
    """Main function"""
    windows = get_windows()
    if not windows:
        print("No windows found", file=sys.stderr)
        sys.exit(1)
 
    selected = select_window(windows)
    if selected:
        window_id = selected.split('|')[0]
        focus_window(window_id)


if __name__ == "__main__":
    main()
