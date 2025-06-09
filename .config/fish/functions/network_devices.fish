function network_devices --description "Discover all devices on the local network with their IPs and hostnames"
    # Colors for output
    set_color cyan
    echo "🔍 Discovering devices on the network..."
    set_color normal
    echo
    
    # Get network information
    set gateway (route -n get default 2>/dev/null | grep gateway | awk '{print $2}')
    set network_interface (route -n get default 2>/dev/null | grep interface | awk '{print $2}')
    
    if test -z "$gateway"
        set_color red
        echo "❌ Could not determine network gateway"
        set_color normal
        return 1
    end
    
    # Extract network range from gateway (assumes /24 subnet)
    set network_base (echo $gateway | sed 's/\.[0-9]*$//')
    set network_range "$network_base.0/24"
    
    set_color yellow
    echo "📡 Network range: $network_range"
    echo "🌐 Gateway: $gateway"
    echo "🔌 Interface: $network_interface"
    echo
    set_color normal
    
    # Create temporary file for results
    set temp_file (mktemp)
    
    # Function to scan a single IP
    function scan_ip
        set ip $argv[1]
        # Quick ping test
        if ping -c 1 -W 1000 $ip >/dev/null 2>&1
            # Try to get hostname
            set hostname (dig +short -x $ip 2>/dev/null | sed 's/\.$//g')
            if test -z "$hostname"
                set hostname (nslookup $ip 2>/dev/null | grep 'name =' | awk '{print $4}' | sed 's/\.$//g')
            end
            if test -z "$hostname"
                set hostname "(no hostname)"
            end
            echo "$ip|$hostname" >> $temp_file
        end
    end
    
    # Parallel ping sweep
    set_color cyan
    echo "⏳ Scanning network (this may take a moment)..."
    set_color normal
    
    # Scan IPs 1-254 in parallel
    for i in (seq 1 254)
        scan_ip "$network_base.$i" &
    end
    
    # Wait for all background jobs to complete
    wait
    
    # Also get devices from ARP table
    set_color cyan
    echo "📋 Getting devices from ARP table..."
    set_color normal
    
    # Parse ARP table and add to results
    arp -a | grep -E '\([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\)' | while read line
        set hostname_arp (echo $line | awk '{print $1}')
        set ip_arp (echo $line | sed 's/.*(//' | sed 's/).*//')
        set mac (echo $line | grep -o '[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]:[0-9a-f][0-9a-f]')
        
        if test "$hostname_arp" != "?"
            echo "$ip_arp|$hostname_arp|$mac" >> $temp_file
        end
    end
    
    # Display results
    echo
    set_color green
    echo "🌟 Discovered Devices:"
    set_color normal
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "%-18s %-35s %-18s\n" "IP Address" "Hostname" "MAC Address"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Sort and display unique results
    if test -f $temp_file
        sort $temp_file | uniq | while read line
            set parts (string split '|' $line)
            set ip $parts[1]
            set hostname $parts[2]
            set mac_addr $parts[3]
            
            if test -z "$mac_addr"
                set mac_addr "(unknown)"
            end
            
            # Color code by device type
            if string match -q "*.lan" $hostname
                set_color cyan
            else if string match -q "*(no hostname)*" $hostname
                set_color white
            else
                set_color yellow
            end
            
            printf "%-18s %-35s %-18s\n" $ip $hostname $mac_addr
            set_color normal
        end
    else
        set_color red
        echo "❌ No devices found"
        set_color normal
    end
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Count devices
    if test -f $temp_file
        set device_count (wc -l < $temp_file | tr -d ' ')
        set_color green
        echo "📊 Total devices found: $device_count"
        set_color normal
    end
    
    # Cleanup
    rm -f $temp_file
    
    echo
    set_color blue
    echo "💡 Tip: Run 'network_devices' anytime to refresh the device list"
    set_color normal
end

