PCSX_VERSION="${PCSX_VERSION:-master}"

git clone --recursive https://github.com/notaz/pcsx_rearmed.git
cd pcsx_rearmed
git checkout "$PCSX_VERSION"
git submodule update --init --recursive
apply_patches /patches

./configure --platform=generic --gpu=neon --sound-drivers="alsa sdl" --enable-neon
make -j"$(nproc)"

strip -s pcsx
cp pcsx "$OUTPUT_DIR/"
[ -d frontend/pandora/skin ] && cp -r frontend/pandora/skin "$OUTPUT_DIR/skin"
collect_libs pcsx
