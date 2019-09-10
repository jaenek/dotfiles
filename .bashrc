#!/bin/bash
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.
export PS1="\[\e[38;5;4m\]\w \[\e[38;5;2m\]\\$ \[\e[38;5;15m\]"

[ -f "$HOME/.config/shortcuts" ] && source "$HOME/.config/shortcuts" # Load shortcut aliases
[ -f "$HOME/.config/aliases" ] && source "$HOME/.config/aliases"

vf() {
	IFS=$'\n' files=($(fzf --query="$*" --multi))
	[[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

sd() {
	IFS=$'\n' dir=($(fd -t d | fzf --query="$*" --multi))
	[[ -n "$dir" ]] && cd "$dir"
}

export MIROBO_IP=192.168.2.238
export MIROBO_TOKEN=784a7a65757a4937334652336f574c55
