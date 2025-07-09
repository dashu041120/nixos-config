{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    swww
    # inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
    ghostty
    hyprpolkitagent
    mako
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
    systemd.variables = ["--all"];
  };
}
