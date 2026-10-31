OPENBOR_VERSION="${OPENBOR_VERSION:-v7533}"

git clone --branch "$OPENBOR_VERSION" https://github.com/DCurrent/openbor.git
cd openbor
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_LINUX=ON -DTARGET_ARCH=ARM64
cmake --build build --parallel

strip -s engine/releases/LINUX/OpenBOR-arm64
cp engine/releases/LINUX/OpenBOR-arm64 "$OUTPUT_DIR/OpenBOR"
cp LICENSE "$OUTPUT_DIR/"
collect_libs "$OUTPUT_DIR/OpenBOR"
