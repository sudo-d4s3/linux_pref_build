# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ip="ip --color=auto"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -avlF'
alias la='ls -A'
alias l='ls -CF'
alias ...='pushd ../..'

# cd without having to type `cd`
shopt -s autocd

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

#bind '"\e\e": "\C-a\C-x\C-e\C-usudo $(fc -ln -1)\C-j"'
#bind '"\e\e": "sudo `fc -ln -1`"'
bind '"\e\e": "sudo !!\C-j"'

#calc() { python3 -c "import math; def calculator(expression): return eval(expression, {'__builtins__': None}, {'sqrt': math.sqrt, 'sin': math.sin, 'cos': math.cos, 'tan': math.tan}); while True: try: expression = input('Enter an expression: '); result = calculator(expression); print(result); except Exception as e: print('Invalid expression:', e);" }

#calc() { python -c "import math; print(eval($1))"; }

#calc() { python3 -c "import ast; from math import *; print(eval(compile(ast.parse('$1', mode='eval'), '<string>', 'eval')))" || echo "Invalid expression"; }

calc() { python3 -c "import ast; from math import *; print(eval(compile('$1', '<string>', 'eval')))" || echo "Invalid expression"; }

mkd() { mkdir $1 && pushd $1; }

function rot13() { if [ -r $1 ]; then cat $1 | tr '[N-ZA-Mn-za-m5-90-4]' '[A-Za-z0-9]'; else echo $* | tr '[N-ZA-Mn-za-m5-90-4]' '[A-Za-z0-9]'; fi }
function rot47() { if [ -r $1 ]; then cat $1 | tr '\!-~' 'P-~\!-O' ; else echo $* | tr '\!-~' 'P-~\!-O'; fi }


fkill() {
    local pids=$(
      ps -f -u $USER | sed 1d | fzf --multi | tr -s [:blank:] | cut -d' ' -f2
      )
    if [[ -n $pids ]]; then
        echo "$pids" | xargs kill -9 "$@"
    fi
}

gll() {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $selections ]]; then
        local commits=$(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
        git show $commits
    fi
}

# NOTE: make more extensible 
school() {
	if [ -n "$1" ]; then
		local selection=$1
	else
		local selection=$(
			ls $HOME/Documents/school | cut -d' ' -f 9 | fzf
		)
	fi
	case $selection in
		speech)
			pushd $HOME/Documents/school/speech
			;;
		hardware)
			pushd $HOME/Documents/school/hardware
			;;
		human_dev)
			pushd $HOME/Documents/school/human_dev
			;;
		bio)
			pushd $HOME/Documents/school/bio
			;;
	esac
}
export PATH=/home/d4s3/.nimble/bin:$PATH
export PATH=/home/$USER/.local/bin:$PATH
export PS1=$(printf "%*s\r%s\n\$ " "$(tput cols)" "\t \$?\[$(tput sgr0)\]" "\u@\h:\w\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\]") 
