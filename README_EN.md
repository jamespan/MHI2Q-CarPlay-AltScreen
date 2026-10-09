# MIB2 Toolbox — CarPlay AltScreen V3.7

**English** | [简体中文](README.md)

This project is designed for the Audi **MHI2Q** platform and displays the **native CarPlay AltScreen / secondary navigation view** directly on the vehicle's **Virtual Cockpit**. The core display path has been verified in a vehicle. Read the [SD card instructions](SD_CARD_README.txt) before making changes to the head unit.

**V3.7 update: full RGI navigation-data integration is now available (built on [Luka's mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi)), the runtime watermark has been removed, and starting with V3.7 the whole project is open source under GPL-3.0.**

> [!NOTE]
> **Sister project: MMI Mirror**  
> If you want to mirror the **entire MMI center display** instead of using the native CarPlay secondary display, see:  
> **[MHI2Q-CarPlay-MMI-Mirror](https://github.com/Lanye-z/MHI2Q-CarPlay-MMI-Mirror)**

> [!WARNING]
> **⚠️ A note before you start**
>
> Because freely shared test builds were previously repackaged and resold without permission, earlier versions of this project published only the runtime package and released features in stages. **Starting with V3.7, the project is fully open source**: every feature and all source code are published in this repository.
>
> The whole project is licensed under the **[GNU GPL v3.0](LICENSE)**: anyone may use, modify, and redistribute it, and anyone who redistributes binaries or modified versions must also provide the complete source under GPL-3.0. See "Licensing, authors, and third-party files" below.
>
> This is not a demonstration build. The current CarPlay AltScreen functionality is already usable in a real vehicle.
>
> This project was originally developed around our own vehicles and day-to-day use cases. **China-region (CN) AUG22 firmware has been tested in a vehicle and works normally.** AUG22 firmware for US / ER and other regions may have unknown bugs and is **not guaranteed to work 100%**; assess the risk yourself and keep your stock backup. The MHI2 platform is not supported. Do not bypass the installer's firmware checks to force installation.
>
> **Shared free of charge.** The source and installation packages are available for free on GitHub; do not pay for them.
>
> You are welcome to learn from, study, and discuss the project. If someone provides you with this project or a modified version of it, the GPL-3.0 entitles you to request the complete source from them.

> [!IMPORTANT]
> This project modifies system files on the head unit. Keep the SD card inserted and maintain stable power during installation, start, or recovery operations.  
> **After installation or recovery, fully reboot the head unit / HMI as instructed before judging the result.**
>
> Do not perform installation, update, recovery, or troubleshooting while driving.

---

## Vehicle demonstration

<img width="1920" height="1080" alt="CarPlay AltScreen on Virtual Cockpit" src="https://github.com/user-attachments/assets/f582d179-8c8e-41ac-882b-24d623813fca" />

---

## Currently included in the public release

- Native CarPlay AltScreen
- The main CarPlay display remains available and unaffected
- Full RGI navigation-data integration (built on [Luka's mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi))
- Classic / Sport dynamic layout adaptation
- Global centering
- Left steering-wheel scroll-wheel zoom
- STATUS diagnostics
- Safe installation and recovery
- Protection against interrupted installation / recovery
- Restoration of stock configuration
- Logs and SD-card backups

## Compatibility

| Item | Status |
|---|---|
| Platform | **MHI2Q** only; MHI2 is not supported |
| Firmware version | **AUG22**; the installer checks the head unit's firmware version and refuses anything other than AUG22 |
| China-region (CN) firmware | ✅ Vehicle-tested and works normally |
| US / ER and other regional firmware | ⚠️ May have unknown bugs; not guaranteed to work 100% |

---

## How it works

This project no longer relies on the early Window58 readback route. It connects directly to CarPlay's **private type111** secondary-display video stream: the stock AirPlay / OMX decoding path is kept, frames are safely read from the stock renderer and linearized into standard NV12, handed to a separate display process, and finally shown on the cluster through GLES / displayable3 / Java Context80.

```text
iPhone CarPlay
  ↓
private type111 secondary-display video stream
  ↓
Stock AirPlay / OMX decoding
  ↓
QNX Screen readback + linearization → standard NV12 (/carplay111_decoded)
  ↓
Separate display process (sidecar)
  ↓
GLES / displayable3 (1440×542 source shown 1:1 on the 1440×455 cluster plane)
  ↓
Java/HMI Context80
  ↓
Virtual Cockpit
```

- The main CarPlay display (Main110) stays on the stock path and is not part of this display path.
- No extra decoder is introduced; the stock decoding path that already works on MHI2Q is reused to keep new variables to a minimum.
- The FULL / SMALL view areas switch dynamically within the same CarPlay session through the standard `updateViewArea`; the Classic / Sport layout follows the head unit's HMI state.
- Java/HMI is the only owner of Context80; the display process does not change the cluster Context directly.

---

## Installation and testing

> [!IMPORTANT]
> **This repository is now an AltScreen overlay only. It no longer contains the complete MIB2 Toolbox installer.**
>
> - The **red software-update menu** is only for installing or repairing the upstream [jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox).
> - **This project itself cannot be installed directly through the red software-update menu.**
> - After the upstream Toolbox is working, load this project through **`MQBCoding → Update Toolbox`** in the green menu.
> - If `Update Toolbox` reports `Script not found` or `/eso/hmi/engdefs/scripts/mqb/update_toolbox.sh` is missing, repair/reinstall the upstream Toolbox first.
> - **When upgrading from an older version of this project, you must restore first and then install.** Follow section 8; do not run `INSTALL` directly over an older version.

### 1. Confirm that the upstream MIB2 Toolbox works

1. Check that the head unit's firmware version is **AUG22**. The installer verifies the firmware version and refuses non-AUG22 firmware. Stop if the version differs or cannot be confirmed; do not bypass the checks. For firmware outside the China region, read "Compatibility" above first.
2. Park the vehicle and maintain stable power. Back up the current SD card and stock files, then prepare a writable **FAT32** SD card. If the old card contains `MMI-Cockpit-Carplay`, preserve that entire directory when changing cards because it contains stock backups needed for restoration.
3. If `Green Developer Menu → MQBCoding` already works and **`Update Toolbox` runs normally without a Script not found error**, skip directly to section 2.
4. If the upstream Toolbox is not installed, or the green menu exists but `Update Toolbox` is broken / missing its script, download and extract the latest complete **[jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox)** package. Copy the **contents** of that upstream package to the SD-card root without an extra ZIP-name folder.
5. Insert only that SD card in the head unit. Enter the red menu and select `Software updates/versions → Update → SD card → MQB Coding MIB2 Toolbox`. Wait for the update and all automatic reboots to finish; do not remove the card or cut power early.
6. After reboot, open `Green Developer Menu → MQBCoding` and confirm that **`Update Toolbox` runs normally**. If the upstream package is not recognized, check FAT32 format, root layout, and the upstream instructions. Stop if it is still rejected; do not force-flash it.

### 2. Merge this project overlay into the upstream Toolbox SD card

1. Keep the **complete upstream MIB2 Toolbox SD-card contents**. Do not delete its `metainfo2.txt`, `Toolbox/final/`, `Toolbox/GEM/mqb-main.esd`, `Toolbox/scripts/update_toolbox.sh`, or other upstream files.
2. Download the package from this repository's [Releases](https://github.com/yuedizhibo/MHI2Q-CarPlay-AltScreen/releases) page and extract it. These are compiled vehicle overlay files; **you do not need to copy source code or build directories**. Merge the package's **`Toolbox/` directory into the existing `Toolbox/` directory on the SD card**:
   - Replace same-name files with this project's versions.
   - Keep all upstream-only files.
   - When upgrading from an older project build (after completing the restore in section 8), delete the old `logo.rgba` and `watermark.rgba` from `Toolbox/carplay_alt_screen/mirror_display/release/` on the card; the new binary does not use them.
   - **Do not wipe the upstream Toolbox first, and do not treat this repository as a standalone red-menu update package.**
3. You may also copy `SD_CARD_README.txt` and `SHA256SUMS-SD.txt` to the SD-card root. If changing cards, also preserve the complete `MMI-Cockpit-Carplay` stock-backup directory.
4. The resulting layout should look like:

```text
SD card root/
├─ metainfo2.txt                  ← keep from upstream Toolbox
├─ Toolbox/
│  ├─ final/                      ← keep from upstream Toolbox
│  ├─ GEM/
│  │  ├─ mqb-main.esd             ← keep from upstream Toolbox
│  │  └─ mqb-carplayAltScreen.esd ← this project
│  ├─ scripts/
│  │  ├─ update_toolbox.sh        ← keep from upstream Toolbox
│  │  └─ ...AltScreen scripts...  ← this project
│  └─ carplay_alt_screen/         ← this project payload
├─ SD_CARD_README.txt
└─ SHA256SUMS-SD.txt
```

5. Do not add an extra `SD card/Toolbox/` or `MHI2Q-CarPlay-AltScreen/Toolbox/` directory level.
6. From the SD-card root, run:

```sh
sha256sum -c SHA256SUMS-SD.txt
```

with Git Bash, Linux, or another environment that provides `sha256sum`. Confirm that every project file reports `OK`. This manifest validates this project's overlay files, not the complete upstream Toolbox.

### 3. Load this project's menu and scripts through the green menu

1. Reinsert the merged SD card.
2. Open `TESTMODE → Green Developer Menu → MQBCoding`.
3. Run **`Update Toolbox`**. The upstream Toolbox update script copies the SD card's `Toolbox/scripts/` and `Toolbox/GEM/` contents into the head unit.
4. Exit and reopen the green menu, then open:

```text
Customization
└─ MMI-Cockpit-Carplay
```

5. If you still see:

```text
Script not found:
/eso/hmi/engdefs/scripts/mqb/update_toolbox.sh
```

the **upstream Toolbox base installation is still broken**. Do not continue with this project's `INSTALL`; return to section 1 and repair the upstream Toolbox first.

### 4. Install and start the secondary display

In the `MMI-Cockpit-Carplay` menu, follow this order and let each action finish before continuing:

1. **Disconnect the iPhone / CarPlay** so navigation video is not playing during installation.
2. Select `INSTALL`. Wait until it finishes. After `INSTALL=PASS` and `reboot_required=YES`, **fully reboot the head unit**. If it reports `FAIL`, record the message and stop.
3. After reboot, select `START`. Wait for `START=PASS` and `reboot_required=YES`, then **fully reboot the head unit again**. If it fails, do not skip ahead to connecting the phone.
4. After the second reboot, connect the iPhone, enter CarPlay, and start navigation. Check whether the Virtual Cockpit shows the secondary display and updates with navigation.

> [!NOTE]
> Packages published on GitHub Releases show a startup watermark when the secondary display starts. This is expected. It is not the vehicle boot logo.

### 5. Check status and troubleshoot

- With CarPlay navigation running, open `STATUS`. `PHYSICAL_ROUTE_READY=SOFTWARE_CHAIN_COMPLETE` means the script observed the video decoding, display path, Context 80, and other required software conditions; you must still **visually confirm the image on the Virtual Cockpit**. `PHYSICAL_ROUTE_READY=NO` means the required conditions are not all present; check the missing items shown in the output.
- If the `MMI-Cockpit-Carplay` menu is missing, first confirm that the upstream green menu works, the SD-card directory layout is correct, and `MQBCoding → Update Toolbox` completed successfully.
- If `Update Toolbox` itself reports `Script not found`, that is an upstream Toolbox base-installation problem rather than an AltScreen installer problem. Repair the upstream Toolbox through the red software-update menu first.
- If the SD card is not detected, check FAT32, root layout, and read/write status. If `STATUS` is not ready, confirm that CarPlay is connected and navigation is producing video, then record the status and logs; do not repeatedly force `START`.
- `STORE LOGS + RESTORE` tries to collect diagnostics and **then immediately restores the stock configuration**. It is not a logs-only action. If you want to keep the AltScreen runtime installed and active, do not select it.

### 6. Logs

- Runtime logs are kept on the head unit in `/tmp/MMI-Cockpit-Carplay/`. They cover private111 connect / teardown, H.264, Screen readback, decoded SHM, display frame rate, displayable3, Context80, view-area and layout state, and system diagnostics such as CPU, temperature, and memory.
- After `STORE LOGS + RESTORE`, logs are saved to the `MMI-Cockpit-Carplay/logs/` directory on the SD card.
- When something goes wrong, save the complete logs before changing any configuration or code. When reporting an issue, attach the logs and include the firmware version and region, the Classic / Sport and FULL / SMALL layout, and how the phone was connected (phone plugged in before the head unit started / after it fully started / quick reconnect).

### 7. Restore the stock configuration

1. Insert the SD card that retains the `MMI-Cockpit-Carplay` stock-backup directory. Select `RESTORE ORIGINAL`, or `STORE LOGS + RESTORE` if you want to collect logs before restoring.
2. Wait for `RESTORE=PASS` and `reboot_required=YES`, then fully reboot the head unit. Restore stops the display process, releases the Context80 display demand, removes the startup entries, removes this project's HMI JAR, and restores the HMI files and preload configuration saved before installation.
3. If installation or restore was interrupted, runtime operation remains disabled. Keep the original backup card, run `RESTORE ORIGINAL` again, confirm that restoration succeeds, and only then consider running `INSTALL` again. Do not run `START` while restoration is incomplete.

### 8. Upgrade from an older version

Upgrading requires **restoring first, then installing**. Do not run `INSTALL` directly over an older version that is still active:

1. Disconnect the iPhone / CarPlay and insert the SD card that retains the `MMI-Cockpit-Carplay` stock-backup directory.
2. In the existing `MMI-Cockpit-Carplay` menu on the head unit, run `RESTORE ORIGINAL`. Wait for `RESTORE=PASS` and `reboot_required=YES`, then fully reboot the head unit. If the restore fails, stop the upgrade, keep the backup card, and record the message.
3. After a successful restore, merge the new overlay into the SD card as described in section 2, and delete the leftover `logo.rgba` and `watermark.rgba` from the old version. Keep the `MMI-Cockpit-Carplay` directory on the card intact.
4. Run `Update Toolbox` as described in section 3, then follow section 4: `INSTALL` → full reboot → `START` → full reboot.

See [SD_CARD_README.txt](SD_CARD_README.txt) for the notes shipped on the SD card. Changing head-unit system files can cause a blank screen or require recovery.

---

## Contributing

**V3.7 is fully open source, and everyone is welcome to help maintain the project, fix issues, and add new features.**

- Report problems through Issues, with complete logs, the firmware version and region, the layout, and how the phone was connected.
- Submit fixes and new features through Pull Requests. Vehicle test results on US / ER and other regional firmware are also welcome and help widen the validated scope.
- In a pull request, describe the test vehicle, firmware version, test steps, and results.
- Change one layer at a time: do not introduce a new decoder, a new Context, and broad display-structure changes in the same change, or it becomes hard to tell which layer caused a problem.
- Vehicle tests should cover cold start (phone plugged in before the head unit started / after it fully started / quick reconnect) and the four Classic / Sport × FULL / SMALL layouts, and confirm that `RESTORE ORIGINAL` still restores correctly.
- Contributed code is released with this project under GPL-3.0.

---

## Licensing, authors, and third-party files

This project is developed by [yuedizhibo](https://github.com/yuedizhibo) and [Lanye-z](https://github.com/Lanye-z). **V3.7 is fully open source**: this repository publishes all C/C++ source code, runtime binaries, installation scripts, and documentation, and the whole project is released under the **[GNU General Public License v3.0](LICENSE)** (GPL-3.0).

The GPL-3.0 allows anyone to use, study, modify, and redistribute this project, including for commercial purposes. Anyone who redistributes binaries or modified versions must provide the complete corresponding source under GPL-3.0 and keep the existing copyright and license notices.

| Part | Origin | License |
|---|---|---|
| AltScreen display path, HMI JAR, install / restore / diagnostic scripts, green menu, documentation, etc. | Original to this project | GPL-3.0 |
| Full RGI navigation-data integration, including `Toolbox/carplay_alt_screen/rgi_meta/` and its source | Built on [Luka's mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi) | GPL-3.0 |
| Upstream MIB2 Toolbox files | [jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox) | [MIT](LICENSE.TOOLBOX-MIT), GPL-3.0 compatible |
| Mirror runtime component | [Lanye-z's MMI Mirror](https://github.com/Lanye-z/MHI2Q-CarPlay-MMI-Mirror) | [Unlicense](Toolbox/carplay_alt_screen/mirror_display/release/LICENSE.MMI-MIRROR), GPL-3.0 compatible |

Keep the original license notices of third-party files.

Research and implementation references:

- [LIVI](https://github.com/f-io/LIVI): research reference for CarPlay main-display and instrument-cluster secondary-display protocol behavior.
- [mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi) (Luka): foundation of the full RGI navigation-data integration, and reference for MHI2Q CarPlay navigation guidance, HMI, and instrument-cluster interaction.
- [MIB2 High Toolbox](https://github.com/jilleb/mib2-toolbox): upstream project for the SD-card toolchain, engineering menu, and scripts.

---

## Version status

Current recommended version:

~~~text
main
└── AUG22 / V3.7
    ├── China-region (CN) firmware: vehicle-tested and working
    └── Other regional firmware: may have unknown bugs; not guaranteed to work 100%
~~~

The current public release prioritizes stable installation, normal use, and reliable recovery.

---

## Public-release notice

Starting with V3.7, the project is fully open source: every feature, all source code, the installable runtime package, and related documentation are public and released under GPL-3.0.

> **Shared free of charge: this project is available for free on GitHub; do not pay for it.**
