function rust-switch-version
    set current_version (rustup show | grep -A1 "active toolchain" | tail -n1 | string trim)
    echo "Current version: $current_version"

    set available_versions (rustup toolchain list)
    echo "Available versions:"
    printf "%s\n" $available_versions

    read -P "Enter version to switch to: " target_version

    return 0
    if test -n "$target_version"
        rustup default $target_version
        set new_version (rustup show | grep -A1 "active toolchain" | tail -n1 | string trim)
        echo "Switched to: $new_version"
    end
end
