# The commit spruce ships (5.0-90).
ADVMAME_VERSION="${ADVMAME_VERSION:-8da8d34e}"

git clone https://github.com/amadvance/advancemame.git
cd advancemame
git checkout "$ADVMAME_VERSION"
autoreconf -i
CFLAGS="-O3 -fsigned-char" ./configure --enable-sdl2 --disable-sdl --disable-fb --disable-vc --enable-alsa --enable-freetype
make -j"$(nproc)" all

strip -s advmame
cp advmame COPYING "$OUTPUT_DIR/"
collect_libs advmame
