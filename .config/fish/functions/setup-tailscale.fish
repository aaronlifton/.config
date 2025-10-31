function setup-tailscale --argument-names up
    set -l
    if test -z "$up"
        echo "Usage: setup-tailscale <up|down>"
        return 1
    end
    if test "$up" != up -a "$up" != down -a "$up" != uninstall
        echo "Usage: setup-tailscale <up|down>"
        return 1
    end
    if test "$up" = uninstall
        echo "Uninstalling Tailscale..."
        tailscale down
        sudo tailscaled uninstall-system-daemon
        echo "Restoring DNS settings..."
        # sudo networksetup -setdnsservers "Wi-Fi" "Empty"
        sudo networksetup -setdnsservers Wi-Fi
        # sudo networksetup -setdnsservers Ethernet
    end
    if test "$up" = down
        echo "Tearing down Tailscale..."
        sudo tailscale down
        echo "Restoring DNS settings..."
        sudo networksetup -setdnsservers Wi-Fi Empty
        sudo networksetup -setdnsservers Ethernet Empty
        # sudo networksetup -setdnsservers Wi-Fi 192.168.1.1 2603::9000:e000:a91:1
        # sudo networksetup -setdnsservers Ethernet 192.168.1.1 2603::9000:e000:a91:1
        return 0
    else
        echo "Bringing up Tailscale..."
        sudo tailscaled install-system-daemon
        # tailscale set --ssh
        tailscale up --accept-routes --accept-dns --ssh
        networksetup -setdnsservers Wi-Fi 100.100.100.100 192.168.1.1 2603:9000:e000:a91::1
        networksetup -setdnsservers Ethernet 100.100.100.100 192.168.1.1 2603:9000:e000:a91::1
    end
end
