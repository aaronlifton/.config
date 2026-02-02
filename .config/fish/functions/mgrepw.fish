function mgrepw --description "Search the web with mgrep and display with bat" --argument-names query
    command mgrep --web --answer "$query" \
        | sed -E 's/<cite/\n\n<cite/g' \
        | glow
end
