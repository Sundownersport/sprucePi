# The libretro-super rule does not build liblcf.
git clone --recurse-submodules https://github.com/EasyRPG/Player.git
cd Player
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DPLAYER_TARGET_PLATFORM=libretro -DBUILD_SHARED_LIBS=ON -DPLAYER_BUILD_LIBLCF=ON
cmake --build build -j"$(nproc)"
so=build/easyrpg_libretro.so
commit=$(git rev-parse HEAD)
