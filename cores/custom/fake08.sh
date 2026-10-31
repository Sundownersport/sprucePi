git clone --depth 1 --recurse-submodules https://github.com/jtothebell/fake-08.git
cd fake-08
make -C platform/libretro -j"$(nproc)"
so=platform/libretro/fake08_libretro.so
commit=$(git rev-parse HEAD)
