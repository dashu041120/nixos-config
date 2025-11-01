{ pkgs, ... }:

{
  services = {
    desktopManager.plasma6.enable = true;
  };
  environment.systemPackages = with pkgs;
  [
    # KDE
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    # Non-KDE graphical packages
    hardinfo2 # System information and benchmarks for Linux systems
    vlc # Cross-platform media player and streaming server
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland


    kde-rounded-corners
    whitesur-kde
    # pkgs.catppuccin{
    #   accent = "blue"; # blue, rosewater, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, lavender
    #   variant = "mocha"; # latte, frappe, macchiato, mocha
    #   themelist = [ "kvantum" "qt5ct" ];
    # }
    # pkgs.catppuccin-kde{
    #   accent = "blue"; # blue, rosewater, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, lavender
    #   variant = "mocha"; # latte, frappe, macchiato, mocha
    #   size = [ "standard" "compact" ]; # standard, compact
    # }
    # catppuccin-gtk
  ];

   environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # Simple music player aiming to provide a nice experience for its users
    kdePackages.kdepim-runtime # Akonadi agents and resources
    kdePackages.kmahjongg # KMahjongg is a tile matching game for one or two players
    kdePackages.kmines # KMines is the classic Minesweeper game
    kdePackages.konversation # User-friendly and fully-featured IRC client
    kdePackages.kpat # KPatience offers a selection of solitaire card games
    kdePackages.ksudoku # KSudoku is a logic-based symbol placement puzzle
    kdePackages.ktorrent # Powerful BitTorrent client
  ];

  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";  
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-chinese-addons
  #     fcitx5-gtk
  #   ];
  # };

# Remote Desktop Service
#   xrdp = {
#     defaultWindowManager = "startplasma-x11";
#     enable = true;
#     openFirewall = true;
#   };

#   xserver = {
#     enable = true;

#     xkb = {
#       layout = "us";
#       variant = "";
#     };
#   };
}