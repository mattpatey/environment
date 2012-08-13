#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

xrdb -merge .Xresources
syndaemon -d -t
feh --bg-tile ~/wallpaper/arch.png &
xscreensaver -nosplash &
exec xmonad
