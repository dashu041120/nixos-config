{ ... }:
{
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./bluetooth.nix
    ./garbage_clean.nix
    ./pipewire.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./wayland.nix
    ./virtualization.nix
  ];
}
