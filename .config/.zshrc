export ZSH="/home/d4s3/.oh-my-zsh"
ZSH_THEME="agnoster"

HYPHEN_INSENSITIVE="true"

export UPDATE_ZSH_DAYS=7

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
plugins=(git sudo)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

cdls() { cd "$@";ls -la; }
# Set personal aliases, overriding those provided by oh-my-zsh libs,
alias ls='ls -la --color=auto'

