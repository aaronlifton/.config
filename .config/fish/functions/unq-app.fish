# Usage: unquarantine-app "/Applications/Alacritty.app"
function unq-app --argument-names fullpath --description "deletes the com.apple.quarantine so the app can be run"
    xattr -d com.apple.quarantine $fullpath
end
