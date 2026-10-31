# The default tuning targets ARMv8.2, which the Pi 3 and 4 lack.
git clone --recursive https://github.com/MagnominusGit/armN64.git
cd armN64
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DARMN64_TUNE=OFF
cmake --build build -j"$(nproc)"
so=build/armn64_libretro.so
cp libretro/armn64_libretro.info /output/
commit=$(git rev-parse HEAD)
