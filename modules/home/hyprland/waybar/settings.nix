# Waybar settings configuration
{
  main-bar = {
    # Basic configuration
    name = "main-bar";
    id = "main-bar";
    layer = "top";
    exclusive = true;
    passthrough = false;
    position = "top";
    height = 32;
    spacing = 6;
    margin = "0";
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    fixed-center = true;
    ipc = true;

    # Module layout
    modules-left = ["custom/menu" "cpu" "memory" "disk" "idle_inhibitor"];
    modules-center = ["hyprland/workspaces" "mpd" "tray"];
    modules-right = ["custom/themes" "pulseaudio" "backlight" "bluetooth" "network" "battery" "clock" "custom/power"];

    # Module configurations
    "hyprland/workspaces" = {
      format = "{icon}";
      sort-by-number = true;
      active-only = false;
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "漣";
        "7" = "";
        "8" = "";
        "9" = "";
        "10" = "ﳴ";
        "urgent" = "";
        "focused" = "";
        "default" = "";
      };
      on-click = "activate";
    };

    "mpd" = {
      interval = 2;
      unknown-tag = "N/A";
      format = "{stateIcon} {artist} - {title}";
      format-disconnected = " Disconnected";
      format-paused = "{stateIcon} {artist} - {title}";
      format-stopped = "Stopped ";
      state-icons = {
        paused = "";
        playing = "";
      };
      tooltip-format = "MPD (connected)";
      tooltip-format-disconnected = "MPD (disconnected)";
      on-click = "mpc toggle";
      on-click-middle = "mpc prev";
      on-click-right = "mpc next";
      on-scroll-up = "mpc seek +00:00:01";
      on-scroll-down = "mpc seek -00:00:01";
      smooth-scrolling-threshold = 1;
    };

    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
      timeout = 30;
    };

    "tray" = {
      icon-size = 16;
      spacing = 10;
    };

    "clock" = {
      interval = 60;
      tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      format = " {:%I:%M %p}";
      format-alt = " {:%a %b %d, %G}";
    };

    "cpu" = {
      interval = 5;
      format = " LOAD: {usage}%";
    };

    "memory" = {
      interval = 10;
      format = " USED: {used:0.1f}G";
    };

    "disk" = {
      interval = 30;
      format = " FREE: {free}";
    };

    "battery" = {
      interval = 60;
      full-at = 100;
      design-capacity = false;
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-full = "{icon} Full";
      format-alt = "{icon} {time}";
      format-icons = ["" "" "" "" ""];
      format-time = "{H}h {M}min";
      tooltip = true;
    };

    "network" = {
      interval = 5;
      format-wifi = " {essid}";
      format-ethernet = " {ipaddr}/{cidr}";
      format-linked = " {ifname} (No IP)";
      format-disconnected = "睊 Disconnected";
      format-disabled = "睊 Disabled";
      format-alt = " {bandwidthUpBits} |  {bandwidthDownBits}";
      tooltip-format = " {ifname} via {gwaddr}";
    };

    "pulseaudio" = {
      format = "{icon} {volume}%";
      format-muted = " Mute";
      format-bluetooth = " {volume}% {format_source}";
      format-bluetooth-muted = " Mute";
      format-source = " {volume}%";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
      scroll-step = 5.0;
      on-click = "pulsemixer --toggle-mute";
      on-click-right = "pulsemixer --toggle-mute";
      smooth-scrolling-threshold = 1;
    };

    "bluetooth" = {
      format = " {status}";
      format-on = " {status}";
      format-off = " {status}";
      format-disabled = " {status}";
      format-connected = " {device_alias}";
      format-connected-battery = " {device_alias}, {device_battery_percentage}%";
      tooltip = true;
      tooltip-format = "{controller_alias}\t{controller_address}";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      on-click = "~/.config/hypr/scripts/rofi_bluetooth";
      on-click-right = "blueman-manager";
    };

    "backlight" = {
      interval = 2;
      format = "{icon} {percent}%";
      format-icons = ["" "" "" ""];
      on-scroll-up = "light -A 5%";
      on-scroll-down = "light -U 5%";
      smooth-scrolling-threshold = 1;
    };

    "custom/menu" = {
      format = "";
      tooltip = false;
      on-click = "$HOME/.config/hypr/scripts/rofi_launcher";
      on-click-right = "$HOME/.config/hypr/scripts/rofi_runner";
    };

    "custom/power" = {
      format = "襤";
      tooltip = false;
      on-click = "$HOME/.config/hypr/scripts/rofi_powermenu";
    };

    "custom/themes" = {
      format = "";
      tooltip = false;
      on-click = "$HOME/.config/hypr/theme/theme.sh --pywal";
      on-click-right = "$HOME/.config/hypr/theme/theme.sh --default";
    };

    "custom/spotify" = {
      exec = "$HOME/.config/hypr/waybar/spotify";
      interval = 1;
      format = "{}";
      tooltip = true;
      max-length = 40;
      on-click = "playerctl play-pause";
      on-click-middle = "playerctl previous";
      on-click-right = "playerctl next";
      on-scroll-up = "playerctl position 05+";
      on-scroll-down = "playerctl position 05-";
      smooth-scrolling-threshold = 1;
    };
  };
}
