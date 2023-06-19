#!/usr/bin/sh
if [ $1 == "up" ]; then
	amixer set Master 5%+
	sleep 0.5
	notify-send "up$(amixer get Master | tail -n 1 | awk -F ' ' '{print $5}' | tr -d '[]%')%"
else
	amixer set Master 5%-
	sleep 0.5
	notify-send "down$(amixer get Master | tail -n 1 | awk -F ' ' '{print $5}' | tr -d '[]%')%"
fi
