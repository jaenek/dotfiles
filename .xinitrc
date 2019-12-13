#!/bin/sh

# restore theme:
wal -R

# apply Xresources:
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# set background:
bkr bag

# mount net shares:
bkr netmnt

# notifications:
run dunst

# compositor:
run picom -bf -o 0.0 -D 5

# remapping script:
bkr remaps

# makes the mouse invisible after a brief period:
run unclutter

# mpd notificatons:
run mpdupdate

# music player daemon:
run mpd

# status bar
while true; do
	bkr sts
	sleep 1
done &

# check for new articles
bkr new

# start dwm
while true; do
	ssh-agent dwm
done
