PPSSPP_VERSION="${PPSSPP_VERSION:-v1.20.3}"

git clone --depth 1 --branch "$PPSSPP_VERSION" --recurse-submodules --shallow-submodules \
	https://github.com/hrydgard/ppsspp.git
cd ppsspp
apply_patches /patches/common /patches/darkmoss

mkdir -p build
cd build
FLAGS="-O3 -ffunction-sections -fdata-sections -fomit-frame-pointer -flto=auto -Wno-error"
cmake .. -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS="$FLAGS" -DCMAKE_CXX_FLAGS="$FLAGS" \
	-DCMAKE_EXE_LINKER_FLAGS="-Wl,--gc-sections -flto=auto" \
	-DUSING_GLES2=ON -DUSING_EGL=OFF -DUSING_FBDEV=OFF -DVULKAN=OFF -DUSING_X11_VULKAN=OFF \
	-DUSE_WAYLAND_WSI=OFF -DBUILD_SHARED_LIBS=OFF -DUSE_SYSTEM_LIBPNG=OFF -DUSE_SYSTEM_FFMPEG=OFF \
	-DUSE_DISCORD=OFF -DUSE_MINIUPNPC=OFF -DHEADLESS=OFF -DUNITTEST=OFF \
	-DCMAKE_DISABLE_FIND_PACKAGE_SDL2_ttf=ON -DCMAKE_DISABLE_FIND_PACKAGE_Fontconfig=ON \
	-DCMAKE_DISABLE_FIND_PACKAGE_X11=ON
make -j"$(nproc)" PPSSPPSDL

strip -s PPSSPPSDL
cp PPSSPPSDL "$OUTPUT_DIR/"
cp -r ../assets "$OUTPUT_DIR/assets"
collect_libs PPSSPPSDL
