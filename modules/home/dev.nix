{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # !!! devbox
    devbox
    ## Lsp
    nixd # nix

    ## formating
    shfmt
    treefmt
    nixfmt-rfc-style

    ## C / C++
    gcc
    gdb
    gef
    cmake
    gnumake
    valgrind
    llvmPackages_20.clang-tools
    # arrow-c1pp

    python3
    conda
    uv
    # jre8
    jdk

    # gui
    imhex
    serial-studio
    putty

    # android
    # android-tools
    androidenv.androidPkgs.platform-tools
  ];
}
