#!/usr/bin/env bash
# Nix 环境初始化脚本
# 替代 NixOS 系统级配置的初始化步骤

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1" >&2
}

# 检查 Nix 安装
check_nix_installation() {
    print_status "检查 Nix 安装..."
    
    if ! command -v nix >/dev/null 2>&1; then
        print_error "未找到 Nix 包管理器"
        print_status "请先安装 Nix: https://nixos.org/download.html"
        return 1
    fi
    
    print_success "Nix 已安装"
    nix --version
}

# 检查 home-manager 安装
check_home_manager() {
    print_status "检查 home-manager 安装..."
    
    if ! command -v home-manager >/dev/null 2>&1; then
        print_warning "未找到 home-manager"
        print_status "尝试通过 nix 启动..."
        
        # 尝试通过 nix run 使用 home-manager
        if nix run home-manager -- --version >/dev/null 2>&1; then
            print_success "home-manager 可通过 nix 访问"
            HM_CMD="nix run home-manager --"
        else
            print_error "无法找到 home-manager"
            print_status "请安装: nix-shell -p home-manager"
            return 1
        fi
    else
        print_success "home-manager 已安装"
        HM_CMD="home-manager"
    fi
    
    $HM_CMD --version
}

# 设置 Nix 替代品源
setup_nix_substituters() {
    print_status "配置 Nix 替代品源..."
    
    mkdir -p ~/.config/nix
    
    # 检查是否已有配置
    if [ -f ~/.config/nix/nix.conf ]; then
        print_warning "~/.config/nix/nix.conf 已存在，跳过"
        return 0
    fi
    
    # 创建配置文件
    cat > ~/.config/nix/nix.conf << 'EOF'
# Nix 配置文件
experimental-features = nix-command flakes

# 替代品源（二进制缓存）
substituters = https://cache.nixos.org https://nix-community.cachix.org https://hyprland.cachix.org https://nix-gaming.cachix.org https://mirrors.ustc.edu.cn/nix-channels/store

# 信任的公钥
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypG7a+qvXL0QKRK7QDeB3+TEZc= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=

# 自动垃圾收集（可选）
# auto-optimise-store = true
EOF
    
    print_success "Nix 替代品源已配置"
}

# 设置垃圾收集任务
setup_garbage_collection() {
    print_status "设置垃圾收集任务..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SETUP_GC="$SCRIPT_DIR/setup-nix-gc.sh"
    
    if [ -f "$SETUP_GC" ]; then
        read -p "使用 systemd 定时器还是 cron? (systemd/cron) [systemd]: " choice
        choice=${choice:-systemd}
        
        case "$choice" in
            systemd)
                bash "$SETUP_GC" install-systemd
                ;;
            cron)
                bash "$SETUP_GC" install-cron
                ;;
            *)
                print_warning "跳过垃圾收集设置"
                ;;
        esac
    else
        print_warning "未找到垃圾收集设置脚本"
    fi
}

# 验证配置
verify_flake() {
    print_status "验证 flake 配置..."
    
    if [ -f "flake.nix" ]; then
        if nix flake show >/dev/null 2>&1; then
            print_success "flake 配置有效"
        else
            print_error "flake 配置有效性验证失败"
            return 1
        fi
    else
        print_warning "未找到 flake.nix"
    fi
}

# 显示后续步骤
show_next_steps() {
    cat << EOF

${GREEN}=== 初始化完成 ===${NC}

后续步骤:

1. ${BLUE}构建配置${NC}（不应用）:
   home-manager build --flake .#dashu@laptop

2. ${BLUE}应用配置${NC}:
   home-manager switch --flake .#dashu@laptop

3. ${BLUE}定期更新${NC}:
   nix flake update
   home-manager switch --flake .#dashu@laptop

4. ${BLUE}垃圾收集${NC}（手动）:
   ~/.config/nix-gc/nix-gc.sh

或通过以下命令查看所有选项:
   ~/.config/nix-gc/setup-nix-gc.sh status

${YELLOW}提示:${NC}
- 所有 home-manager 配置存储在 ~/.local/state/home-manager/
- 可以通过 'home-manager generations' 查看历史版本
- 回滚: home-manager switch --gen <generation-number>

EOF
}

# 主函数
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════╗"
    echo "║     Nix 环境初始化脚本 (非 NixOS)          ║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # 执行检查
    check_nix_installation || exit 1
    echo ""
    
    check_home_manager || exit 1
    echo ""
    
    setup_nix_substituters
    echo ""
    
    read -p "是否设置自动垃圾收集? (y/n) [y]: " setup_gc
    setup_gc=${setup_gc:-y}
    if [ "$setup_gc" = "y" ]; then
        setup_garbage_collection
        echo ""
    fi
    
    verify_flake
    echo ""
    
    show_next_steps
}

# 运行主函数
main "$@"
