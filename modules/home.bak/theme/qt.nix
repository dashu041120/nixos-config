{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    themechanger
    # catppuccin-kvantum
    gruvbox-kvantum
    # catppuccin-qt5ct
    # catppuccin-qt6ct
    # qt6ct
    # libsForQt5.qt5ct
  ];

#   qt = {
#     enable = true;
#     style.name = "kvantum";
#     platformTheme.name = "adwaita";
#   };
}