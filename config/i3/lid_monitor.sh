#!/bin/bash

# Get the actual display name dynamically
LAPTOP_DISPLAY=$(xrandr | grep " connected" | grep -E "(eDP|LVDS)" | cut -d' ' -f1)

acpi_listen | while read event; do
    if [[ $event == *"button/lid"* ]]; then
        # Check if lid state file exists
        if [[ -f /proc/acpi/button/lid/LID0/state ]]; then
            LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')
        else
            # Alternative method for newer systems
            LID_STATE=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | awk '{print $2}' | head -1)
        fi
        
        if [[ $LID_STATE == "closed" ]]; then
            xrandr --output "$LAPTOP_DISPLAY" --off
        elif [[ $LID_STATE == "open" ]]; then
            xrandr --output "$LAPTOP_DISPLAY" --auto
        fi
    fi
done
