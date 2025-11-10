# 📚 NixGL 完整使用指南

> 为非 NixOS 系统提供 OpenGL 支持的完整配置与使用指南

**最后更新**：2025 年 11 月 10 日 | **状态**：✅ 生产就绪

---

## 目录

1. [快速开始](#快速开始)
2. [配置概览](#配置概览)
3. [已配置应用](#已配置应用)
4. [使用指南](#使用指南)
5. [添加新应用](#添加新应用)
6. [常见问题](#常见问题)
7. [故障排查](#故障排查)
8. [参考资源](#参考资源)

---

## 快速开始

### 验证 OpenGL 支持

```bash
# 检查 OpenGL 版本
nixGL glxinfo | grep "OpenGL version"

# 预期输出：
# OpenGL version string: 4.6 (Compatibility Profile) Mesa 25.2.6
```

### 运行应用

```bash
# 方式 1：直接使用 nixGL（推荐）
nixGL ghostty
nixGL obs
nixGL spotify

# 方式 2：使用便捷脚本
ghostty-gl
obs-gl
spotify-gl
```

### 应用配置

如需更新或应用新配置：

```bash
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

**⚠️ 重要**：必须使用 `--impure` 标志，nixGL 需要访问系统时间进行硬件检测。

---

## 配置概览

### 什么是 NixGL？

NixGL 是一个包装工具，为 Nix 应用提供正确的 OpenGL 库支持。在非 NixOS 系统上运行 GUI 应用时常见问题：

```
libGL error: unable to load driver: i965_dri.so
libGL error: driver pointer missing
libGL error: failed to load driver: i965
```

NixGL 解决这个问题，使应用能正确访问系统驱动。

### 已配置的组件

| 文件 | 作用 |
|------|------|
| `flake.nix` | nixGL 输入和 overlay 配置 |
| `home/dashu/nixgl.nix` | 包装脚本生成逻辑（核心） |
| `home/dashu/default.nix` | 导入 nixgl 模块 |

### 验证结果

```
OpenGL 版本：4.6 (Compatibility Profile) Mesa 25.2.6
Direct Rendering：Yes
硬件检测：自动
状态：✅ 正常工作
```

---

## 已配置应用

### 终端 & Shell

| 应用 | 脚本名 | 使用方式 |
|------|--------|---------|
| ghostty | ghostty-gl | `nixGL ghostty` |
| warp-terminal | warp-terminal-gl | `nixGL warp-terminal` |
| waveterm | waveterm-gl | `nixGL waveterm` |
| noctalia | noctalia-gl | `nixGL noctalia` |

### 媒体 & 工具

| 应用 | 脚本名 | 使用方式 |
|------|--------|---------|
| obs | obs-gl | `nixGL obs` |
| spotify | spotify-gl | `nixGL spotify` |
| vlc | vlc-gl | `nixGL vlc` |

### 其他

| 应用 | 脚本名 | 使用方式 |
|------|--------|---------|
| vicinae | vicinae-gl | `nixGL vicinae` |
| looking-glass-client | looking-glass-client-gl | `nixGL looking-glass-client` |

### 配置方式

所有应用的包装脚本由 `home/dashu/nixgl.nix` 中的单个配置列表自动生成：

```nix
glApps = [
  "ghostty"
  "vicinae"
  "noctalia"
  "obs"
  "spotify"
  "vlc"
  "warp-terminal"
  "waveterm"
  "looking-glass-client"
];
```

---

## 使用指南

### 基础使用

#### 直接使用 nixGL（推荐方式）

```bash
# 启动任何应用
nixGL ghostty
nixGL obs
nixGL spotify
```

这是最灵活的方式，不需要任何特殊配置。

#### 使用便捷脚本

```bash
# 使用生成的脚本（名为 <应用名>-gl）
ghostty-gl
obs-gl
spotify-gl
```

便捷脚本在 `~/.local/bin/` 中自动创建。

### 创建别名

在 `~/.config/fish/config.fish` 中添加别名便于快速启动：

```fish
# 快速别名
alias g='nixGL ghostty'
alias o='nixGL obs'
alias s='nixGL spotify'
alias v='nixGL vlc'

# 或完整别名
alias ghostty='nixGL ghostty'
alias obs='nixGL obs'
alias spotify='nixGL spotify'
```

### GPU 性能测试

```bash
# OpenGL 基准测试
nixGL glmark2

# Vulkan 信息（如需要）
nixGL vulkaninfo
```

### 桌面集成（可选）

为应用创建持久的桌面快捷方式，编辑 `home/dashu/default.nix`：

```nix
xdg.desktopEntries.ghostty-gl = {
  name = "Ghostty (OpenGL)";
  exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ghostty";
  type = "Application";
  categories = [ "System" "TerminalEmulator" ];
};
```

---

## 添加新应用

### 最简单的方式（3 步）

#### 步骤 1：编辑应用列表

编辑 `home/dashu/nixgl.nix`，找到 `glApps` 列表并添加应用：

```nix
glApps = [
  "ghostty"
  "your-new-app"  # ← 添加这一行
];
```

#### 步骤 2：应用配置

```bash
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

#### 步骤 3：使用

```bash
# 方式 1
nixGL your-new-app

# 方式 2
your-new-app-gl
```

### 为什么这样有效？

`nixgl.nix` 使用 Nix 函数式编程自动生成脚本：

```nix
let
  mkNixGLWrapper = appName: ''
    #!/usr/bin/env bash
    exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${appName} "$@"
  '';

  mkGLWrappers = lib.listToAttrs (map (app: {
    name = ".local/bin/${app}-gl";
    value = { executable = true; text = mkNixGLWrapper app; };
  }) glApps);
in
{ home.file = mkGLWrappers; }
```

**优势**：
- ✅ 代码极简（~30 行处理 9 个应用）
- ✅ 完全可复用（新增应用只需一行）
- ✅ DRY 原则（无重复代码）
- ✅ 易于维护

---

## 常见问题

### Q: 为什么应用启动不了？

A: 确保应用已通过其他方式安装（如 `gui.nix`）。NixGL 只是提供 OpenGL 支持，不会自动安装应用。

```bash
# 检查应用是否已安装
which ghostty

# 或在 gui.nix 中检查应用是否在 home.packages 列表中
```

### Q: 如何知道 OpenGL 是否工作？

A: 运行诊断命令：

```bash
nixGL glxinfo | head -20

# 应该看到：
# name of display: :0
# display: :0  screen: 0
# direct rendering: Yes
# ...
# OpenGL version string: 4.6 (Compatibility Profile) Mesa 25.2.6
```

### Q: 可以针对特定 GPU 优化吗？

A: 可以。编辑 `home/dashu/nixgl.nix` 并将 `nixgl.auto.nixGLDefault` 改为：

| 配置 | 适用 |
|------|------|
| `nixgl.auto.nixGLIntel` | Intel 集成显卡 |
| `nixgl.auto.nixGLNvidia` | NVIDIA 独立显卡 |
| `nixgl.auto.nixGLNvidiaBumblebee` | 混合配置 |
| `nixgl.auto.nixVulkanNvidia` | NVIDIA Vulkan |

```nix
# 示例：针对 Intel GPU
mkNixGLWrapper = appName: ''
  #!/usr/bin/env bash
  exec ${pkgs.nixgl.auto.nixGLIntel}/bin/nixGL ${appName} "$@"
'';
```

### Q: 性能会受影响吗？

A: 不会。nixGL 仅在应用启动时加载库，不会持续占用资源。性能与直接运行应用相同。

### Q: 如何为所有应用创建别名？

A: 在 `~/.config/fish/config.fish` 中：

```fish
# 为所有应用创建别名
for app in ghostty vicinae noctalia obs spotify vlc warp-terminal waveterm looking-glass-client
    alias $app="nixGL $app"
end
```

### Q: 我需要 Vulkan 支持吗？

A: 大多数应用使用 OpenGL。如果需要 Vulkan（某些游戏或专业应用），使用：

```bash
nixGL vulkaninfo  # 检查 Vulkan 支持

# 对于 NVIDIA Vulkan，修改 nixgl.nix：
# nixgl.auto.nixVulkanNvidia
```

---

## 故障排查

### 问题 1：应用提示找不到

**症状**：`command not found: ghostty`

**解决**：
```bash
# 检查应用是否已安装
which ghostty

# 如果为空，在 gui.nix 中添加应用到 home.packages
```

### 问题 2：OpenGL 不工作

**症状**：应用运行但图形有问题

**解决**：
```bash
# 验证 nixGL 工作
nixGL glxinfo

# 检查配置
cat home/dashu/nixgl.nix | grep -A5 "mkNixGLWrapper"

# 尝试直接运行
nixGL ghostty  # 而不是 ghostty-gl
```

### 问题 3：脚本未生成

**症状**：`ghostty-gl` 命令不存在

**解决**：
```bash
# 检查脚本是否存在
ls -la ~/.local/bin/*-gl

# 如果为空，重新应用配置
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

### 问题 4：GLIBC 版本不匹配

**症状**：`GLIBC_2.34' not found` 或类似错误

**解决**：
```bash
# 确保 nixGL 和应用使用相同的 nixpkgs 版本

# 更新 flake.lock
nix flake update

# 重新应用配置
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

### 问题 5：硬件检测失败

**症状**：`error: attribute 'currentTime' missing`

**解决**：确保使用 `--impure` 标志：

```bash
# ❌ 错误
home-manager switch --flake .#dashu@laptop

# ✅ 正确
home-manager switch --flake .#dashu@laptop --impure
```

---

## 环境变量

### 自动配置的变量

`nixgl.nix` 自动配置：

```nix
home.sessionVariables = {
  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
    pkgs.libGL
    pkgs.vulkan-loader
  ]}:$LD_LIBRARY_PATH";
};
```

### 手动配置额外变量（如需要）

如果应用仍有问题，编辑 `home/dashu/nixgl.nix` 添加：

```nix
home.sessionVariables = {
  LD_LIBRARY_PATH = "...";  # 已有
  LIBGL_DRIVERS_PATH = "${pkgs.libGL}/lib/dri";
  LIBVA_DRIVERS_PATH = "${pkgs.libva}/lib/dri";
};
```

---

## 更新和维护

### 更新 nixGL 驱动

```bash
# 更新 flake 输入
nix flake update nixgl

# 应用配置
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

### 定期检查

```bash
# 每月检查驱动版本
nixGL glxinfo | grep "Mesa\|Nvidia"

# 查看 flake.lock 中的提交日期
git log --oneline flake.lock | head -5
```

---

## 参考资源

### 官方文档

- [NixGL GitHub](https://github.com/nix-community/nixGL)
- [Home Manager 文档](https://nix-community.github.io/home-manager/)
- [Nix Flakes 手册](https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html)

### 相关文件

- `flake.nix` - 顶级配置
- `home/dashu/nixgl.nix` - 核心 nixGL 配置
- `home/dashu/default.nix` - Home Manager 模块导入
- `home/dashu/gui.nix` - 应用安装配置
- `NIXGL_QUICK_REFERENCE.md` - 快速参考卡

### 常见应用列表

需要 OpenGL 的应用：

- **3D 建模**：blender, meshlab, freecad
- **图形编辑**：gimp, krita, inkscape
- **游戏引擎**：godot, unreal-engine
- **视频编辑**：kdenlive, shotcut, davinci-resolve
- **CAD**：freecad, autodesk-fusion360
- **科学可视化**：paraview, visit, veusz

---

## 总结

### ✅ 已完成

- ✅ nixGL 集成到 Flake 配置
- ✅ 9 个应用配置了 OpenGL 支持
- ✅ 自动生成便捷脚本
- ✅ 环境变量正确配置
- ✅ OpenGL 验证成功（4.6 版本）

### 🎯 关键命令

```bash
# 验证
nixGL glxinfo | grep "OpenGL version"

# 运行应用
nixGL ghostty
ghostty-gl

# 添加新应用
# 1. 编辑 home/dashu/nixgl.nix
# 2. 运行 home-manager switch ... --impure
# 3. 完成

# 更新驱动
nix flake update nixgl
```

### 📝 下一步

1. **创建别名** - 在 `~/.config/fish/config.fish` 中为常用应用创建别名
2. **添加应用** - 根据需要将更多应用添加到 `glApps` 列表
3. **监控性能** - 使用 `nixGL glmark2` 测试 GPU 性能
4. **定期更新** - 每月更新 nixGL 和驱动程序

---

**配置完成时间**：2025 年 11 月 10 日  
**应用数量**：9 个  
**代码行数**：约 30 行  
**状态**：✅ 生产就绪

如有问题，参考官方文档或提交 issue 到 [NixGL GitHub](https://github.com/nix-community/nixGL)。
