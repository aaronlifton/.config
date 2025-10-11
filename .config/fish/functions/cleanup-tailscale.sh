#!/bin/bash

# SOURCE:
# https://gist.githubusercontent.com/in03/38facc215e10d1b040ab740b0a24be6f/raw/ed99e009a21edf56d7de9e96eb4c3fac8441a50d/Cleanup-Tailscale.sh

# If you're having issues with Tailscale after a reinstall, try cleaning up.
# Tailscale recommends the following. I've just scripted it for ease:
# https://tailscale.com/kb/1069/uninstall?q=uninstall&tab=macos+%28standalone%29

# Oh would you look at that, if you've got brew, just use that.
# https://github.com/Homebrew/homebrew-cask/blob/master/Casks/t/tailscale.rb

# Delete paths
paths=(
  "~/Library/Application Scripts/*.io.tailscale.ipn.macos"
  "~/Library/Application Scripts/io.tailscale.ipn.macos"
  "~/Library/Application Scripts/io.tailscale.ipn.macos.login-item-helper"
  "~/Library/Application Scripts/io.tailscale.ipn.macos.share-extension"
  "~/Library/Caches/io.tailscale.ipn.macos"
  "~/Library/Containers/io.tailscale.ipn.macos"
  "~/Library/Containers/io.tailscale.ipn.macos.login-item-helper"
  "~/Library/Containers/io.tailscale.ipn.macos.network-extension"
  "~/Library/Containers/io.tailscale.ipn.macos.share-extension"
  "~/Library/Containers/Tailscale"
  "~/Library/Group Containers/*.io.tailscale.ipn.macos"
  "~/Library/HTTPStorages/io.tailscale.ipn.macos"
  "~/Library/Preferences/io.tailscale.ipn.macos.plist"
  "~/Library/Tailscale"
)

for path in "${paths[@]}"; do
  expanded_path=$(eval echo "$path")
  if [ -e "$expanded_path" ]; then
    rm -rf "$expanded_path"
    echo "Deleted: $expanded_path"
  else
    echo "Not found: $expanded_path"
  fi
done

# Remove login keychain items that start with "tailscale"
sudo security dump-keychain | grep -i "tailscale" | cut -d'"' -f4 | while read -r keychain_item; do
  sudo security delete-generic-password -l "$keychain_item"
  echo "Removed keychain item: $keychain_item"
done

# Remove Tailscale from VPN configuration
if [ -e /Library/Preferences/SystemConfiguration/preferences.plist ]; then
  sudo /usr/libexec/PlistBuddy -c "Delete :NetworkServices:*:UserDefinedName:Tailscale" /Library/Preferences/SystemConfiguration/preferences.plist 2>/dev/null
  sudo /usr/libexec/PlistBuddy -c "Delete :NetworkServices:*:Interface:SubType:Tailscale" /Library/Preferences/SystemConfiguration/preferences.plist 2>/dev/null
  echo "Removed Tailscale from VPN configuration"
else
  echo "VPN configuration file not found"
fi

# Restart the network service to apply changes
sudo killall -HUP mDNSResponder
echo "Network service restarted"
