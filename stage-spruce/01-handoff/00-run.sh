#!/bin/bash -e

install -m 755 files/mount-spruce.sh files/console-blank.sh "${ROOTFS_DIR}/usr/local/sbin/"
install -m 644 files/spruce-launch.service "${ROOTFS_DIR}/etc/systemd/system/"
echo 'SPRUCE_PLATFORM="RaspberryPi"' > "${ROOTFS_DIR}/etc/sprucepi-release"

on_chroot <<CHROOT
systemctl enable spruce-launch.service
systemctl mask getty@tty1.service
CHROOT
