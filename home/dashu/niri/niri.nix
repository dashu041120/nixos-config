{ pkgs, ... }: {
    # xdg.configFile."niri/config.kdl".source = ./config.kdl;
    home.packages = with pkgs; [
        # swaybg # wallpaper
        # swww
        # xwayland-satellite # xwayland support
        # vicinae
        nirius
        # pkgs.xdg-desktop-portal-gnome # for screenshot support
        # matugen
        soteria
        # stardust-xr-kiara # 360-degree app shell / DE for Stardust XR using Niri
    ];
    home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };
    # services.polkit-gnome.enable = true; # polkit
}

# 热键	功能
# Mod + Shift + /(?)	显示热键菜单
# Mod + A	打开 Vicinae (App 启动器)
# Mod + D	打开 Dolphin（文件管理器）
# Mod + X	打开 google-chrome-stable （浏览器，需安装）
# Mod + Enter	打开 ghostty（终端）
# Mod + F	将当前窗口全屏
# Mod + L	用 Hyprlock 锁屏
# Mod + 左右箭头	切换窗口左右焦点
# Mod + Shift + 左右箭头	将当前列和左右列互换位置
# Mod + PgUp / PgDn	上下切换工作区
# Mod + Ctrl + PgUp / PgDn	将当前列移动到上下工作区
# Mod + Tab	进入 Overview （缩小整个屏幕以显示工作区概览）
# PrtSc	截屏并复制到剪贴板以及保存到 ~
# Ctrl + PrtSc	截全屏，操作同上
# 三指滑动触摸板	切换窗口以及工作区
# 四指滑动触摸板	操作同 Mod + Tab