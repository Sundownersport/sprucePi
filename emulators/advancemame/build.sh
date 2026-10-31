# The commit spruce ships (5.0-90). No upstream branch has it, so it needs fetching by hash.
ADVMAME_VERSION="${ADVMAME_VERSION:-8da8d34e082380f89a60298778aac72a533b28a4}"

git clone https://github.com/amadvance/advancemame.git
cd advancemame
git fetch origin "$ADVMAME_VERSION"
git checkout FETCH_HEAD
autoreconf -i
CFLAGS="-O3 -fsigned-char" ./configure --enable-sdl2 --disable-sdl --disable-fb --disable-vc --enable-alsa --enable-freetype
make -j"$(nproc)" all

strip -s advmame
cp advmame COPYING "$OUTPUT_DIR/"
collect_libs advmame
