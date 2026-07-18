{
  description = "PetrichorZ's NixOS + Home Manager configuration (separated)";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      # 使用 cachix 分支以启用二进制缓存（不 follows nixpkgs）
      url = "github:noctalia-dev/noctalia/cachix";
      # inputs.quickshell.follows = "quickshell";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aerothemeplasma-nix = {
      url = "github:nyakase/aerothemeplasma-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";

    catppuccin.url = "github:catppuccin/nix";

    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    polybar-themes = {
      url = "github:adi1090x/polybar-themes";
      flake = false;
    };

    ########################  My own repositories  #########################################
    # my private secrets, it's a private repository, you need to replace it with your own.
    # use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
    # TODO
#    mysecrets = {
#      url = "git+ssh://git@github.com/xxx/nix-secrets.git?shallow=1";
#      flake = false;
#    };

    # my wallpapers
#    wallpapers = {
#      url = "github:xxx/wallpapers";
#      flake = false;
#    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    # ────────────────────────────────────────────────────────────
    # Helper: 生成 NixOS 系统配置（不含 home-manager）
    # ────────────────────────────────────────────────────────────
    mkSystem = { hostname, username, system ? "x86_64-linux" }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit self inputs hostname username; };
        modules = [
          ./hosts/${hostname}
          inputs.catppuccin.nixosModules.catppuccin
          inputs.chaotic.nixosModules.default
          inputs.minegrub-theme.nixosModules.default
          inputs.aerothemeplasma-nix.nixosModules.aerothemeplasma-nix
          inputs.noctalia.nixosModules.default
        ];
      };

    # ────────────────────────────────────────────────────────────
    # Helper: 生成独立的 Home Manager 配置
    # ────────────────────────────────────────────────────────────
    mkHome = { username, hostname, system ? "x86_64-linux" }:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self inputs username hostname; };
        modules = [
          ./users/${username}/home.nix
          # # 避免与已有配置文件冲突时直接覆盖 -- 方法不可用
          # { home-manager.backupFileExtension = "hm-backup"; }
          # standalone 模式需要指定 nix.package
          { nix.package = pkgs.nix; }
          inputs.catppuccin.homeModules.catppuccin
          inputs.chaotic.homeManagerModules.default
          inputs.noctalia.homeModules.default
          inputs.zen-browser.homeModules.beta
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
      };
  in
  {
    # ════════════════════════════════════════════════════════════
    # NixOS 系统配置
    # 用法: sudo nixos-rebuild switch --flake .#laptop
    # ════════════════════════════════════════════════════════════
    nixosConfigurations = {
      laptop = mkSystem {
        hostname = "laptop-rog-gu603";
        username = "dashu";
      };

      vm = mkSystem {
        hostname = "vm";
        username = "dashu";
      };
    };

    # ════════════════════════════════════════════════════════════
    # Home Manager 用户配置（独立于 NixOS）
    # 用法: home-manager switch --flake .#dashu@laptop
    # ════════════════════════════════════════════════════════════
    homeConfigurations = {
      "dashu@laptop" = mkHome {
        username = "dashu";
        hostname = "laptop-rog-gu603";
      };

      "dashu@vm" = mkHome {
        username = "dashu";
        hostname = "vm";
      };
    };
  };
}
