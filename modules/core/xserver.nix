{ username, pkgs, ... }:
{
  environment.systemPackages =  with pkgs; [
    xhost
    x11docker
  ];
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,cn";
    };

    # xserver.displayManager.lightdm = {
    #   enable = false;
    #   # greeters.gtk.enable = true;
    #   greeters.gtk.theme.name = "Adwaita";

    # };
    

    displayManager.autoLogin = {
      enable = false;
      user = "${username}";
    };

    # displayManager.sessionCommands = ''
    #   # Ensure Nix environment is available in display-manager sessions.
    #   for nix_init in \
    #     /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
    #     /nix/var/nix/profiles/default/etc/profile.d/nix.sh \
    #     /etc/profile.d/nix-daemon.sh \
    #     /etc/profile.d/nix.sh; do
    #     if [ -r "$nix_init" ]; then
    #       . "$nix_init"
    #       break
    #     fi
    #   done
    #
    #   if ! command -v nix >/dev/null 2>&1 && [ -d /nix/var/nix/profiles/default/bin ]; then
    #     export PATH="/nix/var/nix/profiles/default/bin:$PATH"
    #   fi
    # '';

    libinput = {
      enable = true;
    };
  };


  # services.xserver.desktopManager.plasma5.useQtScaling = true;


  # To prevent getting stuck at shutdown
  # systemd.extraConfig = "DefaultTimeoutStopSec=10s";The option definition `systemd.extraConfig' in `/nix/store/fnszw5nsn64kaz6wmv2d6vxj1xbw49bn-source/modules/core/xserver.nix' no longer has any effect; please remove it.
      #  Use systemd.settings.Manager instead.
  systemd.settings.Manager = {
    # KExecWatchdogSec = "5min";
    RebootWatchdogSec = "10s";
    # RuntimeWatchdogSec = "30s";
    # WatchdogDevice = "/dev/watchdog";

  };
}
