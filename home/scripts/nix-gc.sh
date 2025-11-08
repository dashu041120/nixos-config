#!/usr/bin/env bash
# POSIX-compatible Nix garbage collection script
# 替代 NixOS 的 nix.gc.automatic 选项

set -e

# 配置变量
DAYS_TO_KEEP=7
FORCE=false
DRY_RUN=false

# 解析命令行参数
while [ $# -gt 0 ]; do
    case "$1" in
        --days)
            DAYS_TO_KEEP="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            cat << EOF
用法: $(basename "$0") [选项]

选项:
    --days <N>      保留最近 N 天的构建结果（默认：7）
    --force         跳过确认提示
    --dry-run       显示将要删除的内容但不实际删除
    -h, --help      显示此帮助信息

示例:
    # 删除 7 天前的构建结果
    $(basename "$0")
    
    # 删除 30 天前的构建结果
    $(basename "$0") --days 30
    
    # 预览将要删除的内容
    $(basename "$0") --dry-run
EOF
            exit 0
            ;;
        *)
            echo "未知选项: $1" >&2
            exit 1
            ;;
    esac
done

# 检查是否安装了 nix
if ! command -v nix-collect-garbage >/dev/null 2>&1; then
    echo "错误: 未找到 nix-collect-garbage 命令" >&2
    echo "请确保已安装 Nix 包管理器" >&2
    exit 1
fi

# 计算要删除的文件信息
echo "Nix 垃圾收集工具"
echo "================"
echo ""
echo "检查垃圾收集信息..."

# 获取当前 store 大小
if command -v du >/dev/null 2>&1; then
    STORE_SIZE=$(du -sh ~/.cache/nix 2>/dev/null | cut -f1 || echo "未知")
    echo "当前 Nix store 缓存大小: $STORE_SIZE"
fi

echo ""
echo "准备删除 $DAYS_TO_KEEP 天前的构建结果..."
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "[预览模式] 将执行："
    echo "  nix-collect-garbage --delete-older-than ${DAYS_TO_KEEP}d"
    echo ""
    echo "[预览模式] 实际删除操作请运行："
    echo "  $(basename "$0") --force"
    exit 0
fi

if [ "$FORCE" = false ]; then
    echo "警告: 这将删除所有 $DAYS_TO_KEEP 天前的旧构建结果"
    echo ""
    read -p "是否继续? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        exit 0
    fi
fi

echo "执行垃圾收集..."
nix-collect-garbage --delete-older-than "${DAYS_TO_KEEP}d"

echo ""
echo "垃圾收集完成！"

# 优化 store 链接
echo ""
echo "优化 Nix store..."
if command -v nix >/dev/null 2>&1; then
    nix store optimize
    echo "store 优化完成"
else
    echo "（跳过 store 优化，需要较新的 nix 版本）"
fi

echo ""
echo "✓ 操作完成"
