#!/bin/bash

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Requires root"
  exit
fi

# Create the files needed, on some systems you cant use cat to make a new file
mkdir /etc/bashrc.d/
touch {/etc/profile.d/bash-xdg.sh,/etc/bashrc.d/bash-xdg.sh}

# Append a loader script for interactive shells to run our xdg script
cat >> /etc/bash.bashrc << 'EOF'
if test -d /etc/bashrc.d; then
  for script in /etc/bashrc.d/*.sh; do
    test -r "$script" && . "$script"
  done
  unset item
fi
EOF

# Klepped both of the following scripts from https://hiphish.github.io/blog/2020/12/27/making-bash-xdg-compliant/ 

# Creating a file in /etc/profile.d to make bash login shells XDG complient 
cat > /etc/profile.d/bash-xdg.sh << EOF
# Make bash follow the XDG_CONFIG_HOME specification
_confdir=\${XDG_CONFIG_HOME:-\$HOME/.config}/bash
_datadir=\${XDG_DATA_HOME:-\$HOME/.local/share}/bash

# Source settings file
if [ -d "\$_confdir" ] then
    for f in .bash_profile .bashrc; do
        [ -f "\$_confdir/$f" ] && . "\$_confdir/\$f"
    done
fi

# Change the location of the history file by setting the environment variable
[ ! -d "\$_datadir" ] && mkdir -p "\$_datadir"
HISTFILE="\$_datadir/history"

unset _confdir
unset _datadir
EOF


# Creating a file in /etc/profile.d to make bash interactive shells XDG complient 
cat > /etc/bashrc.d/bash-xdg.sh << EOF
_confdir=\${XDG_CONFIG_HOME:-\$HOME/.config}/bash
_datadir=\${XDG_DATA_HOME:-\$HOME/.local/share}/bash

[[ -r "\$_confdir/.bashrc" ]] && . "\$_confdir/.bashrc"

[[ ! -d "\$_datadir" ]] && mkdir -p "\$_datadir"
HISTFILE=\$_datadir/history

unset _confdir
unset _datadir
EOF
