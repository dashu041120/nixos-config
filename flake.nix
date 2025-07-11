{
  description = "PetrichorZ's nix configuration for NixOS";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server

    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"  # 新增的 Hyprland 缓存
      # "https://yazi.cachix.org"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };
    
    
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-24.11";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    # TODO
#    agenix = {
#      # lock with git commit at 0.15.0
#      url = "github:ryantm/agenix";
#      # replaced with a type-safe reimplementation to get a better error message and less bugs.
#      # url = "github:yourusername/ragenix";
#      inputs.nixpkgs.follows = "nixpkgs";
#      # optionally choose not to download darwin deps (saves some resources on Linux)
#      #inputs.agenix.inputs.darwin.follows = "";
#    };  

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################  Some non-flake repositories  #########################################
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    catppuccin.url = "github:catppuccin/nix";

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
    # 步骤1: 定义一个函数，它接受所有可能变化的参数
    mkSystem = { hostname, username, system ? "x86_64-linux" }: 
    let 
      # specialArgs 保持不变，它将被传递给 NixOS 和 Home Manager
      specialArgs = { 
        inherit self inputs hostname username; 
      };
    in
    nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          # 原有的主机配置
          ./hosts/${hostname}
          # 添加 Catppuccin NixOS 模块
          inputs.catppuccin.nixosModules.catppuccin
          # --- Home Manager 配置开始 ---
          # 1. 导入 Home Manager 的 NixOS 模块
          inputs.home-manager.nixosModules.home-manager

          # 2. 添加内联配置
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 启用文件备份功能，避免配置冲突
            home-manager.backupFileExtension = "hm-backup";
            # 将 specialArgs 传递给 home.nix
            home-manager.extraSpecialArgs = specialArgs;
            # 关联用户和其 home.nix 配置文件
            home-manager.users.${username} = {
              imports = [
                ./users/${username}/home.nix
                # 添加 Catppuccin Home Manager 模块
                inputs.catppuccin.homeManagerModules.catppuccin
              ];
            };
          }
          # --- Home Manager 配置结束 ---
        ];
      };
  in
  {
    # 步骤2: 调用这个函数来生成你的所有主机配置
    nixosConfigurations = {
      # 主机一：
      desktop = mkSystem { 
        hostname = "desktop";
        username = "patrickz";
      };

      # 主机二：笔记本
      laptop = mkSystem {
        hostname = "laptop-rog-gu603";
        username = "dashu";
      };

      # 主机三：虚拟机
      vm = mkSystem {
        hostname = "vm";
        username = "guest";
      };


      # (可选) 如果你的某台机器是 aarch64 架构
      # macbook = mkSystem {
      #   hostname = "macbook";
      #   username = "frostphoenix";
      #   system = "aarch64-darwin";
      # };
    };

    # 新增：为 home-manager 提供 flake homeConfigurations 输出
    # homeConfigurations = {
    #   "dashu@laptop-rog-gu603" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     extraSpecialArgs = { username = "dashu"; };
    #     modules = [
    #       ./modules/home/home.nix
    #       ./modules/core
    #       inputs.catppuccin.homeManagerModules.catppuccin
    #     ];
    #     # 你可以根据需要添加更多模块
    #   };
    #   # 其他用户可仿照添加
    # };
  };
}


# .
# ├── flake.nix
# ├── hosts
# │   ├── desktop
# │   │   └── default.nix
# │   ├── laptop
# │   │   └── default.nix
# │   └── vm
# │       └── default.nix
# └── users
# │   ├── frostphoenix
# │   │   ├── home.nix      <-- frostphoenix 的 Home Manager 配置
# │   │   └── nixos.nix
# │   ├── suzi
# │   │   ├── home.nix      <-- suzi 的 Home Manager 配置
# │   │   └── nixos.nix
# │   └── guest
# │       ├── home.nix      <-- guest 的 Home Manager 配置
# │       └── nixos.nix
# └── modules
#     ├── core
#     └── home

