function font-info --argument-names font limit --description "Search for a font to scan with fc-scan"
    # Set default limit to 5 if not provided
    if test -z "$limit"
        set limit 5
    end

    # Find the first 5 matching font files in system and user font directories
    set -l font_basenames (fd --max-results $limit --format "{/}" $font /Library/Fonts ~/Library/Fonts)
    set -l font_paths (fd --max-results $limit --format "{}" $font /Library/Fonts ~/Library/Fonts)

    # If no fonts found, exit with message
    if test (count $font_basenames) -eq 0
        echo "Font not found."
        return 1
    end
    set -l num_choices (count $font_basenames)

    # Display the found fonts with numbers
    for i in (seq $num_choices)
        echo "$i: $font_basenames[$i]"
    end

    # Ask user to select a font
    read -P "Select font (1-"$num_choices"): " selection

    # Validate selection
    if test "$selection" -ge 1 -a "$selection" -le $num_choices
        echo "Selected: $selection"
        echo "Running `fc-scan "$font_paths[$selection]"`"
        fc-scan "$font_paths[$selection]" | $PAGER
    else
        echo "Invalid selection."
        return 1
    end
end
