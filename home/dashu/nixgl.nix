{ pkgs, config, lib, ... }:

let
  # 创建 nixGL 包装的应用
  mkNixGLApp = appName: app:
    lib.hiPrio (pkgs.writeShellScriptBin appName ''
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${lib.getExe app} "$@"
    '');

  # 需要 OpenGL 支持的应用列表
  glApps = [
    { name = "ghostty"; app = pkgs.ghostty; }
    # { name = "vicinae"; app = pkgs.vicinae; }
    # { name = "noctalia"; app = pkgs.noctalia; }
    # { name = "obs"; app = pkgs.obs-studio; }
    { name = "spotify"; app = pkgs.spotify; }
    { name = "vlc"; app = pkgs.vlc; }
    { name = "warp-terminal"; app = pkgs.warp-terminal; }
    { name = "waveterm"; app = pkgs.waveterm; }
    # { name = "looking-glass-client"; app = pkgs.looking-glass-client; }
    { name = "gimp"; app = pkgs.gimp; }
  ];

  # 过滤掉不存在的应用
  availableApps = lib.filter (app: 
    lib.hasAttr app.app.pname pkgs || lib.hasAttr app.name pkgs
  ) glApps;

in
{
  # 安装 nixGL 包装器
  home.packages = with pkgs; [
    nixgl.auto.nixGLDefault
  ] ++ (map (app: mkNixGLApp app.name app.app) availableApps);

  # 环境变量配置，确保 OpenGL 库正确加载
  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
      pkgs.libGL
      pkgs.vulkan-loader
    ]}:$LD_LIBRARY_PATH";
  };

  # ============================================================
  # 使用说明
  # ============================================================
  # 直接运行应用（自动使用 nixGL）：
  #   ghostty
  #   obs
  #   spotify
  #   gimp
  #   vlc
  #
  # 添加应用：
  # 1. 在 glApps 列表中取消注释或添加应用
  # 2. 运行: home-manager switch --flake .#dashu@laptop --impure
}
