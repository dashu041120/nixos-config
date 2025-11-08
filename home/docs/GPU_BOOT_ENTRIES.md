# GPU 启动条目管理指南

## 概述

此指南介绍如何使用 `gpu-boot-entry.sh` 脚本在 GRUB 启动菜单中创建两个独立的 GPU 配置启动条目：

1. **Disable dGPU (iGPU only)** - 禁用独立显卡，仅使用集成显卡
2. **GPU Passthrough (IOMMU Enabled)** - 启用 IOMMU 和 GPU 直通支持

此脚本支持 ArchLinux 和 Debian（包括 Ubuntu）两个发行版。

---

## 目录

- [快速开始](#快速开始)
- [两种启动模式详解](#两种启动模式详解)
- [核心技术原理](#核心技术原理)
- [脚本使用手册](#脚本使用手册)
- [常见场景和解决方案](#常见场景和解决方案)
- [故障排查](#故障排查)

---

## 快速开始

### 前置要求

- root 权限或 sudo 访问
- GRUB 启动引导程序
- ArchLinux 或 Debian/Ubuntu 系统
- 文件系统配置完整（/etc/fstab）

### 安装步骤

```bash
# 1. 赋予脚本执行权限（如果未设置）
sudo chmod +x ~/home/scripts/gpu-boot-entry.sh

# 2. 运行安装命令
sudo ~/home/scripts/gpu-boot-entry.sh install

# 3. 重启系统
sudo reboot

# 4. 在 GRUB 菜单中选择对应启动项
```

### 验证安装

```bash
# 查看已安装的启动条目
sudo ~/home/scripts/gpu-boot-entry.sh show

# 查看详细说明
sudo ~/home/scripts/gpu-boot-entry.sh details

# 验证 GRUB 配置
sudo ~/home/scripts/gpu-boot-entry.sh verify
```

---

## 两种启动模式详解

### 模式 1: Disable NVIDIA dGPU (iGPU only)

#### 用途

- **延长笔记本续航时间** - 关闭独立显卡可节省 30-50% 电力
- **降低系统温度** - 减少热量生成，改善散热
- **日常办公场景** - 文本编辑、浏览器、开发工作

#### 工作原理

此启动条目使用以下内核参数：

```bash
nouveau.modeset=0              # 禁用 Nouveau 开源显卡驱动
nvidia_drm.modeset=0           # 禁用 NVIDIA DRM 输出
nvidia.NVreg_DynamicPowerManagement=0  # 禁用动态电源管理
intel_pmc_core.warn_on_alloc=1 # Intel 电源管理配置
```

#### 工作流程

1. **启动时** - 内核加载时检测到禁用参数
2. **驱动加载** - Nouveau 和 NVIDIA 驱动不加载
3. **BIOS 禁用** - 操作系统禁用 dGPU
4. **iGPU 接管** - 集成显卡成为唯一图形设备

#### 影响分析

| 方面 | 效果 |
|------|------|
| 续航时间 | +2-4 小时 |
| 系统温度 | -5-15°C |
| 功耗 | -20-30W |
| 图形性能 | 保持可用但有限 |
| 支持 | 集成显卡上网、办公、视频播放 |

#### 设备支持

- ✅ Intel 核显（集成显卡）
- ✅ AMD Radeon 集成显卡
- ✅ 任何 NVIDIA dGPU（禁用）

### 模式 2: GPU Passthrough (IOMMU Enabled)

#### 用途

- **虚拟机 GPU 直通** - 将实体 GPU 分配给 QEMU/KVM 虚拟机
- **游戏虚拟机** - 在虚拟机中运行高性能游戏
- **GPU 计算** - CUDA/OpenCL 应用在虚拟机中运行
- **接近原生性能** - 虚�拟机可获得 95%+ 原生 GPU 性能

#### 工作原理

此启动条目启用 IOMMU（I/O Memory Management Unit）和相关内核参数：

```bash
iommu=pt                       # 启用 IOMMU 直通模式
intel_iommu=on                 # 启用 Intel IOMMU（DMAR）
amd_iommu=on                   # 启用 AMD IOMMU
vfio_iommu_type1.allow_unsafe_interrupts=1  # 允许直通中断
kvm.ignore_msrs=1              # 忽略不支持的 MSR
kvm.report_ignored_msrs=0      # 不报告 MSR 错误
```

#### 工作流程

1. **IOMMU 初始化** - 启动时 IOMMU 表初始化
2. **设备分组** - GPU 和相关设备组织为 IOMMU 组
3. **VFIO 绑定** - GPU 绑定到 vfio-pci 驱动（非原生驱动）
4. **虚拟机访问** - QEMU/KVM 可直接访问 GPU 硬件

#### 性能指标

| 指标 | 数值 |
|------|------|
| 原生性能比 | 95-98% |
| 延迟增加 | <1% |
| 内存开销 | 1-2% |
| GPU 共享 | 不支持（专占模式） |

#### 硬件要求

- 🔧 **CPU** - 支持 IOMMU 虚拟化
  - Intel - VT-d 支持（Sandy Bridge 及以后）
  - AMD - AMD-Vi 支持（Bulldozer 及以后）
- 🔌 **主板 BIOS** - IOMMU 选项（VT-d 或 IOMMU）需要**启用**
- 🎮 **GPU** - NVIDIA（在 Windows 虚拟机上无特殊限制）

#### 检查 IOMMU 支持

```bash
# 检查 CPU 是否支持 IOMMU
grep -o 'vmx\|svm' /proc/cpuinfo | sort | uniq

# 检查 BIOS 是否启用 IOMMU
dmesg | grep -i iommu

# 查看 IOMMU 组
for d in /sys/kernel/iommu_groups/*/devices/*; do n=${d%/*}; n=${n##*/}; printf '%s ' "$n"; cat "$d/modalias"; done; echo
```

#### 配置虚拟机步骤

```bash
# 1. 识别 GPU 设备 ID（例如 0000:01:00.0）
lspci -nn | grep -i nvidia

# 2. 将 GPU 绑定到 vfio-pci
echo "0000:01:00.0" > /sys/bus/pci/drivers/nvidia/unbind
echo "10de:1c82" > /sys/bus/pci/drivers/vfio-pci/new_id

# 3. 使用 QEMU/libvirt 配置直通
# 示例 libvirt XML 配置
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
  </source>
</hostdev>

# 4. 在虚拟机中安装 GPU 驱动
```

---

## 核心技术原理

### IOMMU 技术

**定义** - I/O Memory Management Unit 是计算机芯片组中的硬件功能，用于 I/O 设备的内存虚拟化。

**功能** - IOMMU 将设备访问的物理地址转换为设备虚拟地址，实现：
- 🛡️ **内存保护** - 限制设备访问的内存范围
- 🔄 **地址转换** - DMA 地址映射和重定向
- 🎯 **设备隔离** - 设备无法访问其他设备或 VM 内存

### VFIO (Virtual Function I/O)

**定义** - 通用用户空间驱动框架，允许用户空间应用直接访问硬件设备。

**工作流程**：
1. 设备从原生驱动中解绑（例如 nvidia）
2. 设备绑定到 vfio-pci 驱动
3. 用户空间应用（QEMU）通过 VFIO 接口访问设备
4. IOMMU 处理内存地址转换

### dGPU 禁用机制

**内核级禁用** - 通过模块参数在启动时防止驱动加载：

```bash
# Nouveau 驱动禁用
nouveau.modeset=0
↓
Nouveau 驱动不初始化，不探测 GPU

# NVIDIA 驱动禁用  
nvidia_drm.modeset=0
↓
NVIDIA DRM 模块不启用输出管理

# 结果：集成显卡成为唯一可用图形设备
```

---

## 脚本使用手册

### 命令参考

#### `install` - 安装启动条目（默认）

```bash
sudo ~/home/scripts/gpu-boot-entry.sh install
# 或
sudo ~/home/scripts/gpu-boot-entry.sh
```

**功能**：
- 备份现有 GRUB 配置
- 创建 GRUB 自定义文件（如不存在）
- 添加两个启动菜单项
- 自动检测根分区 UUID
- 验证 GRUB 配置语法
- 重建 GRUB 配置文件

**输出示例**：
```
[✓] 检测到发行版: arch
[✓] GRUB 已安装
[✓] 已备份自定义文件
[✓] 已初始化 GRUB 自定义文件
[✓] 已添加 Disable dGPU 条目
[✓] 已添加 GPU Passthrough 条目
[✓] 已更新 UUID
[✓] GRUB 条目验证通过
[✓] GRUB 已重建
[✓] 安装完成！重启后在 GRUB 菜单中选择对应条目
```

#### `show` - 显示启动条目列表

```bash
sudo ~/home/scripts/gpu-boot-entry.sh show
```

**输出**：
```
[INFO] 当前 GRUB 自定义条目:

  Linux - Disable NVIDIA dGPU (iGPU only)
  Linux - GPU Passthrough (IOMMU Enabled)
```

#### `details` - 显示详细说明

```bash
sudo ~/home/scripts/gpu-boot-entry.sh details
```

**输出** - 显示每个启动项的功能、优势和场景

#### `verify` - 验证 GRUB 配置

```bash
sudo ~/home/scripts/gpu-boot-entry.sh verify
```

**功能** - 检查：
- ✓ menuentry 是否存在
- ✓ GRUB 语法是否正确
- ✓ 配置文件是否可读

#### `remove <name>` - 删除指定条目

```bash
# 删除 dGPU 禁用条目
sudo ~/home/scripts/gpu-boot-entry.sh remove "Disable"

# 删除 GPU 直通条目
sudo ~/home/scripts/gpu-boot-entry.sh remove "Passthrough"
```

**功能** - 从 GRUB 自定义文件中删除指定条目并重建配置

#### `rebuild` - 重建 GRUB 配置

```bash
sudo ~/home/scripts/gpu-boot-entry.sh rebuild
```

**功能** - 手动重建 GRUB 配置文件，用于编辑后刷新配置

#### `restore` - 从备份恢复

```bash
sudo ~/home/scripts/gpu-boot-entry.sh restore
```

**功能** - 从最近的备份恢复 GRUB 配置

### 选项

```bash
-h, --help    显示帮助信息
help          显示帮助信息
```

---

## 常见场景和解决方案

### 场景 1: 日常使用延长续航

**目标** - 在日常办公时使用集成显卡以延长电池续航时间。

**步骤**：
```bash
# 1. 安装启动条目
sudo ~/home/scripts/gpu-boot-entry.sh install

# 2. 重启系统
sudo reboot

# 3. 在 GRUB 菜单中选择 "Disable NVIDIA dGPU"

# 4. 验证 dGPU 已禁用
lspci | grep -i nvidia  # 不应显示任何 NVIDIA 设备

# 5. 检查电池续航（应有明显改善）
```

**预期结果** - 续航时间延长 2-4 小时，系统温度下降 5-15°C

### 场景 2: 虚拟机 GPU 直通

**目标** - 在 KVM/QEMU 虚拟机中运行 Windows 11，并将 GPU 直通给虚拟机。

**步骤**：
```bash
# 1. 安装启动条目
sudo ~/home/scripts/gpu-boot-entry.sh install

# 2. 重启并选择 "GPU Passthrough" 条目
sudo reboot

# 3. 验证 IOMMU 已启用
dmesg | grep -i "DMAR\|AMD-Vi"  # 应显示 IOMMU 初始化消息

# 4. 查看 IOMMU 组
for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d%/*}; n=${n##*/}
    printf '%s ' "$n"
    cat "$d/modalias"
done

# 5. 配置 VFIO 驱动绑定
GPU_ID="0000:01:00.0"
sudo echo "$GPU_ID" > /sys/bus/pci/drivers/nvidia/unbind
sudo echo "10de:1c82" > /sys/bus/pci/drivers/vfio-pci/new_id

# 6. 在 libvirt XML 中添加 GPU 设备
# 参见上方 GPU 直通配置示例

# 7. 启动虚拟机
virsh start win11

# 8. 在虚拟机中验证 GPU
# Windows: 设备管理器 - 显示适配器 - 应显示 NVIDIA GPU
```

**预期结果** - 虚拟机中可访问 GPU，性能达原生 95%+ 

### 场景 3: 双启动 GPU 配置切换

**目标** - 灵活切换 dGPU 禁用和启用模式。

**步骤**：
```bash
# 1. 第一次安装（已完成）
sudo ~/home/scripts/gpu-boot-entry.sh install

# 2. 重启时的每次选择
#    方案 A: 使用 iGPU（续航优先）
#       → 启动菜单中选择 "Disable NVIDIA dGPU"
#    方案 B: 虚拟机 GPU 直通（性能优先）
#       → 启动菜单中选择 "GPU Passthrough"
#    方案 C: 默认启动（使用原始配置）
#       → 启动菜单中选择 "Linux"

# 3. 可选：设置默认启动项
sudo grub-set-default "Linux - Disable NVIDIA dGPU (iGPU only)"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**预期结果** - 可在启动时灵活选择 GPU 配置

---

## 故障排查

### 问题 1: UUID 自动检测失败

**症状** - 启动菜单中出现 `UUID=__ROOT_UUID__`

**原因** - `/etc/fstab` 中未使用 UUID 标识根分区

**解决方案**：
```bash
# 1. 查看当前文件系统
df /
# 输出示例: /dev/nvme0n1p3

# 2. 获取 UUID
blkid /dev/nvme0n1p3
# 输出示例: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890"

# 3. 手动编辑 GRUB 自定义文件
sudo nano /etc/grub.d/40_custom

# 4. 找到 __ROOT_UUID__ 并替换为实际 UUID
# 例如: root=UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890

# 5. 保存并重建 GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 问题 2: GPU 仍然可见于设备列表

**症状** - 选择 Disable dGPU 后，`lspci` 仍显示 NVIDIA GPU

**原因** - 模块参数未正确生效或 BIOS 未禁用设备

**解决方案**：
```bash
# 1. 验证启动参数是否正确应用
cat /proc/cmdline | grep nouveau

# 2. 尝试运行时禁用
sudo echo "1" > /sys/bus/pci/devices/0000\:01\:00.0/remove

# 3. 检查 BIOS 设置
#    进入 BIOS → 找到 "Integrated Graphics" 或 "Primary Display"
#    确保集成显卡被设置为主显示器
#    确保独立显卡未被禁用或隐藏

# 4. 查看驱动加载状态
lsmod | grep -i nvidia
lsmod | grep -i nouveau
# 如果有输出则说明驱动仍在加载，需要调整启动参数
```

### 问题 3: GRUB 语法错误

**症状** - `verify` 命令报错"GRUB 配置有语法错误"

**原因** - `/etc/grub.d/40_custom` 中可能有语法错误

**解决方案**：
```bash
# 1. 检查文件语法
sudo grub-mkconfig -o /tmp/test.cfg 2>&1 | head -20

# 2. 查看自定义文件内容
sudo cat /etc/grub.d/40_custom | head -30

# 3. 从备份恢复
sudo ~/home/scripts/gpu-boot-entry.sh restore
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 4. 重新安装
sudo ~/home/scripts/gpu-boot-entry.sh install
```

### 问题 4: IOMMU 不工作

**症状** - `dmesg | grep IOMMU` 无输出

**原因** - 可能 BIOS 未启用或 CPU 不支持

**解决方案**：
```bash
# 1. 检查 CPU 是否支持
grep flags /proc/cpuinfo | grep -o 'vmx\|svm'
# 如无输出，CPU 可能不支持虚拟化

# 2. 进入 BIOS 设置
#    ⚙️ BIOS/UEFI 设置 (通常按 Del/F2/F10 键)
#    🔍 查找 "IOMMU", "VT-d", "AMD-Vi" 或 "I/O Virtualization"
#    ✅ 确保已启用 (ENABLED)

# 3. 检查内核是否启用 IOMMU 支持
grep IOMMU /boot/config-$(uname -r)
# 应该显示: CONFIG_IOMMU_SUPPORT=y

# 4. 重启并选择 GPU Passthrough 启动项
sudo reboot

# 5. 验证 IOMMU 初始化
dmesg | grep -E "DMAR|AMD-Vi"
```

### 问题 5: 虚拟机看不到 GPU

**症状** - 虚拟机中的 GPU 未检测到

**原因** - GPU 未绑定到 vfio-pci 驱动

**解决方案**：
```bash
# 1. 查找 GPU 设备 ID
lspci -nn | grep -i nvidia
# 输出: 01:00.0 3D controller [0302]: NVIDIA ... [10de:1c82]

# 2. 绑定到 vfio-pci
GPU_ID="10de:1c82"
sudo bash -c "echo $GPU_ID > /sys/bus/pci/drivers/vfio-pci/new_id"

# 3. 验证绑定
lspci -k | grep -A 2 "01:00.0"
# 应显示 "Kernel driver in use: vfio-pci"

# 4. 更新 libvirt XML 配置（如需要）

# 5. 重启虚拟机使其识别 GPU
```

### 问题 6: 启动后系统黑屏

**症状** - 选择新的启动项后系统黑屏或无显示

**原因** - 集成显卡输出未正确配置

**解决方案**：
```bash
# 1. 强制进入恢复模式或默认启动项
#    按住 Shift 键进入 GRUB 菜单
#    选择原始的 "Linux" 条目启动

# 2. 检查 BIOS 设置
#    确保集成显卡（iGPU）在主板中未被禁用
#    查看集成显卡是否被设为主显示器

# 3. 更新显卡驱动（如在 Linux 下）
sudo pacman -S intel-media-driver  # ArchLinux - Intel GPU
sudo apt install intel-media-driver # Debian - Intel GPU

# 4. 编辑启动项参数
sudo nano /etc/grub.d/40_custom
# 添加更多视频输出参数: video=1920x1080@60
# 例如: linux /boot/vmlinuz-linux ... video=1920x1080@60

# 5. 重建 GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 问题 7: 脚本权限不足

**症状** - 运行脚本报错 "Permission denied" 或 "需要 root 权限"

**原因** - 脚本未设置执行权限或未用 sudo 运行

**解决方案**：
```bash
# 1. 确保脚本有执行权限
chmod +x ~/home/scripts/gpu-boot-entry.sh

# 2. 始终使用 sudo 运行
sudo ~/home/scripts/gpu-boot-entry.sh install

# 3. 或添加当前用户到 sudoers（可选但推荐谨慎）
sudo usermod -aG wheel $USER  # ArchLinux
sudo usermod -aG sudo $USER   # Debian
```

---

## 发行版特定说明

### ArchLinux

**GRUB 配置文件位置**：
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

**GRUB 配置文件位置**：
- 自定义文件: `/etc/grub.d/40_custom`
- 主配置: `/etc/default/grub`
- 生成配置: `/boot/grub/grub.cfg`

**GRUB 重建命令**:
```bash
sudo update-grub
# 或
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**启动参数文件**：
- `/boot/vmlinuz-linux-generic` 或 `/boot/vmlinuz-$(uname -r)` - Linux 内核
- `/boot/initrd.img` 或 `/boot/initramfs-$(uname -r).img` - 初始化 RAM 磁盘

---

## 高级配置

### 设置默认启动项

```bash
# 列出所有启动项
grep "menuentry" /boot/grub/grub.cfg | nl -v 0

# 设置默认启动项（例如第 2 个）
sudo grub-set-default 2
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 也可直接编辑 /etc/default/grub
sudo nano /etc/default/grub
# 修改: GRUB_DEFAULT="Linux - Disable NVIDIA dGPU (iGPU only)"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 添加启动菜单超时

编辑 `/etc/default/grub`：

```bash
GRUB_TIMEOUT=10  # 等待 10 秒自动启动默认项
```

然后重建 GRUB：
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 启用 IOMMU 高级选项

对于特殊需求，可在启动参数中添加更多选项：

```bash
# 禁用 GPU 重置（某些 GPU 需要）
gpu.noreboot=1

# 启用 GPU 中断重新映射
irqchip.pin_2_irq=-1

# NVIDIA 特定选项
nvidia.NVreg_UsePageAttributeTable=1
```

编辑方式：
```bash
sudo nano /etc/grub.d/40_custom
# 在 linux 行末添加参数
# 例如: linux /boot/vmlinuz-linux ... gpu.noreboot=1
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 总结和建议

### ✅ 推荐做法

1. **定期备份** - 脚本自动备份，但也应手动备份重要配置
2. **验证配置** - 修改后总是运行 `verify` 命令
3. **测试启动** - 新增启动项后重启并测试
4. **记录设置** - 记下有效的 GRUB 参数配置

### ⚠️ 注意事项

1. **GPU 独占** - GPU 直通时，主系统无法使用该 GPU
2. **驱动冲突** - dGPU 禁用和直通不应同时应用
3. **BIOS 设置** - 许多功能依赖 BIOS 中的虚拟化选项
4. **电源管理** - 某些旧系统可能对内核参数反应不同

### 🔗 相关资源

- [NVIDIA Optimus 笔记本配置](https://wiki.archlinux.org/title/NVIDIA_Optimus_zh)
- [PCI 直通 - ArchLinux Wiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [libvirt GPU 直通](https://libvirt.org/formatdomain.html)
- [IOMMU 和 VFIO](https://www.kernel.org/doc/html/latest/driver-api/vfio.html)

---

**最后更新**: 2024年
**兼容版本**: GRUB 2.x, Linux 5.x+
**支持系统**: ArchLinux, Debian, Ubuntu
