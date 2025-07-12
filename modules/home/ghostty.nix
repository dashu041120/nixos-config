{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".text = ''
    # Window settings matching Alacritty
    # window-width = 95
    # window-height = 24
    # window-padding-x = 12
    # window-padding-y = 12
    # window-decoration = true
    # window-opacity = 1.0
    
    # Font configuration matching Alacritty
    font-family = "JetBrainsMono Nerd Font"
    font-size = 10
    font-style = normal
    font-style-bold = bold
    font-style-italic = italic
    
    # Scrollback matching Alacritty
    scrollback-limit = 10000
    
    # Cursor matching Alacritty
    cursor-style = block
    cursor-style-blink = true
    
    # Additional terminal settings
    confirm-close-surface = false
    quit-after-last-window-closed = true
    
    # Mouse settings
    mouse-hide-while-typing = true
    copy-on-select = true
    
    # Shell integration
    shell-integration = detect
    
    # Performance settings
    resize-overlay = never
    resize-overlay-position = center
    
    # Theme
    theme = catppuccin-mocha
  '';
  
  xdg.configFile."ghostty/themes/catppuccin-mocha".text = ''
    # Catppuccin Mocha color scheme - exact match with Alacritty
    background = #1E1E2E
    foreground = #CDD6F4
    
    # Selection colors
    selection-background = #585B70
    selection-foreground = #CDD6F4
    
    # Normal colors (palette 0-7)
    palette = 0=#45475A
    palette = 1=#F38BA8
    palette = 2=#A6E3A1
    palette = 3=#F9E2AF
    palette = 4=#89B4FA
    palette = 5=#F5C2E7
    palette = 6=#94E2D5
    palette = 7=#BAC2DE
    
    # Bright colors (palette 8-15)
    palette = 8=#585B70
    palette = 9=#F38BA8
    palette = 10=#A6E3A1
    palette = 11=#F9E2AF
    palette = 12=#89B4FA
    palette = 13=#F5C2E7
    palette = 14=#94E2D5
    palette = 15=#A6ADC8
  '';
}
