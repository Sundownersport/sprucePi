# The libretro-super rule expects a Makefile.libretro that the repo no longer has.
git clone https://github.com/libretro/mgba.git
cd mgba
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DLIBMGBA_ONLY=ON -DBUILD_LIBRETRO=ON
cmake --build build -j"$(nproc)"
so=build/mgba_libretro.so
commit=$(git rev-parse HEAD)
