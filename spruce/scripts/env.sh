#!/bin/sh
export SCREEN_WIDTH=1280 SCREEN_HEIGHT=720 SCREEN_ROTATION=0
# DARKMOSS: the system configs already list it, and it is also 64-bit Debian trixie.
export PYUI_DEVICE_NAMES=SPRUCEPI,DARKMOSS
export AUDIO_PLAYER=SDL2
export POWER_OFF_CMD=poweroff REBOOT_CMD=reboot
export CONTROLLER_EVENT_FORMAT=llHHi

export DEFAULT_CFG_PATH=/opt/spruce/config/system.json
export SYSTEM_CFG_PATH=/mnt/SDCARD/Saves/sprucepi-system.json
export ROMS_PATH=/mnt/SDCARD/Roms/
export FAVORITES_PATH=/mnt/SDCARD/Saves/pyui-favorites.json
export RECENTS_PATH=/mnt/SDCARD/Saves/pyui-recents.json
export APPS_CONFIG_PATH=/mnt/SDCARD/Saves/pyui-apps.json
export COLLECTIONS_PATH=/mnt/SDCARD/Collections/
export STATE_PATH=/mnt/SDCARD/Saves/pyui-state.json

find_input() {
	for dev in /dev/input/event*; do
		udevadm info -q property -n "$dev" 2>/dev/null | grep -q "^$1=1" && { echo "$dev"; return 0; }
	done
	return 1
}

# A gamepad wins over a keyboard. Returns 1 with neither connected.
select_input() {
	if pad=$(find_input ID_INPUT_JOYSTICK); then
		export CONTROLLER_EVENT_PATH="$pad"
		CONTROLLER_KEY_MAPPINGS="$(cat /opt/spruce/config/keymap-gamepad.json)"
		export CONTROLLER_KEY_MAPPINGS
		export LEFT_STICK_X_AXIS=0 LEFT_STICK_Y_AXIS=1
		export RIGHT_STICK_X_AXIS=3 RIGHT_STICK_Y_AXIS=4
		export STICK_DEADZONE=16000
	elif keyboard=$(find_input ID_INPUT_KEYBOARD); then
		export CONTROLLER_EVENT_PATH="$keyboard"
		CONTROLLER_KEY_MAPPINGS="$(cat /opt/spruce/config/keymap-keyboard.json)"
		export CONTROLLER_KEY_MAPPINGS
	else
		return 1
	fi
}
