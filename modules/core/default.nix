{ ... }:
{


  imports = [
    ./bootloader.nix
    ./cosmic.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./bluetooth.nix
    ./garbage_clean.nix
    ./pipewire.nix
    ./programs.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./wayland.nix
    ./virtualization.nix
    ./game.nix
  ];
}
