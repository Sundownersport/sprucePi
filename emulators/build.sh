#!/bin/bash
# Builds one emulator natively, inside a clean Debian trixie container:
#   emulators/build.sh <name> [output dir]
set -e
name="$1"
root="$(cd "$(dirname "$0")/.." && pwd)"
output="$(realpath -m "${2:-output/$name}")"
[ -f "$root/emulators/$name/build.sh" ] || { echo "unknown emulator: $name"; exit 1; }
mkdir -p "$output"

if [ ! -f /.dockerenv ]; then
	exec docker run --rm -v "$root:/src:ro" -v "$output:/output" debian:trixie \
		/src/emulators/build.sh "$name" /output
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends build-essential git pkg-config python3 ca-certificates \
	$(cat "/src/emulators/$name/deps")

# The spruce patch scripts expect these fixed paths.
cp -a "/src/emulators/$name/." /recipe/ 2>/dev/null || { mkdir -p /recipe; cp -a "/src/emulators/$name/." /recipe/; }
[ -d /recipe/patches ] && ln -sfn /recipe/patches /patches
[ -d /recipe/overlay ] && ln -sfn /recipe/overlay /overlay
mkdir -p /build
cd /build
export OUTPUT_DIR=/output
. /src/emulators/common.sh
. /recipe/build.sh
chown -R --reference=/output /output
