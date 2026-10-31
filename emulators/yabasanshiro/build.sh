YABA_VERSION="${YABA_VERSION:-a40dace1ae0af3ebd45848549fdf396f40e3930f}"
export CMAKE_POLICY_VERSION_MINIMUM=3.5

git clone --recursive https://github.com/sydarn/yabause.git yabasanshiro
cd yabasanshiro
git checkout "$YABA_VERSION"
git submodule update --init --recursive
apply_patches /patches

mkdir -p build
cd build
cmake ../yabause -DCMAKE_TOOLCHAIN_FILE=../yabause/src/retro_arena/n2.cmake \
	-DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-O3 -DCMAKE_CXX_FLAGS=-O3 \
	-DYAB_PORTS=retro_arena -DYAB_WANT_ARM7=ON -DYAB_WANT_DYNAREC_DEVMIYAX=ON -DYAB_WANT_VULKAN=OFF \
	-DYAB_WANT_OPENAL=OFF -DYAB_MULTIBUILD=OFF -DCMAKE_DISABLE_FIND_PACKAGE_GLUT=TRUE
make -j"$(nproc)"

bin=$(find . -name yabasanshiro -type f -executable | head -1)
[ -n "$bin" ] || bin=$(find . -name 'yabause*' -type f -executable | head -1)
[ -n "$bin" ] || { echo "no yabasanshiro binary"; exit 1; }
strip -s "$bin"
cp "$bin" "$OUTPUT_DIR/yabasanshiro"
collect_libs "$OUTPUT_DIR/yabasanshiro"
