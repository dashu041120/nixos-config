{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpolkitagent
    mako
    rofi-wayland
    swaybg
    swayidle
    swaylock
    wlroots
    waybar
    foot
    grim
    slurp
    
    hyprpicker
    
    xfce.thunar
    xfce.thunar-volman
    geany
    mpd
    mpc
    viewnior
    imagemagick
    xwayland
    # xdg-desktop-portal-wlr
    playerctl
    pastel
    pywal
    alacritty
    pulsemixer
    hyprlock
    
    
    nwg-dock-hyprland
  ];
}