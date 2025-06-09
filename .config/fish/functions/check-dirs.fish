function check-dirs
    # Split the PATH variable into individual directories using space as delimiter
    for dir in (string split ' ' (string join ' ' $argv))
        # Check if directory exists
        if test -d $dir
            # Print in green if directory exists
            set_color green
            echo "✓ $dir"
        else
            # Print in red if directory doesn't exist
            set_color red
            echo "✗ $dir"
        end
        # Reset color
        set_color normal
    end
end

# Example usage:
# check-dirs $PATH
