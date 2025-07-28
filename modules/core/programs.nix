{ pkgs, ... }:
{
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];
  
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ 
      thunar-archive-plugin 
      thunar-volman 
      thunar-media-tags-plugin 
      thunar-vcs-plugin 
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    #portalPackage =
    #  inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
