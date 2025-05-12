function spinner_start -d "Start a spinner with the specified style" -a style
    # Check if we're in a TTY
    set -l is_tty
    test -t 1; and set is_tty true; or set is_tty false

    # Only start spinner if we're in a TTY and the spinner function exists
    if $is_tty; and type -q spinner
        # Set default style to dot if not specified
        set -q style[1]; or set style dot

        # Start the spinner in the background
        fish -c "spinner --$style" &

        # Return the PID of the spinner process
        echo $last_pid
    else
        # Return 0 if spinner couldn't be started
        echo 0
    end
end

function spinner_stop -d "Stop a spinner by PID" -a spinner_pid
    # Only attempt to stop if we have a valid PID
    if test "$spinner_pid" -gt 0
        # Kill the spinner process
        kill $spinner_pid 2>/dev/null

        # Clear the spinner from the current line
        echo -ne '\r\033[K'
    end
end
