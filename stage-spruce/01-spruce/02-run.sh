#!/bin/bash -e

RELEASES="https://github.com/Sundownersport/sprucePi/releases/download/beta-emulators"
for recipe in "${BASE_DIR}"/emulators/*/; do
	name=$(basename "$recipe")
	dest="${ROOTFS_DIR}/opt/spruce/emulators/$name"
	if curl -fsSL -o "/tmp/$name.tar.gz" "$RELEASES/$name.tar.gz"; then
		install -d "$dest"
		tar -xzf "/tmp/$name.tar.gz" -C "$dest"
		rm "/tmp/$name.tar.gz"
	else
		echo "WARNING: no build of $name in beta-emulators"
	fi
done

# Reused from spruce until sprucePi builds its own.
SPRUCE_REF=0ac664313a183e68c0e8e8a6885058f42b49a44e
rm -rf /tmp/spruceOS
git clone --filter=blob:none --no-checkout https://github.com/spruceUI/spruceOS.git /tmp/spruceOS
GIT_LFS_SKIP_SMUDGE=1 git -C /tmp/spruceOS sparse-checkout set --no-cone \
	/RetroArch/.retroarch/cores64/ /RetroArch/.retroarch/assets/ /RetroArch/.retroarch/info/
GIT_LFS_SKIP_SMUDGE=1 git -C /tmp/spruceOS checkout -q "$SPRUCE_REF"
install -d "${ROOTFS_DIR}/opt/spruce/retroarch/cores"
find /tmp/spruceOS/RetroArch/.retroarch/cores64 -name '*.so' -size +1k \
	-exec cp {} "${ROOTFS_DIR}/opt/spruce/retroarch/cores/" \;
cp -r /tmp/spruceOS/RetroArch/.retroarch/assets /tmp/spruceOS/RetroArch/.retroarch/info "${ROOTFS_DIR}/opt/spruce/retroarch/"
rm -rf /tmp/spruceOS

rm -rf /tmp/autoconfig
git clone --depth 1 https://github.com/libretro/retroarch-joypad-autoconfig.git /tmp/autoconfig
install -d "${ROOTFS_DIR}/opt/spruce/retroarch/autoconfig"
cp -r /tmp/autoconfig/udev "${ROOTFS_DIR}/opt/spruce/retroarch/autoconfig/"
rm -rf /tmp/autoconfig

on_chroot <<CHROOT
chown -R ${FIRST_USER_NAME}: /opt/spruce
CHROOT
