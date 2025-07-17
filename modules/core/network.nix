{ config, pkgs, ... } : {
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
  
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

}