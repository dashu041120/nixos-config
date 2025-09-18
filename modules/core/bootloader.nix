{ config, pkgs, ... }:
{
    # (UEFI 系统推荐) 确保 efi 变量可被写入
    boot.loader.efi.canTouchEfiVariables = true;
    
    boot.loader.grub = {
    # theme
      minegrub-theme = {
        enable = true;
        splash = "100% Flakes!";
        background = "background_options/1.8  - [Classic Minecraft].png";
        boot-options-count = 4;
      };
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
    };

    boot.loader.timeout = 5; # 设置 GRUB 菜单的超时时间，单位为秒
    
    # 如果您的系统是 UEFI 模式，请务必禁用 systemd-boot 以免冲突
    # 如果为虚拟机，请override
    boot.loader.systemd-boot.enable = false;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi"; # UEFI 系统的 EFI 分区挂载点

    boot.plymouth = {
      enable = true;
      theme = "rog";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rog" ];
        })
      ];
    };

    # Enable "Silent boot"
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
    boot.kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed

}