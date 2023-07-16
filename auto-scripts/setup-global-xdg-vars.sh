#!/bin/sh

if [ "$EUID" -ne 0 ]
	then echo -e "Usually Requires Root\nIf not you can always remove this part of the script."
	exit
fi

cat > /etc/profile.d/xdg_vars.sh << 'EOF'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
# the runtime dir should be set by pam_systemd
# only enable if you dont have pam or systemd
# export XDG_RUNTIME_DIR=/run/user/$UID
EOF
