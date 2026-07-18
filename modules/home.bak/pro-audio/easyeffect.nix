{ programs, pkgs, lib, ... }:
{
    home.packages = with pkgs; [
        ## Pro Audio
        easyeffects
    ];
    
}