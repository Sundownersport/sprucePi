FLYCAST_VERSION="${FLYCAST_VERSION:-v2.6}"

git clone --recursive https://github.com/flyinghead/flycast.git
cd flycast
git checkout "$FLYCAST_VERSION"
git submodule update --init --recursive

mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-O3 -DCMAKE_CXX_FLAGS=-O3 \
	-DUSE_HOST_SDL=ON -DUSE_OPENGL=ON -DUSE_GLES=ON -DUSE_VULKAN=ON -DLIBRETRO=OFF
make -j"$(nproc)"

strip -s flycast
cp flycast "$OUTPUT_DIR/"
collect_libs flycast
