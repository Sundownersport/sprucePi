MUPEN_VERSION="${MUPEN_VERSION:-master}"

export OPTFLAGS="-O3 -ffunction-sections -fdata-sections -flto=auto"
export LDFLAGS="-Wl,--gc-sections -flto=auto"
APIDIR=/build/core/src/api
SDL_CFLAGS="$(pkg-config --cflags sdl2)"
SDL_LDLIBS="$(pkg-config --libs sdl2)"
export SDL_CFLAGS SDL_LDLIBS

m64p_make() {
	make -C "$1" HOST_CPU=aarch64 USE_GLES=1 NEW_DYNAREC=1 VULKAN=0 APIDIR="$APIDIR" \
		SDL_CFLAGS="$SDL_CFLAGS" SDL_LDLIBS="$SDL_LDLIBS" OPTFLAGS="$OPTFLAGS" PREFIX="" V=1 \
		-j"$(nproc)" all
}

clone() {
	git clone --depth 1 --branch "$MUPEN_VERSION" "https://github.com/$1.git" "$2"
}
clone mupen64plus/mupen64plus-core core
clone mupen64plus/mupen64plus-ui-console ui-console
clone mupen64plus/mupen64plus-audio-sdl audio-sdl
clone mupen64plus/mupen64plus-input-sdl input-sdl
clone mupen64plus/mupen64plus-rsp-hle rsp-hle
clone mupen64plus/mupen64plus-video-rice video-rice
clone mupen64plus/mupen64plus-video-glide64mk2 video-glide64mk2
git init -q video-gliden64
git -C video-gliden64 fetch --depth 1 https://github.com/gonetz/GLideN64.git c8ef81c7d9aede9f67f6ed3d3426c90541f9f13e
git -C video-gliden64 checkout -q FETCH_HEAD

apply_patches /patches/common /patches/universal

m64p_make core/projects/unix

for src in emu_overlay emu_overlay_cfg emu_overlay_sdl emu_frontend cjson/cJSON; do
	cc $OPTFLAGS -fPIC -I/overlay -I/overlay/cjson $SDL_CFLAGS -I"$APIDIR" \
		-c "/overlay/$src.c" -o "/overlay/$(basename "$src").o"
done
ar rcs /overlay/liboverlay.a /overlay/*.o

m64p_make audio-sdl/projects/unix
m64p_make input-sdl/projects/unix
m64p_make rsp-hle/projects/unix
m64p_make video-rice/projects/unix
m64p_make video-glide64mk2/projects/unix

mkdir -p video-gliden64/src/build
(
	cd video-gliden64/src/build
	cmake .. -DCMAKE_BUILD_TYPE=Release -DMUPENPLUSAPI=ON -DEGL=ON -DUSE_SYSTEM_LIBS=ON \
		-DCMAKE_C_FLAGS="$OPTFLAGS" -DCMAKE_CXX_FLAGS="$OPTFLAGS" \
		-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS"
	make -j"$(nproc)"
)

m64p_make ui-console/projects/unix

cp ui-console/projects/unix/mupen64plus "$OUTPUT_DIR/"
cp core/projects/unix/libmupen64plus.so.2.0.0 "$OUTPUT_DIR/libmupen64plus.so.2"
cp audio-sdl/projects/unix/mupen64plus-audio-sdl.so input-sdl/projects/unix/mupen64plus-input-sdl.so \
	rsp-hle/projects/unix/mupen64plus-rsp-hle.so video-rice/projects/unix/mupen64plus-video-rice.so \
	video-glide64mk2/projects/unix/mupen64plus-video-glide64mk2.so \
	video-gliden64/src/build/plugin/Release/mupen64plus-video-GLideN64.so "$OUTPUT_DIR/"
strip -s "$OUTPUT_DIR"/mupen64plus "$OUTPUT_DIR"/*.so*

mkdir -p "$OUTPUT_DIR/data"
cp core/data/* video-rice/data/* video-glide64mk2/data/* "$OUTPUT_DIR/data/"
cp video-gliden64/ini/* "$OUTPUT_DIR/data/" 2>/dev/null || true
cp /overlay/overlay_settings.json "$OUTPUT_DIR/"
collect_libs "$OUTPUT_DIR"/mupen64plus "$OUTPUT_DIR"/*.so
