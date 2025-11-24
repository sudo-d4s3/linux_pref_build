#!/bin/bash
set -e 

# User Vars
DISK='/dev/sda'
BOOT_PART="${DISK}1"
ZFS_PART="${DISK}2"
ZFS_PASS='thisisN0Tasecurepassword!'
ENV_DISK_SIZE="4G"

# Script Vars
ARCHZFS_GPG_KEY=3A9917BF0DED5C13F69AC68FABEC0A1208037BE9
KERNEL_VERSION=$(uname -r | sed 's/-/./')
KERNEL_HEADER_PKG="linux-headers-${KERNEL_VERSION}-x86_64.pkg.tar.zst"
KERNEL_HEADER_PKG_URL="https://archive.archlinux.org/packages/l/linux-headers/${KERNEL_HEADER_PKG}"

echo "Adding ArchZFS repo"
cat >> /etc/pacman.conf << EOF
[archzfs]
SigLevel = Required
Server = https://github.com/archzfs/archzfs/releases/download/experimental
EOF

echo "Adding SELinux repo"
cat >> /etc/pacman.conf << EOF
[selinux]
SigLevel = Never
Server = https://github.com/archlinuxhardened/selinux/releases/download/ArchLinux-SELinux
EOF

echo "Importing ArchZFS GPG Keys"
pacman-key --init
pacman-key --recv-keys $ARCHZFS_GPG_KEY
pacman-key --lsign-key $ARCHZFS_GPG_KEY

echo "Updating pacman cache"
pacman -Syy

echo "Expanding Live Environment Space"
mount -o remount,size=$ENV_DISK_SIZE /run/archiso/cowspace

echo "Installing Live Environment Dependencies"
pacman -S curl tar zstd --noconfirm --needed
curl $KERNEL_HEADER_PKG_URL -o $KERNEL_HEADER_PKG
pacman -U $KERNEL_HEADER_PKG --noconfirm --needed

echo "Installing ZFS packages"
pacman -S archzfs-dkms --noconfirm --needed

echo "Partitioning $DISK"
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary fat32 1MiB 512MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary 512MiB 100%

echo "Formatting $BOOT_PART"
mkfs.fat -F32 "$BOOT_PART"

echo "Loading ZFS kernel modual"
modprobe zfs

echo "Creating encrypted ZFS pool"
echo "$ZFS_PASS" | zpool create -f 	\
	-o ashift=12 			\
	-O acltype=posixacl 		\
	-O compression=lz4 		\
	-O dnodesize=auto 		\
	-O normalization=formD 		\
	-O relatime=on 			\
	-O xattr=sa 			\
	-O encryption=aes-256-gcm 	\
	-O keylocation=prompt 		\
	-O keyformat=passphrase 	\
	-O mountpoint=none 		\
	zroot "$ZFS_PART"

echo "Creating ZFS Datasets"
zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default
zfs create -o mountpoint=/home -o exec=off -o setuid=off -o devices=off zroot/data/home
zfs create -o mountpoint=/tmp -o exec=off -o setuid=off -o devices=off zroot/data/tmp
zfs create -o mountpoint=/var -o setuid=off zroot/data/var
zfs create -o mountpoint=/var/log -o exec=off -o setuid=off -o devices=off zroot/data/var-log

echo "Mounting ZFS pool to /mnt"
zpool set bootfs=zroot/ROOT/default zroot
zpool export zroot
echo "$ZFS_PASS" | zpool import -d /dev/disk/by-id -R /mnt/ zroot
echo "$ZFS_PASS" | zfs load-key zroot
zfs mount zroot/ROOT/default

echo "Mounting Boot partition to /mnt/boot"
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

echo "Installing Base Packages"
pacstrap -K /mnt		\
	base-selinux		\
	base-devel		\
        devtools		\
	linux-hardened 		\
	linux-hardened-headers 	\
	grub			\
	efibootmgr		\
	archzfs-dkms		\
	kbd			\
	amd-ucode		\
	intel-ucode		\
	networkmanager		\
	firewalld


echo "Writing FSTAB"
genfstab -U /mnt | grep -v "zroot" >> /mnt/etc/fstab
echo "proc /proc proc nosuid,nodev,noexec,hidepid=2,gid=proc 0 0" >> /mnt/etc/fstab

echo "Allowing systemd-logind to view other user's processes"
mkdir -p /mnt/etc/systemd/system/systemd-logind.service.d
cat > /mnt/etc/systemd/system/systemd-logind.service.d/hidepid.conf << EOF
[Service]
SupplementaryGroups=proc
EOF

echo "Copying pacman.conf"
cp /etc/pacman.conf /mnt/etc/pacman.conf

echo "Entering chroot"
cp chroot-inject.sh /mnt
arch-chroot /mnt /chroot-inject.sh

echo "Cleanup"
rm /mnt/chroot-inject.sh
