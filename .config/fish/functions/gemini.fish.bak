function gemini --argument-names model query view_in_pager
    set -l model_name
    set -l is_tty
    test -t 1; and set is_tty true; or set is_tty false

    if test "$model" = flash
        set model_name "gemini-2.5-flash-preview-04-17"
    else if test "$model" = pro
        set model_name "gemini-2.5-pro-exp-03-25"
    else
        echo "model not found"
        exit 1
    end

    set -l system_message "You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer."

    set -l spinner_pid 0
    set -l spinner_type dot
    if $is_tty; and type -q spinner
        printf '%b%s ' \r '⠏'
        fish -c "spinner --$spinner_type" &
        set spinner_pid $last_pid
    end

    # Capture the LLM output to a variable
    set -l llm_output (llm -m $model_name --system "$system_message" "$query")

    if test "$spinner_pid" -gt 0
        kill $spinner_pid
        echo -ne '\r'
    end

    # Display the LLM output
    if test "$view_in_pager" = true
        # echo "$llm_output" | bat --style plain --language markdown --paging always
        echo "$llm_output" | bat --style default --language markdown --paging always
    else
        echo "$llm_output"
    end
end

function start-spinner

end
