# sprucePi

Raspberry Pi OS Lite (64-bit) with PyUI as its frontend and an LXQt desktop, built with
[pi-gen](https://github.com/RPi-Distro/pi-gen). The `spruce` branch is upstream's `arm64`
branch plus new files only, so upstream updates merge cleanly.

- **Build:** run the "Build image" workflow. It replaces the `beta-spruce` prerelease.
- **Login:** `spruce` / `happygaming`, with SSH on.

## Layout

| Where | What |
|---|---|
| `spruce/` -> `/opt/spruce` (ext4) | `pyui` (subtree of spruceOS `App/PyUI`), `apps`, `emu` (system configs), `retroarch`, `scripts`, `config`, `themes` |
| `/mnt/SDCARD` (exFAT, made on first boot) | `Roms`, `BIOS`, `Saves` |
| `stage-spruce/` | The pi-gen stage: boot logo, spruce, desktop |

PyUI hardcodes `/mnt/SDCARD/App`, `/spruce` and `/Emu`, so `mount-data.sh` binds the
`/opt/spruce` copies there. Leave `spruce/pyui` unedited where possible.

## Updating PyUI

In a clone of spruceOS, then here:

```sh
git subtree split -P App/PyUI origin/Development -b pyui-only
git subtree pull -P spruce/pyui /path/to/spruceOS pyui-only
```

## Emulators

`emulators/<name>/` holds a `deps` list, a `build.sh` and the spruce patches for one emulator. The
"Build emulators" workflow builds them natively on arm64 and posts them to the `beta-emulators`
release, which the image build unpacks into `/opt/spruce/emulators`. To build one locally:
`emulators/build.sh retroarch`. RetroArch's cores still come from spruceOS, at the commit in
`stage-spruce/01-spruce/02-run.sh`.
