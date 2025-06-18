{ config, pkgs, ... } : {
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
  
}