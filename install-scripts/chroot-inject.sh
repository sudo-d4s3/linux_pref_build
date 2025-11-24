#!/bin/bash
set -e

# User Vars
TIMEZONE_DOUBLE="America/Chicago"
HOSTNAME="puter"
USERNAME="com"
ARCHZFS_GPG_KEY=3A9917BF0DED5C13F69AC68FABEC0A1208037BE9
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 slab_nomerge init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 pti=on randomize_kstack_offset=on vsyscall=none debugfs=off oops=panic module.sig_enforce=0 lockdown=confidentiality mce=0 sysctl.kernel.kptr_restrict=2 sysctl.kernel.dmesg_restrict=1 sysctl.kernel.printk=3 3 3 3 sysctl.kernel.unprivileged_bpf_disabled=1 sysctl.core.bpf_jit_harden=2 sysctl.dev.tty.ldisc_autoload=0 sysctl.vm.unprivileged_userfaultfd=0 sysctl.kexec_load_disabled=1 sysctl.kernel.sysrq=4 sysctl.kernel.unprivileged_userns_clone=0 sysctl.perf_event_paranoid=3 sysctl.net.ipv4.tcp_syncookies=1 sysctl.net.ipv4.tcp_rfc1337=1 sysctl.net.ipv4.conf.all.rp_filter=1 sysctl.net.ipv4.conf.default.rp_filter=1 sysctl.net.ipv4.conf.all.accept_redirects=0 sysctl.net.ipv4.conf.default.accept_redirects=0 sysctl.net.ipv4.conf.all.secure_redirects=0 sysctl.net.ipv4.conf.default.secure_redirects=0 sysctl.net.ipv6.conf.all.accept_redirects=0 sysctl.net.ipv6.conf.default.accept_redirects=0 sysctl.net.ipv4.conf.all.send_redirects=0 sysctl.net.ipv4.conf.default.send_redirects=0 sysctl.net.ipv4.conf.all.accept_source_route=0 sysctl.net.ipv4.conf.default.accept_source_route=0 sysctl.net.ipv6.conf.all.accept_source_route=0 sysctl.net.ipv6.conf.default.accept_source_route=0 sysctl.net.ipv6.conf.all.accept_ra=0 sysctl.net.ipv6.conf.default.accept_ra=0 sysctl.net.ipv4.tcp_sack=0 sysctl.net.ipv4.tcp_dsack=0 sysctl.net.ipv4.tcp_fack=0 sysctl.kernel.yama.ptrace_scope=2 sysctl.vm.mmap_rnd_bits=32 sysctl.vm.mmap_rnd_compat_bits=16 sysctl.fs.protected_symlinks=1 sysctl.fs.protected_hardlinks=1 sysctl.fs.protected_fifos=2 sysctl.fs.protected_regular=2"

echo "Setting Timezone"
ln -sf /usr/share/zoneinfo/$TIMEZONE_DOUBLE /etc/localtime
hwclock --systohc

echo "Setting Local"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting Hostname"
echo $HOSTNAME > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1	${HOSTNAME}.localdomain ${HOSTNAME} localhost
::1		localhost
EOF

echo "Adding ArchZFS repo keys"
pacman-key --recv-keys $ARCHZFS_GPG_KEY
pacman-key --lsign-key $ARCHZFS_GPG_KEY

echo "Enabling ZFS Services"
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.target
systemctl enable zfs-mount.service
systemctl enable zfs.target

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
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block zfs filesystems)/' /etc/mkinitcpio.conf
sed -i 's/^MODULES=.*/MODULES=(zfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "Generating GRUB Conf"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT=${GRUB_CMDLINE_LINUX_DEFAULT}/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
