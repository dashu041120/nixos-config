{ inputs, pkgs, ... }:
{
# CPU 微码 (Microcode) 配置
  # NixOS 会自动侦测您的 CPU 类型，并加载正确的微码更新
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

# 驱动与固件
  # 强烈推荐，为许多无线网卡、蓝牙和GPU提供必要的固件
  hardware.enableRedistributableFirmware = true;

# graphics  
  hardware = {
    graphics = {
      enable = true;
      package = pkgs.mesa;
      extraPackages = with pkgs; [
        intel-media-driver # Intel 新一代硬解驱动 (VA-API)
        # Intel 新一代硬解驱动 (VA-API)
        (vaapiIntel.override { enableHybridCodec = true; }) 
        
        #AMD
        amdvlk # AMD 官方开源 Vulkan 驱动 (与 Mesa RADV 互补)

        # generic
        vaapiVdpau # VDPAU 到 VA-API 的转译层
        libvdpau-va-gl # 另一个 VDPAU 到 VA-API 的转译层
      ];
    };
  };

}
