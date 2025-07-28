{ programs, pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Pro Audio
    jamesdsp
  ];

}