{ ... }:
{
  imports = [
    ./home.nix
#     # TODO
    ./aseprite.nix           # pixel art editor
    ./alacritty.nix         # terminal emulator
#     ./audacious.nix                   # music player
    ./bat.nix                         # better cat command
    ./browser.nix                     # firefox based browser
    # ./btop.nix                        # resouces monitor 
#     ./cava.nix                        # audio visualizer
#     ./discord.nix                     # discord
#     ./fastfetch.nix                   # fetch tool
#     ./flow.nix                        # terminal text editor
    ./fzf.nix                         # fuzzy finder
    ./gaming.nix                      # packages related to gaming
    ./ghostty.nix                     # terminal
    # ./gpu-optimization.nix            # GPU performance optimization
#     ./git.nix                         # version control
#     ./gnome.nix                       # gnome apps
    ./gtk.nix                         # gtk theme
    ./hyprland
    ./fcitx5                     # window manager
    ./cli.nix
    ./dev.nix
    ./gui.nix
    ./vscode.nix
    ./xdg.nix
    ./yazi.nix                        # file manager
#     ./kitty.nix                       # terminal
#     ./lazygit.nix
#     ./nemo.nix                        # file manager
#     ./nix-search/nix-search.nix       # TUI to search nixpkgs
#     ./nvim.nix                        # neovim editor
    ./oh-my-posh.nix
    ./obs-studio.nix                 # screen recorder
#     ./p10k/p10k.nix
#     ./packages                        # other packages
#     ./retroarch.nix  
#     ./rofi.nix                        # launcher
#     ./scripts/scripts.nix             # personal scripts
#     ./ssh.nix                         # ssh config
#     ./superfile/superfile.nix         # terminal file manager
#     ./swaylock.nix                    # lock screen
#     ./swayosd.nix                     # brightness / volume wiget
#     ./swaync/swaync.nix               # notification deamon
      ./social.nix                     # social apps
#     # ./viewnior.nix                    # image viewer
#     ./vscodium                        # vscode fork
#     ./waybar                          # status bar
#     ./waypaper.nix                    # GUI wallpaper picker
    ./wps-office.nix                # WPS office
#     ./xdg-mimes.nix                   # xdg config
    ./zsh.nix                            # shell
  ];
}
