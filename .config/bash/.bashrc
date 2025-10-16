#!/bin/bash
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# aliases
source $HOME/git/linux_pref_build/shell_scripts/shell_aliases.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Hitting esc twice will print "sudo !!" and hit enter
bind '"\e\e": "sudo !!\C-j"'

# Source Bash Functions
# note make this recursive
source $HOME/git/linux_pref_build/shell_scripts/bashrc_functions/calc.sh
source $HOME/git/linux_pref_build/shell_scripts/bashrc_functions/mkd.sh
source $HOME/git/linux_pref_build/shell_scripts/bashrc_functions/rot.sh
source $HOME/git/linux_pref_build/shell_scripts/bashrc_functions/git-functions.sh

# Path, will make this a patch because I hate adding this
export PATH=$HOME/.nimble/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# XDG env vars
source $HOME/git/linux_pref_build/shell_scripts/xdg_env.sh

# Prompt
export PS1=$(printf "%*s\r%s\n\$ " "$(tput cols)" "\t \$?\[$(tput sgr0)\]" "\u@\h:\w\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\]") 
