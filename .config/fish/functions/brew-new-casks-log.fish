function brew-new-casks-log --description "Append newly announced Homebrew casks to a Markdown digest"
    set -l script_path "$HOME/.codex/skills/homebrew-new-casks/scripts/update_cask_digest.py"

    if not test -f "$script_path"
        echo "Missing skill script: $script_path" >&2
        return 1
    end

    if test (count $argv) -eq 0
        command python3 "$script_path" --run-update
    else
        command python3 "$script_path" $argv
    end
end
