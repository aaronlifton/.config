function mcp-util --description "MCP utilities" --argument-names server action value
    set -l create_env_file true
    if test $server = claude
        # if action = "update-github-pat"
        if test $action = update-github-pat
            if test -z $GITHUB_PAT
                echo "Error: (GITHUB_PAT environment variable must be set"
                return 0
            end

            # Update github token in Claude MCP
            claude mcp add --transport http github https://api.githubcopilot.com/mcp/ --env GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PAT

            # Create .env file if it doesn't exist and flag is set
            if test $create_env_file = true
                if ! test -e .env
                    echo "Warning: .env file not found in the current directory, " \
                        "creating..."
                    touch .env
                end
                echo "GITHUB_PAT=$GITHUB_PAT" >>.env
                return
            end
        else
            echo "Unknown action: $action"
        end
    else
        echo "Unknown server: $server"
    end
end
