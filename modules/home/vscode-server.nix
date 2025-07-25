{ ... }:
{
    # fix vscode-server in nixos
  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;

  programs.nix-ld.enable = true;

}

# systemctl --user enable --now auto-fix-vscode-server.service