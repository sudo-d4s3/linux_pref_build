#!/bin/bash
set -e

# User Vars
TIMEZONE_DOUBLE="America/Chicago"
HOSTNAME="puter"
USERNAME="com"
ARCHZFS_GPG_KEY=3A9917BF0DED5C13F69AC68FABEC0A1208037BE9

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

echo "Updating mikinitcpio for ZFS"
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block zfs filesystems)/' /etc/mkinitcpio.conf
sed -i 's/^MODULES=.*/MODULES=(zfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo "Generating GRUB Conf"
GRUB_CMDLINE_LINUX_DEFAULT="root=ZFS=zroot/ROOT/default rw quiet splash"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
