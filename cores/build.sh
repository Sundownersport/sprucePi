#!/bin/bash
# Builds one core natively, with libretro-super as the libretro buildbot does, or
# with a recipe in cores/custom for the few it has no rule for:
#   cores/build.sh <core> [output dir]
set -e
LIBRETRO_SUPER_VERSION="${LIBRETRO_SUPER_VERSION:-542c909bc7b56705a6dc42e5323aef1762c618d9}"
core="$1"
root="$(cd "$(dirname "$0")/.." && pwd)"
output="$(realpath -m "${2:-output/cores/$core}")"
mkdir -p "$output"

if [ ! -f /.dockerenv ]; then
	exec docker run --rm -v "$root:/src:ro" -v "$output:/output" -e LIBRETRO_SUPER_VERSION debian:trixie \
		/src/cores/build.sh "$core" /output
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends build-essential cmake git pkg-config python3 ca-certificates \
	zip unzip curl libgl-dev libgles-dev libegl-dev zlib1g-dev \
	$(cat "/src/cores/deps/$core" 2>/dev/null)

# Many cores predate GCC 14, which made these errors.
relax="-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types"
export CFLAGS="$relax"

if [ -f "/src/cores/custom/$core.sh" ]; then
	mkdir -p /build
	cd /build
	. "/src/cores/custom/$core.sh"
else
	git clone https://github.com/libretro/libretro-super.git /libretro-super
	cd /libretro-super
	git checkout "$LIBRETRO_SUPER_VERSION"
	./libretro-fetch.sh "$core"
	./libretro-build.sh "$core"
	so="dist/unix/${core}_libretro.so"
	[ ! -f "dist/info/${core}_libretro.info" ] || cp "dist/info/${core}_libretro.info" /output/
	[ ! -d "libretro-$core" ] || commit=$(git -C "libretro-$core" rev-parse HEAD)
fi

[ -f "$so" ] || { echo "no $so"; exit 1; }
strip -s "$so"
cp "$so" /output/
echo "${commit:-unknown}" > /output/commit.txt
chown -R --reference=/output /output
