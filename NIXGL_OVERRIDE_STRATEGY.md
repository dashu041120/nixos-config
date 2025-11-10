# NixGL 应用覆盖策略

## 概述

通过 `lib.hiPrio` 直接覆盖应用的可执行文件，自动为其提供 OpenGL 支持。

## 工作原理

### 旧方法（已弃用）
```nix
# 在 ~/.local/bin 中创建脚本
home.file.".local/bin/ghostty-gl" = { ... }

# 缺点：
# ❌ 需要添加 ~/.local/bin 到 PATH
# ❌ 创建额外的脚本文件
# ❌ 需要记住使用 ghostty-gl 而不是 ghostty
```

### 新方法（当前）
```nix
# 直接覆盖原始应用
mkNixGLApp = appName: app:
  lib.hiPrio (pkgs.writeShellScriptBin appName ''
    exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${lib.getExe app} "$@"
  '');

# 优点：
# ✅ 无需修改 PATH
# ✅ 直接运行应用名 (ghostty 而不是 ghostty-gl)
# ✅ 完全透明的包装
```

## 已配置的应用

| 应用 | 包名 | 使用方式 |
|------|------|---------|
| Ghostty | ghostty | `ghostty` |
| Vicinae | vicinae | `vicinae` |
| Noctalia | noctalia | `noctalia` |
| OBS | obs-studio | `obs` |
| Spotify | spotify | `spotify` |
| VLC | vlc | `vlc` |
| Warp Terminal | warp-terminal | `warp-terminal` |
| Waveterm | waveterm | `waveterm` |
| Looking Glass Client | looking-glass-client | `looking-glass-client` |
| GIMP | gimp | `gimp` |

## 添加新应用

### 步骤 1：编辑 `home/dashu/nixgl.nix`

在 `glApps` 列表中添加应用：

```nix
glApps = [
  { name = "ghostty"; app = pkgs.ghostty; }
  { name = "your-app"; app = pkgs.your-app; }  # ← 添加这一行
];
```

### 步骤 2：应用配置

```bash
nix --extra-experimental-features 'nix-command flakes' run home-manager -- switch -b backup --flake .#dashu@laptop --impure
```

### 步骤 3：直接使用

```bash
your-app
```

就这样！无需任何额外配置。

## 技术细节

### `lib.hiPrio` 的作用

```nix
lib.hiPrio pkg
```

- 给予包更高的优先级
- 当有多个版本时，优先使用这个版本
- 确保 nixGL 包装的版本被使用而不是原始版本

### `writeShellScriptBin` 的作用

```nix
pkgs.writeShellScriptBin "ghostty" ''
  exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${lib.getExe app} "$@"
''
```

- 创建一个新的可执行文件
- 命名为 `ghostty`
- 自动添加到 `$PATH`（通过 `home.packages`）
- 转发所有参数给原始应用

### `lib.getExe` 的作用

```nix
lib.getExe app
```

- 从应用包中获取可执行文件的完整路径
- 例如：`${pkgs.ghostty}/bin/ghostty`
- 更健壮的方法，避免手动指定路径

## 对比不同的包装方式

### 方式 1：脚本文件（旧）
```nix
home.file.".local/bin/app" = {
  executable = true;
  text = "exec nixGL ...";
};
```
- ❌ 需要 PATH 配置
- ❌ 脚本分散存放

### 方式 2：覆盖（新 - 当前）
```nix
home.packages = [ (mkNixGLApp "app" pkgs.app) ];
```
- ✅ 自动在 PATH 中
- ✅ 应用直接可用
- ✅ 不需要额外配置

### 方式 3：桌面文件
```nix
xdg.desktopEntries.app = {
  exec = "nixGL ...";
};
```
- ✅ GUI 应用可用
- ❌ 命令行仍需 nixGL 前缀
- ❌ 只影响桌面启动

## 优势总结

| 特性 | 脚本 | 覆盖（当前） | 桌面文件 |
|------|------|-----------|---------|
| 命令行使用 | ❌ | ✅ | ❌ |
| GUI 启动 | ❌ | ✅ | ✅ |
| PATH 配置 | ❌ | ✅ | N/A |
| 透明度 | ❌ | ✅ | ❌ |
| 配置简度 | ⭐ | ⭐⭐⭐ | ⭐⭐ |

## 常见问题

### Q: 为什么应用还是提示找不到？

A: 检查应用是否在 `pkgs` 中可用：

```bash
nix search nixpkgs ghostty
```

如果找不到，可能需要使用不同的包名。

### Q: 如何知道正确的包名？

A: 使用 `nix search`：

```bash
nix search nixpkgs "#^obs" --limit 10
```

### Q: 可以同时使用原始应用和包装版本吗？

A: 可以，但使用 `lib.hiPrio` 后，包装版本会优先。如需原始版本，可以：

```bash
$(nix build nixpkgs#ghostty --print-out-paths)/bin/ghostty
```

### Q: 性能有影响吗？

A: 没有。只是多一层脚本调用，启动时间可忽略不计。

## 下一步

1. **应用配置**：运行 home-manager switch
2. **验证**：直接运行应用名（如 `ghostty`）
3. **测试 OpenGL**：`ghostty` 启动后，检查是否有 OpenGL 支持
4. **添加更多应用**：根据需要扩展 `glApps` 列表

---

**优势**：简洁、透明、无需额外配置
