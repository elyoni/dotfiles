#!/bin/bash

# Get the main interface
INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n 1)

# Get the IP address of the interface
IP=$(ip addr show "$INTERFACE" | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Check if the interface is wireless or wired
if [[ "$INTERFACE" == *"wlan"* || "$INTERFACE" == *"wifi"* || "$INTERFACE" == *"wlp"* ]]; then
    ICON="📶"  # Wireless icon
elif [[ "$INTERFACE" == *"eth"* || "$INTERFACE" == *"enp"* ]]; then
    ICON="🔌"  # Wired icon
else
    ICON="❌"  # Not connected
fi

# Print the icon and IP address
if [[ -z "$IP" ]]; then
    echo "$ICON No IP Address (Not connected)"
else
    echo "$ICON $IP"
fi
