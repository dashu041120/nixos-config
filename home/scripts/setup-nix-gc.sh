#!/usr/bin/env bash
# 为 Nix 配置创建定期垃圾回收任务
# 替代 NixOS 的 nix.gc.automatic 功能
# 支持 systemd 用户定时器和 cron

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GC_SCRIPT="$SCRIPT_DIR/nix-gc.sh"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
SYSTEMD_USER_DIR="$CONFIG_HOME/systemd/user"

# 检查 nix-gc.sh 是否存在
if [ ! -f "$GC_SCRIPT" ]; then
    echo "错误: 未找到 $GC_SCRIPT" >&2
    exit 1
fi

# 使脚本可执行
chmod +x "$GC_SCRIPT"

usage() {
    cat << EOF
用法: $(basename "$0") [命令]

命令:
    install-systemd    安装 systemd 用户定时器（推荐）
    install-cron       安装 cron 任务
    uninstall-systemd  卸载 systemd 定时器
    uninstall-cron     卸载 cron 任务
    status             显示当前状态
    -h, --help         显示此帮助信息

注意:
    - systemd 定时器是首选方案（更现代、更可靠）
    - cron 是备选方案（需要 cron 服务运行）
    
示例:
    # 使用 systemd 定时器（每周运行一次垃圾收集）
    $(basename "$0") install-systemd
    
    # 检查状态
    $(basename "$0") status
    
    # 卸载
    $(basename "$0") uninstall-systemd
EOF
}

install_systemd() {
    echo "安装 systemd 用户定时器..."
    
    # 创建目录
    mkdir -p "$SYSTEMD_USER_DIR"
    
    # 创建服务文件
    cat > "$SYSTEMD_USER_DIR/nix-gc.service" << 'EOF'
[Unit]
Description=Nix Garbage Collection
After=network.target

[Service]
Type=oneshot
ExecStart=%h/.config/nix-gc/nix-gc.sh --force
StandardOutput=journal
StandardError=journal
EOF

    # 创建定时器文件
    cat > "$SYSTEMD_USER_DIR/nix-gc.timer" << 'EOF'
[Unit]
Description=Weekly Nix Garbage Collection
Requires=nix-gc.service

[Timer]
# 每周日 02:00 运行
OnCalendar=Sun *-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    # 复制脚本到配置目录
    mkdir -p "$CONFIG_HOME/nix-gc"
    cp "$GC_SCRIPT" "$CONFIG_HOME/nix-gc/"
    chmod +x "$CONFIG_HOME/nix-gc/nix-gc.sh"
    
    # 重新加载并启用定时器
    systemctl --user daemon-reload
    systemctl --user enable nix-gc.timer
    systemctl --user start nix-gc.timer
    
    echo "✓ systemd 定时器已安装"
    echo ""
    echo "使用以下命令管理："
    echo "  systemctl --user status nix-gc.timer     # 查看状态"
    echo "  systemctl --user start nix-gc.timer      # 启动"
    echo "  systemctl --user stop nix-gc.timer       # 停止"
    echo "  journalctl --user -u nix-gc -f          # 查看日志"
}

install_cron() {
    echo "安装 cron 任务..."
    
    # 检查 cron 是否可用
    if ! command -v crontab >/dev/null 2>&1; then
        echo "错误: 未找到 crontab 命令" >&2
        exit 1
    fi
    
    # 获取当前 crontab（如果存在）
    current_cron=$(crontab -l 2>/dev/null || echo "")
    
    # 检查是否已存在
    if echo "$current_cron" | grep -q "nix-gc.sh"; then
        echo "⚠ Nix 垃圾收集任务已存在于 crontab 中"
        return 0
    fi
    
    # 添加新任务
    # 每周日 02:00 运行
    new_task="0 2 * * 0 $GC_SCRIPT --force"
    
    if [ -z "$current_cron" ]; then
        echo "$new_task" | crontab -
    else
        echo "$current_cron" | {
            cat
            echo "$new_task"
        } | crontab -
    fi
    
    echo "✓ cron 任务已安装"
    echo ""
    echo "任务详情: 每周日 02:00 运行垃圾收集"
    echo ""
    echo "查看 crontab:"
    crontab -l
}

uninstall_systemd() {
    echo "卸载 systemd 定时器..."
    
    systemctl --user disable nix-gc.timer
    systemctl --user stop nix-gc.timer
    rm -f "$SYSTEMD_USER_DIR/nix-gc.timer" "$SYSTEMD_USER_DIR/nix-gc.service"
    systemctl --user daemon-reload
    
    echo "✓ systemd 定时器已卸载"
}

uninstall_cron() {
    echo "卸载 cron 任务..."
    
    if ! command -v crontab >/dev/null 2>&1; then
        echo "错误: 未找到 crontab 命令" >&2
        exit 1
    fi
    
    current_cron=$(crontab -l 2>/dev/null || echo "")
    
    if echo "$current_cron" | grep -q "nix-gc.sh"; then
        echo "$current_cron" | grep -v "nix-gc.sh" | crontab -
        echo "✓ cron 任务已卸载"
    else
        echo "⚠ 未找到 Nix 垃圾收集任务"
    fi
}

show_status() {
    echo "Nix 垃圾收集任务状态"
    echo "===================="
    echo ""
    
    # 检查 systemd
    if systemctl --user list-timers nix-gc.timer >/dev/null 2>&1; then
        echo "✓ systemd 定时器已安装"
        echo ""
        systemctl --user status nix-gc.timer --no-pager
        echo ""
    else
        echo "✗ systemd 定时器未安装"
    fi
    
    # 检查 cron
    echo ""
    if command -v crontab >/dev/null 2>&1; then
        if crontab -l 2>/dev/null | grep -q "nix-gc.sh"; then
            echo "✓ cron 任务已安装"
            echo ""
            crontab -l | grep "nix-gc.sh"
        else
            echo "✗ cron 任务未安装"
        fi
    fi
}

# 主程序
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

case "$1" in
    install-systemd)
        install_systemd
        ;;
    install-cron)
        install_cron
        ;;
    uninstall-systemd)
        uninstall_systemd
        ;;
    uninstall-cron)
        uninstall_cron
        ;;
    status)
        show_status
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "未知命令: $1" >&2
        usage
        exit 1
        ;;
esac
