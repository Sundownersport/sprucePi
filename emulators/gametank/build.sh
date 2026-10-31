GTE_VERSION="${GTE_VERSION:-9896544460d5bb7dd89c2d2bc0f5c97a6f31d2e0}"

git clone https://github.com/clydeshaffer/GameTankEmulator.git gte
cd gte
git checkout "$GTE_VERSION"
git submodule update --init --depth 1 src/mos6502 src/imgui/ext/implot
apply_patches /patches/common

make -j"$(nproc)" bin OPTIM_FLAGS=-O2

strip -s build/GameTankEmulator
cp build/GameTankEmulator "$OUTPUT_DIR/"
collect_libs build/GameTankEmulator
