#!/bin/bash
set -e

# User Vars
TIMEZONE_DOUBLE="America/Chicago"
KEYBOARD_LAYOUT="dvorak"
HOSTNAME="puter"
USERNAME="com"
USER_PASS="not@securepassword1" #MUST BE ATLEAST 16 CHARS, ALPHANUMERIC AND A SPECIAL CHAR
ADMIN_PASS="stillnot@securepassword1" #MUST BE ATLEAST 16 CHARS, ALPHANUMERIC AND A SPECIAL CHAR
ARCHZFS_GPG_KEY=3A9917BF0DED5C13F69AC68FABEC0A1208037BE9
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 pti=on randomize_kstack_offset=on vsyscall=none debugfs=off oops=panic module.sig_enforce=0 lockdown=confidentiality mce=0 sysctl.kernel.kptr_restrict=2 sysctl.kernel.dmesg_restrict=1 sysctl.kernel.printk=3 3 3 3 sysctl.kernel.unprivileged_bpf_disabled=1 sysctl.core.bpf_jit_harden=2 sysctl.dev.tty.ldisc_autoload=0 sysctl.vm.unprivileged_userfaultfd=0 sysctl.kexec_load_disabled=1 sysctl.kernel.sysrq=4 sysctl.kernel.unprivileged_userns_clone=0 sysctl.perf_event_paranoid=3 sysctl.net.ipv4.tcp_timestamps=0 sysctl.net.ipv4.tcp_syncookies=1 sysctl.net.ipv4.tcp_rfc1337=1 sysctl.net.ipv4.conf.all.rp_filter=1 sysctl.net.ipv4.conf.default.rp_filter=1 sysctl.net.ipv4.conf.all.accept_redirects=0 sysctl.net.ipv4.conf.default.accept_redirects=0 sysctl.net.ipv4.conf.all.secure_redirects=0 sysctl.net.ipv4.conf.default.secure_redirects=0 sysctl.net.ipv6.conf.all.accept_redirects=0 sysctl.net.ipv6.conf.default.accept_redirects=0 sysctl.net.ipv4.conf.all.send_redirects=0 sysctl.net.ipv4.conf.default.send_redirects=0 sysctl.net.ipv4.conf.all.accept_source_route=0 sysctl.net.ipv4.conf.default.accept_source_route=0 sysctl.net.ipv6.conf.all.accept_source_route=0 sysctl.net.ipv6.conf.default.accept_source_route=0 sysctl.net.ipv6.conf.all.accept_ra=0 sysctl.net.ipv6.conf.default.accept_ra=0 sysctl.net.ipv4.tcp_sack=0 sysctl.net.ipv4.tcp_dsack=0 sysctl.net.ipv4.tcp_fack=0 sysctl.kernel.yama.ptrace_scope=2 sysctl.vm.mmap_rnd_bits=32 sysctl.vm.mmap_rnd_compat_bits=16 sysctl.fs.protected_symlinks=1 sysctl.fs.protected_hardlinks=1 sysctl.fs.protected_fifos=2 sysctl.fs.protected_regular=2 selinux=1 security=selinux random.trust_cpu=off fbcon=font:cybercafe sysctl.kernel.core_pattern=|/bin/false sysctl.fs.suid_dumpable=0 sysctl.vm.swappiness=1 sysctl.ipv6.conf.all.use_tempaddr=2 sysctl.ipv6.conf.default.use_tempaddr=2 lsm=landlock,lockdown,yama,integrity,selinux,bpf"

echo "Setting Timezone"
ln -sf /usr/share/zoneinfo/$TIMEZONE_DOUBLE /etc/localtime
hwclock --systohc

echo "Setting Local"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting Keyboard Layout"
localectlset-keymap $KEYBOARD_LAYOUT

echo "Setting Hostname"
echo $HOSTNAME > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1	${HOSTNAME}.localdomain ${HOSTNAME} localhost
::1		${HOSTNAME}.localdomain ${HOSTNAME} localhost
EOF

echo "Adding ArchZFS repo keys"
pacman-key --recv-keys $ARCHZFS_GPG_KEY
pacman-key --lsign-key $ARCHZFS_GPG_KEY

echo "Setting ZFS cachefile"
zpool set cachefile=/etc/zfs/zpool.cache zroot

echo "Enabling ZFS Services"
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.target
systemctl enable zfs-mount.service
systemctl enable zfs.target

echo "Restricting SU"
cat >> /etc/pam.d/su << EOF
auth required pam_wheel.so use_uid
EOF
cat >> /etc/pam.d/su-l << EOF
auth required pam_wheel.so use_uid
EOF

echo "Disabling Root"
passwd -l root

echo "Increasing Password Requirements"
cat >> /etc/pam.d/passwd << EOF
password required pam_pwquality.so retry=2 minlen=16 difok=6 dcredit=-1 ucredit=-2 lcredit=-2 ocredit=-1 enforce_for_root
password required pam_unix.so sha512 shadow nullok rounds=65536
EOF

echo "Creating Admin's Account"
useradd -G wheel,adm admin
passwd admin $ADMIN_PASS

echo "Creating $USERNAME's Account"
useradd -m $USERNAME
passwd $USERNAME $USER_PASS

echo "Hardening Filepaths"
chmod 700 /home/$USERNAME
chmod 700 /boot /usr/src /lib/modules /usr/lib/modules

echo "Setting default umask"
echo "umask 0077" >> /etc/profile

echo "Disabling Core Dumps"
mkdir -p /etc/systemd/coredump.conf.d
cat > /etc/systemd/coredump.conf.d/disable.conf << EOF
[Coredump]
Storage=none
EOF
echo "* hard core 0" >> /etc/security/limits.conf

echo "Enabling Userspace IPV6 Privacy Extensions"
cat >> /etc/NetworkManager/NetworkManager.conf << EOF
[connection]
ipv6.ip6-privacy=2
EOF
cat > /etc/systemd/network/ipv6-privacy.conf << EOF
[Network]
IPv6PrivacyExtensions=kernel
EOF

echo "blocking certian kernel modules"
cat > /etc/modprobe.d/disable_rare_networks.conf << EOF
install dccp /bin/false
install sctp /bin/false
install rds /bin/false
install tipc /bin/false
install n-hdlc /bin/false
install ax25 /bin/false
install netrom /bin/false
install x25 /bin/false
install rose /bin/false
install decnet /bin/false
install econet /bin/false
install af_802154 /bin/false
install ipx /bin/false
install appletalk /bin/false
install psnap /bin/false
install p8023 /bin/false
install p8022 /bin/false
install can /bin/false
install atm /bin/false
EOF
cat > /etc/modprobe.d/disable_rare_filesystems.conf << EOF
install cramfs /bin/false
install freevxfs /bin/false
install jffs2 /bin/false
install hfs /bin/false
install hfsplus /bin/false
install squashfs /bin/false
install udf /bin/false
EOF
cat > /etc/modprobe.d/disable_dev_graphics_driver.conf << EOF
install vivid /bin/false
EOF
cat > /etc/modprobe.d/disable_bluetooth.conf << EOF
install bluetooth /bin/false
install btusb /bin/false
EOF

echo "Updating mikinitcpio for ZFS"
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont numlock block zfs filesystems)/' /etc/mkinitcpio.conf
sed -i 's/^MODULES=.*/MODULES=(zfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "Generating GRUB Conf"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT=\"${GRUB_CMDLINE_LINUX_DEFAULT}\"/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
