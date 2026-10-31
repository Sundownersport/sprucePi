XROAR_VERSION="${XROAR_VERSION:-1.11}"

curl -fsSL "https://www.6809.org.uk/xroar/dl/xroar-$XROAR_VERSION.tar.gz" | tar xz
cd "xroar-$XROAR_VERSION"
./configure --without-gl CFLAGS=-O3
make -j"$(nproc)"

strip -s src/xroar
cp src/xroar "$OUTPUT_DIR/"
cp COPYING* "$OUTPUT_DIR/" 2>/dev/null || true
collect_libs src/xroar
