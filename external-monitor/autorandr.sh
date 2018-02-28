#!/bin/sh
#
# Switch to single/dual monitor mode.
#
# Script is triggered via a udev rule, defined in /etc/udev/rules.d/95-monitor-switch.rules
#
set -e

RES="1"
ATTEMPT="0"
while [ "${RES}" -ne "0" && "${ATTEMPT}" -lt "5" ]; do
    set +e
    EXTERNAL_MONITOR_STATUS=$( cat /sys/class/drm/card1-DP-4/status )
    set -e
    RES="${?}"
    ATTEMPT=$[$ATTEMPT+1]
done


logger -t autorandr "${EXTERNAL_MONITOR_STATUS} => ${RES}"

if [ $EXTERNAL_MONITOR_STATUS == "connected" ]; then
    TYPE="single"
    /usr/bin/xrandr --output DP3-8 --off --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal
else
    TYPE="double"
    /usr/bin/xrandr --output DP3-8 --primary --mode 2560x1440 --pos 0x0 --right-of eDP1 --output eDP1 --mode 1920x1080 --pos 0x1440 --rotate normal
fi

logger -t autorandr "Switched to $TYPE monitor mode"

exit 0
