#!/bin/sh

is_paused=$(dunstctl is-paused)
echo $is_paused
set -x
dunstctl close-all
if [ "$is_paused" = true ]; then
    echo $is_paused
    dunstify "Notifications enabled" -t 5000
elif [ "$is_paused" = false ]; then
    echo $is_paused
    dunstify "Notifications disabled" -t 5000
fi
sleep 2
exec dunstctl set-paused toggle
set +x
