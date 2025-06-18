{ ... }:
{
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = { };
}
// vim: set ft=nix:
{
  security.sudo.extraConfig = ''
    Defaults env_keep += "WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
  '';
}