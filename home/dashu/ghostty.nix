{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".text = ''
    # Window settings matching Alacritty
    window-width = 95
    window-height = 40
    window-padding-x = 12
    window-padding-y = 12
    window-decoration = true
    
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
    theme = Catppuccin Mocha
    
    # Background transparency and blur
    background-opacity = 0.85
    background-blur = true
    background-blur-radius = 10
  '';

}
