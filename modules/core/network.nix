{ config, pkgs, ... } : {
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [ 
    networkmanagerapplet 
    # flclash
    clash-nyanpasu
    # hiddify-app
  ];

  programs.clash-verge = {
    enable = true;
    # package = pkgs.clash-verge-rev;
    tunMode = true;
    serviceMode = true;
  };

  systemd.services.clash-verge = {
    enable = true;
    description = "Clash Verge Service Mode";
    serviceConfig = {
      ExecStart = "${config.programs.clash-verge.package}/bin/clash-verge-service";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };
# https://47.238.198.94/iv/verify_mode.htm?token=83d524d1ef0bd64d11d4d7236739d117

  # services.mihomo = {
  #   enable = true;
  #   package = pkgs.mihomo;
  #   tunMode = true;
  #   webui = pkgs.metacubexd;
  #   configFile = "/home/dashu/config.yaml";
  # };
}