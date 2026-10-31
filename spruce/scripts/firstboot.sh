#!/bin/sh -e
# Grow the system partition to 16 GB and give the rest to an exFAT data partition.
root_part=$(findmnt -no SOURCE /)
disk=/dev/$(lsblk -no PKNAME "$root_part")
disk_gib=$(($(blockdev --getsize64 "$disk") / 1073741824))

if [ "$disk_gib" -lt 24 ]; then
	plymouth quit 2>/dev/null || true
	printf '\033[2J\033[H\n\n  sprucePi needs a 32 GB or larger card.\n' > /dev/tty1
	exec sleep infinity
fi

echo ",16G" | sfdisk --force --no-reread --no-tell-kernel -N 2 "$disk"
partx -u -n 2 "$disk"
resize2fs "$root_part"

echo ",,7" | sfdisk --force --no-reread --no-tell-kernel --append "$disk"
partx -a -n 3 "$disk"
udevadm settle
data_part=$(lsblk -rno PATH "$disk" | sed -n 4p)
mkfs.exfat -L SPRUCEPI "$data_part"

echo "LABEL=SPRUCEPI /mnt/SDCARD exfat defaults,noatime,umask=0000,nofail 0 0" >> /etc/fstab
systemctl daemon-reload
touch /var/lib/sprucepi-firstboot-done
