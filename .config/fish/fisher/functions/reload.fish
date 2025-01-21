function reload
    # Help
    function __help -d "show help"
        printf "usage: reload [-h] [-c command] [-e 'env1=value1'] [-e 'env2=value2']\n\n"

        printf "positional arguments:\n"
        printf "\n"

        printf "optional arguments:\n"
        printf "  -h, --help          show this help message and exit\n"
        printf "  -c, --command       command to be executed before reloading\n"
        printf "  -e, --env           environment variable to be set before reloading\n"
        printf "\n"

        return 0
    end

    # Parse arguments
    set -l options h/help "c/command=" "e/env=+"
    argparse $options -- $argv || return 1

    # Show help
    set -q _flag_help && __help && return 0

    # Create unset options
    # Was causing the error "env: unsetenv : Invalid argument"
    # for env_var in (env)
    #     set key (string split = "$env_var")[1]
    #     if not contains "$key" $RELOAD_PROTECTED_ENV_VARS
    #         set unset_options $unset_options -u $key
    #     end
    # end
    for env_var in (env)
        set key (string split = "$env_var")[1]
        # Skip empty keys, keys with only whitespace, or keys with invalid characters
        # NOTE: $PATH is causing this to crash when certain dirs dont exist
        if test -n "$key" && string match -q -r '^[A-Za-z_][A-Za-z0-9_]*$' "$key" && test (string trim "$key") != ""
            if not contains "$key" $RELOAD_PROTECTED_ENV_VARS
                echo $key
                set unset_options $unset_options -u $key
            end
        end
    end
    echo $unset_options

    # Execute command
    set -q _flag_command && eval $_flag_command >/dev/null 2>&1

    # Evaluate env
    for env_var in $_flag_env
        set key (string split = "$env_var")[1]
        set value (string split = "$env_var")[2]

        set re_evaluated (fish -c "echo $value")
        set -a envs "$key=$re_evaluated"
    end
    exec env $unset_options
    return

    # Reload shell
    exec env $unset_options /usr/bin/env $envs bash -i -c "exec fish"
end
