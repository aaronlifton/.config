
function update-tailscale --argument-names direction --description "Update Tailscale to the latest version"
    set -l tailscaled_path (type -p tailscaled)
    # Fix: Use string comparison, not variable comparison
    if test "$direction" = down -a -z "$tailscaled_path"
        echo "Tailscale is not installed. Please install it first."
        return 1
    else if string match -q "*homebrew*" "$tailscaled_path"
        echo "Tailscale is installed via Homebrew. Please uninstall" \
            "and reinstall via Go."
        return 1
    end

    if test "$direction" = down
        sudo tailscaled uninstall-system-daemon
        return 0
    else if test "$direction" != up
        echo "Usage: update-tailscale <up|down>"
        return 1
    end

    # go install tailscale.com/cmd/tailscale{,d}@main
    go install tailscale.com/cmd/tailscale{,d}@v1.90.1
    sudo tailscaled install-system-daemon
    return 0
end
