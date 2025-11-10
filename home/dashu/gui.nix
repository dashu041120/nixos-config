{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity
    gimp
    pavucontrol
    # soundwireserver
    # video-trimmer
    vlc
    spotify
    mpv
    # vesktop
    # kdePackages.kdenlive
    # bilibili

    # bottles-unwrapped
    # q4wine

    # cassowary

    ## Office
    # libreoffice
    gnome-calculator
    obsidian
    kdePackages.kate

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity
    boxbuddy
    localsend
    kdePackages.ark
    peazip

    motrix
    meld
    snipaste
    filezilla
    xorg.xkill # kill X server window

    #fpv utils
    # betaflight-configurator

    ## Level editor
    ldtk
    tiled

    ## terminal
    warp-terminal
    waveterm
    zellij
    ghostty

    looking-glass-client
    pavucontrol
  ];
}
