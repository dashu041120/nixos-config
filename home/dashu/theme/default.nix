{ config, pkgs, ... }:

{
  imports = [
    ./catppuccin.nix
    ./gtk.nix
    ./qt.nix
  ];
}
