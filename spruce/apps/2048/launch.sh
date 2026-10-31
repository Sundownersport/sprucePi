#!/bin/sh
[ -s /mnt/SDCARD/Saves/retroarch.cfg ] || cp /opt/spruce/retroarch/retroarch.cfg /mnt/SDCARD/Saves/retroarch.cfg
dir=/opt/spruce/emulators/retroarch
LD_LIBRARY_PATH="$dir/libs" exec "$dir/retroarch" --config /mnt/SDCARD/Saves/retroarch.cfg \
	-L /opt/spruce/retroarch/cores/2048_libretro.so
