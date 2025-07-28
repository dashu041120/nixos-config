{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    audacity
    gimp
    pavucontrol
    soundwireserver
    video-trimmer
    vlc
    spotify
    mpv
    kdePackages.kdenlive
    bilibili


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

    snipaste

    #fpv utils
    betaflight-configurator

    ## Level editor
    ldtk
    tiled

    ## terminal
    warp-terminal
    waveterm
    
  ];
}
