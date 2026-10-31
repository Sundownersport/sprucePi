#!/bin/bash
# Runs every .patch and .py in the given directories, in the current directory.
apply_patches() {
	local dir patch
	for dir in "$@"; do
		for patch in "$dir"/*.patch; do
			[ -f "$patch" ] || continue
			git apply "$patch"
			echo "Applied: $(basename "$patch")"
		done
		for patch in "$dir"/*.py; do
			[ -f "$patch" ] || continue
			python3 "$patch"
			echo "Applied: $(basename "$patch")"
		done
	done
}

# Copies what a binary links to into $OUTPUT_DIR/libs, leaving out what the
# image always has.
collect_libs() {
	local skip='linux-vdso|ld-linux|libc\.so|libm\.so|libdl\.so|libpthread\.so|librt\.so|libgcc_s|libstdc\+\+|libSDL2|libasound|libEGL|libGLES|libGL\.|libGLX|libOpenGL|libGLdispatch|libdrm|libgbm|libudev|libX|libxcb|libwayland|libvulkan'
	mkdir -p "$OUTPUT_DIR/libs"
	ldd "$@" | awk '$2 == "=>" && $3 ~ /^\// { print $3 }' | sort -u | grep -vE "$skip" |
		while read -r lib; do cp -Ln "$lib" "$OUTPUT_DIR/libs/"; done
}
