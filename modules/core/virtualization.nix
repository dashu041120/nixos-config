{ pkgs, username, ... }:
{
  # Add user to libvirtd group
  users.users.${username}.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme

    podman-desktop
    distrobox
    crun
    runc
  ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # Distrobox 需要一个容器后端，我们选择 Podman。
  # enable = true 会自动安装 Podman 并配置好 storage 和 socket。
  virtualisation.podman = {
    enable = true;
    enableNvidia = true; # 如果需要使用 NVIDIA GPU
    dockerCompat = true; # 启用 Docker 兼容性
    # networkSocket.enable = true; # 启用网络套接字
    dockerSocket.enable = true; # 启用 Docker 套接字
    # storage = {
    #   size = "20GiB"; # 设置 Podman 存储大小
    #   driver = "overlay"; # 使用 overlay 驱动
    # };
  };



}
