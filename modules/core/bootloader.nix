{ config, pkgs, ... }:
{
    # (UEFI 系统推荐) 确保 efi 变量可被写入
    boot.loader.efi.canTouchEfiVariables = true;
    
    boot.loader.grub = {
    # 启用 GRUB
    enable = true;

    # (UEFI 系统推荐) 允许 GRUB 修改 EFI 变量
    efiSupport = true; # 如果您的系统是 UEFI 模式，请设置为 true
    
    # **极重要**: 指定要安装 GRUB 的硬盘。请用 `lsblk` 命令确认您的硬盘设备名！
    # 如果是 SATA/SAS/USB 硬盘，通常是 /dev/sda, /dev/sdb 等
    # 如果是 NVMe SSD，通常是 /dev/nvme0n1, /dev/nvme1n1 等
    # UEFI模式下使用"nodev"而不是具体设备
    device = "nodev"; # <--- 请务必替换成您的硬盘设备名

    # (可选) 如果您有 Windows 等其他操作系统，启用此项来自动侦测它们
    useOSProber = true;

    # (可选) 设置 GRUB 菜单的默认启动项，通常是第一个操作系统
    #default = 0; # 0 表示第一个操作系统，1 表示第二个，以此类推 
    # (可选) 设置 GRUB 菜单的超时时间，单位为秒
    # timeout = 5; # 5 秒后自动启动默认操作系统
    # (可选) 设置 GRUB 菜单的主题，您可以选择其他主题或自定义主题
    # theme = "my-custom-theme"; # 请替换成您自己的主题名称
    # (可选) 设置 GRUB 菜单的分辨率，通常为 1024x768 或 1920x1080
    # resolution = "1024x768"; # 请替换成您自己的分辨率
    # (可选) 启用 GRUB 的图形模式，通常需要安装 `grub2-theme-graphical` 包
    # graphical = true; # 如果您希望使用图形模式，请取消注释此行
    # (可选) 启用 GRUB 的自动更新功能，自动检测系统更新并更新 GRUB 配置
    # autoUpdate = true; # 如果您希望启用自动更新功能，请取消注释此行
    # (可选) 启用 GRUB 的多语言支持，允许用户选择不同的语言
    # languages = [ "en_US.UTF-8" "zh_CN.UTF-8" ]; # 请替换成您希望支持的语言列表
    # (可选) 启用 GRUB 的高级功能，如 LUKS 加密支持、Btrfs 快照支持等
    # advancedFeatures = true; # 如果您希望启用高级功能，请取消注释此行
    };

    boot.loader.timeout = 5; # 设置 GRUB 菜单的超时时间，单位为秒
    
    # 如果您的系统是 UEFI 模式，请务必禁用 systemd-boot 以免冲突
    # 如果为虚拟机，请override
    boot.loader.systemd-boot.enable = false;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi"; # UEFI 系统的 EFI 分区挂载点
    
}