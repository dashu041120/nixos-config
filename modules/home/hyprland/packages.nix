{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty
    hyprpolkitagent
    mako
    rofi-wayland
    swaybg
    swayidle
    swaylock
    wlroots
    wl-clipboard
    waybar
    foot
    grim
    slurp
    wf-recorder
    hyprpicker
    
    light
    yad
    xfce.thunar
    xfce.thunar-volman
    geany
    mpv
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
    
    pavucontrol
    power-profiles-daemon
    nwg-dock-hyprland
  ];
}