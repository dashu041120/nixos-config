#!/usr/bin/env bash
# 快速启动脚本 - 一键初始化迁移配置

set -e

print_header() { echo -e "\n\033[1;34m>>> $1\033[0m\n"; }
print_success() { echo -e "\033[0;32m✓ $1\033[0m"; }
print_error() { echo -e "\033[0;31m✗ $1\033[0m" >&2; }
print_info() { echo -e "\033[0;36mℹ $1\033[0m"; }

print_header "NixOS → 独立 Nix 迁移快速启动"

# 检查前提条件
print_header "1️⃣  检查前提条件"

if ! command -v nix >/dev/null 2>&1; then
    print_error "未找到 Nix，请先安装 Nix："
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
fi
print_success "Nix 已安装"

if ! command -v home-manager >/dev/null 2>&1; then
    print_info "home-manager 未在 PATH 中，将通过 nix run 调用"
fi

if [ ! -f flake.nix ]; then
    print_error "当前目录不是有效的 Nix Flake 项目"
    exit 1
fi
print_success "Flake 项目已验证"

# 验证分支
print_header "2️⃣  验证工作分支"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "migrate-to-nix-standalone" ]; then
    print_info "当前分支: $CURRENT_BRANCH"
    read -p "是否切换到 migrate-to-nix-standalone 分支? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout migrate-to-nix-standalone || {
            print_error "无法切换分支"
            exit 1
        }
        print_success "已切换分支"
    fi
fi

# 初始化环境
print_header "3️⃣  初始化 Nix 环境"

if [ ! -x "home/scripts/init-nix-env.sh" ]; then
    print_info "使脚本可执行..."
    chmod +x home/scripts/*.sh
fi

print_info "运行 init-nix-env.sh..."
bash home/scripts/init-nix-env.sh

# 验证配置
print_header "4️⃣  验证配置"

print_info "检查 flake 配置..."
if nix flake show >/dev/null 2>&1; then
    print_success "Flake 配置有效"
else
    print_error "Flake 配置有问题，请检查"
fi

# 提示下一步
print_header "5️⃣  下一步操作"

echo "✅ 快速启动完成！"
echo ""
echo "📝 建议的下一步："
echo "   1. 查看文档:"
echo "      - START_HERE.md - 快速了解"
echo "      - home/scripts/README.md - 脚本使用"
echo "      - MIGRATION_FINAL_SUMMARY.md - 完整总结"
echo ""
echo "   2. 构建配置（检查错误）:"
echo "      nix build .#homeConfigurations.dashu@laptop.activationPackage"
echo ""
echo "   3. 应用配置:"
echo "      nix run home-manager -- switch --flake .#dashu@laptop"
echo ""
echo "   4. 设置 GPU 启动条目（可选）:"
echo "      sudo bash home/scripts/gpu-boot-entry.sh install"
echo ""
echo "🔗 相关资源:"
echo "   - 迁移分支: git checkout migrate-to-nix-standalone"
echo "   - 查看提交: git log --oneline migrate-to-nix-standalone"
echo "   - 提示: 定期使用 'nix flake update' 更新依赖"
echo ""

print_success "祝您使用愉快！"
