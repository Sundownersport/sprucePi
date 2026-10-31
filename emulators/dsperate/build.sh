DSPERATE_VERSION="${DSPERATE_VERSION:-main}"

git clone https://github.com/beebono/DSperate.git
cd DSperate
git checkout "$DSPERATE_VERSION"
apply_patches /patches

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-O3 -pthread" -DCMAKE_CXX_FLAGS="-O3 -pthread" \
	-DDSPERATE_JIT=ON -DDSPERATE_NEON=ON -DDSPERATE_HEADLESS=OFF -DDSPERATE_SDL=ON -DDSPERATE_WAYLAND=OFF -DDSPERATE_TESTS=OFF
[ -d build/src/frontend/sdl ] || { echo "SDL2 not found, no SDL frontend"; exit 1; }
cmake --build build -j"$(nproc)"

strip -s build/src/frontend/sdl/dsperate
mkdir -p "$OUTPUT_DIR/configs"
cp build/src/frontend/sdl/dsperate LICENSE README.md "$OUTPUT_DIR/"
cp configs/*.ini "$OUTPUT_DIR/configs/"
collect_libs build/src/frontend/sdl/dsperate
