{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    # Mount, trash, and other functionalities
    dbus.enable = true;
    fstrim.enable = true;

    syncthing.enable = true;

    # auto mount usb drives
    udisks2.enable = true;
    printing.enable = true;
    
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no"; # disable root login
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
    };

    power-profiles-daemon = {
      enable = true;
    };

    dbus.packages = [pkgs.gcr];

    geoclue2.enable = true;

      # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    udev.packages = with pkgs; [gnome-settings-daemon];
  };

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
