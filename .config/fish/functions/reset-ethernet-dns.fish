function reset-ethernet-dns
    sudo networksetup -setdnsservers Ethernet Empty
    networksetup -getdnsservers Ethernet
end
