{
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      fcitx5-rime
      # needed enable rime using configtool after installed
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-chinese-addons
      # fcitx5-mozc    # japanese input method
      fcitx5-gtk # gtk im module
      # fcitx5-qt5  # qt im module
      libsForQt5.fcitx5-qt
      # fcitx5-qt6
      kdePackages.fcitx5-qt
      # fcitx5-libpinyin # pinyin input method
    ];
  };

  # copy themes to ~/.local/share/fcitx5/themes
  home.file.".local/share/fcitx5/themes" = {
    source = ./themes;
    recursive = true;
  };

  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
    "fcitx5/conf/classicui.conf".source = ./classicui.conf;
  };


  home.file.".local/share/fcitx5/rime" = {
    source = ./oh-my-rime;
    recursive = true;
  };
}
