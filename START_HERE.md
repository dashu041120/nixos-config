# 📖 迁移后的快速指南

> 你的 Nix 配置已从 NixOS 成功迁移到独立环境！

## 🎯 你现在可以做什么

### ✅ 在任何 Linux 发行版上使用

在以下系统上使用相同配置：

- ✅ **ArchLinux** - 使用 Nix 包管理器
- ✅ **Debian/Ubuntu** - 使用 Nix 包管理器  
- ✅ **其他 Linux** - 任何支持 Nix 的发行版
- ✅ **macOS** - 使用 Nix（可选）

### ✅ 继续使用 Nix Flakes

```bash
# 更新所有依赖
nix flake update

# 显示所有可用配置
nix flake show

# 验证 flake 有效性
nix flake check
```

### ✅ 利用 home-manager 全部功能

```bash
# 应用配置
home-manager switch --flake .#dashu@laptop

# 查看历史版本
home-manager generations

# 回滚到上一版本
home-manager switch --gen <N>
```

---

## 📁 项目结构速览

```
home/
├── dashu/              ← 你的所有配置都在这里
│   ├── default.nix     ← 配置入口，所有模块 imports
│   ├── zsh.nix         ← Shell 配置
│   ├── vscode.nix      ← VSCode 配置
│   ├── fcitx5/         ← 输入法配置
│   ├── fonts/          ← 字体文件
│   ├── hyprland/       ← Hyprland 配置
│   └── ...
│
├── scripts/            ← 替代 NixOS 的脚本
│   ├── init-nix-env.sh
│   ├── nix-gc.sh
│   └── setup-nix-gc.sh
│
└── docs/               ← 文档
    └── MIGRATION_GUIDE.md
```

---

## 🚀 三个最常用的命令

### 1. 应用配置变更

```bash
home-manager switch --flake .#dashu@laptop
```

**何时使用**：修改任何 `home/dashu/` 配置文件后

### 2. 更新依赖

```bash
nix flake update
home-manager switch --flake .#dashu@laptop
```

**何时使用**：想要最新的包和依赖版本

### 3. 垃圾收集

```bash
bash home/scripts/nix-gc.sh --force
```

**何时使用**：想要释放磁盘空间，清理旧版本

---

## 🔧 脚本快速参考

### 初始化脚本（只需运行一次）

```bash
bash home/scripts/init-nix-env.sh
```

**功能**：检查安装、配置缓存源、设置垃圾收集

### 垃圾收集脚本

```bash
# 手动执行一次
bash home/scripts/nix-gc.sh

# 设置为每周自动运行
bash home/scripts/setup-nix-gc.sh install-systemd

# 查看定时任务状态
bash home/scripts/setup-nix-gc.sh status
```

### 脚本帮助

```bash
bash home/scripts/init-nix-env.sh --help
bash home/scripts/nix-gc.sh --help
bash home/scripts/setup-nix-gc.sh --help
```

---

## 📚 找不到某个功能？

### Q: 如何添加新的系统包？

在 `home/dashu/cli.nix` 或 `home/dashu/dev.nix` 等文件中添加：

```nix
home.packages = with pkgs; [
  neovim
  rust
  # 其他工具
];
```

然后应用：

```bash
home-manager switch --flake .#dashu@laptop
```

### Q: 如何启用 Hyprland 配置？

取消注释 `home/dashu/default.nix` 中的：

```nix
imports = [
  # ...
  ./hyprland  # ← 取消注释这一行
];
```

### Q: 如何配置新应用？

1. 在 `home/dashu/` 中创建 `newapp.nix`
2. 在 `home/dashu/default.nix` 的 imports 中添加它
3. 应用配置：`home-manager switch --flake .#dashu@laptop`

### Q: 旧的配置在哪里？

所有 NixOS 系统级配置已删除。如需参考，查看：

- 🔍 **备份分支**: `master` (原始配置)
- 📖 **文档**: `WHY_DELETE_MODULES_CORE.md`

---

## ⚡ 日常工作流

### 修改配置

```bash
# 编辑配置
nano home/dashu/zsh.nix

# 应用更改
home-manager switch --flake .#dashu@laptop

# 有问题？回滚
home-manager switch --gen <N>
```

### 安装新包

```bash
# 方法 1：通过 home-manager
# 编辑 home/dashu/cli.nix 或 dev.nix
# 添加包到 home.packages
# 应用：home-manager switch --flake .#dashu@laptop

# 方法 2：临时安装（会重启后消失）
nix-shell -p <package-name>
```

### 查看历史

```bash
# 列出所有版本
home-manager generations

# 回到上一个
home-manager switch --gen <N>

# 查看变更
nix diff-closures /path/to/old /path/to/new
```

---

## 🆘 遇到问题？

### 问题：flake 显示错误

**尝试**：
```bash
nix flake show
nix flake check
```

**查看**: `home/docs/MIGRATION_GUIDE.md` 的故障排除部分

### 问题：某个工具缺失

**查找**：该工具是否在这些文件中：
- `home/dashu/cli.nix` - CLI 工具
- `home/dashu/dev.nix` - 开发工具
- `home/dashu/gui.nix` - GUI 应用
- `home/dashu/gaming.nix` - 游戏工具

**添加**：如果不在，添加到相应文件的 `home.packages`

### 问题：权限错误

脚本不需要 `sudo`。如果需要 root 权限说明配置有问题。

**检查**：
```bash
grep -r "sudo" home/
```

---

## 📖 详细文档

| 需求 | 文档 |
|------|------|
| 如何使用脚本 | `home/scripts/README.md` |
| 详细迁移指南 | `home/docs/MIGRATION_GUIDE.md` |
| 快速参考 | `QUICK_REFERENCE.md` |
| 为什么删除某配置 | `WHY_DELETE_MODULES_CORE.md` |
| 迁移检查清单 | `MIGRATION_CHECKLIST.md` |

---

## 🎓 学到更多

- **Nix 官方**: https://nixos.org/
- **home-manager**: https://nix-community.github.io/home-manager/
- **搜索包**: https://search.nixos.org/
- **社区**: https://discourse.nixos.org/

---

## 🎉 你已准备好！

配置已完全迁移。现在：

1. ✅ 在 ArchLinux/Debian 上使用你的 Nix 配置
2. ✅ 继续享受声明式配置带来的好处
3. ✅ 随时回到 NixOS（使用同一套配置！）
4. ✅ 与团队分享你的配置

---

## 📝 当前环境

- **分支**: `migrate-to-nix-standalone`
- **状态**: ✅ 准备就绪
- **版本**: 1.0 (2025-11-08)

---

**祝你使用愉快！** 🎊

有问题？查看相关文档或运行脚本的帮助信息。
