SCUMMVM_VERSION="${SCUMMVM_VERSION:-v2026.2.0}"

git clone --depth 1 --branch "$SCUMMVM_VERSION" https://github.com/scummvm/scummvm.git
cd scummvm
apply_patches /patches/common

export CFLAGS="-O3 -ffunction-sections -fdata-sections -flto=auto"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--gc-sections -flto=auto"
./configure --backend=sdl --opengl-mode=gles2 --enable-all-engines --enable-optimizations \
	--enable-release --disable-debug --disable-eventrecorder --enable-vkeybd --enable-openmpt \
	--enable-fluidsynth
make -j"$(nproc)"

strip -s scummvm
mkdir -p "$OUTPUT_DIR/LICENSES" "$OUTPUT_DIR/Theme" "$OUTPUT_DIR/Extra/shaders"
cp scummvm "$OUTPUT_DIR/"
cp LICENSES/* "$OUTPUT_DIR/LICENSES/"
cp gui/themes/*.dat gui/themes/*.zip dists/networking/wwwroot.zip "$OUTPUT_DIR/Theme/"
cp -r dists/engine-data/* backends/vkeybd/packs/vkeybd_default.zip backends/vkeybd/packs/vkeybd_small.zip "$OUTPUT_DIR/Extra/"
rm -rf "$OUTPUT_DIR/Extra/patches" "$OUTPUT_DIR/Extra/testbed-audiocd-files" "$OUTPUT_DIR/Extra/README" "$OUTPUT_DIR"/Extra/*.mk "$OUTPUT_DIR"/Extra/*.sh
find engines/ -type f \( -name '*.fragment' -o -name '*.vertex' \) -exec cp {} "$OUTPUT_DIR/Extra/shaders/" \;
collect_libs scummvm
