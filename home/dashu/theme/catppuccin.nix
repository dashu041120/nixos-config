{ config, pkgs, lib, ... }:

let
  # # 自定义 Catppuccin GTK 主题包，指定 mocha 风味
  # catppuccin-gtk-mocha = pkgs.catppuccin-gtk.overrideAttrs (oldAttrs: {
  #   # 重写构建参数，指定 mocha 风味和 blue accent
  #   buildInputs = oldAttrs.buildInputs or [];
  #   nativeBuildInputs = oldAttrs.nativeBuildInputs or [];
    
  #   # 重写安装阶段，确保使用 mocha 风味
  #   installPhase = ''
  #     runHook preInstall

  #     mkdir -p $out/share/themes

  #     python3 build.py mocha \
  #       --accent blue \
  #       --size standard \
  #       --dest $out/share/themes

  #     runHook postInstall
  #   '';
  # });
  catppuccin-gtk-mocha = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    variant = "mocha";
    # 添加 tweaks 以包含更多组件支持
    tweaks = [ "rimless" "normal" "float" ];
  };

in
{
  config = {
    home.packages = [
      catppuccin-gtk-mocha
      # catppuccin-kvantum-mocha
      pkgs.papirus-icon-theme
      pkgs.bibata-cursors
      # pkgs.libsForQt5.qtstyleplugin-kvantum
      # pkgs.qt6Packages.qtstyleplugin-kvantum
      (pkgs.catppuccin.override {
        accent = "blue"; # blue, rosewater, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, lavender
        variant = "mocha"; # latte, frappe, macchiato, mocha
        themeList = [ "kvantum" "qt5ct" ];
      })
      (pkgs.catppuccin-kde.override {
        accents = [ "blue" ]; # blue, rosewater, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, lavender
        flavour = [ "mocha" ]; # latte, frappe, macchiato, mocha
        winDecStyles = [ "modern" "classic" ]; 
      })
    ];

    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    # 配置 GTK 使用 Catppuccin Mocha
    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-blue-standard+rimless,normal,float";
        package = catppuccin-gtk-mocha;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      font = {
        name = "Sans";
        size = 10;
      };
    };

    # 为 Nix 应用设置 GTK 环境变量，确保能找到主题
    home.sessionVariables = {
      GTK_THEME = "catppuccin-mocha-blue-standard+rimless,normal,float";
      GTK_DATA_PREFIX = "${config.home.profileDirectory}:${config.home.homeDirectory}/.nix-profile:/usr/share";
    };

    # 配置 Qt 使用 Kvantum
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    # 配置 Kvantum 使用 Catppuccin Mocha 主题
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-mocha-blue
    '';
  };
  
}


# or try this?
# flakes.nix
# {
#   inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

#   outputs = { self, nixpkgs }: {
#     packages.x86_64-linux.catppuccin-gtk-all-accents = 
#       let
#         pkgs = import nixpkgs { system = "x86_64-linux"; };
#         allAccents = [
#           "blue" "flamingo" "green" "lavender" "maroon" "mauve"
#           "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"
#         ];
#       in
#         pkgs.catppuccin-gtk {
#           accents = allAccents;
#           # 你也可以指定其它参数，比如 variant/size/tweaks
#           variant = "frappe";
#           size = "standard";
#         };
#   };
# }