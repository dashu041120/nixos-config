#!/usr/bin/env bash

echo "=== Ghostty 性能测试与诊断脚本 ==="
echo "时间: $(date)"
echo

echo "1. 检查 GPU 信息..."
if command -v lspci &> /dev/null; then
    lspci | grep -E "(VGA|3D)"
else
    echo "lspci 不可用，检查 /dev/dri/ 设备："
    ls -la /dev/dri/
fi
echo

echo "2. 检查 OpenGL 信息..."
if command -v glxinfo &> /dev/null; then
    glxinfo | grep -E "(OpenGL renderer|OpenGL version|OpenGL vendor)"
else
    echo "glxinfo 不可用"
fi
echo

echo "3. 检查 Wayland/X11 环境..."
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
echo "DISPLAY: $DISPLAY"
echo "XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
echo

echo "4. 检查 GTK 相关环境变量..."
echo "GDK_BACKEND: $GDK_BACKEND"
echo "GDK_SCALE: $GDK_SCALE"
echo "GTK_USE_PORTAL: $GTK_USE_PORTAL"
echo

echo "5. 检查 NVIDIA 相关..."
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA GPU 状态:"
    nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu --format=csv,noheader
else
    echo "nvidia-smi 不可用"
fi
echo

echo "6. 测试 ghostty 启动性能..."
echo "使用优化脚本启动 ghostty..."

# 记录启动时间
start_time=$(date +%s.%N)

# 使用优化脚本启动 ghostty，并在 2 秒后关闭
timeout 3s /home/dashu/nixos-config/modules/home/hyprland/configs/scripts/ghostty-optimized.sh --version &

# 等待命令完成
wait

end_time=$(date +%s.%N)
duration=$(echo "$end_time - $start_time" | bc)

echo "启动测试完成，耗时: ${duration}s"
echo

echo "7. 推荐的使用方法:"
echo "   使用优化启动脚本: ~/nixos-config/modules/home/hyprland/configs/scripts/ghostty-optimized.sh"
echo "   或在 Hyprland 中按 SUPER+Return 启动"
