#!/usr/bin/env bash

# Ghostty 优化启动脚本
# 确保使用正确的GPU和环境变量，修复无响应问题

# 设置 GPU 相关环境变量
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# 优化终端性能
export TERM=xterm-256color
export COLORTERM=truecolor

# 禁用一些可能导致问题的功能
export WLR_NO_HARDWARE_CURSORS=1

# GTK 优化设置，修复警告和无响应问题
export GDK_BACKEND=wayland,x11
export GDK_SCALE=1
export GDK_DPI_SCALE=1

# 禁用可能导致问题的 GDK 调试设置
unset GDK_DEBUG
export GDK_DISABLE=vulkan

# 优化鼠标和触摸
export GTK_USE_PORTAL=0

# 修复 Wayland 下 GTK 应用的无响应问题
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}

# 禁用 GTK 的一些可能导致问题的功能
export GTK_IM_MODULE=
export XMODIFIERS=
export QT_IM_MODULE=fcitx5

# 确保正确的会话类型
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland

# 禁用一些可能导致冲突的环境变量
unset DISPLAY

# 启动 ghostty 并确保它在前台运行
exec ghostty "$@"
