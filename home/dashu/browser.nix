{ pkgs, ... }:
let
  zenFlake = builtins.getFlake "github:youwen5/zen-browser-flake";
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = [
    # zenFlake.packages.${system}.default
  ];
}
