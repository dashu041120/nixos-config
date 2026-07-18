# NixOS Configuration

NixOS + Home Manager 分离式配置。

## 分支说明

| 分支 | 用途 |
|---|---|
| `nixos-full` | 完整 NixOS + Home Manager 配置（主分支） |
| `nix-only` | 仅 NixOS 系统配置 |

## 快速开始

```bash
cd ~/Desktop/nixos-config

# 1. 应用系统配置（会自动安装 home-manager CLI）
sudo nixos-rebuild switch --flake .#laptop

# 2. 应用用户配置
home-manager switch --flake .#dashu@laptop
```

## 可用配置

### NixOS 系统配置

```bash
sudo nixos-rebuild switch --flake .#laptop    # 笔记本
sudo nixos-rebuild switch --flake .#vm        # 虚拟机
```

### Home Manager 用户配置

```bash
home-manager switch --flake .#dashu@laptop    # 笔记本用户
home-manager switch --flake .#dashu@vm        # 虚拟机用户
```

## 包含模块

### 系统 (NixOS)
- 桌面环境：KDE / Niri (Wayland)
- 主题：Marathon GRUB Theme / AeroThemePlasma / Catppuccin
- 音频：PipeWire
- 网络：NetworkManager
- 蓝牙：Bluez
- 虚拟化：KVM/QEMU
- 游戏：Steam / Gamemode

### 用户 (Home Manager)
- Shell：Zsh + Starship + Oh My Posh
- 终端：Alacritty / Ghostty / Kitty
- 编辑器：VSCode
- 文件管理：Yazi / Thunar
- 浏览器：Firefox
- 主题：Catppuccin
- 桌面：Niri + Noctalia Shell

## TODO

- [ ] 引入 `nixvim`
- [ ] 剪切板历史记录
- [ ] 输入法窗口策略
- [ ] Emoji 选择面板
