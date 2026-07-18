{ config, pkgs, lib, ... }:

let
  # 在这里直接定义我们修改过的 wps 包
  my-wps-with-fcitx = pkgs.wpsoffice-cn.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.gnused ];
    installPhase = oldAttrs.installPhase + ''
      for i in wps wpp et wpspdf; do
        sed -i '/^gOpt=/a \
      export GTK_IM_MODULE=fcitx\
      export QT_IM_MODULE=fcitx5\
      export XMODIFIERS=@im=fcitx
        ' $out/bin/$i
      done
    '';
  });
in
{
  # ✅ 关键：所有配置都必须在这个 `config` 属性里面
  config = {
    # 现在可以在这里安全地使用 home.packages
    home.packages = [
      my-wps-with-fcitx
    ];
  };
}
