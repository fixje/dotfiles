setxkbmap de -variant nodeadkeys
xmodmap -e "clear lock"
xmodmap ~/.Xmodmap

## trackpoint scrolling
xinput set-int-prop 12 "Evdev Wheel Emulation" 8 1
xinput set-int-prop 12 "Evdev Wheel Emulation Button" 8 2
xinput --set-prop 12 "Device Accel Profile" 6
# diable touchpad
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Off" 8 1

wicd-gtk &

/usr/local/bin/yeah-transparent &

if [ -e /dev/input/js0 ]
then
	qjoypad &
fi

# java hack for awesome
wmname LG3D &

/home/fixje/bin/display-setup.sh
exec awesome
#exec startfluxbox
