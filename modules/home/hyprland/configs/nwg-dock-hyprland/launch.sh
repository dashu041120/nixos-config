#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\
#


config="$HOME/.config/gtk-3.0/settings.ini"
if [ ! -f $HOME/.config/ml4w/settings/dock-disabled ]; then
    killall nwg-dock-hyprland
    sleep 0.5
    prefer_dark_theme="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//')"
    if [ $prefer_dark_theme == 0 ]; then
        style="style-light.css"
    else
        style="style-dark.css"
    fi
    nwg-dock-hyprland -i 32 -w 5 -mb 10 -ml 10 -mr 10 -d -l overlay -s $style -c "/home/dashu/hypr-config/scripts/rofi_launcher"
else
    echo ":: Dock disabled"
fi

# 配置说明：
# -d: 自动隐藏模式（鼠标离开就隐藏）
# -x: 独占空间模式（其他窗口避开dock区域）
# -l overlay: 覆盖层模式（dock始终显示在最上层，但不强制隐藏）