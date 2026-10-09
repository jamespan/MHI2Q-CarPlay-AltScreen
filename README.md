# MIB2 Toolbox — CarPlay AltScreen V3.7

[English](README_EN.md) | **简体中文**

本项目面向 Audi **MHI2Q** 平台，用于将 **CarPlay 原生 AltScreen / 第二屏导航画面**直接显示至车辆的 **Virtual Cockpit**。核心显示链路已完成实车验证。操作前请先阅读 [SD 卡说明](SD_CARD_README.txt)。

**V3.7 更新：完整 RGI 导航信息联动上线（基于 [Luka 的 mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi) 构建）；运行水印已移除；V3.7 起全部以 GPL-3.0 开源。**

> [!NOTE]
> **姊妹项目：MMI Mirror**  
> 如果你希望显示的是 **MMI 中控完整画面镜像**，而不是 CarPlay 原生第二屏，请前往：  
> **[MHI2Q-CarPlay-MMI-Mirror](https://github.com/Lanye-z/MHI2Q-CarPlay-MMI-Mirror)**

> [!WARNING]
> **⚠️ 写在前面**
>
> 考虑到此前免费测试成果曾被未经允许包装和倒卖，本项目早期版本只公开了运行包，并分阶段发布功能。**自 V3.7 起，本项目全部开源**：全部功能与源码均已在本仓库公开。
>
> 本项目整体采用 **[GNU GPL v3.0](LICENSE)** 许可：任何人都可以使用、修改和再分发；再分发二进制或修改版时，必须以 GPL-3.0 同时提供完整源码。详见文末「许可、作者与第三方文件」。
>
> 当前版本并非演示代码，现有 CarPlay AltScreen 第二屏功能已经可以正常实车使用。
>
> 本项目最初就是基于我们自己的车辆和日常使用需求进行开发。**中国区（CN）AUG22 固件已经过实车测试，可以正常使用。** US / ER 等其他地区的 AUG22 固件可能存在未知 BUG，**不保证 100% 可用**，请自行评估风险并保留好原车备份。本项目不支持 MHI2 平台；请不要绕过安装脚本的固件检查强制安装。
>
> **免费分享。** 本项目的源码和安装包都可以在 GitHub 上免费获取，请不要花钱购买。
>
> 欢迎学习、研究和交流。如果有人向你提供本项目或其修改版，你有权按 GPL-3.0 向对方索取完整源码。

> [!IMPORTANT]
> 本项目会修改车机系统文件。安装、启动或恢复过程中请保持 SD 卡连接和车机供电稳定。  
> **安装或恢复完成后，请按照页面中的步骤完整重启车机 / HMI，再判断结果。**
>
> 请勿在驾驶过程中进行安装、更新、恢复或故障处理。

---

## 实车效果

<img width="1920" height="1080" alt="CarPlay AltScreen on Virtual Cockpit" src="https://github.com/user-attachments/assets/f582d179-8c8e-41ac-882b-24d623813fca" />

---

## 当前公开版本已支持

- CarPlay 原生 AltScreen
- CarPlay 主屏正常使用，不受第二屏影响
- 完整 RGI 导航信息联动（基于 [Luka 的 mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi) 构建）
- Classic / Sport 动态布局适配
- 全域居中
- 方向盘左侧滚轮缩放
- STATUS 状态诊断
- 安全安装与恢复
- 安装 / 恢复中断保护
- 原车配置恢复
- 日志与 SD 卡备份

## 适用范围

| 项目 | 状态 |
|---|---|
| 平台 | 仅 **MHI2Q**；不支持 MHI2 |
| 固件版本 | **AUG22**；安装脚本会核验车机固件版本，非 AUG22 会拒绝安装 |
| 中国区（CN）固件 | ✅ 已实车测试，可以正常使用 |
| US / ER 等其他地区固件 | ⚠️ 可能存在未知 BUG，不保证 100% 可用 |

---

## 安装与测试

> [!IMPORTANT]
> **本仓库现在只提供 CarPlay AltScreen 覆盖包，不再包含完整 MIB2 Toolbox 安装器。**
>
> - **红色软件更新菜单**只用于安装 / 修复上游 [jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox)。
> - **本项目本身不能直接通过红色菜单安装。**
> - 本项目应在上游 Toolbox 已正常安装后，通过绿色菜单里的 **`MQBCoding → Update Toolbox`** 写入菜单和脚本。
> - 如果绿色菜单里的 `Update Toolbox` 提示 `Script not found` 或缺少 `/eso/hmi/engdefs/scripts/mqb/update_toolbox.sh`，先重新安装 / 修复上游 Toolbox，再继续本项目。
> - **从本项目旧版本升级时，必须先复原再安装**，请直接按第 7 节操作，不要在旧版上直接覆盖执行 `INSTALL`。

### 1. 先确认上游 MIB2 Toolbox 是否正常

1. 先在车机信息页确认固件版本为 **AUG22**。安装脚本会核验固件版本，非 AUG22 固件会被拒绝；版本不符或无法确认时停止操作，不要绕过检查。非中国区固件请先阅读上方「适用范围」。
2. 车辆停稳并保持稳定供电。备份正在使用的 SD 卡及原车文件，准备一张可正常读写的 **FAT32** SD 卡。如果旧卡已有 `MMI-Cockpit-Carplay` 目录，换卡时完整保留；其中有原车备份，日后恢复需要这张备份卡。
3. 如果车上已经能够正常进入 `Green Developer Menu → MQBCoding`，并且 **`Update Toolbox` 可以正常执行且不会提示 Script not found**，可直接跳到第 2 节。
4. 如果车上尚未安装上游 Toolbox，或者绿色菜单存在但 `Update Toolbox` 已损坏 / 提示脚本不存在，请前往 **[jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox)** 下载最新完整版本并解压。将**上游包内的文件和目录**复制到 SD 卡根目录，不要再套一层 ZIP 名称文件夹。
5. 车机中只插这一张 SD 卡，进入红色菜单，选择 `Software updates/versions → Update → SD 卡 → MQB Coding MIB2 Toolbox`。等待软件更新和自动重启全部完成，不要提前拔卡或断电。
6. 重启完成后，进入 `Green Developer Menu → MQBCoding`，确认 **`Update Toolbox` 能正常执行**。如果上游安装包不被识别，检查 FAT32、根目录结构和上游说明；仍被拒绝就停止，不要强制刷入。

### 2. 将本项目覆盖包合并到上游 Toolbox

1. 在电脑上保留**上游完整 MIB2 Toolbox SD 卡内容**，不要删除其 `metainfo2.txt`、`Toolbox/final/`、`Toolbox/GEM/mqb-main.esd`、`Toolbox/scripts/update_toolbox.sh` 或其他上游文件。
2. 从本仓库 [Releases](https://github.com/yuedizhibo/MHI2Q-CarPlay-AltScreen/releases) 下载安装包并解压。这里使用的是已编译的上车覆盖文件，**不需要复制源码或编译目录**。将安装包中的 **`Toolbox/` 目录合并到 SD 卡根目录已有的 `Toolbox/` 目录**：
   - 同名文件：使用本项目版本覆盖；
   - 上游独有文件：全部保留；
   - 从本项目旧版升级时（先按第 7 节完成复原），删除卡上 `Toolbox/carplay_alt_screen/mirror_display/release/` 内旧版的 `logo.rgba` 和 `watermark.rgba`；新版不再使用它们；
   - **不要清空后再复制，也不要把本项目当成一张独立的红菜单安装卡。**
3. 也可以同时复制 `SD_CARD_README.txt` 和 `SHA256SUMS-SD.txt` 到卡根目录。若更换 SD 卡，务必同时完整保留 `MMI-Cockpit-Carplay` 原车备份目录。
4. 正确结构应类似：

```text
SD 卡根目录/
├─ metainfo2.txt                 ← 上游 Toolbox 保留
├─ Toolbox/
│  ├─ final/                     ← 上游 Toolbox 保留
│  ├─ GEM/
│  │  ├─ mqb-main.esd            ← 上游 Toolbox 保留
│  │  └─ mqb-carplayAltScreen.esd← 本项目
│  ├─ scripts/
│  │  ├─ update_toolbox.sh       ← 上游 Toolbox 保留
│  │  └─ ...AltScreen scripts... ← 本项目
│  └─ carplay_alt_screen/        ← 本项目 payload
├─ SD_CARD_README.txt
└─ SHA256SUMS-SD.txt
```

5. 不要出现 `SD卡/Toolbox/`、`MHI2Q-CarPlay-AltScreen/Toolbox/` 之类的额外层级。
6. 在 SD 卡根目录用 Git Bash、Linux 或其他提供 `sha256sum` 的环境运行：

```sh
sha256sum -c SHA256SUMS-SD.txt
```

确认本项目清单中的文件均为 `OK`。该清单只校验本项目覆盖文件，不校验上游完整 Toolbox。

### 3. 用绿色菜单加载本项目菜单和脚本

1. 将合并后的 SD 卡插回车机。
2. 打开 `TESTMODE → Green Developer Menu → MQBCoding`。
3. 执行 **`Update Toolbox`**。此步骤由上游 Toolbox 的更新脚本负责把 SD 卡中的 `Toolbox/scripts/` 和 `Toolbox/GEM/` 同步到车机。
4. 更新完成后退出并重新打开绿色菜单，进入：

```text
Customization
└─ MMI-Cockpit-Carplay
```

5. 如果此时仍提示：

```text
Script not found:
/eso/hmi/engdefs/scripts/mqb/update_toolbox.sh
```

说明车机上的**上游 Toolbox 基础安装本身仍未修复**。不要继续执行本项目的 `INSTALL`，应返回第 1 节重新修复上游 Toolbox。

### 4. 安装第二屏并启动

在 `MMI-Cockpit-Carplay` 菜单中按以下顺序操作，每步完成后再进行下一步：

1. **断开 iPhone / CarPlay**，避免安装过程中正在输出导航视频。
2. 选择 `INSTALL`。等待执行结束；看到 `INSTALL=PASS` 且提示 `reboot_required=YES` 后，**完整重启车机**。若出现 `FAIL`，先记录提示并停止后续步骤。
3. 重启完成后选择 `START`。等待 `START=PASS` 和 `reboot_required=YES`，然后**再次完整重启车机**。若失败，不要直接跳到连接手机。
4. 第二次重启后连接 iPhone、进入 CarPlay 并启动导航。观察 Virtual Cockpit 是否出现第二屏画面且能随导航更新。

> [!NOTE]
> GitHub Releases 中发布的安装包会在第二屏启动时显示开屏水印，属于正常现象。它不是整车开机 Logo。

### 5. 查看状态和排查

- 在 CarPlay 导航运行时打开 `STATUS`。`PHYSICAL_ROUTE_READY=SOFTWARE_CHAIN_COMPLETE` 表示脚本观察到视频解码、显示链路和 Context 80 等软件条件；仍须**亲眼确认仪表实际显示画面**。`PHYSICAL_ROUTE_READY=NO` 表示条件未齐，按输出中的缺失项检查。
- 若完全看不到 `MMI-Cockpit-Carplay` 菜单，先确认上游绿菜单正常、SD 卡目录层级正确，并确认 `MQBCoding → Update Toolbox` 已成功执行。
- 若 `Update Toolbox` 本身报 `Script not found`，这是上游 Toolbox 基础安装问题，不是本项目第二屏安装脚本的问题；先用上游完整包通过红色软件更新菜单修复 Toolbox。
- 若 SD 卡找不到，核对 FAT32、卡根目录文件和读写状态。若 `STATUS` 不就绪，确认已连接 CarPlay 且导航正在输出，再记录状态及日志；不要反复强制执行 `START`。
- `STORE LOGS + RESTORE` 会尽力保存诊断日志，**随后立即恢复原车配置**；它不是只导出日志的按钮。需要保留第二屏运行时，不要选择它。

### 6. 恢复原车

1. 插入保留了 `MMI-Cockpit-Carplay` 原车备份目录的 SD 卡，在菜单选择 `RESTORE ORIGINAL`；若要先收集日志再恢复，选择 `STORE LOGS + RESTORE`。
2. 等待 `RESTORE=PASS` 和 `reboot_required=YES`，然后完整重启车机。恢复会删除本项目的 HMI JAR，并还原相关原车配置。
3. 如果安装或恢复中断，运行会保持关闭。保留原备份卡，先重新执行 `RESTORE ORIGINAL`，确认恢复成功后再考虑重新 `INSTALL`；不要在恢复未完成时继续 `START`。

### 7. 从旧版本升级

升级必须**先复原、再安装**，不要在旧版运行状态下直接覆盖执行 `INSTALL`：

1. 断开 iPhone / CarPlay，插入保留了 `MMI-Cockpit-Carplay` 原车备份目录的 SD 卡。
2. 在车机上现有的 `MMI-Cockpit-Carplay` 菜单中执行 `RESTORE ORIGINAL`，等待 `RESTORE=PASS` 和 `reboot_required=YES`，然后完整重启车机。若复原失败，停止升级，保留备份卡并记录提示。
3. 复原成功后，按第 2 节把新版覆盖包合并到 SD 卡，并删除旧版遗留的 `logo.rgba` 和 `watermark.rgba`。卡上的 `MMI-Cockpit-Carplay` 目录必须完整保留。
4. 按第 3 节执行 `Update Toolbox`，再按第 4 节执行 `INSTALL` → 完整重启 → `START` → 完整重启。

SD 卡随附说明见 [SD_CARD_README.txt](SD_CARD_README.txt)。车机修改有黑屏或需要恢复的风险。

---

## 许可、作者与第三方文件

本项目由 [yuedizhibo](https://github.com/yuedizhibo) 和 [Lanye-z](https://github.com/Lanye-z) 共同开发。**V3.7 全部开源**：本仓库公开全部 C/C++ 源码、运行二进制、安装脚本和说明，整个项目采用 **[GNU General Public License v3.0](LICENSE)**（GPL-3.0）发布。

GPL-3.0 允许任何人使用、研究、修改和再分发本项目，包括商业用途；再分发二进制或修改版时，必须以 GPL-3.0 同时提供完整对应源码，并保留原有版权与许可声明。

| 部分 | 来源 | 许可 |
|---|---|---|
| AltScreen 显示链路、HMI JAR、安装 / 恢复 / 诊断脚本、绿色菜单、说明文档等 | 本项目原创 | GPL-3.0 |
| 完整 RGI 导航信息联动，包括 `Toolbox/carplay_alt_screen/rgi_meta/` 及其源码 | 基于 [Luka 的 mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi) 构建 | GPL-3.0 |
| 上游 MIB2 Toolbox 相关文件 | [jilleb/mib2-toolbox](https://github.com/jilleb/mib2-toolbox) | [MIT](LICENSE.TOOLBOX-MIT)，与 GPL-3.0 兼容 |
| 镜像运行组件 | [Lanye-z 的 MMI Mirror](https://github.com/Lanye-z/MHI2Q-CarPlay-MMI-Mirror) | [Unlicense](Toolbox/carplay_alt_screen/mirror_display/release/LICENSE.MMI-MIRROR)，与 GPL-3.0 兼容 |

第三方文件的原有授权声明须一并保留。

研究与实现参考项目：

- [LIVI](https://github.com/f-io/LIVI)：CarPlay 主屏与仪表第二屏协议行为的研究参考。
- [mib2q-carplay-rgi](https://github.com/luka-dev/mib2q-carplay-rgi)（Luka）：完整 RGI 导航信息联动的构建基础，以及 MHI2Q 的 CarPlay 导航引导、HMI 与仪表交互参考。
- [MIB2 High Toolbox](https://github.com/jilleb/mib2-toolbox)：SD 卡工具链、工程菜单及脚本的上游项目。

---

## 版本状态

当前推荐版本：

~~~text
main
└── AUG22 / V3.7
    ├── 中国区（CN）固件：实车测试可用
    └── 其他地区固件：可能存在未知 BUG，不保证 100% 可用
~~~

当前公开版本以稳定、可安装、可恢复为优先目标。

---

## 公开发布说明

自 V3.7 起，本项目全部开源：全部功能、源码、可安装运行包与相关说明均已公开，并统一以 GPL-3.0 发布。

> **免费分享：本项目在 GitHub 上免费提供，请勿花钱购买。**
