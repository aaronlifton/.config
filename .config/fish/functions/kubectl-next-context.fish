function kubectl-next-context --description "Switch to the next kubectl context"
    # Get all contexts and current context
    set -l contexts (kubectl config get-contexts -o name)
    set -l current_context (kubectl config current-context)

    # Find the index of current context
    set -l current_index 1
    for i in (seq (count $contexts))
        if test "$contexts[$i]" = "$current_context"
            set current_index $i
            break
        end
    end

    # Calculate next index (wrap around to 1 if at the end)
    set -l next_index (math "$current_index + 1")
    if test $next_index -gt (count $contexts)
        set next_index 1
    end

    # Switch to next context
    set -l next_context $contexts[$next_index]
    echo "Switching from $current_context to $next_context"
    kubectl config use-context $next_context
end
