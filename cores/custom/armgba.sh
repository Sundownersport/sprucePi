ARMGBA_VERSION="${ARMGBA_VERSION:-v1.2.1}"

git clone --depth 1 --branch "$ARMGBA_VERSION" https://github.com/MagnominusGit/armGBA.git
cd armGBA
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
so=build/armgba_libretro.so
commit=$(git rev-parse HEAD)
