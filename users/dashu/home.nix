{pkgs, ...}: {
  ##################################################################################################################
  #
  # All dashu's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [


    ../../modules/home/core.nix

    # ../../modules/home/fcitx5
    # ../../modules/home/hyprland
    # ../../modules/home/programs
    # ../../modules/home/rofi
    # ../../modules/home/shell
  ];

  programs.git = {
    userName = "dashu041120";
    userEmail = "zhangjingduan@msn.com";
  };
}