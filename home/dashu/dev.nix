{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # !!! devbox
    # devbox
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
    # valgrind
    # llvmPackages_20.clang-tools
    llvmPackages.clangUseLLVM
    llvmPackages.clang-tools
    # arrow-c1pp
    meson

    python3
    # conda
    uv
    jre8
    jdk

    ## nodejs
    nodejs
    yarn
    pnpm
    bun

    ## Golang
    # go

    # glib
    # glibtool
    # glibc
    # glibcLocales
    # glibcInfo

    # Rust
    rustup
    # gui
    imhex
    serial-studio
    putty
    freerdp
    # libxcb

    # android
    android-tools
    # androidenv.androidPkgs.platform-tools
    edl

    gh
    ghui
    opencode-desktop
  ];
}
