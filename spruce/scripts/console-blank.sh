#!/bin/sh
# Keep the console from showing between PyUI and whatever it launches.
for vtcon in /sys/class/vtconsole/vtcon*; do
	case "$(cat "$vtcon/name" 2>/dev/null)" in
		*"frame buffer device"*) echo 0 > "$vtcon/bind" 2>/dev/null ;;
	esac
done
exit 0
