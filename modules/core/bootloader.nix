{ config, pkgs, ... }:
{
    boot.loader.grub = {
    # 启用 GRUB
    enable = true;

    # (UEFI 系统推荐) 允许 GRUB 修改 EFI 变量
    efiSupport = true;
    
    # **极重要**: 指定要安装 GRUB 的硬盘。请用 `lsblk` 命令确认您的硬盘设备名！
    # 如果是 SATA/SAS/USB 硬盘，通常是 /dev/sda, /dev/sdb 等
    # 如果是 NVMe SSD，通常是 /dev/nvme0n1, /dev/nvme1n1 等
    device = "/dev/nvme0n1p4/"; # <--- 请务必替换成您的硬盘设备名

    # (可选) 如果您有 Windows 等其他操作系统，启用此项来自动侦测它们
    useOSProber = true;
};
    # 如果您的系统是 UEFI 模式，请务必禁用 systemd-boot 以免冲突
    # 如果为虚拟机，请override
    boot.loader.systemd-boot.enable = false;
    # (UEFI 系统推荐) 确保 efi 变量可被写入
    boot.loader.efi.canTouchEfiVariables = true;
}