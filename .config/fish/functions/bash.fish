# unsets the `SHELL` environment variable before launching Bash, which prevents potential conflicts between Fish and Bash shell environments.
# passes the Fish version (`FISH_VERSION="$FISH_VERSION"`) to Bash as an environment variable, which might be useful for scripts that need to know the parent shell's version

function bash
    env -u SHELL FISH_VERSION="$FISH_VERSION" bash $argv
end
