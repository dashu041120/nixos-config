{ config, pkgs, lib, ... }:

let
  # 自定义 Catppuccin GTK 主题包，指定 mocha 风味
  catppuccin-gtk-mocha = pkgs.catppuccin-gtk.overrideAttrs (oldAttrs: {
    # 重写构建参数，指定 mocha 风味和 blue accent
    buildInputs = oldAttrs.buildInputs or [];
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [];
    
    # 重写安装阶段，确保使用 mocha 风味
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      python3 build.py mocha \
        --accent blue \
        --size standard \
        --dest $out/share/themes

      runHook postInstall
    '';
  });

  # 自定义 Catppuccin Kvantum 主题包，指定 mocha 风味  
  catppuccin-kvantum-mocha = pkgs.catppuccin-kvantum.overrideAttrs (oldAttrs: {
    # 重写安装阶段，确保使用 mocha 风味和 blue accent
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/Kvantum
      cp -a themes/catppuccin-mocha-blue $out/share/Kvantum
      runHook postInstall
    '';
  });

in
{
  config = {
    # 安装自定义的主题包
    home.packages = [
      catppuccin-gtk-mocha
      catppuccin-kvantum-mocha
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.qt6Packages.qtstyleplugin-kvantum
    ];

    # 配置 GTK 使用 Catppuccin Mocha
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Blue";
      };
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
