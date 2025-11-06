{ ... }:
{
  imports = [
    ./home.nix
#     # TODO
    # ./aseprite.nix           # pixel art editor
    ./alacritty.nix         # terminal emulator
#     ./audacious.nix                   # music player
    ./bat.nix                         # better cat command
    ./browser.nix                     # firefox based browser
    # ./btop.nix                        # resouces monitor 
#     ./cava.nix                        # audio visualizer
#     ./discord.nix                     # discord
    ./dconf.nix
#     ./fastfetch.nix                   # fetch tool
#     ./flow.nix                        # terminal text editor
    ./fzf.nix                         # fuzzy finder
    ./gaming.nix                      # packages related to gaming
    ./ghostty.nix                     # terminal
    # ./gpu-optimization.nix            # GPU performance optimization
#     ./git.nix                         # version control
#     ./gnome.nix                       # gnome apps

    # ./hyprland

    ./fcitx5                     # window manager
    ./fonts.nix                   # font configuration
    ./cli.nix
    ./dev.nix
    ./gui.nix
    # ./looking-glass/kvmfr.nix
    ./vscode.nix
    ./xdg.nix
    ./yazi.nix                        # file manager
#     ./kitty.nix                       # terminal
#     ./lazygit.nix
#     ./nemo.nix                        # file manager
    ./nix-direnv.nix                 # nix-direnv integration
#     ./nvim.nix                        # neovim editor
    ./niri                        # niri
    ./oh-my-posh.nix
    ./obs-studio.nix                 # screen recorder
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
}
