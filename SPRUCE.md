# sprucePi

Raspberry Pi OS Lite (64-bit) that boots into spruce, built with
[pi-gen](https://github.com/RPi-Distro/pi-gen). The `spruce` branch is upstream's `arm64`
branch plus new files only: `stage-spruce/`, `sprucepi.config`, the workflow and this file.
Upstream's own files stay untouched so updates merge cleanly.

- **Build:** run the "Build image" workflow. The image is the `sprucePi` artifact.
- **Boot logo:** `stage-spruce/00-bootlogo`
- **Handoff:** `stage-spruce/01-handoff` mounts the FAT or exFAT drive holding spruce at
  `/mnt/SDCARD` and runs `spruce/scripts/runtime.sh`.
- **Login:** `spruce` / `happygaming`, with SSH on.
