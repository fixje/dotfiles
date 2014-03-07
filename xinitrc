# run stuff to fix permissions etc
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xmodmap /home/fixje/.Xmodmap

# java hack for awesome
wmname LG3D &
