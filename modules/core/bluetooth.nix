{ config, pkgs, ... }:
{
    hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  #音频服务 (用于蓝牙音频)
  sound.enable = true;
  security.rtkit.enable = true;
}