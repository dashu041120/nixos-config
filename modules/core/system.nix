{ pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nyx-cache.chaotic.cx/"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://hyprland.cachix.org"
        "https://noctalia.cachix.org"
        "https://cache.numtide.com"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "cache.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
      builders-use-substitutes = true;
    };

    
  };
  
  nixpkgs = {
    overlays = [ inputs.nur.overlays.default ];
      # Allow unfree packages
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gcc
    cmake
    curl
    htop
    btop
    util-linux
    scrot
    sysstat
    yazi
    polkit

    pciutils  #lspci
    autoconf
    procps
    m4
    gperf
    libGLU libGL
    libxi libxmu freeglut
    libxext libx11 libxv libxrandr zlib
    ncurses5
    stdenv.cc
    binutils
    wayland-utils
  ];

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };



  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
#       nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
#       nerd-fonts.iosevka
    ];
    fontDir.enable = true;
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontconfig.useEmbeddedBitmaps = true;
    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
      #   serif = [ "Noto Serif" ];
      #   sansSerif = [ "Noto Sans CJK SC" ];
      #   monospace = [ "Noto Sans Mono CJK SC" ];
    };
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  security.polkit.enable = true;

  system.stateVersion = "26.05";
}
