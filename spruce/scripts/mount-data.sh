#!/bin/sh
# PyUI hardcodes /mnt/SDCARD/App, /spruce and /Emu, so bind the system partition's
# copies there instead of editing the subtree.
mkdir -p /mnt/SDCARD
mountpoint -q /mnt/SDCARD || mount /mnt/SDCARD

mkdir -p /mnt/SDCARD/App /mnt/SDCARD/spruce /mnt/SDCARD/Emu /mnt/SDCARD/Roms \
	/mnt/SDCARD/BIOS /mnt/SDCARD/Collections /mnt/SDCARD/Saves/spruce \
	/mnt/SDCARD/Saves/saves /mnt/SDCARD/Saves/states
mountpoint -q /mnt/SDCARD/App || mount --bind /opt/spruce/apps /mnt/SDCARD/App
mountpoint -q /mnt/SDCARD/spruce || mount --bind /opt/spruce /mnt/SDCARD/spruce
mountpoint -q /mnt/SDCARD/Emu || mount --bind /opt/spruce/emu /mnt/SDCARD/Emu

[ -s /mnt/SDCARD/Saves/pyui-config.json ] || cp /opt/spruce/config/pyui-config.json /mnt/SDCARD/Saves/pyui-config.json
