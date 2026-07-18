{ config, pkgs, ... }:

{
  # Install fonts via Nix packages for broader availability
  home.packages = with pkgs; [
    # hyprland needs these fonts
    icomoon-feather

    #cjk
    noto-fonts
    # noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    sarasa-gothic # 更纱黑体
    source-code-pro
    wqy_zenhei # 添加文泉驿字体

    fira
    fira-sans
    font-awesome
    roboto
    helvetica-neue-lt-std
    fragment-mono

    corefonts
    vista-fonts-chs

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    twemoji-color-font
    fantasque-sans-mono
    maple-mono.truetype-autohint
  ];


  # Link local fonts from the project's home module directory
  # The path is relative to this .nix file, pointing to the sibling fonts folder
  home.file = {
    ".local/share/fonts/Archcraft" = {
      source = ./fonts/Archcraft.ttf;
    };
    ".local/share/fonts/IcomoonFeather" = {
      source = ./fonts/IcomoonFeather.ttf;
    };
    ".local/share/fonts/SymbolsNerdFontComplete" = {
      source = ./fonts/SymbolsNerdFontComplete.ttf;
    };
     ".local/share/fonts/IosevkaNerdFonts" = {
      source = ./fonts/IosevkaNerdFonts;
      recursive = true;
    };
    ".local/share/fonts/JetBrainsMono" = {
      source = ./fonts/JetBrainsMono;
      recursive = true;
    };
    ".local/share/fonts/JetBrainsMonoNerdFonts" = {
      source = ./fonts/JetBrainsMonoNerdFonts;
      recursive = true;
    };
  };
  # Rebuild font cache after activation to make new fonts available
  home.activation.rebuildFontCache = ''
    ${pkgs.fontconfig}/bin/fc-cache -fv
  '';
}
