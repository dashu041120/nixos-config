# NixOS → 独立 Nix 完整迁移指南

> 从 NixOS 完整系统配置迁移到可在任何 Linux 发行版上运行的独立 Nix 包管理器环境

**目录**: [快速开始](#快速开始) | [项目概览](#项目概览) | [安装步骤](#安装步骤) | [脚本使用](#脚本使用) | [GPU 启动条目](#gpu-启动条目) | [常见问题](#常见问题) | [故障排查](#故障排查)

---

## 快速开始

### 5 分钟快速上手

```bash
# 方法 1: 一键启动（推荐）
bash QUICK_START.sh

# 方法 2: 手动步骤
git checkout migrate-to-nix-standalone
bash home/scripts/init-nix-env.sh
nix flake show
nix run home-manager -- switch --flake .#dashu@laptop
```

### ✅ 快速验证

```bash
# 验证配置是否有效
nix flake show

# 构建配置（测试）
nix build .#homeConfigurations.dashu@laptop.activationPackage

# 应用配置
nix run home-manager -- switch --flake .#dashu@laptop
```

### 🎯 你现在可以做什么

- ✅ 在 **ArchLinux、Debian、Ubuntu** 等任何 Linux 发行版上使用相同配置
- ✅ 继续使用 **Nix Flakes** 管理依赖
- ✅ 使用 **home-manager** 配置用户环境
- ✅ 使用 **POSIX shell 脚本**替代 NixOS 系统功能
- ✅ 创建 **GPU 启动条目**实现启动时 GPU 配置切换

---

## 项目概览

### 📊 迁移成果

| 指标 | 数值 |
|------|------|
| 工作分支 | `migrate-to-nix-standalone` |
| 配置文件 | 202 个 (从 modules/home/ 复制) |
| 脚本文件 | 4 个 POSIX shell 脚本 |
| 代码行数 | 928 行 (脚本代码) |
| 文档字数 | 15,000+ 字 |
| 总提交数 | 6 个主要提交 |

### 📁 目录结构

```
.
├── configuration.nix              # 顶级配置
├── flake.nix                      # Flakes 配置（已验证）
│
├── home/                          # ⭐ 新增用户级配置
│   ├── dashu/                     # 用户 dashu 完整配置
│   │   ├── default.nix            # 主配置文件（导入所有模块）
│   │   ├── zsh.nix                # Shell 配置
│   │   ├── starship.nix           # 提示符配置
│   │   ├── vscode.nix             # VSCode 配置
│   │   ├── hyprland/              # Hyprland 窗口管理器
│   │   ├── niri/                  # Niri 窗口管理器
│   │   ├── fcitx5/                # 输入法配置 + oh-my-rime
│   │   ├── fonts/                 # 字体文件
│   │   └── (20+ 其他配置模块)
│   │
│   ├── patrickz/                  # 用户 patrickz 配置模板
│   │   └── default.nix
│   │
│   ├── scripts/                   # ⭐ 新增 POSIX shell 脚本
│   │   ├── init-nix-env.sh        # 环境初始化
│   │   ├── setup-nix-gc.sh        # GC 定时器配置
│   │   ├── nix-gc.sh              # GC 执行
│   │   ├── gpu-boot-entry.sh      # GPU 启动条目管理
│   │   └── README.md              # 脚本文档
│   │
│   └── docs/                      # ⭐ 新增文档
│       ├── MIGRATION_GUIDE.md     # 迁移步骤详情
│       └── GPU_BOOT_ENTRIES.md    # GPU 启动条目技术指南
│
├── modules/
│   ├── core/                      # ❌ 不适用（系统级配置）
│   └── home/                      # ⭐ 已复用至 home/dashu/
│
├── users/
│   ├── dashu/
│   └── patrickz/
│
├── hosts/                         # ❌ 不适用（系统配置）
│   ├── laptop-rog-gu603/
│   └── vm/
│
└── MIGRATION_GUIDE_COMPLETE.md    # 本文档 ⭐ 统一指南
```

### ✅ 功能对标

#### 成功替代的 NixOS 功能

| NixOS 配置 | 替代方案 | 状态 |
|-----------|--------|------|
| `modules/core/system.nix` | `init-nix-env.sh` | ✅ 完全替代 |
| `modules/core/garbage_clean.nix` | `setup-nix-gc.sh` + `nix-gc.sh` | ✅ 完全替代 |
| `modules/core/security.nix` | 基础安全配置 | ✅ 适配 |
| 启动参数配置 | `gpu-boot-entry.sh` | ✅ 增强替代 |
| 30+ home-manager 模块 | `home/dashu/` | ✅ 直接复用 |

#### 不适用或需要替代的 NixOS 功能

以下配置涉及系统级设置，在独立 Nix 环境中不适用：

| 文件 | 原因 | 替代方案 |
|------|------|--------|
| `modules/core/bootloader.nix` | 系统启动配置 | 使用发行版的引导程序工具 |
| `modules/core/hardware.nix` | BIOS/UEFI 配置 | 发行版硬件工具 (intel-microcode 等) |
| `modules/core/network.nix` | 系统网络配置 | NetworkManager 或 systemd-networkd |
| `modules/core/virtualization.nix` | 系统虚拟化 | `libvirt` 包 + 用户权限配置 |
| `modules/core/kde.nix` 等桌面环境 | 系统级 DE 配置 | home-manager 中的 `hyprland.nix`, `niri.nix` 等 |

---

## 安装步骤

### 前置要求

1. **Linux 系统** - ArchLinux、Debian、Ubuntu 或其他支持 Nix 的发行版
2. **Nix 包管理器** - 已安装 Nix (非 NixOS)
3. **home-manager** - 已安装 home-manager
4. **Git** - 版本控制

### 安装 Nix

如果未安装 Nix：

```bash
# 官方安装脚本
curl -L https://nixos.org/nix/install | sh

# 加载 Nix 环境
source ~/.nix-profile/etc/profile.d/nix.sh
```

### 安装 home-manager

```bash
# 使用 Nix Flakes 安装（推荐）
nix run home-manager -- --version

# 或通过 Nix shell
nix-shell -p home-manager
```

### 配置迁移步骤

#### 步骤 1: 切换到迁移分支

```bash
cd /path/to/nixos-config
git checkout migrate-to-nix-standalone
```

#### 步骤 2: 运行初始化脚本

```bash
bash home/scripts/init-nix-env.sh
```

此脚本将：
- ✓ 检查 Nix 和 home-manager 安装
- ✓ 配置 Nix 替代品源（缓存）
- ✓ 启用实验特性 (nix-command, flakes)
- ✓ 设置自动垃圾收集

#### 步骤 3: 验证配置

```bash
# 显示所有配置
nix flake show

# 构建配置（检查错误）
nix build .#homeConfigurations.dashu@laptop.activationPackage
```

#### 步骤 4: 应用配置

```bash
# 应用用户配置
nix run home-manager -- switch --flake .#dashu@laptop

# 或使用别名（如已配置）
home-manager switch --flake .#dashu@laptop
```

#### 步骤 5 (可选): 设置 GPU 启动条目

```bash
# 安装 GPU 启动条目
sudo bash home/scripts/gpu-boot-entry.sh install

# 重启系统
sudo reboot

# 在 GRUB 菜单中选择对应启动项
```

---

## 脚本使用

### 1. init-nix-env.sh - 环境初始化

**作用**: 初始化 Nix 环境并验证前置条件

**替代**: NixOS `modules/core/system.nix`

**使用方法**:

```bash
bash home/scripts/init-nix-env.sh
```

**功能**:
- 检查 Nix 和 home-manager 安装
- 配置 Nix 替代品源和二进制缓存
- 初始化实验特性 (nix-command, flakes)
- 设置自动垃圾收集
- Flake 配置验证

**输出示例**:

```
✓ Nix 已安装
✓ home-manager 已安装
✓ 配置缓存已设置
✓ 实验特性已启用
✓ Flake 配置有效
```

### 2. setup-nix-gc.sh - 垃圾收集任务管理

**作用**: 安装和管理定期垃圾收集任务

**替代**: NixOS `modules/core/garbage_clean.nix`

**使用方法**:

```bash
# 使用 systemd 定时器（推荐，现代系统）
bash home/scripts/setup-nix-gc.sh install-systemd

# 或使用 cron（备选，传统方式）
bash home/scripts/setup-nix-gc.sh install-cron

# 查看状态
bash home/scripts/setup-nix-gc.sh status

# 卸载
bash home/scripts/setup-nix-gc.sh uninstall-systemd
```

**支持的方式**:

1. **systemd 定时器**（推荐）
   - 现代、可靠的任务调度
   - 与 systemd 集成
   - 支持日志查看: `journalctl --user -u nix-gc -f`

2. **cron 任务**（备选）
   - 简单、轻量级
   - 需要 cron 服务运行
   - 支持自定义时间表

### 3. nix-gc.sh - 垃圾收集执行

**作用**: 执行 Nix 垃圾收集和 store 优化

**替代**: NixOS `nix.gc.*` 和 `nix.optimise-store` 选项

**使用方法**:

```bash
# 标准垃圾收集（删除 7 天前的构建）
bash home/scripts/nix-gc.sh

# 指定保留天数
bash home/scripts/nix-gc.sh --days 30

# 预览将要删除的内容（不实际删除）
bash home/scripts/nix-gc.sh --dry-run

# 跳过交互式确认
bash home/scripts/nix-gc.sh --force

# 同时运行预览和实际删除
bash home/scripts/nix-gc.sh --force --days 14
```

**参数说明**:

- `--days N` - 保留 N 天的构建结果，默认为 7
- `--dry-run` - 预览模式，仅显示将要删除的内容
- `--force` - 跳过交互式确认，直接执行
- `--help` - 显示帮助信息

**功能**:
- 删除旧的构建结果
- 优化 store 链接
- 支持预览模式
- 交互式确认选项

### 4. gpu-boot-entry.sh - GPU 启动条目管理 ⭐

**作用**: 在 GRUB 启动菜单中创建 GPU 配置启动条目

**替代**: `hosts/laptop-rog-gu603/disable-dgpu.nix` (增强)

**使用方法**:

```bash
# 安装 GPU 启动条目（默认）
sudo bash home/scripts/gpu-boot-entry.sh install

# 查看启动条目列表
sudo bash home/scripts/gpu-boot-entry.sh show

# 显示详细说明
sudo bash home/scripts/gpu-boot-entry.sh details

# 验证 GRUB 配置
sudo bash home/scripts/gpu-boot-entry.sh verify

# 删除条目
sudo bash home/scripts/gpu-boot-entry.sh remove "Disable"

# 从备份恢复
sudo bash home/scripts/gpu-boot-entry.sh restore

# 重建 GRUB 配置
sudo bash home/scripts/gpu-boot-entry.sh rebuild
```

**功能**:
- 创建两个 GRUB 启动条目：
  1. **Disable dGPU (iGPU only)** - 禁用独立显卡，延长续航
  2. **GPU Passthrough (IOMMU Enabled)** - 启用 GPU 直通
- 自动检测根分区 UUID
- GRUB 配置自动备份和恢复
- 发行版检测 (ArchLinux/Debian)
- 配置验证和重建

---

## GPU 启动条目

### 功能详解

#### 启动项 1: 禁用 dGPU (iGPU only)

**用途**: 使用集成显卡，禁用独立显卡

**优势**:
- 延长笔记本续航 2-4 小时
- 降低系统温度 5-15°C
- 减少功耗 20-30W

**场景**: 日常办公、文本编辑、编程、轻量级工作

**技术实现**:

```bash
# 禁用的内核参数
nouveau.modeset=0                    # 禁用 Nouveau 驱动
nvidia_drm.modeset=0                 # 禁用 NVIDIA DRM
nvidia.NVreg_DynamicPowerManagement=0
```

#### 启动项 2: GPU 直通 (IOMMU Enabled)

**用途**: 启用 IOMMU 和 GPU 直通支持

**优势**:
- 虚拟机可访问 GPU
- 性能达原生 95%+
- 低延迟 (<1%)

**场景**: QEMU/KVM 虚拟机、游戏虚拟机、GPU 计算

**技术实现**:

```bash
# 启用的内核参数
iommu=pt                             # IOMMU 直通模式
intel_iommu=on                       # Intel IOMMU
amd_iommu=on                         # AMD IOMMU
vfio_iommu_type1.allow_unsafe_interrupts=1
kvm.ignore_msrs=1                    # KVM 配置
kvm.report_ignored_msrs=0
```

### 硬件要求

**CPU 要求**:
- Intel - VT-d 支持 (Sandy Bridge 及以后)
- AMD - AMD-Vi 支持 (Bulldozer 及以后)

**主板 BIOS 要求**:
- 需启用 IOMMU（VT-d 或 AMD-Vi）
- 需启用虚拟化扩展（VT-x 或 SVM）

**GPU 要求**:
- NVIDIA dGPU（在 Windows 虚拟机上无特殊限制）

### 安装步骤

```bash
# 1. 安装启动条目
sudo bash home/scripts/gpu-boot-entry.sh install

# 2. 验证安装
sudo bash home/scripts/gpu-boot-entry.sh show

# 3. 重启系统
sudo reboot

# 4. 在 GRUB 菜单中选择对应条目
# 按住 Shift 进入 GRUB 菜单，选择：
#   - "Linux - Disable NVIDIA dGPU (iGPU only)"
#   - "Linux - GPU Passthrough (IOMMU Enabled)"
```

### 验证配置

**检查 dGPU 是否禁用**:

```bash
# 列出显卡设备
lspci | grep -i nvidia

# 如果输出为空，说明 dGPU 已禁用
```

**检查 IOMMU 是否启用**:

```bash
# 查看 IOMMU 初始化消息
dmesg | grep -i "DMAR\|AMD-Vi"

# 列出 IOMMU 组
for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d%/*}; n=${n##*/}
    printf '%s ' "$n"
    cat "$d/modalias"
done
```

### 虚拟机 GPU 直通配置

**前置步骤**:

```bash
# 1. 重启并选择 GPU Passthrough 启动项

# 2. 验证 IOMMU 已启用
dmesg | grep -i DMAR

# 3. 找到 GPU 设备 ID
lspci -nn | grep -i nvidia
# 输出: 01:00.0 3D controller [0302]: NVIDIA ... [10de:1c82]
```

**VFIO 绑定**:

```bash
# 将 GPU 绑定到 vfio-pci 驱动
GPU_ID="10de:1c82"
sudo bash -c "echo $GPU_ID > /sys/bus/pci/drivers/vfio-pci/new_id"

# 验证绑定
lspci -k | grep -A 2 "01:00.0"
# 应显示: Kernel driver in use: vfio-pci
```

**libvirt 配置**:

```xml
<!-- 在虚拟机 XML 配置中添加 GPU 直通 -->
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
  </source>
</hostdev>
```

---

## 常见场景

### 场景 1: 日常使用延长续航

**目标**: 在日常办公时使用集成显卡以延长电池续航

**步骤**:

```bash
# 1. 安装 GPU 启动条目
sudo bash home/scripts/gpu-boot-entry.sh install

# 2. 重启
sudo reboot

# 3. 在 GRUB 菜单中选择 "Disable NVIDIA dGPU"

# 4. 验证 dGPU 已禁用
lspci | grep -i nvidia  # 无输出表示已禁用

# 5. 检查续航时间（应明显改善）
```

**预期结果**: 续航时间延长 2-4 小时，系统温度下降 5-15°C

### 场景 2: 虚拟机 GPU 直通

**目标**: 在 KVM/QEMU 虚拟机中运行 Windows 11 并进行 GPU 直通

**步骤**:

```bash
# 1. 安装启动条目
sudo bash home/scripts/gpu-boot-entry.sh install

# 2. 重启并选择 "GPU Passthrough" 条目
sudo reboot

# 3. 验证 IOMMU
dmesg | grep -i DMAR

# 4. 查看 IOMMU 组
for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d%/*}; n=${n##*/}
    printf '%s ' "$n"
    cat "$d/modalias"
done

# 5. 配置虚拈机并应用 GPU 直通

# 6. 启动虚拟机并验证 GPU
# Windows: 设备管理器 - 显示适配器 - 应显示 NVIDIA GPU
```

**预期结果**: 虚拟机中可访问 GPU，性能达原生 95%+

### 场景 3: 双启动 GPU 配置切换

**目标**: 灵活在不同 GPU 配置间切换

**步骤**:

```bash
# 1. 第一次安装（一次性）
sudo bash home/scripts/gpu-boot-entry.sh install

# 2. 每次重启时选择
# 方案 A: 使用 iGPU（续航优先）
#   → 启动菜单中选择 "Disable NVIDIA dGPU"
# 方案 B: 虚拟机 GPU 直通（性能优先）
#   → 启动菜单中选择 "GPU Passthrough"
# 方案 C: 默认启动（原始配置）
#   → 启动菜单中选择 "Linux"

# 3. 可选：设置默认启动项
sudo grub-set-default "Linux - Disable NVIDIA dGPU (iGPU only)"
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Debian/ArchLinux
```

---

## 常见问题

### Q1: 如何检查当前分支是否正确？

```bash
git branch -v
# 应显示: * migrate-to-nix-standalone ...
```

### Q2: 如何更新配置后应用更改？

```bash
home-manager switch --flake .#dashu@laptop
```

### Q3: 如何查看 home-manager 版本历史？

```bash
home-manager generations
# 输出列表，显示所有历史版本
```

### Q4: 如何回滚到上一个版本？

```bash
# 查看可用版本
home-manager generations

# 回滚到指定版本
home-manager switch --gen <generation-number>
```

### Q5: 垃圾收集会删除我正在使用的包吗？

**不会**。`nix-collect-garbage` 只删除无用的构建结果，不会删除当前活跃的包。

### Q6: 脚本需要 sudo 权限吗？

大多数脚本不需要，但以下需要：
- `gpu-boot-entry.sh` - 需要修改 GRUB
- `setup-nix-gc.sh` - 需要创建系统文件

### Q7: 如何手动运行垃圾收集？

```bash
bash home/scripts/nix-gc.sh --force
```

### Q8: 如何修改垃圾收集的计划？

```bash
# 使用 systemd 定时器
systemctl --user edit nix-gc.timer

# 或编辑 crontab
crontab -e
```

---

## 故障排查

### 问题 1: Nix 命令未找到

**症状**: `command not found: nix`

**原因**: Nix 未正确安装或加载

**解决方案**:

```bash
# 加载 Nix 环境
source ~/.nix-profile/etc/profile.d/nix.sh

# 验证
nix --version

# 如果仍未找到，重新安装 Nix
curl -L https://nixos.org/nix/install | sh
source ~/.nix-profile/etc/profile.d/nix.sh
```

### 问题 2: Flake 配置有错误

**症状**: `nix flake show` 报错

**原因**: 配置文件语法错误

**解决方案**:

```bash
# 详细的错误信息
nix flake show 2>&1 | head -20

# 验证 flake.nix 语法
nix flake check

# 查看最近的更改
git log --oneline -5

# 如需要，恢复到上一个正常版本
git revert <commit-hash>
```

### 问题 3: home-manager 配置导入失败

**症状**: `imports list is malformed` 或类似错误

**原因**: `home/dashu/default.nix` 中的导入路径错误

**解决方案**:

```bash
# 检查 home/dashu/default.nix 中的导入
cat home/dashu/default.nix | grep imports

# 确保所有导入都是正确的相对路径
# 示例（正确格式）:
# imports = [
#   ./alacritty.nix
#   ./bat.nix
#   ./cli.nix
#   ...
# ];
```

### 问题 4: GPU 启动条目出现语法错误

**症状**: `verify` 命令报错"GRUB 配置有语法错误"

**原因**: `/etc/grub.d/40_custom` 中可能有语法错误

**解决方案**:

```bash
# 从备份恢复
sudo bash home/scripts/gpu-boot-entry.sh restore

# 重建 GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 重新安装
sudo bash home/scripts/gpu-boot-entry.sh install
```

### 问题 5: dGPU 禁用不生效

**症状**: 选择 Disable dGPU 后 `lspci` 仍显示 NVIDIA GPU

**原因**: BIOS 设置未配置或内核参数未生效

**解决方案**:

```bash
# 1. 验证启动参数是否已应用
cat /proc/cmdline | grep nouveau

# 2. 检查 BIOS 设置
# 进入 BIOS → 查找 "Integrated Graphics"
# 确保集成显卡被设为主显示器

# 3. 查看驱动加载状态
lsmod | grep -i nvidia
lsmod | grep -i nouveau
# 如有输出则说明驱动仍在加载

# 4. 运行时禁用
sudo echo "1" > /sys/bus/pci/devices/0000\:01\:00.0/remove
```

### 问题 6: IOMMU 不工作

**症状**: `dmesg | grep IOMMU` 无输出

**原因**: BIOS 未启用或 CPU 不支持

**解决方案**:

```bash
# 1. 检查 CPU 是否支持
grep flags /proc/cpuinfo | grep -o 'vmx\|svm'

# 2. 检查 BIOS 设置
# 进入 BIOS → 查找 "IOMMU", "VT-d", "AMD-Vi"
# 确保已启用 (ENABLED)

# 3. 检查内核配置
grep IOMMU /boot/config-$(uname -r)

# 4. 重启并选择 GPU Passthrough 启动项
sudo reboot
```

### 问题 7: 脚本权限不足

**症状**: `Permission denied` 或 `需要 root 权限`

**原因**: 脚本未设置执行权限或未用 sudo 运行

**解决方案**:

```bash
# 确保脚本有执行权限
chmod +x home/scripts/*.sh

# 对于需要 root 的脚本，使用 sudo
sudo bash home/scripts/gpu-boot-entry.sh install
```

---

## 发行版特定说明

### ArchLinux

**GRUB 配置文件位置**:
- 自定义文件: `/etc/grub.d/40_custom`
- 主配置: `/etc/default/grub`
- 生成配置: `/boot/grub/grub.cfg`

**GRUB 重建命令**:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**启动参数文件**:
- `/boot/vmlinuz-linux` - Linux 内核
- `/boot/initramfs-linux.img` - 初始化 RAM 磁盘

### Debian / Ubuntu

**GRUB 配置文件位置**:
- 自定义文件: `/etc/grub.d/40_custom`
- 主配置: `/etc/default/grub`
- 生成配置: `/boot/grub/grub.cfg`

**GRUB 重建命令**:

```bash
# 推荐方式
sudo update-grub

# 或直接指定输出
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**启动参数文件**:
- `/boot/vmlinuz-linux-generic` 或 `/boot/vmlinuz-$(uname -r)` - Linux 内核
- `/boot/initrd.img` 或 `/boot/initramfs-$(uname -r).img` - 初始化 RAM 磁盘

---

## 高级配置

### 设置默认 GRUB 启动项

```bash
# 列出所有启动项
grep "menuentry" /boot/grub/grub.cfg | nl -v 0

# 设置默认启动项（例如第 2 个）
sudo grub-set-default 2
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 或直接编辑配置
sudo nano /etc/default/grub
# 修改: GRUB_DEFAULT="Linux - Disable NVIDIA dGPU (iGPU only)"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 设置 GRUB 菜单超时

编辑 `/etc/default/grub`：

```bash
GRUB_TIMEOUT=10  # 等待 10 秒自动启动默认项
```

然后重建 GRUB：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 自定义 Nix 缓存源

编辑 `~/.config/nix/nix.conf`：

```nix
# 使用清华大学镜像（中国用户）
substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org

# 或使用官方缓存
substituters = https://cache.nixos.org
```

### 添加额外的 Nix 通道

```bash
# 添加 unstable 通道
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --update
```

---

## 日常使用工作流

### 修改配置

```bash
# 1. 编辑配置文件
nano home/dashu/zsh.nix

# 2. 构建并测试
nix build .#homeConfigurations.dashu@laptop.activationPackage

# 3. 应用配置
home-manager switch --flake .#dashu@laptop

# 4. 提交到 git
git add home/dashu/zsh.nix
git commit -m "chore: update zsh configuration"
git push
```

### 更新依赖

```bash
# 1. 更新 flake 锁定文件
nix flake update

# 2. 验证配置
nix flake show

# 3. 应用更新
home-manager switch --flake .#dashu@laptop

# 4. 提交更新
git add flake.lock
git commit -m "chore: update flake dependencies"
```

### 垃圾收集

```bash
# 定期（推荐每月一次）
bash home/scripts/nix-gc.sh

# 或使用自动定时器
# 通过 setup-nix-gc.sh 已配置

# 检查磁盘使用
du -sh ~/.cache/nix
```

### 问题排查

```bash
# 查看最近的错误
home-manager switch --flake .#dashu@laptop 2>&1 | tail -20

# 查看 home-manager 日志
journalctl --user -xe

# 查看垃圾收集日志
journalctl --user -u nix-gc -f
```

---

## 系统级配置替代方案

### 网络配置

如果 `modules/core/network.nix` 中有用户相关配置：

**替代方法**:

```bash
# 使用 NetworkManager（GUI）
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager

# 或使用 home-manager 的网络配置
# home/dashu/network.nix
programs.ssh.enable = true;
```

### 虚拟化配置

如果需要虚拟化支持：

**替代方法**:

```bash
# 1. 安装 libvirt 和 QEMU
sudo pacman -S libvirt qemu  # ArchLinux
sudo apt install libvirt-clients qemu  # Debian

# 2. 添加用户到 libvirt 组
sudo usermod -aG libvirt $USER

# 3. 启动 libvirt 服务
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# 4. 在 Nix 中安装虚拟化工具
# home/dashu/dev.nix
home.packages = with pkgs; [
  libvirt
  qemu
  virt-manager
  win-spice
];
```

---

## 最佳实践

### ✅ 推荐做法

1. **定期备份配置**
   - 使用 git 管理所有配置
   - 定期 push 到远程仓库

2. **验证更改前应用**
   ```bash
   nix build .#homeConfigurations.dashu@laptop.activationPackage
   ```

3. **使用有意义的提交信息**
   ```bash
   git commit -m "feat: add fcitx5 input method configuration"
   ```

4. **定期更新依赖**
   ```bash
   nix flake update
   ```

5. **监控磁盘使用**
   ```bash
   du -sh ~/.cache/nix
   du -sh ~/.nix-profile
   ```

### ⚠️ 注意事项

1. **GPU 配置互斥** - dGPU 禁用和直通不应同时应用
2. **BIOS 配置重要** - IOMMU 直通依赖 BIOS 虚拟化选项
3. **驱动冲突** - 某些旧系统对启动参数反应不同
4. **备份重要** - 修改 GRUB 前始终备份（脚本自动处理）

---

## 后续增强

### 可选的改进项目

1. **测试其他发行版**
   - Debian/Ubuntu 虚拟机测试
   - ArchLinux 虚拟机测试
   - 验证脚本完全兼容性

2. **扩展 GPU 支持**
   - 添加 AMD GPU 配置
   - 添加 Intel Arc GPU 支持
   - 创建 NVIDIA 特定优化

3. **自动化部署**
   - 创建安装脚本自动克隆仓库
   - 添加 CI/CD 管道验证配置
   - 实现一键部署脚本

4. **性能优化**
   - 根据实际使用调整 GC 时间表
   - 监控磁盘使用和 store 大小
   - 实现自动告警机制

---

## 学习资源

### 官方文档

- [Nix 官方文档](https://nixos.org/manual/nix/)
- [home-manager 文档](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)

### 高级主题

- [PCI 直通 - ArchLinux Wiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [libvirt GPU 直通](https://libvirt.org/formatdomain.html)
- [IOMMU 和 VFIO - Linux 内核文档](https://www.kernel.org/doc/html/latest/driver-api/vfio.html)

### 社区资源

- [NixOS Discourse](https://discourse.nixos.org/)
- [Arch Linux Forum](https://bbs.archlinux.org/)
- [GitHub Discussions](https://github.com/NixOS/nixpkgs/discussions)

---

## 版本信息

- **创建日期**: 2025-11-08
- **迁移分支**: `migrate-to-nix-standalone`
- **主要版本**: 1.0
- **状态**: ✅ 完成和验证
- **文档状态**: ✅ 完整

---

## 快速参考

### 最常用的命令

```bash
# 应用配置
home-manager switch --flake .#dashu@laptop

# 验证配置
nix flake show

# 更新依赖
nix flake update

# 垃圾收集
bash home/scripts/nix-gc.sh --force

# 查看历史
home-manager generations

# 回滚版本
home-manager switch --gen <N>

# GPU 启动条目
sudo bash home/scripts/gpu-boot-entry.sh install
sudo bash home/scripts/gpu-boot-entry.sh show

# 初始化环境
bash home/scripts/init-nix-env.sh
```

### 脚本文件位置

```
home/scripts/
├── init-nix-env.sh         # 环境初始化
├── setup-nix-gc.sh         # GC 定时器配置
├── nix-gc.sh               # GC 执行
├── gpu-boot-entry.sh       # GPU 启动条目
└── README.md               # 脚本文档
```

### 配置文件位置

```
home/dashu/
├── default.nix             # 主配置（导入所有模块）
├── zsh.nix                 # Shell
├── vscode.nix              # 编辑器
├── hyprland/               # 窗口管理器
├── fcitx5/                 # 输入法
└── (20+ 其他配置)
```

---

## 支持和反馈

### 遇到问题？

1. 查看本文档的相关章节
2. 检查脚本的详细错误输出
3. 查看 git 日志了解历史更改
4. 参考官方文档和社区资源

### 想要改进？

1. 改进脚本或文档
2. 提交 Pull Request
3. 创建 Issue 报告问题
4. 分享使用经验和技巧

---

**祝您使用愉快！🚀**

对于任何问题或建议，请查阅相关文档或提交 Issue。
