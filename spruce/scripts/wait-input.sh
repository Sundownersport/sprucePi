#!/bin/sh
# Keeps the message on screen until there is something to control PyUI with.
. /opt/spruce/scripts/env.sh
until select_input; do
	printf '\033[2J\033[H\n\n  Connect a controller or keyboard...\n' > /dev/tty1
	sleep 2
done
