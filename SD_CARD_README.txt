MMI Cockpit CarPlay 第二屏覆盖包（AUG22 / V3.5 + 内嵌 Logo + 重连修复）

1. 从 https://github.com/jilleb/mib2-toolbox 下载最新代码 ZIP。解压后将其内容复制到
   FAT32 SD 卡根目录，按上游说明通过车机软件更新安装 MIB2 Toolbox 绿菜单。
2. 安装完成并确认绿菜单可用后，取出同一张 SD 卡；将本覆盖包内 Toolbox 目录
   与卡上的 Toolbox 目录合并，同名文件选择替换。不要清空卡上原有 Toolbox。
   若卡上有本项目旧版，删除 Toolbox/carplay_alt_screen/mirror_display/release/ 下
   旧版遗留的独立资源文件可以删除；新版本不再需要独立资源文件。
3. 本包不含上游 Toolbox 安装文件和 metainfo2.txt，不能单独用于软件更新。
   若换卡，先完整保留 MMI-Cockpit-Carplay 原车备份目录，否则无法恢复原车文件。
4. 重新插卡，进入绿菜单 MQBCoding，执行 Update Toolbox；完成后重新打开绿菜单，
   进入 Customization → MMI-Cockpit-Carplay。
5. 断开 iPhone → INSTALL → 完整重启 → START → 完整重启 → 连接 CarPlay → 开导航。
   仅支持安装脚本可核验的 AUG22 固件。
6. 第二屏解码帧就绪后播放约 4.57 秒开屏视频，70% 居中、四周纯黑，随后
   550 毫秒整屏交叉淡化到 CarPlay。正常首连及新会话播放；同会话异常恢复跳过。
   视频内嵌于二进制，无外置视频。两个 BUILD_INFO.txt 是安装必需文件，须保留。
   已修复自动断开清理留下主动停止标记的问题，下一会话可重新启动显示。
7. 恢复使用 RESTORE ORIGINAL；恢复时插入保留原车备份的 SD 卡。
本包只包含本项目的覆盖文件，不附带上游完整 MIB2 Toolbox。

历史第二屏链路已完成实车验证。本次 QNX ARM 编译及主机连续重连测试通过，新增开屏与重连修复待实车确认。覆盖前请备份 SD 卡；覆盖后可用 SHA256SUMS-SD.txt 核验本项目文件。

MMI Cockpit CarPlay AltScreen overlay (AUG22 / V3.5 + embedded logo + reconnect fix)

1. Download the latest ZIP from https://github.com/jilleb/mib2-toolbox. Extract it and
   copy its contents to the root of a FAT32 SD card. Follow the upstream instructions
   to install the MIB2 Toolbox green menu through the head unit's software update.
2. Once the green menu works, remove the same SD card. Merge this overlay's Toolbox
   directory into the Toolbox directory already on the card. Replace files with the
   same names, but keep all other upstream Toolbox files.
   When upgrading from an older project build, remove obsolete standalone asset files
   from Toolbox/carplay_alt_screen/mirror_display/release/.
3. This overlay contains neither the complete upstream installer nor metainfo2.txt;
   it cannot be installed by software update on its own. If changing SD cards, copy
   the entire MMI-Cockpit-Carplay stock-backup directory for future restoration.
4. Reinsert the card. In the green menu, open MQBCoding and run Update Toolbox.
   Reopen the menu and select Customization -> MMI-Cockpit-Carplay.
5. Disconnect the iPhone -> INSTALL -> fully reboot -> START -> fully reboot ->
   reconnect CarPlay -> start navigation. Only AUG22 firmware verified by the
   installation scripts is supported.
6. Once decoded secondary-display frames are ready, the embedded video intro plays
   for about 4.57 seconds at 70% centered scale with black padding, followed by a
   550 ms whole-plane crossfade to CarPlay. First connections and new sessions play
   the intro; same-session crash recovery skips it. No external video is needed.
   Both BUILD_INFO.txt files are required for installation and must be retained.
   Automatic disconnect cleanup no longer leaves an explicit-stop guard that
   prevents the next display session from starting.
7. Use RESTORE ORIGINAL to restore the stock configuration. Insert the SD card
   containing the original stock backup before restoring.
This package contains only this project's overlay, not the full upstream Toolbox.

Earlier releases of the secondary-display path were validated in a vehicle.
This QNX ARM build and host reconnect tests passed; the new intro and reconnect
fix still need vehicle validation. Back up the SD card before merging files,
then verify project files with SHA256SUMS-SD.txt.
