# 迁移指南：NixOS → Nix 独立环境

本文档介绍如何从 NixOS 系统配置迁移到独立 Nix 环境。

## 📁 新的目录结构

```
nixos-config/
├── flake.nix                          # 已重写（支持 homeConfigurations）
├── flake.lock
├── README.md
├── home/                              # 新：集中的 home-manager 配置
│   ├── dashu/                         # 用户 dashu 的配置
│   │   ├── default.nix                # 主配置文件
│   │   ├── alacritty.nix
│   │   ├── bat.nix
│   │   ├── browser.nix
│   │   ├── cli.nix
│   │   ├── dev.nix
│   │   ├── dconf.nix
│   │   ├── fonts/
│   │   ├── fcitx5/
│   │   ├── zsh.nix
│   │   ├── starship.nix
│   │   ├── hyprland/
│   │   ├── niri/
│   │   ├── vscode.nix
│   │   ├── gaming.nix
│   │   └── ... (其他 home-manager 配置)
│   │
│   ├── patrickz/                      # 用户 patrickz 的配置
│   │   ├── default.nix
│   │   └── ... (同样的结构)
│   │
│   ├── scripts/                       # 替代 NixOS 配置的脚本
│   │   ├── init-nix-env.sh           # 初始化环境
│   │   ├── setup-nix-gc.sh           # 设置垃圾收集
│   │   ├── nix-gc.sh                 # 执行垃圾收集
│   │   ├── README.md                 # 脚本文档
│   │   └── docs/                     # 其他文档
│   │
│   └── docs/                          # 文档
│       └── ...
│
├── docs/                              # 项目文档
│   ├── MIGRATION_GUIDE.md             # 本文件
│   ├── WHY_DELETE_MODULES_CORE.md     # 为什么删除 modules/core
│   └── ...
│
├── modules/
│   ├── core/
│   │   ├── default.nix                # ⚠️ 已简化（仅 import system.nix）
│   │   ├── system.nix                 # ⚠️ 已修改（仅保留 Nix 设置）
│   │   └── (其他文件已删除)
│   │
│   └── home/                          # ❌ 已弃用（移至 home/dashu）
│
├── users/                             # ❌ 已弃用（移至 home/）
├── hosts/                             # ❌ 已删除
└── configuration.nix                  # ❌ 已删除
```

## 🔄 迁移步骤

### 第 1 步：查看新结构

```bash
cd /path/to/nixos-config

# 查看新的目录结构
tree -L 2 home/

# 验证 flake 有效性
nix flake show
```

### 第 2 步：初始化环境

```bash
# 使脚本可执行
chmod +x home/scripts/*.sh

# 运行初始化脚本
bash home/scripts/init-nix-env.sh
```

这将：
- ✓ 检查 Nix 和 home-manager 安装
- ✓ 配置 Nix 替代品源
- ✓ 设置自动垃圾收集
- ✓ 验证 flake 配置

### 第 3 步：构建和应用配置

```bash
# 构建配置（检查错误，不应用）
home-manager build --flake .#dashu@laptop

# 应用配置
home-manager switch --flake .#dashu@laptop
```

### 第 4 步：验证

```bash
# 检查生成的配置
ls ~/.local/state/home-manager/

# 查看历史版本
home-manager generations

# 检查垃圾收集任务
~/.config/nix-gc/setup-nix-gc.sh status
```

---

## 📝 配置映射：旧 → 新

### NixOS 配置删除

| 旧配置文件 | 原始功能 | 替代方案 |
|----------|--------|--------|
| `hosts/*/default.nix` | 主机配置 | ❌ 删除（系统已配置） |
| `modules/core/bootloader.nix` | GRUB/启动 | ❌ 删除（系统级） |
| `modules/core/hardware.nix` | 硬件驱动 | ❌ 删除（系统级） |
| `modules/core/xserver.nix` | X11/Wayland | ❌ 删除（系统级） |
| `modules/core/network.nix` | 网络配置 | ❌ 删除（系统级） |
| `modules/core/bluetooth.nix` | 蓝牙服务 | ❌ 删除（系统级） |
| `modules/core/pipewire.nix` | 音频服务 | ❌ 删除（系统级） |
| `modules/core/security.nix` | 安全配置 | ⚠️ 部分转为脚本 |
| `modules/core/user.nix` | 用户账户 | ❌ 删除（系统级） |
| `configuration.nix` | NixOS 根配置 | ❌ 删除 |

### Home-Manager 配置迁移

| 旧位置 | 新位置 | 状态 |
|-------|-------|------|
| `modules/home/*` | `home/dashu/*` | ✅ 直接复制 |
| `users/dashu/home.nix` | `home/dashu/default.nix` | ✅ 转移 |
| `users/patrickz/home.nix` | `home/patrickz/default.nix` | ✅ 转移 |

### 脚本替代

| 旧配置 | 新脚本 | 位置 |
|-------|--------|------|
| `nix.gc.automatic` | `setup-nix-gc.sh` | `home/scripts/` |
| `nix.gc.dates` | `nix-gc.sh` | `home/scripts/` |
| 系统初始化 | `init-nix-env.sh` | `home/scripts/` |

---

## 🔧 关键改动

### flake.nix

**从**:
```nix
nixosConfigurations = {
  laptop = mkSystem { ... };
  desktop = mkSystem { ... };
};
```

**改为**:
```nix
homeConfigurations = {
  "dashu@laptop" = home-manager.lib.homeManagerConfiguration { ... };
  "patrickz@desktop" = home-manager.lib.homeManagerConfiguration { ... };
};
```

### modules/core/system.nix

**删除了**:
- `environment.systemPackages` - 系统级包
- 所有 `boot.*` 选项
- 所有 `services.*` 选项
- 所有 `hardware.*` 选项

**保留了**:
- `nix.settings` - Nix 配置
- `nixpkgs.overlays` - 包覆盖
- `nixpkgs.config` - 包配置

### modules/core/default.nix

**从**:
```nix
imports = [
  ./bootloader.nix
  ./hardware.nix
  ./xserver.nix
  # ... 18 个文件
];
```

**改为**:
```nix
imports = [
  ./system.nix
];
```

---

## 📦 包管理

### 安装用户级包

不再使用 `environment.systemPackages`，改为在 home-manager 中配置：

```nix
# home/dashu/packages.nix (新建)
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vim wget git gcc cmake curl
    htop btop yazi
    # 其他工具
  ];
}
```

然后在 `home/dashu/default.nix` 中 import:
```nix
imports = [
  ./packages.nix
  # 其他配置
];
```

### 添加新用户配置

1. 复制用户目录模板:
```bash
cp -r home/dashu home/newuser
```

2. 编辑 `home/newuser/default.nix`:
```nix
{ pkgs, ... }:
{
  programs.git = {
    userName = "newuser";
    userEmail = "newuser@example.com";
  };
  # 其他配置
};
```

3. 在 `flake.nix` 中添加:
```nix
"newuser@hostname" = home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ./home/newuser/default.nix ... ];
  extraSpecialArgs = { inherit inputs; username = "newuser"; };
};
```

---

## 🚀 常用命令

### 首次使用

```bash
# 初始化
bash home/scripts/init-nix-env.sh

# 应用配置
home-manager switch --flake .#dashu@laptop
```

### 日常更新

```bash
# 更新 flake 依赖
nix flake update

# 应用新配置
home-manager switch --flake .#dashu@laptop

# 查看历史
home-manager generations

# 回滚
home-manager switch --gen <N>
```

### 垃圾收集

```bash
# 手动执行
bash home/scripts/nix-gc.sh

# 管理定时任务
bash home/scripts/setup-nix-gc.sh status
bash home/scripts/setup-nix-gc.sh install-systemd
```

### 故障排除

```bash
# 验证 flake
nix flake show

# 构建检查（不应用）
home-manager build --flake .#dashu@laptop

# 查看详细日志
home-manager switch --flake .#dashu@laptop -v

# 生成的配置目录
ls ~/.local/state/home-manager/
```

---

## ⚠️ 注意事项

### 系统级配置

以下配置**无法**通过 Nix 独立环境修改，需要通过系统的包管理器：

- ✗ 启动引导程序配置
- ✗ 内核参数
- ✗ 系统服务（NetworkManager、PipeWire 等）
- ✗ 用户账户管理
- ✗ PAM/sudo 配置
- ✗ firewall 规则

**解决方案**: 使用 ArchLinux/Debian 的包管理器配置这些项目

### 权限限制

- ✓ 可以：修改用户目录下的配置
- ✓ 可以：安装用户级包
- ✗ 不可以：修改 /etc 文件
- ✗ 不可以：启动系统服务
- ✗ 不可以：修改系统配置

### 窗口管理器启动

如果使用 Hyprland/Niri，需要手动配置启动方式：

```bash
# ~/.xinitrc 或 ~/.bashrc
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
exec Hyprland
```

或配置显示管理器（如 LightDM、SDDM）在系统级启动。

---

## 📚 参考资源

- [Nix 官方文档](https://nixos.org/manual/nix/)
- [home-manager 文档](https://nix-community.github.io/home-manager/)
- [nixpkgs 搜索](https://search.nixos.org/)
- [NUR (nix user repository)](https://github.com/nix-community/NUR)

---

## 🐛 问题排查

### 问题：flake.nix 评估失败

**原因**: 可能还有过时的 NixOS 模块引用

**解决**:
```bash
grep -r "nixosModules" home/
grep -r "systemPackages" home/dashu/default.nix
```

### 问题：home-manager switch 失败

**检查**:
```bash
# 构建配置
home-manager build --flake .#dashu@laptop

# 查看错误
cat result/home-environment.json | jq .
```

### 问题：某些工具/配置缺失

**原因**: 可能在 NixOS 配置中但未迁移到 home-manager

**解决**:
1. 查找原始配置位置
2. 在相应的 `home/dashu/` 文件中添加
3. 重新应用: `home-manager switch --flake .#dashu@laptop`

### 问题：脚本不可执行

```bash
chmod +x home/scripts/*.sh
bash home/scripts/init-nix-env.sh
```

---

## ✅ 迁移检查清单

- [ ] 创建新分支
- [ ] 复制 home-manager 配置到 `home/dashu`
- [ ] 更新 flake.nix（使用 homeConfigurations）
- [ ] 制作脚本可执行
- [ ] 运行初始化脚本
- [ ] 验证 flake 结构
- [ ] 构建配置
- [ ] 应用配置
- [ ] 验证所有工具/配置正常
- [ ] 提交变更

---

**迁移完成后，你可以安全删除**:
- ❌ `hosts/` 目录
- ❌ `modules/core/` 中的大部分文件（除了 system.nix）
- ❌ `modules/home/` 目录（已复制到 home/）
- ❌ `users/` 目录（已复制到 home/）
- ❌ `configuration.nix`
- ❌ `home/` 目录（备份后）

**最终结构应该只有**:
- ✓ `home/dashu/`, `home/patrickz/`, `home/scripts/`
- ✓ `modules/core/default.nix`, `system.nix`（简化版）
- ✓ `flake.nix`（新版本）
- ✓ `README.md`, `docs/`

祝迁移顺利！
