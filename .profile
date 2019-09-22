#!/bin/sh
# Profile file. Runs on login.

export GOPATH=$HOME/workspace/go
export PATH="$PATH:$GOPATH/bin:$HOME/.local/bin:$HOME/.local/bin/cron:$HOME/.local/bin/dmenu:$HOME/.local/bin/dwm:$HOME/.local/bin/tools:$HOME/.local/bin/vifm"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export FILE="vifmrun"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"; a="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"; a="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; a="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"; a="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"; a="${a%_}"

[ ! -f ~/.config/shortcuts ] && shortcuts >/dev/null 2>&1

echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Start graphical server if dwm not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x dwm >/dev/null && exec startx
