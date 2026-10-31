# The libretro-super rule expects a Makefile.libretro that the repo no longer has.
git clone https://github.com/libretro/hatari.git
cd hatari
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DENABLE_LIBRETRO=ON -DENABLE_HATARI=OFF -DENABLE_TOOLS=OFF
cmake --build build -j"$(nproc)"
so=build/src/hatari_libretro.so
commit=$(git rev-parse HEAD)
