{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [  
    whitesur-gtk-theme
    lxappearance
    # catppuccin-gtk
  ];
  # Configure GTK settings using 
  # gtk = {
  #   enable = true;
  #   theme = {
  #     # name = "WhiteSur-dark";
  #     name = "Catppuccin-Mocha-Blue";
  #   };
  # };

  # Use Catppuccin theme via the official nix module
  # catppuccin = {
  #   flavor = "mocha";
  #   accent = "blue";  # You can change this to any accent color like "red", "green", "yellow", etc.
  #   gtk.enable = false;
  #   gtk.icon = {
  #     enable = false;  # Enable GTK icon theme
  #     accent = "blue";  # You can change this to any accent color like "red", "green", "yellow", etc.
  #   };
  # };
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
