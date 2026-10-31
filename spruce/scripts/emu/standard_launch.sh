#!/bin/sh
# Every system's config.json points here. Picks the emulator the same way PyUI
# shows it, then runs it from /opt/spruce/emulators or through RetroArch.
. /opt/spruce/scripts/env.sh

EMU_NAME=${0#*/Emu/}
EMU_NAME=${EMU_NAME%%/*}
ROM="$1"
GAME=$(basename "$ROM")
SAVES=/mnt/SDCARD/Saves/saves
BIOS=/mnt/SDCARD/BIOS

CORE=$(jq -r --arg game "$GAME" --arg names "$PYUI_DEVICE_NAMES" '
	($names | split(",")) as $names
	| (.menuOptions // {}) as $options
	| ([$options | to_entries[]
		| select(.key | startswith("Emulator"))
		| select((.value.devices // []) as $devices | any($names[]; . as $name | $devices | index($name)))]
		| first | .value) as $match
	| ($match // $options.Emulator // {}) as $option
	| ($option.overrides[$game]? // $option.selected // .default_emulator)
' "/opt/spruce/emu/$EMU_NAME/config.json")

standalone() {
	dir="/opt/spruce/emulators/$1"
	[ -d "$dir" ] || { echo "$1 is not installed" >&2; exit 1; }
	export LD_LIBRARY_PATH="$dir/libs"
	cd "$dir"
	export HOME="$SAVES/$1"
	mkdir -p "$HOME"
}

retroarch() {
	core=${1%-libretro}
	core=${core%_libretro}
	[ -f "/opt/spruce/retroarch/cores/${core}_libretro.so" ] || { echo "no core: $core" >&2; exit 1; }
	[ -s /mnt/SDCARD/Saves/retroarch.cfg ] || cp /opt/spruce/retroarch/retroarch.cfg /mnt/SDCARD/Saves/retroarch.cfg
	dir=/opt/spruce/emulators/retroarch
	LD_LIBRARY_PATH="$dir/libs" "$dir/retroarch" --config /mnt/SDCARD/Saves/retroarch.cfg \
		-L "/opt/spruce/retroarch/cores/${core}_libretro.so" "$ROM"
}

case "$EMU_NAME:$CORE" in
	PSP:*)
		standalone ppsspp
		exec ./PPSSPPSDL "$ROM" --fullscreen --pause-menu-exit
		;;
	*:mupen64plus-standalone)
		standalone mupen64plus
		exec ./mupen64plus --fullscreen --resolution "${SCREEN_WIDTH}x${SCREEN_HEIGHT}" \
			--configdir "$HOME" --datadir data --plugindir . --gfx mupen64plus-video-GLideN64 "$ROM"
		;;
	*:Flycast-standalone | *:Flycast2024-standalone)
		standalone flycast
		export XDG_DATA_HOME="$HOME" XDG_CONFIG_HOME="$HOME"
		exec ./flycast "$ROM"
		;;
	*:yabasanshiro-standalone-*)
		standalone yabasanshiro
		bios=""
		[ "$CORE" = yabasanshiro-standalone-bios ] && [ -f "$BIOS/saturn_bios.bin" ] && bios="$BIOS/saturn_bios.bin"
		exec ./yabasanshiro -r 3 -i "$ROM" ${bios:+-b "$bios"}
		;;
	SCUMMVM:*)
		standalone scummvm
		id=$(tr -d '\r\n' < "$ROM")
		data="${ROM%.*}"
		[ -d "$data" ] || data=$(dirname "$ROM")
		exec ./scummvm --config="$HOME/scummvm.ini" --themepath=Theme --extrapath=Extra --fullscreen --path="$data" "$id"
		;;
	NDS:* | NDSI:*)
		standalone dsperate
		exec ./dsperate "$ROM" --fullscreen
		;;
	GAMETANK:gametank-standalone)
		standalone gametank
		exec ./GameTankEmulator "$ROM"
		;;
	*:advmame-standalone)
		standalone advancemame
		exec ./advmame -dir_rom "$(dirname "$ROM")" "${GAME%.*}"
		;;
	OPENBOR:*)
		standalone openbor
		exec ./OpenBOR "$ROM"
		;;
	COCO:*)
		standalone xroar
		exec ./xroar -default-machine coco2bus "$ROM"
		;;
	JAGUAR:bigpemu*)
		retroarch virtualjaguar
		;;
	*)
		retroarch "$CORE"
		;;
esac
