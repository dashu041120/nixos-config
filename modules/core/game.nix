# https://github.com/fufexan/dotfiles/blob/483680e121b73db8ed24173ac9adbcc718cbbc6e/system/programs/gamemode.nix
{
  config,
  pkgs,
  nix-gaming,
  lib,
  ...
}: let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.coreutils
    pkgs.power-profiles-daemon
  ];

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
    powerprofilesctl set performance
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
    powerprofilesctl set power-saver
  '';
in {
  programs = {
    steam = {
      # Some location that should be persistent:
      #   ~/.local/share/Steam - The default Steam install location
      #   ~/.local/share/Steam/steamapps/common - The default Game install location
      #   ~/.steam/root        - A symlink to ~/.local/share/Steam
      #   ~/.steam             - Some Symlinks & user info
      enable = true;
      # https://github.com/ValveSoftware/gamescope
      # enables features such as resolution upscaling and stretched aspect ratios (such as 4:3)
      gamescopeSession.enable = true;

      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils

            # fix CJK fonts
            source-sans
            source-serif
            source-han-sans
            source-han-serif

            # audio
            pipewire

            # other common
            udev
            alsa-lib
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr # To use the x11 feature
            libxkbcommon
            wayland # To use the wayland feature
        ];
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };

  # Optimise Linux system performance on demand
  # https://github.com/FeralInteractive/GameMode
  # https://wiki.archlinux.org/title/Gamemode
  #
  # Usage:
  #   1. For games/launchers which integrate GameMode support:
  #      https://github.com/FeralInteractive/GameMode#apps-with-gamemode-integration
  #      simply running the game will automatically activate GameMode.
  #   2. For others, launching the game through gamemoderun: `gamemoderun ./game`
  #   3. For steam: `gamemoderun steam-runtime`
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      # custom = {
      #   start = startscript.outPath;
      #   end = endscript.outPath;
      # };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;
  programs.steam.platformOptimizations.enable = true;
  imports = with nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
  ];
}
