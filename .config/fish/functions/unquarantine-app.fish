# Usage: unquarantine-app "/Applications/Alacritty.app" [--recursive]
function unquarantine-app --argument-names fullpath --description "deletes the com.apple.quarantine so the app can be run"
    argparse r/recursive -- $argv
    or return

    set -l xattr_cmd xattr -d

    if set -q _flag_recursive
        set xattr_cmd xattr -rd
    end

    sudo $xattr_cmd com.apple.quarantine $fullpath
end
