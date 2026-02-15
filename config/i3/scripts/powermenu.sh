#!/usr/bin/env bash

# Rofi Power Menu Script
# Options: Poweroff, Reboot, Logout, Lock, Suspend

options="⏻ Poweroff\n Reboot\n Logout\n Lock\n⏾ Suspend"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    *Poweroff)
        systemctl poweroff
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Logout)
        i3-msg exit
        ;;
    *Lock)
        i3lock -c 000000 -f
        ;;
    *Suspend)
        systemctl suspend
        ;;
esac

