{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Better core utils
    duf                               # disk information
    eza                               # ls replacement
    fd                                # find replacement
    gping                             # ping with a graph
    gtrash                            # rm replacement, put deleted files in system trash
    trash-cli
    # hevi                              # hex viewer
    # hexyl                             # hex viewer
    man-pages                         # extra man pages
    ncdu                              # disk space
    ripgrep                           # grep replacement
    tldr
    appimage-run
    # appimageupdate

    ## Tools / useful cli
    # aoc-cli                           # Advent of Code command-line tool
    asciinema
    asciinema-agg
    binsider
    bitwise                           # cli tool for bit / hex manipulation
    broot
    btop                             # tree files view
    baidupcs-go                      # Baidu Netdisk CLI client
    caligula                          # User-friendly, lightweight TUI for disk imaging
    hyperfine                         # benchmarking tool
    pastel                            # cli to manipulate colors
    swappy                            # snapshot editing tool
    tdf                               # cli pdf viewer
    tokei                             # project line counter
    translate-shell                   # cli translator
    # woomer
    # yt-dlp-light
    htop
    switcheroo-control

    # rar
    unrar

    ## TUI
    # epy                               # ebook reader
    # gtt                               # google translate TUI
    # smassh                            # typing test in the terminal
    # toipe                             # typing test in the terminal
    ttyper                            # cli typing test
    # programmer-calculator

    ## Monitoring / fetch
    # htop
    # neofetch
    # nitch                             # systhem fetch util
    # onefetch                          # fetch utility for git repo
    wavemon                           # monitoring for wireless network devices

    ## Fun / screensaver
    asciiquarium-transparent
    # cbonsai
    # cmatrix
    # countryfetch
    cowsay
    fastfetch 
    hyfetch
    # figlet
    # fortune
    # lavat
    # lolcat
    # pipes
    # sl
    # tty-clock

    ## Multimedia
    ani-cli #  A cli tool to browse and play anime 
    imv  # imv is a command-line image viewer 
    lowfi  
    mpv
    ffmpeg-full
    
    ## Utilities
    entr                              # perform action when file change
    # ffmpeg  # removed to avoid conflict with ffmpeg-full
    file                              # Show file information
    jq                                # JSON processor
    killall
    libnotify
    mimeo
    openssl
    pamixer                           # pulseaudio command line mixer
    playerctl                         # controller for media players
    poweralertd
    unzip
    wget
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    xdg-utils

    # winetricks
    # wineWow64Packages.stableFull
    # vkd3d

    # gemini-cli

    coreutils-prefixed
    gpaste

    nh  # Yet another nix cli helper
    wayland-utils
    wl-clipboard
    wl-clipboard-x11
    wf-recorder
    yad
    light
    mpv
    
    # power-profiles-daemon
  ];
}
