{ ... }:

{
  services.xserver = {
    desktopManager = {
    cinnamon.enable = true;
    };
    displayManager.lightdm.enable = false;
  };
  services.cinnamon.apps.enable = true;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Cinnamon";
    XDG_SESSION_DESKTOP = "cinnamon";
    GDK_BACKEND = "x11,wayland";

    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx";
  };
  
}
