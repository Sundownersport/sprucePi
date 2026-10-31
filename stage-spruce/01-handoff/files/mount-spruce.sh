#!/bin/sh
# Mount the FAT or exFAT partition holding spruce at /mnt/SDCARD. With none yet,
# say so and fail: the unit retries, so plugging the drive in is enough.
mountpoint -q /mnt/SDCARD && [ -f /mnt/SDCARD/spruce/scripts/runtime.sh ] && exit 0
mkdir -p /mnt/SDCARD
boot_dev=$(findmnt -no SOURCE /boot/firmware)

for dev in $(lsblk -rno PATH,FSTYPE | awk '$2 == "vfat" || $2 == "exfat" { print $1 }'); do
	[ "$dev" != "$boot_dev" ] || continue
	mount -o rw,noatime,umask=0000 "$dev" /mnt/SDCARD 2>/dev/null || continue
	if [ -f /mnt/SDCARD/spruce/scripts/runtime.sh ]; then
		printf '\033[2J\033[H' > /dev/tty1
		exit 0
	fi
	umount /mnt/SDCARD
done

printf '\033[2J\033[H\n\n  Looking for a spruce drive...\n' > /dev/tty1
exit 1
