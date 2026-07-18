{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity
    gimp
    glava
    pavucontrol
    # soundwireserver
    # video-trimmer
    # vlc
    # spotify
    # mpv
    blanket
    # vesktop
    # kdePackages.kdenlive
    # bilibili

    # bottles-unwrapped
    # q4wine

    # cassowary

    ## Office
    # libreoffice
    # gnome-calculator
    # obsidian
    kdePackages.kate

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    # appimagelauncher
    appimage-run
    # zenity
    boxbuddy
    # localsend
    # kdePackages.ark
    peazip

    # motrix
    meld
    # snipaste
    filezilla
    # xorg.xkill # kill X server window

    #fpv utils
    # betaflight-configurator

    # kando
    # gnomeExtensions.kando-integration

    ## Level editor
    ldtk
    tiled

    ## terminal
    # warp-terminal
    # waveterm
    # zellij
    ghostty

    usbkvm

    # looking-glass-client
  ];
}
