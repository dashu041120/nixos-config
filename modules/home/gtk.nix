{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-emoji
    fantasque-sans-mono
    maple-mono.truetype-autohint
  ];
  # Configure GTK settings using Catppuccin/nix
  gtk = {
    enable = true;
  };

  # Use Catppuccin theme via the official nix module
  catppuccin = {
    flavor = "mocha";
    accent = "blue";  # You can change this to any accent color like "red", "green", "yellow", etc.
    gtk.enable = true;
    gtk.icon = {
      enable = true;  # Enable GTK icon theme
      accent = "blue";  # You can change this to any accent color like "red", "green", "yellow", etc.
    };
  };
  gtk.cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };  
}
