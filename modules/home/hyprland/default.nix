{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./rofi.nix
    ./fonts.nix
    ./variables.nix
    ./config.nix
    ./waybar
  ];
}
