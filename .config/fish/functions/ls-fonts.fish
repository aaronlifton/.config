function ls-fonts --description "Prettifies system_profiler SPFontsDataType output by listing font name and path"
    # Check if jq is installed
    if ! command -v jq >/dev/null
        echo "Error: jq is not installed. Please install it to use this function."
        echo "  e.g., brew install jq"
        return 1
    end

    echo "Fetching font information..."

    # Run system_profiler, pipe JSON output to jq for processing
    # jq selects the SPFontsDataType array, iterates through each item,
    # and formats the output string for each font entry.
    /usr/sbin/system_profiler SPFontsDataType -json | jq '.SPFontsDataType[] | .typefaces[] | {name: ._name, family: .family, style: .style}'

    echo "Done."
end
