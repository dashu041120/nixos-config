{ ... }:
{


  imports = [
    ./bootloader.nix
    # ./cosmic.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./bluetooth.nix
    ./garbage_clean.nix
    # ./gnome.nix
    ./kde.nix
    ./cinnamon.nix
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
    ./net-forwarding.nix
  ];
}
