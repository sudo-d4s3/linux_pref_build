#!/bin/bash

# Color
alias ls='ls --color=auto'    
alias grep='grep --color=auto'    
alias fgrep='fgrep --color=auto'    
alias egrep='egrep --color=auto'    
alias ip="ip --color=auto"

# ls aliases
alias ll='ls -avlhF'
alias ...='pushd ../..'

# making wget a bit more xdg compliant
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
