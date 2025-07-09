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
        PasswordAuthentication = true; # enable password login
      };
      openFirewall = false;
    };

    power-profiles-daemon = {
      enable = true;
    };

    dbus.packages = [pkgs.gcr];

    geoclue2.enable = true;

    udev.packages = with pkgs; [gnome-settings-daemon];
  };

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  ''; 
  
}
