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
      enable32Bit = true;
      package32 = pkgs.pkgsi686Linux.mesa;
      extraPackages = with pkgs; [ 
        intel-media-driver # Intel 新一代硬解驱动 (VA-API)
        # Intel 新一代硬解驱动 (VA-API)
        (intel-vaapi-driver.override { enableHybridCodec = true; }) 
        
        #AMD


        # generic
        libva-vdpau-driver # VDPAU 到 VA-API 的转译层
        libvdpau-va-gl # 另一个 VDPAU 到 VA-API 的转译层
      ];
    };
  };

  hardware.xone.enable = true;

}
