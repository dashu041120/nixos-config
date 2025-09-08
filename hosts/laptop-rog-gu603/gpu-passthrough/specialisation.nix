# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# https://github.com/LostAttractor/flake/blob/5ff52c63a129f6e3c13f272eedaf0571ff74a5ae/specific/hardware-specific/asus-zephyrus-ga401/modules/features/gpu-paththrough/specialisation.nix
# https://lostattractor.net/archives/nixos-gpu-vfio-passthrough

let
# lspci -nn | grep NVIDIA
  gpuIDs = [
    "10de:28e0" # Graphics
    "10de:22be" # Audio
  ];
in
{ lib, ... }:
{
  specialisation."GPUPassthrough".configuration = {
    system.nixos.tags = [ "Nvidia-GPU-VFIO" ];

    # The vfio modules before the nvidia modules is very intentional because it lets vfio claim my GPU before nvidia does.
    boot.initrd.kernelModules = [
      # vifo
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      # Built into kernel at linux 6.2
      # "vfio_virqfd"
    #   没在initrd中就加载nvidia的内核模块，你不需要指定这些模块在vfio后加载，否则请取消这里的注释
      # If you load nvidia driver in initrd, you need specific vfio load before nvidia driver
      # "nvidia"
      # "nvidia_modeset"
      # "nvidia_uvm"
      # "nvidia_drm"
    ];
    boot.kernelParams = [
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs) # vfio devices
    ];
  };
}