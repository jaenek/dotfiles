# Save history between sessions
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Set prompt
autoload -U colors && colors
PS1="%{$fg[blue]%}%~%{$fg[green]%} $%{$reset_color%} "

# Display current branch on the right-hand side of the terminal window
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats "%{$fg[yellow]%}(%b)%{$reset_color%}"

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcuts" ] && source "$HOME/.config/shortcuts"
[ -f "$HOME/.config/aliases" ] && source "$HOME/.config/aliases"

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd -H -t f -L'
export FZF_DEFAULT_OPTS=' --extended --select-1 --exit-0 --prompt=🔎'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd -H -t d -L'
export FZF_CTRL_T_OPTS="--preview '[[ \$(file --mime {}) =~ binary ]] &&
                                    echo {} is a binary file ||
                                    (highlight -O ansi -l {} 2> /dev/null ||
									cat {} ||
									tree -C {}) 2> /dev/null | head -200'"
