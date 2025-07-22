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


    python3


    # gui
    imhex
    serial-studio
    putty
  ];
}
