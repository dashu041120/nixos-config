{pkgs, ...}: {
  ##################################################################################################################
  #
  # All dashu's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ./home.nix
    ./alacritty.nix
    ./bat.nix
    ./browser.nix
    ./dconf.nix
    ./fzf.nix
    ./gaming.nix
    ./ghostty.nix
    ./fcitx5
    ./fonts.nix
    ./cli.nix
    ./dev.nix
    ./gui.nix
    ./vscode.nix
    ./xdg.nix
    ./yazi.nix
    ./nix-direnv.nix
    ./niri
    ./oh-my-posh.nix
    ./obs-studio.nix
    ./pro-audio
    ./starship.nix
    # 如需启用，取消注释
    # ./hyprland
  ];

  programs.git = {
    userName = "dashu041120";
    userEmail = "zhangjingduan@msn.com";
  };
}