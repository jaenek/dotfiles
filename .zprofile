#!/bin/zsh
# Runs on login.

# Load environmental variables.
[ -f "$HOME/.config/env" ] && source "$HOME/.config/env"

# Create shortcuts if needed.
[ ! -f ~/.config/shortcuts ] && shortcuts >/dev/null 2>&1

# Start graphical server if dwm not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x dwm >/dev/null && \
	exec startx $XDG_CONFIG_HOME/x11/xinitrc
