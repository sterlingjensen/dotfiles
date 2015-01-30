export LANG=en_US.UTF-8
xrdb -merge ~/.Xdefaults
xset -display localhost:0 -b
urxvtd -q -o -f
exec /usr/local/bin/i3
