git clone https://github.com/seriamaugenlicher/gloopy.git
cd gloopy
make -f Makefile.libretro platform=unix BUILD_TAG=arm64 -j"$(nproc)"
so=gloopy_libretro.so
commit=$(git rev-parse HEAD)
