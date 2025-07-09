# Waybar Configuration

这是一个基于Catppuccin主题的Waybar配置，专为Hyprland桌面环境设计。

## 文件结构

```
waybar/
├── default.nix      # 主配置文件，导入其他模块
├── settings.nix     # Waybar设置和模块配置
├── style.nix        # CSS样式定义
├── spotify.sh       # Spotify状态脚本
└── README.md        # 此文件
```

## 文件说明

### `default.nix`
主配置文件，负责：
- 导入设置和样式文件
- 启用waybar程序
- 配置spotify脚本到正确位置

### `settings.nix`
包含waybar的所有设置：
- 基本窗口配置（位置、尺寸、边距等）
- 模块布局（左、中、右侧模块）
- 各个模块的具体配置

### `style.nix`
包含waybar的CSS样式：
- Catppuccin颜色主题
- 字体配置
- 各模块的样式定义
- 动画效果

### `spotify.sh`
Spotify状态监控脚本：
- 检测播放状态
- 显示当前播放的歌曲信息
- 处理离线状态

## 模块配置

### 左侧模块
- `custom/menu` - 应用菜单
- `cpu` - CPU使用率
- `memory` - 内存使用情况
- `disk` - 磁盘使用情况
- `idle_inhibitor` - 空闲抑制器

### 中间模块
- `hyprland/workspaces` - 工作区切换
- `mpd` - 音乐播放器守护进程
- `tray` - 系统托盘

### 右侧模块
- `custom/themes` - 主题切换
- `pulseaudio` - 音频控制
- `backlight` - 背光控制
- `bluetooth` - 蓝牙状态
- `network` - 网络状态
- `battery` - 电池状态
- `clock` - 时钟
- `custom/power` - 电源菜单

## 使用方法

1. 将此目录放置在NixOS配置的相应位置
2. 在home-manager配置中导入 `./waybar`
3. 重建系统配置

## 依赖项

确保系统中安装了以下依赖：
- `waybar` - 状态栏程序
- `playerctl` - 媒体播放器控制
- `light` - 背光控制
- `pulsemixer` - 音频控制
- `mpc` - MPD客户端

## 自定义

- 修改 `settings.nix` 中的模块配置
- 修改 `style.css` 中的颜色和样式
- 根据需要调整脚本路径
