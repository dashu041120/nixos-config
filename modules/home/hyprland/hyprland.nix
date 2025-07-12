{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    swww
    # inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    
    wl-clip-persist
    cliphist
    glib
    wayland
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
# gammastep/wallpaper-switcher need this to be enabled.
    systemd.variables = ["--all"];
    
    # 引用外部配置文件来避免警告
    extraConfig = ''
      # Configuration is managed through files in ~/.config/hypr/
      # This extraConfig is here to satisfy the Home Manager requirement
      # The actual configuration is copied from ./configs/ directory
    '';
  };
}
