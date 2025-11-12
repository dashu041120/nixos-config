{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # !!! devbox
    # devbox
    ## Lsp
    nixd # nix

    ## formating
    # shfmt
    # treefmt
    # nixfmt-rfc-style

    ## C / C++
    # gcc
    # gdb
    # gef
    # cmake
    # gnumake
    # valgrind
    # llvmPackages_20.clang-tools
    # arrow-c1pp

    # python3
    # conda
    # uv
    # jre8
    # jdk

    ## nodejs
    # nodePackages.nodejs
    # yarn
    # pnpm

    ## Golang
    # go

    # glib
    # glibtool
    # glibc
    # glibcLocales
    # glibcInfo

    # gui
    imhex
    serial-studio
    putty
    freerdp
    libxcb

    # android
    # android-tools
    androidenv.androidPkgs.platform-tools
  ];
}
