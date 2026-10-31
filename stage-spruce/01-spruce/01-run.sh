#!/bin/bash -e

install -d "${ROOTFS_DIR}/opt/spruce"
cp -a "${BASE_DIR}/spruce/." "${ROOTFS_DIR}/opt/spruce/"
install -m 644 files/spruce-launch.service files/sprucepi-firstboot.service "${ROOTFS_DIR}/etc/systemd/system/"
echo 'SPRUCE_PLATFORM="RaspberryPi"' > "${ROOTFS_DIR}/etc/sprucepi-release"

on_chroot <<CHROOT
chown -R ${FIRST_USER_NAME}: /opt/spruce
systemctl enable sprucepi-firstboot.service spruce-launch.service
systemctl mask getty@tty1.service
CHROOT
