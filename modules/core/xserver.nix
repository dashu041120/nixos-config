{ username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,cn";
    };

    displayManager = {
      lightdm.enable = true;
      gdm.enable = false;
    };
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
