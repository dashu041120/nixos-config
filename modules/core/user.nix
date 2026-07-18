{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  # ────────────────────────────────────────────────────────────
  # Home Manager 嵌入模式（已禁用，改用独立的 home-manager switch）
  # 如需恢复：取消下面的注释，并在 flake.nix 的 mkSystem 中
  # 添加 inputs.home-manager.nixosModules.home-manager
  # ────────────────────────────────────────────────────────────
  # imports = [ inputs.home-manager.nixosModules.home-manager ];
  # home-manager = {
  #   useUserPackages = true;
  #   useGlobalPkgs = true;
  #   extraSpecialArgs = { inherit inputs username host; };
  #   users.${username} = {
  #     imports =
  #       if (host == "desktop") then
  #         [ ./../home/default.desktop.nix ]
  #       else
  #         [ ./../home ];
  #   };
  # };

  # 安装 home-manager CLI，之后可用 home-manager switch --flake 独立管理
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "tty"
      "libvirt"
      "kvm"
      "render"
      "adbusers"
    ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = [ "${username}" ];
#   nix.settings.trusted-users = [username];

}
