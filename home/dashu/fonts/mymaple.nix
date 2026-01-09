{ config, pkgs, ... }:

let
  myMapleFont = pkgs.stdenv.mkDerivation rec {
    pname = "maple-mono-custom";
    version = "2025.12.31";

    # 1. 这里改为指向 zip 文件的链接
    src = pkgs.fetchurl {
      url = "https://github.com/dashu041120/maple-font-forked/releases/download/v1767266677/MapleMono-NF.zip";
      # 2. 注意：ZIP 文件的 sha256 和 tar.gz 是不一样的，记得重新计算
      sha256 = "221508ce506809248adc0ce810e68a2b8df4514d62683c1627edd4ffc1a100db"; 
    };

    # 3. 关键点：告诉 Nix 构建环境需要 'unzip' 工具
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    dontBuild = true;

    # 4. 安装步骤（mkDerivation 会自动帮您解压 zip，不用手写 unzip 命令）
    installPhase = ''
      runHook preInstall

      # 这里的通配符结构可能需要根据 zip 内部结构微调
      # 通常 zip 解压后会有一个文件夹，或者直接是一堆文件
      # 使用 find 命令可以通吃这两种情况，把所有 ttf 移动到目标目录
      install -Dm644 $(find . -name '*.ttf') -t $out/share/fonts/truetype/

      runHook postInstall
    '';
    # installPhase = ''
    #   runHook preInstall

    #   # 建立存放字体的目录
    #   install -d $out/share/fonts/truetype/
      
    #   # 查找并安装所有 ttf 文件
    #   # 使用 find 是为了保险，无论解压出来是扁平结构还是有文件夹结构都能找到
    #   find . -name '*.ttf' -exec install -m644 {} $out/share/fonts/truetype/ \;

    #   runHook postInstall
    # '';
  };
in
{
  home.packages = [
    myMapleFont
  ];
}

# pacman -Qq | grep -Ei 'ttf|otf|woff|font'