function html2md --description "Convert HTML files to Markdown format using html2markdown"
    # Convert HTML to Markdown using html2markdown
    if test (count $argv) -eq 0
        echo "Usage: html2md <input.html> [output.md]"
        return 1
    end
    set input_file $argv[1]
    if test (count $argv) -eq 2
        set output_file $argv[2]
    else
        set output_file (string replace -r '\.html?$' '.md' $input_file)
    end
    if not test -f $input_file
        echo "Input file '$input_file' does not exist."
        return 1
    end
    bat --style plain $input_file | html2markdown >$output_file
    if test $status -eq 0
        echo "Converted '$input_file' to '$output_file'."
    else
        echo "Failed to convert '$input_file'."
        return 1
    end
end
