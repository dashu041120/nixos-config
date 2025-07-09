{ config, pkgs, ... }:

let
  waybarSettings = import ./settings.nix;
  waybarStyle = builtins.readFile ./style.css;
in
{
  programs.waybar = {
    enable = true;
    settings = waybarSettings;
    style = waybarStyle;
  };

  # Copy spotify script to the appropriate location
  home.file.".config/hypr/waybar/spotify" = {
    source = ./spotify.sh;
    executable = true;
  };
}

# xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
# xdg.configFile."waybar/style.css".source = ./waybar/style.css;