{ inputs, pkgs, ... }:
{
  

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      # xdg-desktop-portal-hyprland
      # xdg-desktop-portal-wlr
  ];
  };
}
