{ username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,cn";
    };

    xserver.displayManager = {
      lightdm.enable = false;
    };
    displayManager.gdm.enable = true;
    # Enable auto-login for the specified user
    displayManager.autoLogin = {
      enable = false;
      user = "${username}";
    };
    
    libinput = {
      enable = true;
    };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
