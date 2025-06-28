# Define the function set-plist with a description
function set-plist --description "manage the com.github.ra-multiplex launch agent"

    # Define the path to the specific plist file
    # Using $HOME ensures correct path expansion for the current user
    set -l plist_path "$HOME/Library/LaunchAgents/com.github.ra-multiplex.plist"

    # Check if an argument was provided
    if test (count $argv) -ne 1
        echo "Usage: set-plist [load|status|unload]"
        echo "  load    - Load/start the launch agent defined in $plist_path"
        echo "  status  - Check if the launch agent is currently loaded by launchd"
        echo "  unload  - Unload/stop the launch agent"
        return 1 # Indicate an error due to incorrect arguments
    end

    # Get the command argument (load, status, or unload)
    set -l command $argv[1]

    # Perform action based on the provided argument
    switch $command
        case load
            echo "Attempting to load launch agent: $plist_path"
            # Use launchctl load to tell launchd about this agent.
            # If RunAtLoad is true in the plist, it will also start the program.
            launchctl load "$plist_path"

            # Check the exit status of the launchctl command
            if test $status -eq 0
                echo "Successfully sent load command."
                echo "If 'RunAtLoad' is true in the plist, the service should now be running."
                echo "Check status using 'set-plist status'."
            else
                echo "Failed to load launch agent."
                echo "Ensure the plist file exists at $plist_path and has correct permissions."
                return 1 # Indicate failure
            end

        case status
            echo "Checking status for launch agent label: com.github.ra-multiplex"
            # Use launchctl list and grep to see if the agent with this label is loaded.
            # grep's exit status will be 0 if found, non-zero otherwise.
            launchctl list | grep com.github.ra-multiplex

            # Check the exit status of the grep command
            if test $status -eq 0
                echo "Launch agent 'com.github.ra-multiplex' is currently loaded."
            else
                echo "Launch agent 'com.github.ra-multiplex' is NOT loaded."
                # Return grep's status directly (0 for found, 1 for not found)
                return $status
            end

        case unload
            echo "Attempting to unload launch agent: $plist_path"
             # Use launchctl unload to stop the running service and prevent it from starting at next login.
            launchctl unload "$plist_path"

            # Check the exit status of the launchctl command
            if test $status -eq 0
                echo "Successfully sent unload command."
                echo "Launch agent should now be stopped and will not load automatically."
            else
                echo "Failed to unload launch agent."
                echo "It may not have been loaded, or the plist file path is incorrect."
                 # launchctl unload returns non-zero if the service wasn't found, which is expected if it wasn't loaded
                 return $status
            end


        case '*' # Default case for any argument other than load, status, or unload
            echo "Invalid argument: $command"
            echo "Usage: set-plist [load|status|unload]"
            echo "  load    - Load/start the launch agent defined in $plist_path"
            echo "  status  - Check if the launch agent is currently loaded by launchd"
            echo "  unload  - Unload/stop the launch agent"
            return 1 # Indicate an error due to invalid command

    end

    return 0 # Indicate overall success if a valid command completed

end

