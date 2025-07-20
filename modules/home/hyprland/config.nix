{
  pkgs,
  config,
  lib,
  ...
}: let
  package = pkgs.hyprland;
in {
  # 使用软链接的方式链接配置文件到 .config/hypr 目录

  # home.file.".config/hypr" = {
  #   source = ./configs;
  #   recursive = true;
  # };

  # xdg.configFile = let
  #   mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  #   hyprPath = "${config.home.homeDirectory}/nixos-config/modules/home/hyprland/configs";
  # in {
  #   # "mako".source = mkSymlink "${hyprPath}/mako";
  #   # "waybar".source = mkSymlink "${hyprPath}/waybar";
  #   # "wlogout".source = mkSymlink "${hyprPath}/wlogout";
  #   # "hypr/hypridle.conf".source = mkSymlink "${hyprPath}/hypridle.conf";
  #   # "hypr/configs".source = mkSymlink "${hyprPath}/configs";
  #   "hypr".source = mkSymlink hyprPath;
  # };
  # status bar
  programs.waybar = {
    enable = true;
    # systemd.enable = true;
  };

  # screen locker
  programs.hyprlock.enable = true;

  # Logout Menu
  programs.wlogout.enable = true;

  # Hyprland idle daemon
  services.hypridle.enable = true;

  # notification daemon, the same as dunst
  services.mako.enable = true;

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = "${package}/bin/Hyprland";
    executable = true;
  };
}