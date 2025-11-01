#!/bin/bash

# Laptop keyboard - swap Alt and Ctrl
LAPTOP_KB=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -oP 'id=\K\d+')

# MX Keys - keep normal
MX_KEYS=$(xinput list | grep "MX Keys Mini Keyboard" | grep -oP 'id=\K\d+' | head -1)

# Swap Alt and Ctrl on laptop keyboard
if [ ! -z "$LAPTOP_KB" ]; then
    setxkbmap -device $LAPTOP_KB -option ctrl:swap_lalt_lctl
fi

# Keep MX Keys normal
if [ ! -z "$MX_KEYS" ]; then
    setxkbmap -device $MX_KEYS -option
fi
