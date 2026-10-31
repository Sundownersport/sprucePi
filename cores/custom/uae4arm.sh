# libretro-super passes platform=unix, which this Makefile treats as 32-bit ARM.
git clone https://github.com/libretro/uae4arm-libretro.git
cd uae4arm-libretro
make -f Makefile.libretro platform=unix-aarch64 CAPS= -j"$(nproc)"
so=uae4arm_libretro.so
commit=$(git rev-parse HEAD)
