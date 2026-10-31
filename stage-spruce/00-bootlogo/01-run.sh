#!/bin/bash -e

THEME="${ROOTFS_DIR}/usr/share/plymouth/themes/spruce"
install -d "${THEME}"
install -m 644 files/spruce.plymouth files/spruce.script files/splash.png "${THEME}/"

on_chroot <<CHROOT
plymouth-set-default-theme spruce
CHROOT

sed -i 's/$/ quiet splash logo.nologo vt.global_cursor_default=0/' "${ROOTFS_DIR}/boot/firmware/cmdline.txt"
echo "disable_splash=1" >> "${ROOTFS_DIR}/boot/firmware/config.txt"
