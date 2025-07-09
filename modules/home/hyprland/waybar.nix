{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      main-bar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 6;
        modules-left = ["custom/menu", "cpu", "memory", "disk", "idle_inhibitor"];
        modules-center = ["hyprland/workspaces", "mpd", "tray"];
        modules-right = ["custom/themes", "pulseaudio", "backlight", "bluetooth", "network", "battery", "clock", "custom/power"];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };
        
        "mpd" = {
          format = "{stateIcon} {title}";
          state-icons = {
            "playing" = "▶";
            "paused" = "⏸";
          };
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            "activated" = "";
            "deactivated" = "";
          };
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = true;
        };

        "memory" = {
          format = " {}%";
        };

        "disk" = {
          format = " {percentage_used}%";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = ["", "", "", "", ""];
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ Disconnected";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-icons = {
            "default" = ["", "", ""];
          };
          on-click = "pavucontrol";
        };
        
        "custom/menu" = {
            format = "";
            on-click = "wofi --show drun";
        };
        
        "custom/power" = {
            format = "";
            on-click = "wlogout";
        };
        
        "custom/themes" = {
            format = "";
            on-click = "wlogout";
        };
      };
    };
    style = ''
      /* Copyright (C) 2020-2024 Aditya Shakya <adi1090x@gmail.com> */
      /*
       *
       * Catppuccin-Mocha
       *
       */

      * {
          font-family: "Iosevka Nerd Font", "IcomoonFeather";
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
          border: none;
          border-radius: 12px;
      }

      window#waybar {
          background-color: rgba(30, 30, 46, 0.8);
          color: #cdd6f4;
          transition-property: background-color;
          transition-duration: .5s;
      }

      /*-----module groups----*/
      .modules-left, .modules-center, .modules-right {
          padding: 2px 0;
      }

      /*-----modules----*/
      #workspaces,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #bluetooth,
      #backlight,
      #cpu,
      #memory,
      #disk,
      #idle_inhibitor,
      #tray,
      #mpd,
      #custom-menu,
      #custom-power,
      #custom-themes {
          color: #cdd6f4;
          background-color: #28283d;
          padding: 5px;
          margin: 2px 5px;
      }

      #workspaces button {
          padding: 2px;
          color: #89b4fa;
      }

      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background: #89b4fa;
          color: #1e1e2e;
      }

      #workspaces button.active {
          background: #89b4fa;
          color: #1e1e2e;
      }

      #workspaces button.focused {
          background-color: #a6e3a1;
          color: #1e1e2e;
      }

      #workspaces button.urgent {
          background-color: #f38ba8;
          color: #1e1e2e;
      }

      #clock {
          color: #f5c2e7;
      }

      #battery {
          color: #a6e3a1;
      }

      #battery.charging, #battery.plugged {
          color: #a6e3a1;
      }

      @keyframes blink {
          to {
              background-color: #f38ba8;
              color: #1e1e2e;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #f38ba8;
          color: #1e1e2e;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #pulseaudio {
          color: #89b4fa;
      }

      #pulseaudio.muted {
          background-color: #f38ba8;
          color: #1e1e2e;
      }

      #network {
          color: #f9e2af;
      }

      #network.disconnected {
          background-color: #f38ba8;
          color: #1e1e2e;
      }

      #bluetooth {
          color: #89b4fa;
      }

      #bluetooth.disabled {
          background-color: #f38ba8;
          color: #1e1e2e;
      }

      #backlight {
          color: #f9e2af;
      }

      #cpu {
          color: #a6e3a1;
      }

      #memory {
          color: #f5c2e7;
      }

      #disk {
          color: #94e2d5;
      }

      #idle_inhibitor {
          color: #cdd6f4;
      }

      #idle_inhibitor.activated {
          background-color: #a6e3a1;
          color: #1e1e2e;
      }

      #mpd {
          color: #a6e3a1;
      }

      #mpd.disconnected {
          background-color: #f38ba8;
          color: #1e1e2e;
      }

      #mpd.stopped {
          background-color: #cdd6f4;
          color: #1e1e2e;
      }

      #mpd.paused {
          background-color: #f9e2af;
          color: #1e1e2e;
      }

      #tray {
          background-color: #28283d;
      }

      #custom-menu {
          color: #cdd6f4;
      }

      #custom-power {
          color: #f38ba8;
      }

      #custom-themes {
          color: #f5c2e7;
      }
    '';
  };
}
