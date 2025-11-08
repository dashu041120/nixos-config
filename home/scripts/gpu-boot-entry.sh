#!/usr/bin/env bash
# GRUB GPU 启动条目管理脚本（完整版）
# 支持 ArchLinux 和 Debian
# 功能：创建两个 GRUB 菜单项用于切换 GPU 配置

set -e

GRUB_CUSTOM_FILE="/etc/grub.d/40_custom"
GRUB_MAIN_CONFIG="/etc/default/grub"
BOOT_DIR="/boot"
DISTRO=""

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[⚠]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1" >&2; }

# 检查 root 权限
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "此脚本需要 root 权限，请使用 sudo"
        exit 1
    fi
}

# 检测发行版
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch) DISTRO="arch" ;;
            debian|ubuntu) DISTRO="debian" ;;
            *) DISTRO="other" ;;
        esac
    fi
    
    [ -z "$DISTRO" ] && DISTRO="other"
    print_success "检测到发行版: $DISTRO"
}

# 检查 GRUB 安装
check_grub() {
    if ! command -v grub-mkconfig >/dev/null 2>&1; then
        print_error "未找到 GRUB，请先安装"
        exit 1
    fi
    print_success "GRUB 已安装"
}

# 备份 GRUB 配置
backup_config() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    [ -f "$GRUB_CUSTOM_FILE" ] && \
        cp "$GRUB_CUSTOM_FILE" "${GRUB_CUSTOM_FILE}.backup.${timestamp}" && \
        print_success "已备份自定义文件"
    
    cp "$GRUB_MAIN_CONFIG" "${GRUB_MAIN_CONFIG}.backup.${timestamp}"
    print_success "已备份主配置（${GRUB_MAIN_CONFIG}.backup.${timestamp}）"
}

# 初始化 GRUB 自定义文件
init_grub_custom() {
    if [ ! -f "$GRUB_CUSTOM_FILE" ]; then
        cat > "$GRUB_CUSTOM_FILE" << 'CUSTOM_EOF'
#!/bin/sh
exec tail -n +3 $0

# GRUB 自定义启动条目
# 在下方添加 menuentry 条目
CUSTOM_EOF
        chmod +x "$GRUB_CUSTOM_FILE"
        print_success "已初始化 GRUB 自定义文件"
    fi
}

# 检查条目是否存在
entry_exists() {
    grep -q "menuentry.*$1" "$GRUB_CUSTOM_FILE" 2>/dev/null
}

# 添加禁用 dGPU 条目
add_disable_dgpu_entry() {
    if entry_exists "Disable.*dGPU"; then
        print_warning "Disable dGPU 条目已存在"
        return 0
    fi
    
    print_status "添加 Disable dGPU 条目..."
    
    cat >> "$GRUB_CUSTOM_FILE" << 'ENTRY_EOF'

### 禁用 NVIDIA dGPU 条目
### 功能: 使用集成显卡 (iGPU)，禁用独立显卡 (dGPU)
### 用途: 延长笔记本续航时间
menuentry 'Linux - Disable NVIDIA dGPU (iGPU only)' --class gnu-linux --class os --users "" {
    insmod gzio
    insmod part_gpt
    insmod ext2
    set root='hd0,gpt2'
    
    echo '加载 dGPU 禁用配置...'
    echo '配置: 禁用 NVIDIA dGPU，仅使用集成显卡'
    echo '续航提升: 约 2-4 小时'
    
    linux /boot/vmlinuz-linux root=UUID=__ROOT_UUID__ rw \
        nouveau.modeset=0 \
        nvidia_drm.modeset=0 \
        nvidia.NVreg_DynamicPowerManagement=0 \
        intel_pmc_core.warn_on_alloc=1
    initrd /boot/initramfs-linux.img
}
ENTRY_EOF
    
    print_success "已添加 Disable dGPU 条目"
}

# 添加 GPU 直通条目
add_passthrough_entry() {
    if entry_exists "GPU.*Passthrough"; then
        print_warning "GPU Passthrough 条目已存在"
        return 0
    fi
    
    print_status "添加 GPU Passthrough 条目..."
    
    cat >> "$GRUB_CUSTOM_FILE" << 'ENTRY_EOF'

### GPU 直通条目
### 功能: 启用 IOMMU 和 GPU 直通支持
### 用途: 虚拟机 (QEMU/KVM) GPU 直通
menuentry 'Linux - GPU Passthrough (IOMMU Enabled)' --class gnu-linux --class os --users "" {
    insmod gzio
    insmod part_gpt
    insmod ext2
    set root='hd0,gpt2'
    
    echo '加载 GPU 直通配置...'
    echo '配置: 启用 IOMMU，GPU 直通支持'
    echo '用途: 虚拟机 GPU 直通 (QEMU/KVM)'
    
    linux /boot/vmlinuz-linux root=UUID=__ROOT_UUID__ rw \
        iommu=pt \
        intel_iommu=on \
        amd_iommu=on \
        vfio_iommu_type1.allow_unsafe_interrupts=1 \
        kvm.ignore_msrs=1 \
        kvm.report_ignored_msrs=0
    initrd /boot/initramfs-linux.img
}
ENTRY_EOF
    
    print_success "已添加 GPU Passthrough 条目"
}

# 提取根分区 UUID
get_root_uuid() {
    # 尝试从 /etc/fstab 获取
    grep -E "^\s*UUID=" /etc/fstab | grep "/" | head -1 | awk '{print $1}' | cut -d= -f2
}

# 修复 GRUB 条目中的 UUID
fix_uuid_in_entries() {
    local root_uuid=$(get_root_uuid)
    
    if [ -z "$root_uuid" ]; then
        print_warning "无法自动检测根分区 UUID，请手动编辑 $GRUB_CUSTOM_FILE"
        print_warning "查找 __ROOT_UUID__ 并替换为你的根分区 UUID"
        return 1
    fi
    
    print_status "使用根分区 UUID: $root_uuid"
    sed -i "s/__ROOT_UUID__/${root_uuid}/g" "$GRUB_CUSTOM_FILE"
    print_success "已更新 UUID"
}

# 重建 GRUB 配置
rebuild_grub() {
    print_status "重建 GRUB 配置..."
    grub-mkconfig -o /boot/grub/grub.cfg
    print_success "GRUB 已重建"
}

# 显示条目
show_entries() {
    print_status "当前 GRUB 自定义条目:"
    echo ""
    
    if [ -f "$GRUB_CUSTOM_FILE" ]; then
        awk '
            /^###/ {print; getline}
            /menuentry/ {
                match($0, /'\''([^'\'']+)'\''/, arr)
                printf "  %-50s\n", arr[1]
            }
        ' "$GRUB_CUSTOM_FILE"
    else
        print_warning "GRUB 自定义文件不存在"
    fi
    
    echo ""
}

# 显示详细信息
show_detailed_info() {
    print_status "GPU 启动条目详细信息:"
    echo ""
    echo "1️⃣  Disable NVIDIA dGPU (iGPU only)"
    echo "   功能: 禁用独立显卡，仅使用集成显卡"
    echo "   优势: 延长笔记本续航 2-4 小时"
    echo "   场景: 日常办公、文本编辑、轻量级任务"
    echo ""
    echo "2️⃣  GPU Passthrough (IOMMU Enabled)"
    echo "   功能: 启用 IOMMU 和 GPU 直通"
    echo "   优势: 虚拟机可访问 GPU，接近原生性能"
    echo "   场景: QEMU/KVM 虚拟机 GPU 直通、游戏虚拟机"
    echo ""
    echo "内核参数说明:"
    echo "  nouveau.modeset=0        - 禁用 Nouveau 显卡驱动"
    echo "  nvidia_drm.modeset=0     - 禁用 NVIDIA DRM 输出"
    echo "  iommu=pt                 - 启用 IOMMU 直通模式"
    echo "  intel_iommu=on           - 启用 Intel IOMMU"
    echo "  amd_iommu=on             - 启用 AMD IOMMU"
    echo "  vfio_iommu_type1.allow_unsafe_interrupts=1"
    echo "                           - 允许 IOMMU 直通"
    echo ""
}

# 删除条目
remove_entry() {
    local entry_name="$1"
    
    if [ -z "$entry_name" ]; then
        print_error "请指定要删除的条目名称"
        return 1
    fi
    
    if ! entry_exists "$entry_name"; then
        print_warning "条目不存在: $entry_name"
        return 0
    fi
    
    print_status "删除条目: $entry_name..."
    
    # 使用 awk 删除匹配的 menuentry 及其内容
    awk -v entry="$entry_name" '
        /menuentry.*'"${entry_name}"'/ {
            in_entry = 1
            next
        }
        in_entry && /^}$/ {
            in_entry = 0
            next
        }
        !in_entry {
            print
        }
    ' "$GRUB_CUSTOM_FILE" > "${GRUB_CUSTOM_FILE}.tmp"
    
    mv "${GRUB_CUSTOM_FILE}.tmp" "$GRUB_CUSTOM_FILE"
    print_success "条目已删除"
    rebuild_grub
}

# 验证条目
verify_entries() {
    print_status "验证 GRUB 条目..."
    
    if ! grep -q "menuentry" "$GRUB_CUSTOM_FILE" 2>/dev/null; then
        print_error "未找到有效的 menuentry"
        return 1
    fi
    
    # 检查语法
    if ! grub-mkconfig -o /tmp/grub_test.cfg 2>/dev/null; then
        print_error "GRUB 配置有语法错误"
        return 1
    fi
    
    print_success "GRUB 条目验证通过"
}

# 显示帮助
usage() {
    cat << EOF
用法: sudo $(basename "$0") [命令] [选项]

命令:
    install              安装 GPU 启动条目（默认）
    show                 显示启动条目列表
    details              显示详细信息
    verify               验证 GRUB 配置
    remove <name>        删除指定条目
    rebuild              重建 GRUB 配置
    restore              从备份恢复

选项:
    -h, --help          显示此帮助信息

示例:
    sudo $(basename "$0") install
    sudo $(basename "$0") show
    sudo $(basename "$0") details
    sudo $(basename "$0") remove "Disable NVIDIA dGPU"

安装后重启系统并在 GRUB 菜单中选择对应条目。

EOF
}

# 主函数
main() {
    check_root
    detect_distro
    check_grub
    
    local cmd="${1:-install}"
    
    case "$cmd" in
        install)
            print_status "开始安装 GPU 启动条目..."
            backup_config
            init_grub_custom
            add_disable_dgpu_entry
            add_passthrough_entry
            fix_uuid_in_entries
            verify_entries
            rebuild_grub
            print_success "安装完成！重启后在 GRUB 菜单中选择对应条目"
            show_entries
            ;;
        show)
            show_entries
            ;;
        details)
            show_detailed_info
            ;;
        verify)
            verify_entries
            ;;
        remove)
            remove_entry "$2"
            ;;
        rebuild)
            rebuild_grub
            ;;
        restore)
            if [ -f "${GRUB_MAIN_CONFIG}.backup" ]; then
                print_status "恢复配置..."
                cp "${GRUB_MAIN_CONFIG}.backup" "$GRUB_MAIN_CONFIG"
                rebuild_grub
                print_success "已从备份恢复"
            else
                print_error "未找到备份文件"
                exit 1
            fi
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            print_error "未知命令: $cmd"
            usage
            exit 1
            ;;
    esac
}

main "$@"
