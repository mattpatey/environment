/home/mlp/bin/autorandr.sh

# Incorporate colour scheme and font settings.
#
xrdb -merge .Xresources

# Start the screensaver daemon.
#
xscreensaver -no-splash &

# Set the background colour and image.
#
xgamma -gamma 0.9
xsetroot -solid black

# Enable Emacs keybindings for GTK applications
#
/usr/bin/gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
/usr/bin/gnome-settings-daemon &

# Turn caps lock into control (possibly unneeded)
#
setxkbmap -layout us -option ctrl:nocaps

# Transparency!
#
xcompmgr &

exec xmonad
