sudo xbps-install -Sy qtile wayland wayland-devel xorg-server-xwayland wlroots0.15-devel python3-devel python3-pip pkg-config gccseatd mesa mesa-dri wget
pip install pywlroots==0.15.24
sudo ln -s /etc/sv/seatd /var/service
sudo sv up seatd
sudo usermod -aG _seatd $USER
ln -s default_config.py ~/.config/qtile/config.py

#XDG_RUNTIME_DIR=$(mktemp -d) qtile start -b wayland
