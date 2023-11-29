#!/bin/bash

os_name="$(uname)"
if [ "$os_name" = "Darwin" ]; then
    tailscale_cmd="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
elif [ "$os_name" = "Linux" ]; then
    tailscale_cmd="/usr/bin/tailscale"
else
    echo "Unsupported operating system: $os_name"
    exit 1
fi

# Signing node definition
tlpub="tlpub:<Signing Node TLPUB>"

sign_node() {
    local line=$1
    if [[ "$line" =~ nodekey:([a-f0-9]{64}) ]]; then
        local nodekey=${BASH_REMATCH[1]}
        echo "Signing nodekey: $nodekey"
        $tailscale_cmd lock sign "nodekey:$nodekey" "$tlpub"
        echo "Signed successfully"
    else
        echo "No valid nodekey found in line: $line"
    fi
}

echo "Fetching Tailscale lock status..."
tailscale_lock_status=$($tailscale_cmd lock status)

if [ $? -ne 0 ]; then
    echo "Error fetching Tailscale lock status. Exiting."
    exit 1
fi

# Process each line containing a nodekey
echo "$tailscale_lock_status" | grep -E '.*nodekey' | while IFS= read -r line; do
    sign_node "$line"
    sleep 0.5  # Optional: Delay between signing to prevent rate limiting
done
