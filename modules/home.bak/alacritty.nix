{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = false;
    settings = {
      # env.TERM = "alacritty";
      window = {
        dimensions = {
          columns = 95;
          lines = 24;
        };
        padding = {
          x = 12;
          y = 12;
        };
        dynamic_padding = true;
        decorations = "full";
        opacity = 1.0;
        startup_mode = "Windowed";
        dynamic_title = true;
      };
      scrolling.history = 10000;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 10;
      };
      colors = {
        primary = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };
        normal = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };
        bright = {
          black = "#585B70";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#A6ADC8";
        };
      };
      cursor.style = {
        shape = "Block";
        blinking = "On";
      };
    };
  };
}
