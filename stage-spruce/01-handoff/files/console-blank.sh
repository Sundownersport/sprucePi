#!/bin/sh
# Keep the console from showing between the frontend and a game.
for vtcon in /sys/class/vtconsole/vtcon*; do
	case "$(cat "$vtcon/name" 2>/dev/null)" in
		*"frame buffer device"*) echo 0 > "$vtcon/bind" 2>/dev/null ;;
	esac
done
exit 0
