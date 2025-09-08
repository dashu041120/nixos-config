{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
  
    ./variables.nix
    ./config.nix
    ./packages.nix
    # Below are already set in configs directory
    # ./waybar
    # ./rofi
  ];
}
