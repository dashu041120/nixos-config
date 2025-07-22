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

    ## Level editor
    ldtk
    tiled

    ## terminal
    warp-terminal
    
  ];
}
