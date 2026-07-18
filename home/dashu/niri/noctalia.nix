{ pkgs, inputs, ... }: {
  programs.noctalia = {
    enable = true;
    systemd.enable = false; # 如果您希望 Noctalia 作为独立的服务运行，请设置为 true
  };

  home.packages = with pkgs; [
    fuzzel
  ];
}