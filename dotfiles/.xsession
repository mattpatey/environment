# .xsession

xrdb -merge .Xresources
xscreensaver -no-splash &
xsetroot -solid black
xgamma -gamma 0.9
syndaemon -d -t
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --height 19 --transparent true --alpha 0 --tint 0x22222222 &
nm-applet --sm-disable &
pasystray &
feh --bg-scale /home/mlp/greeter-tux.png &
exec xmonad
