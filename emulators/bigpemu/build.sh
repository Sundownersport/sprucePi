# BigPEmu is closed source: this packages upstream's ARM64 build with gl4es.
git clone --depth=1 https://github.com/ptitSeb/gl4es.git
mkdir -p gl4es/build
(
	cd gl4es/build
	cmake .. -DODROID=1 -DNOX11=1 -DNOEGL=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
	make -j"$(nproc)"
	strip ../lib/libGL.so.1
	cp ../lib/libGL.so.1 "$OUTPUT_DIR/"
)
ln -sf libGL.so.1 "$OUTPUT_DIR/libOpenGL.so"
ln -sf libOpenGL.so "$OUTPUT_DIR/libOpenGL.so.0"

url="$(curl -s 'https://www.richwhitehouse.com/jaguar/index.php?content=download' |
	grep -oE 'https://www.richwhitehouse.com/jaguar/builds/BigPEmu_LinuxARM64_v[0-9]+\.tar\.gz' | head -1)"
[ -n "$url" ] || { echo "no BigPEmu ARM64 download link"; exit 1; }
curl -sL -o bigpemu.tar.gz "$url"
mkdir -p bp
tar xzf bigpemu.tar.gz -C bp
cp -rf "$(dirname "$(find bp -name bigpemu -type f | head -1)")"/* "$OUTPUT_DIR/"
chmod 0755 "$OUTPUT_DIR/bigpemu"
install -m 755 /recipe/scripts/bigpemu.sh "$OUTPUT_DIR/"
install -Dm 644 /recipe/config/BigPEmuConfig.bigpcfg "$OUTPUT_DIR/defaultconfigs/BigPEmuConfig.bigpcfg"
