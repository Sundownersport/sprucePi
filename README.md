# sprucePi

Raspberry Pi OS Lite (64-bit, Debian trixie) that boots to [PyUI](https://github.com/spruceUI/spruceOS),
the spruceOS game frontend, with an LXQt desktop one app away.

**Status: beta. The image has not been booted on real hardware yet.**

## Install

You need a 64-bit Pi (3, 4, 5 or Zero 2 W; the Pi 5 is the first test target), HDMI, a keyboard or
controller, and a 32 GB or larger card.

1. Download the image from the [`beta-spruce`](https://github.com/Sundownersport/sprucePi/releases/tag/beta-spruce)
   prerelease. If it comes in `.part` files, join them first:
   `cat image_*.img.xz.part* > sprucePi.img.xz`
2. Flash it with Raspberry Pi Imager or similar. Don't apply Imager's OS customisation settings.
3. Boot. The first boot creates the data partition, then PyUI starts.

## Logins

| Account | Password | Notes |
|---|---|---|
| `spruce` | `happygaming` | The only login. Runs PyUI and the desktop, and logs in automatically. Has `sudo`, which asks for this password. |
| `root` | none | Locked. Use `sudo`. |

The hostname is `sprucepi` and SSH is on:

```sh
ssh spruce@sprucepi.local
```

Every image has the same password, so change it with `passwd` before putting the Pi on a network you
don't trust. Upstream's first-boot username prompt is turned off.

## Using it

PyUI and the desktop are separate modes, and only one runs at a time.

- **To the desktop:** open the Desktop app in PyUI.
- **Back to PyUI:** open the spruce icon on the desktop or in the menu.

PyUI uses a controller if one is connected, otherwise a keyboard. With neither, it waits and asks for one.

| Key | Button | Key | Button |
|---|---|---|---|
| Arrows | D-pad | `Q` / `E` | L1 / R1 |
| `Enter` | A | `Z` / `C` | L2 / R2 |
| `Esc` | B | `Tab` | Select |
| `X` / `Y` | X / Y | `Space` | Start |
| `M` | Menu | | |

Wi-Fi country, locale, keyboard layout and timezone keep pi-gen's defaults (none, UK, UK, London).
Change them with `sudo raspi-config`.

## Card layout

| Partition | Mounted at | Holds |
|---|---|---|
| boot (FAT32) | `/boot/firmware` | Pi firmware and kernel |
| system (ext4, 16 GB) | `/` | The OS, with spruce in `/opt/spruce` |
| data (exFAT, `SPRUCEPI`, rest of the card) | `/mnt/SDCARD` | `Roms`, `BIOS`, `Saves`, `Collections` |

The data partition can be read on a PC. Games go in `Roms/<system>`, for example `Roms/SFC`.

## Building

Images are built by GitHub Actions on native arm64 runners, from the `spruce` branch. All three
workflows are started by hand.

| Workflow | Publishes to | Builds |
|---|---|---|
| Build image | `beta-spruce`, replacing the last one | The image, split into parts if it's over 2 GB |
| Build emulators | `beta-emulators` | `emulators/<name>`: a `deps` list, a `build.sh` and spruce's patches |
| Build cores | `beta-cores` | `cores/list.txt`, with libretro-super or a recipe in `cores/custom`. `cores/deps/<core>` lists extra packages. |

The image unpacks the emulators into `/opt/spruce/emulators`. It starts from spruceOS's cores, at the
commit in `stage-spruce/01-spruce/02-run.sh`, and replaces each one that has its own build.

To build one emulator locally: `emulators/build.sh retroarch`

## Source layout

| Where | What |
|---|---|
| `sprucepi.config` | The pi-gen config, including the login |
| `stage-spruce/` | The pi-gen stage: boot logo, spruce, desktop |
| `spruce/` | Copied to `/opt/spruce`: `pyui`, `apps`, `emu` (system configs), `retroarch`, `scripts`, `config`, `themes` |
| `emulators/`, `cores/` | Emulator and core builds |

PyUI hardcodes `/mnt/SDCARD/App`, `/spruce` and `/Emu`, so `mount-data.sh` binds the `/opt/spruce`
copies there. Leave `spruce/pyui` unedited where possible.

## Updating

**PyUI** is a subtree of spruceOS `App/PyUI`. In a clone of spruceOS, then here:

```sh
git subtree split -P App/PyUI origin/Development -b pyui-only
git subtree pull -P spruce/pyui /path/to/spruceOS pyui-only
```

**pi-gen:** the `spruce` branch is upstream's `arm64` branch plus new files, and this README is the
only upstream file it changes. Merge `arm64` from `upstream`, and keep this file if it conflicts.
See [upstream's README](https://github.com/RPi-Distro/pi-gen/blob/arm64/README.md) for pi-gen's
config options and stages.
