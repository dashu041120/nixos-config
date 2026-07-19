{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    # audacity
    # calf  # audio plugin suite calf-plugin
    # gimp
    # glava
    # qsynth
    # soundwireserver
    video-trimmer
    vlc
    # spotify
    # mpv
    blanket
    # vesktop
    # kdePackages.kdenlive
    # bilibili
    # piliplus

    # bottles-unwrapped
    # q4wine

    # cassowary

    ## Office
    # libreoffice
    # gnome-calculator
    # obsidian
    # kdePackages.kate

    ## Utility
    # dconf-editor
    # gnome-disk-utility
    # mission-center # GUI resources monitor
    # appimagelauncher
    # appimage-run
    # zenity
    boxbuddy
    distroshelf
    # localsendl
    # kdePackages.ark
    peazip

    # motrix
    # motrix-next
    yt-dlp
    # meld
    # snipaste
    # filezilla
    # xorg.xkill # kill X server window
    # kdePackages.filelight
    #fpv utils
    # betaflight-configurator
    swappy                            # snapshot editing tool
    # kando
    # gnomeExtensions.kando-integration

    ## Level editor
    ldtk
    tiled

    ## terminal
    # warp-terminal
    # waveterm
    # zellij
    # ghostty

    usbkvm

    # looking-glass-client
  ];
}
