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

  programs.adb.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ 
      thunar-archive-plugin 
      thunar-volman 
      thunar-media-tags-plugin 
      thunar-vcs-plugin 
    ];
  };

  # programs.hyprland = {
  #   enable = false;
  #   withUWSM = true;
  #   xwayland.enable = true;
  # };
  programs.niri.enable = true;
  # Optional, hint electron apps to use wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
