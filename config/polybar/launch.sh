#!/bin/bash
killall -q polybar

# Wait for displays to be configured
sleep 2

# Wait for all polybar instances to terminate
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Launch polybar for each monitor
polybar topbar-hdmi &
polybar topbar-edp &

