{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
    # # Enable auto-login for the specified user
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;
  services.gnome.gnome-browser-connector.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.core-shell.enable = true;
  programs.nm-applet.enable = true;

  services.udev.packages = with pkgs; [  gnome-settings-daemon ];
  environment.systemPackages = with pkgs; [
    polkit_gnome
    gnome-screenshot
    gnome-characters
    gnome.gvfs
    gnome-power-manager
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu
    gnomeExtensions.paperwm
    gnomeExtensions.pop-shell
    gnomeExtensions.zen
    gnomeExtensions.workspace-indicator
    gnome-extensions-cli
    gnome-extension-manager
    qgnomeplatform-qt6
    qgnomeplatform
    gnomeExtensions.workspace-switcher-manager
    gnomeExtensions.window-title-is-back
    gnomeExtensions.custom-osd
    gnomeExtensions.appindicator
    gnome-tweaks
    gnomeExtensions.dock-from-dash
    gnomeExtensions.dash-to-panel
    gnomeExtensions.dash-to-dock
  ];


}