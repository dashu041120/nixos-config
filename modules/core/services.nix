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
    udev.packages = with pkgs; [
      gnome-settings-daemon
      # android-udev-rules # 'android-udev-rules' has been removed due to being superseded by built-in systemd uaccess rules.
    ];
  };


  # services.logind.extraConfig = ''
  #   # don’t shutdown when power button is short-pressed
  #   HandlePowerKey=ignore
  # ''; 
# Use services.logind.settings.Login instead.
  
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    KillUserProcesses = false;
    
  };


  
}
