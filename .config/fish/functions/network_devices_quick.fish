function network_devices_quick --description "Quickly show devices from ARP table with IPs and hostnames"
    set_color cyan
    echo "⚡ Quick device discovery from ARP table..."
    set_color normal
    echo
    
    # Get network information
    set gateway (route -n get default 2>/dev/null | grep gateway | awk '{print $2}')
    
    if test -n "$gateway"
        set_color yellow
        echo "🌐 Gateway: $gateway"
        echo
        set_color normal
    end
    
    # Display header
    set_color green
    echo "🌟 Active Network Devices:"
    set_color normal
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "%-18s %-35s %-18s\n" "IP Address" "Hostname" "MAC Address"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Parse ARP table
    set device_count 0
    arp -a | grep -E '\([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\)' | grep -v incomplete | while read line
        set hostname_arp (echo $line | awk '{print $1}')
        set ip_arp (echo $line | sed 's/.*(//' | sed 's/).*//')
        set mac (echo $line | grep -o '[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]')
        
        if test "$hostname_arp" != "?"
            if test -z "$mac"
                set mac "(unknown)"
            end
            
            # Color code by device type
            if string match -q "*.lan" $hostname_arp
                set_color cyan
            else if string match -q "*iphone*" $hostname_arp; or string match -q "*ipad*" $hostname_arp
                set_color magenta
            else if string match -q "*mac*" $hostname_arp; or string match -q "*MacBook*" $hostname_arp
                set_color blue
            else if string match -q "*camera*" $hostname_arp; or string match -q "*cam*" $hostname_arp
                set_color red
            else
                set_color yellow
            end
            
            printf "%-18s %-35s %-18s\n" $ip_arp $hostname_arp $mac
            set_color normal
            set device_count (math $device_count + 1)
        end
    end
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    set_color green
    echo "📊 Active devices with hostnames found: $device_count"
    set_color normal
    echo
    set_color blue
    echo "💡 Use 'network_devices' for a comprehensive scan including devices without hostnames"
    set_color normal
end

