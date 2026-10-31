#!/bin/sh
# Runs PyUI, then whatever it staged in /tmp/cmd_to_run.sh, then PyUI again.
. /opt/spruce/scripts/env.sh

until select_input; do
	printf '\033[2J\033[H\n\n  Connect a controller or keyboard...\n' > /dev/tty1
	sleep 2
done
/opt/spruce/scripts/console-blank.sh

fast_fails=0
while :; do
	started=$(date +%s)
	python3 /opt/spruce/pyui/main-ui/mainui.py \
		-device SPRUCE \
		-logDir /mnt/SDCARD/Saves/spruce \
		-pyUiConfig /mnt/SDCARD/Saves/pyui-config.json \
		-cfwConfig /mnt/SDCARD/Saves/spruce/spruce-config.json
	status=$?

	if [ -s /tmp/cmd_to_run.sh ]; then
		fast_fails=0
		chmod a+x /tmp/cmd_to_run.sh
		/tmp/cmd_to_run.sh
		rm -f /tmp/cmd_to_run.sh
	elif [ "$status" -ne 0 ] && [ $(($(date +%s) - started)) -lt 5 ]; then
		fast_fails=$((fast_fails + 1))
		# Three quick crashes: go to the desktop instead of a black screen.
		[ "$fast_fails" -lt 3 ] || exec systemctl start --no-block lightdm.service
	else
		fast_fails=0
	fi
done
