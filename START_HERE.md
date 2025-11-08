# 📖 快速开始指南

> **重要**: 本项目的完整文档已合并为单一文件：**[MIGRATION_GUIDE_COMPLETE.md](MIGRATION_GUIDE_COMPLETE.md)**

所有信息（安装步骤、脚本使用、GPU 配置、故障排查等）都在该文件中。

## 🎯 3 分钟快速上手

```bash
# 1. 切换分支
git checkout nix-only

# 2. 一键初始化（推荐）
bash QUICK_START.sh

# 或手动步骤
bash home/scripts/init-nix-env.sh
home-manager switch --flake .#dashu@laptop
```

## 📖 查看完整文档

### 主文档
- **[MIGRATION_GUIDE_COMPLETE.md](MIGRATION_GUIDE_COMPLETE.md)** ⭐ - 完整统一指南（所有内容在这里）

### 脚本文档
- **[home/scripts/README.md](home/scripts/README.md)** - 脚本详细文档
- **[home/docs/GPU_BOOT_ENTRIES.md](home/docs/GPU_BOOT_ENTRIES.md)** - GPU 深度技术指南

## 🚀 常用命令

```bash
# 应用配置
home-manager switch --flake .#dashu@laptop

# 查看配置
nix flake show

# 更新依赖
nix flake update

# 清理磁盘
bash home/scripts/nix-gc.sh

# GPU 启动条目（可选）
sudo bash home/scripts/gpu-boot-entry.sh install
```

## 📁 项目结构

```
home/
├── dashu/          - 你的完整配置
├── scripts/        - 替代 NixOS 的脚本
└── docs/           - 技术文档
```

**现在请查看 [MIGRATION_GUIDE_COMPLETE.md](MIGRATION_GUIDE_COMPLETE.md) 获取完整信息！**
