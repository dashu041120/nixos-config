{ pkgs, username, ... }:
{
  

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
    virglrenderer
    # qemu_full
    # qemu_kvm
    virtualgl
    virglrenderer

    # podman-desktop
    distrobox
    crun
    runc
    gnome-boxes
    virtiofsd
    lazydocker
    # sakaya
    # Run native wine applications inside declarative systemd-nspawn containers. 
    # sakaya functions as a replacement for wine on the host. Works well with NixOS.
    bottles
  ];
  

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        # ovmf.enable = true;
        # # ovmf.packages = [ (pkgs.OVMFFull.override { csmSupport = false; }).fd ];
        # ovmf.packages = [ pkgs.OVMF.fd ];
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # Distrobox 需要一个容器后端，我们选择 Podman。
  # enable = true 会自动安装 Podman 并配置好 storage 和 socket。
  # virtualisation.podman = {
  #   enable = true;
  #   # enableNvidia = true; # 如果需要使用 NVIDIA GPU -- out date
  #   dockerCompat = true; # 启用 Docker 兼容性
  #   # networkSocket.enable = true; # 启用网络套接字
  #   dockerSocket.enable = true; # 启用 Docker 套接字
  #   # storage = {
  #   #   size = "20GiB"; # 设置 Podman 存储大小
  #   #   driver = "overlay"; # 使用 overlay 驱动
  #   # };
  # };
  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs; [ criu ];
    storageDriver = "btrfs";
    enableOnBoot = true;
    # storage = {
    #   size = "20GiB"; # 设置存储大小
    #   driver = "overlay"; # 使用 overlay 驱动
    # };
    rootless.enable = false; # 启用 rootless 模式
  };

  # Add user to libvirtd group
  users.users.${username}.extraGroups = [ "libvirtd" "docker" ];
  virtualisation.oci-containers.backend = "docker"; # 使用 Docker 作为容器后端
}
