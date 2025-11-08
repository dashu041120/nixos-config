{pkgs, ...}: {
  ##################################################################################################################
  #
  # Home Manager Configuration for patrickz
  #
  ##################################################################################################################

  imports = [
    ./home.nix
    ./alacritty.nix
    ./bat.nix
    ./browser.nix
    ./dconf.nix
    ./fzf.nix
    ./fonts.nix
    ./cli.nix
    ./dev.nix
    ./gui.nix
    ./vscode.nix
    ./xdg.nix
    ./yazi.nix
    ./nix-direnv.nix
    ./starship.nix
  ];

  programs.git = {
    userName = "patrickz";
    userEmail = "patrickz@example.com";
  };
}
