# Master: the v7533 tag predates upstream's CMake build.
OPENBOR_VERSION="${OPENBOR_VERSION:-65a7f0b41aee87fe4084e538634b4ed73236f871}"

git clone https://github.com/DCurrent/openbor.git
cd openbor
git checkout "$OPENBOR_VERSION"
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_LINUX=ON -DTARGET_ARCH=ARM64
cmake --build build --parallel

strip -s engine/releases/LINUX/OpenBOR-arm64
cp engine/releases/LINUX/OpenBOR-arm64 "$OUTPUT_DIR/OpenBOR"
cp LICENSE "$OUTPUT_DIR/"
collect_libs "$OUTPUT_DIR/OpenBOR"
