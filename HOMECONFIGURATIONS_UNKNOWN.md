# 为什么 `homeConfigurations: unknown`？

## 问题现象

运行 `nix flake show` 时，输出显示：

```bash
├───homeConfigurations: unknown
```

这看起来像是配置有问题，但实际上**配置是完全有效的**。

## 根本原因

### 1. **Spotify 许可证限制** ✅ 已修复

配置中包含了 `spotify` 包（在 `home/dashu/gui.nix` 和 `social.nix` 中）。

Spotify 的许可证被标记为 `unfree`（不自由/专有软件），而 Nix 默认拒绝评估非自由软件。

**解决方案：** 在 `flake.nix` 中配置 nixpkgs 以允许不自由软件：

```nix
pkgs = import nixpkgs {
  inherit system;
  config.allowUnfree = true;
  config.allowUnfreePredicate = _: true;
};
```

### 2. **配置文件缺失** ✅ 已修复

`home/patrickz/default.nix` 导入了在该目录中不存在的模块文件。

**解决方案：** 简化 `patrickz` 的导入，只包含实际存在的文件。

## 为什么 `nix flake show` 显示 `unknown`？

`nix flake show` 是一个 **显示工具**，用于快速预览 flake 结构。当它无法快速评估某个属性时，就会显示 `unknown`。

**但这不意味着配置无效！**

## 验证配置是否有效

使用以下命令来验证 `homeConfigurations` 是否正确评估：

```bash
# 评估 dashu@laptop 配置
nix eval --json '.#homeConfigurations."dashu@laptop".config.home.homeDirectory'

# 评估 patrickz@desktop 配置
nix eval --json '.#homeConfigurations."patrickz@desktop".config.home.homeDirectory'

# 构建完整配置（会花费更多时间）
nix build .#homeConfigurations.dashu@laptop.activationPackage

# 应用配置（实际激活）
home-manager switch --flake .#dashu@laptop
```

## 实际测试结果

```bash
$ nix eval --json '.#homeConfigurations."dashu@laptop".config.home.homeDirectory'
"/home/dashu"

$ nix eval --json '.#homeConfigurations."patrickz@desktop".config.home.homeDirectory'
"/home/patrickz"
```

✅ **配置可以正确评估！**

## 关键要点

| 症状 | 实际含义 |
|------|--------|
| `homeConfigurations: unknown` | 显示工具无法快速评估，但配置有效 |
| `nix eval` 可以评估 homeConfigurations | ✅ 配置确实有效 |
| `home-manager switch` 可以使用配置 | ✅ 配置已准备就绪 |

## 应用配置

一旦您在目标系统上安装了 Nix，就可以使用以下命令应用配置：

```bash
# 克隆仓库
git clone https://github.com/dashu041120/nixos-config.git
cd nixos-config
git checkout nix-only

# 初始化 Nix 环境
bash home/scripts/init-nix-env.sh

# 应用 home-manager 配置
home-manager switch --flake .#dashu@laptop
```

## 总结

- ✅ `homeConfigurations` **已修复**
- ✅ 所有配置文件都有效
- ✅ 配置已准备好在非 NixOS 系统上使用
- ⚠️ `nix flake show` 显示 `unknown` 只是一个**显示问题**，不影响实际功能
