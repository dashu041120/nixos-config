# https://lostattractor.net/archives/nixos-gpu-vfio-passthrough

{ config, username, pkgs, ... }:
let
  additional = ''
    [app]
    shmFile=/dev/kvmfr0
  '';
in
{
  imports = [ (import ./config.nix { inherit additional; }) ];
  boot = {
    kernelModules = [ "kvmfr" ];
    extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=64
    '';
  };

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="kvmfr", OWNER="${username}", GROUP="kvm", MODE="0660"
  # '';

  # systemd.tmpfiles.rules = [
  #     # Type Path               Mode UID     GID Age Argument
  #     "f /dev/shm/looking-glass 0660 ${username} kvm -"
  #   ];

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm",
      "/dev/kvmfr0"
    ]
  '';
}
