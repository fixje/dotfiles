# run stuff to fix permissions etc
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap de -variant nodeadkeys
xmodmap -e "clear lock"
xmodmap ~/.Xmodmap

## trackpoint scrolling
xinput set-int-prop 12 "Evdev Wheel Emulation" 8 1
xinput set-int-prop 12 "Evdev Wheel Emulation Button" 8 2
xinput --set-prop 12 "Device Accel Profile" 6
# diable touchpad
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Off" 8 1

if [ -e /dev/input/js0 ]
then
	qjoypad &
fi

# java hack for awesome
wmname LG3D &

#exec startfluxbox
systemd --user
