#!/bin/sh

style="$HOME/.config/rofi/launchers/type-4/style-1.rasi "
rofi_command="rofi -theme $style"

# Get connected WiFi
connected_wifi="$(nmcli -f active,ssid dev wifi | awk '/yes/ {print $2}')"

# Get available WiFi networks
wifi_list=$(nmcli -t -f SSID dev wifi list | grep -v '^$')

# Create rofi options string
options=""
while read -r line; do
    options="$options\n$line"
done <<< "$wifi_list"

## Convert the space-separated list into an array
#IFS=$'\n' read -r -d '' -a wifi_array <<< "$wifi_list"
#
## Create rofi options string
#options=""
#for wifi in "${wifi_array[@]}"; do
#    options="$options\n${wifi#*:}"  # Extract the SSID from the "SSID" format
#done

# Show rofi menu filter empty str
chosen=$(echo -e "$options" | grep -v '^$' | $rofi_command -dmenu -i -p "Choose WiFi Network:")
if [ -z "$chosen" ]; then
    exit
fi

# Check if chosen network is already configured
connected=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F':' '{print $1}' | grep -w "$chosen")
if [ "$connected_wifi" = "$chosen" ]; then
    # Network already connected, prompt user whether to disconnect or not
    choice=$(echo -e "No\nYes" | $rofi_command -dmenu -i -p "Disconnect from $connected_wifi?")
    if [ "$choice" = "Yes" ]; then
        nmcli connection down "$connected_wifi"
        back=$(echo -e "go back\nexit" | $rofi_command -dmenu -i -p "go back")
        if [ "$back" != "go back" ]; then
            exit
        fi
    else
                exit
    fi
fi

# Network not connected, prompt user for password
password=$(echo "" | $rofi_command -dmenu -password -i -p "Enter password for $chosen:")
if [ -n "$password" ]; then
    # Connect to chosen network with password
    nmcli dev wifi connect "$chosen" password "$password"
else
    # Connect to chosen network without password
    nmcli dev wifi connect "$chosen"
fi
