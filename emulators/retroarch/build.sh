RETROARCH_VERSION="${RETROARCH_VERSION:-v1.22.2}"

git clone --depth 1 --branch "$RETROARCH_VERSION" https://github.com/libretro/RetroArch.git
cd RetroArch
apply_patches /patches/common
cp -r /recipe/common_src/* .

FLAGS="-O3 -flto=auto -ffunction-sections -fdata-sections -DHAVE_SCREEN_ORIENTATION -DGEOMETRY_MENU_ROTATION -D_GNU_SOURCE -DHAVE_FILTERS_BUILTIN"
CFLAGS="$FLAGS" CXXFLAGS="$FLAGS" LDFLAGS="-Wl,--gc-sections -flto=auto" ./configure \
	--disable-x11 --disable-wayland --enable-vulkan --disable-opengl --disable-qt --disable-kms \
	--disable-pulse --disable-jack --disable-oss --disable-discord \
	--enable-udev --enable-opengles --enable-opengles3 --enable-egl --enable-sdl2 --enable-alsa \
	--enable-networking --enable-ssl --enable-command --enable-freetype --enable-builtinzlib --enable-zlib
make HAVE_STATIC_VIDEO_FILTERS=1 HAVE_STATIC_AUDIO_FILTERS=1 -j"$(nproc)"

strip -s retroarch
cp retroarch "$OUTPUT_DIR/"
collect_libs retroarch
