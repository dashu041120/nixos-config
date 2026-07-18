{ pkgs, inputs, ... }:
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
  home.packages = with pkgs; [
    firefox
    google-chrome
  ];
}
