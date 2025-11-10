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

  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    GTK_DATA_PREFIX = "${config.home.homeDirectory}/.nix-profile";
  };
    
  #   # 创建 gtk-3.0 配置确保主题被识别
  # xdg.configFile."gtk-3.0/settings.ini".text = ''
  #   [Settings]
  #   gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
  #   gtk-application-prefer-dark-theme=1
  #   gtk-icon-theme-name=Papirus-Dark
  #   gtk-font-name=Sans 10
  #   gtk-cursor-theme-name=Bibata-Modern-Ice
  #   gtk-cursor-theme-size=24
  # '';
    
  #   # 为 GTK4 创建类似配置
  # xdg.configFile."gtk-4.0/settings.ini".text = ''
  #   [Settings]
  #   gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
  #   gtk-application-prefer-dark-theme=1
  #   gtk-icon-theme-name=Papirus-Dark
  #   gtk-font-name=Sans 10
  #   gtk-cursor-theme-name=Bibata-Modern-Ice
  #   gtk-cursor-theme-size=24
  # '';
}
