# Nix 环境脚本文档

这个目录包含替代 NixOS 系统级配置的 POSIX shell 脚本。

## 脚本清单

### 1. `init-nix-env.sh` - 环境初始化

**作用**: 初始化 Nix 环境，替代 NixOS 的系统启动配置

**替代的 NixOS 配置**:
- `modules/core/system.nix` - Nix 替代品源和实验特性配置
- `modules/core/security.nix` - 基础安全设置
- `modules/core/garbage_clean.nix` - 垃圾收集配置

**用法**:
```bash
chmod +x init-nix-env.sh
./init-nix-env.sh
```

**功能**:
- ✓ 检查 Nix 和 home-manager 安装
- ✓ 配置 Nix 替代品源和缓存
- ✓ 设置自动垃圾收集
- ✓ 验证 flake 配置
- ✓ 提供后续使用步骤

---

### 2. `setup-nix-gc.sh` - 垃圾收集任务管理

**作用**: 安装和管理定期垃圾收集任务

**替代的 NixOS 配置**:
- `modules/core/garbage_clean.nix` - nix.gc.automatic 选项

**用法**:

```bash
chmod +x setup-nix-gc.sh

# 使用 systemd 定时器（推荐）
./setup-nix-gc.sh install-systemd

# 或使用 cron
./setup-nix-gc.sh install-cron

# 查看状态
./setup-nix-gc.sh status

# 卸载
./setup-nix-gc.sh uninstall-systemd
```

**支持的方式**:
1. **systemd 定时器**（推荐）
   - 现代、可靠
   - 与 systemd 集成
   - 支持日志查看: `journalctl --user -u nix-gc -f`

2. **cron 任务**（备选）
   - 简单、轻量
   - 需要 cron 服务运行
   - 支持自定义时间表

---

### 3. `nix-gc.sh` - 垃圾收集执行脚本

**作用**: 执行 Nix 垃圾收集和 store 优化

**替代的 NixOS 配置**:
- `modules/core/garbage_clean.nix` - nix.gc 和 nix.optimise-store 选项

**用法**:

```bash
chmod +x nix-gc.sh

# 标准垃圾收集（删除 7 天前的构建）
./nix-gc.sh

# 指定保留天数
./nix-gc.sh --days 30

# 预览将要删除的内容
./nix-gc.sh --dry-run

# 跳过确认
./nix-gc.sh --force
```

**功能**:
- 删除旧的构建结果
- 优化 store 链接
- 支持预览模式
- 交互式确认

---

## 其他可替代的配置

### `modules/core/game.nix`

**建议**: 改为通过 home-manager 配置游戏工具

在 `home/dashu/gaming.nix` 中添加:
```nix
# 用户级游戏工具
home.packages = with pkgs; [
  lutris
  wine
  proton
  # 其他游戏工具
];
```

### `modules/core/programs.nix`

**建议**: 将系统级程序改为用户级

在相应的 `home/dashu/*.nix` 文件中配置:
```nix
programs.firefox.enable = true;
programs.git = { ... };
# 等等
```

### `modules/core/system.nix` 中的 `environment.systemPackages`

**改为**: 通过 home-manager 安装用户包

在 `home/dashu/default.nix`:
```nix
home.packages = with pkgs; [
  vim wget git gcc cmake curl
  htop btop yazi
  # 等等
];
```

---

## 快速开始指南

### 第一次使用

```bash
cd /path/to/nixos-config

# 1. 初始化环境
bash home/scripts/init-nix-env.sh

# 2. 验证配置
nix flake show

# 3. 构建配置（检查是否有错误）
home-manager build --flake .#dashu@laptop

# 4. 应用配置
home-manager switch --flake .#dashu@laptop
```

### 日常使用

```bash
# 更新依赖
nix flake update

# 应用最新配置
home-manager switch --flake .#dashu@laptop

# 查看配置历史
home-manager generations

# 回滚到上一个版本
home-manager switch --gen <generation-number>

# 手动垃圾收集
bash home/scripts/nix-gc.sh
```

---

## 配置说明

### ~/.config/nix/nix.conf

自动生成的 Nix 配置文件，包含:
- 实验特性（nix-command, flakes）
- 替代品源（缓存镜像）
- 信任的公钥

**手动编辑**:
```bash
nano ~/.config/nix/nix.conf
```

**常见选项**:
```nix
# 启用 flakes
experimental-features = nix-command flakes

# 添加替代品源
substituters = https://cache.nixos.org https://...

# 自动优化 store（消耗 CPU 但能节省磁盘）
auto-optimise-store = true

# 信任用户（允许用户安装未签名的包）
trusted-users = dashu
```

### systemd 定时器配置

**位置**: `~/.config/systemd/user/nix-gc.{service,timer}`

**编辑计划**:
```bash
systemctl --user edit nix-gc.timer
```

**常见时间设置**:
```ini
# 每天 02:00
OnCalendar=*-*-* 02:00:00

# 每周日 02:00
OnCalendar=Sun *-*-* 02:00:00

# 每月 1 号 02:00
OnCalendar=*-*-01 02:00:00

# 系统启动后 10 分钟
OnBootSec=10min
```

**重新加载**:
```bash
systemctl --user daemon-reload
systemctl --user restart nix-gc.timer
```

---

## 常见问题

### Q: 如何手动运行垃圾收集？

```bash
bash home/scripts/nix-gc.sh --force
```

### Q: 如何修改垃圾收集的计划？

```bash
# 使用 systemd 定时器
systemctl --user edit nix-gc.timer

# 或编辑 crontab
crontab -e
```

### Q: 垃圾收集会删除我正在使用的包吗？

不会。`nix-collect-garbage` 只删除无用的构建结果，不会删除当前活跃的包。

### Q: 如何查看垃圾收集日志？

```bash
# systemd 定时器
journalctl --user -u nix-gc -f

# cron
grep nix-gc /var/log/syslog  # Debian/Ubuntu
grep nix-gc /var/log/cron     # CentOS/RHEL
```

### Q: 脚本需要 sudo 权限吗？

不需要。所有脚本都作为普通用户运行，操作限于用户的 Nix store (~/.cache/nix)。

---

## 故障排除

### 脚本权限错误

```bash
chmod +x home/scripts/*.sh
```

### 找不到 nix 命令

检查 Nix 安装:
```bash
which nix
nix --version

# 如果未找到，可能需要 source 环境
source ~/.nix-profile/etc/profile.d/nix.sh
```

### 定时器未运行

```bash
# 检查定时器状态
systemctl --user status nix-gc.timer

# 启用定时器
systemctl --user enable nix-gc.timer
systemctl --user start nix-gc.timer

# 查看下次运行时间
systemctl --user list-timers
```

### home-manager 找不到

确保已安装:
```bash
nix-shell -p home-manager

# 或通过 flake
nix run home-manager -- --version
```

---

## 相关资源

- [Nix 官方文档](https://nixos.org/manual/nix/)
- [home-manager 文档](https://nix-community.github.io/home-manager/)
- [systemd 定时器文档](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)

---

## 贡献

如果你改进了这些脚本，请提交 PR！

---

**最后更新**: 2025-11-08
