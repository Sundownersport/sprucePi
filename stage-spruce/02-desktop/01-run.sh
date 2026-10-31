#!/bin/bash -e

install -d "${ROOTFS_DIR}/etc/lightdm/lightdm.conf.d" "${ROOTFS_DIR}/usr/share/applications" "${ROOTFS_DIR}/etc/xdg/autostart"
install -m 644 files/50-sprucepi.conf "${ROOTFS_DIR}/etc/lightdm/lightdm.conf.d/"
install -m 644 files/50-sprucepi.rules "${ROOTFS_DIR}/etc/polkit-1/rules.d/"
install -m 644 files/spruce.desktop "${ROOTFS_DIR}/usr/share/applications/"
install -m 644 files/yakuake.desktop "${ROOTFS_DIR}/etc/xdg/autostart/"
install -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/Desktop"
install -m 755 files/spruce.desktop "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/Desktop/"

on_chroot <<CHROOT
chown -R ${FIRST_USER_NAME}: /home/${FIRST_USER_NAME}/Desktop
systemctl disable lightdm.service
systemctl set-default multi-user.target
CHROOT
