{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./rofi
    ./fonts.nix
    ./variables.nix
    ./config.nix
    ./waybar
  ];
} 
