{pkgs, ...}: {
  ##################################################################################################################
  #
  # All dashu's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ./home.nix
#     # TODO
    # ./aseprite.nix           # pixel art editor
    ./alacritty.nix         # terminal emulator
    ./bat.nix                         # better cat command
    ./browser.nix                     # firefox based browser
    # ./btop.nix                        # resouces monitor 
    ./cava.nix
    ./dconf.nix
#     ./fastfetch.nix                   # fetch tool
    ./fzf.nix                         # fuzzy finder
    ./gaming.nix                      # packages related to gaming
    ./ghostty.nix                     # terminal
    # ./gpu-optimization.nix            # GPU performance optimization
    ./fcitx5                     # window manager
    ./fonts.nix                   # font configuration
    ./cli.nix
    ./dev.nix
    ./gui.nix
    ./nixgl.nix                       # OpenGL support for non-NixOS
    # ./vscode.nix
    ./xdg.nix
    ./yazi.nix                        # file manager
#     ./kitty.nix                       # terminal
#     ./lazygit.nix
#     ./nemo.nix                        # file manager
    ./nix-direnv.nix                 # nix-direnv integration
#     ./nvim.nix                        # neovim editor
    ./niri                        # niri
    ./oh-my-posh.nix
    # ./obs-studio.nix                 # screen recorder
#     ./p10k/p10k.nix
#     ./packages                        # other packages
    ./pro-audio
#     ./retroarch.nix  
#     ./rofi.nix                        # launcher
#     ./scripts/scripts.nix             # personal scripts
#     ./ssh.nix                         # ssh config
    ./starship.nix                     # shell prompt
#     ./superfile/superfile.nix         # terminal file manager
#     ./swaylock.nix                    # lock screen
#     ./swayosd.nix                     # brightness / volume wiget
#     ./swaync/swaync.nix               # notification deamon
      ./social.nix                     # social apps
      ./theme
#     # ./viewnior.nix                    # image viewer
    # ./variables.nix
#     ./waybar                          # status bar
#     ./waypaper.nix                    # GUI wallpaper picker
    ./wps-office.nix                # WPS office
#     ./xdg-mimes.nix                   # xdg config
    ./zsh.nix                            # shell
  ];

  programs.git.settings = {
    user.name = "dashu041120";
    user.email = "zhangjingduan@msn.com";
  };
}