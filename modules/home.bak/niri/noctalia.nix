{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default
    fuzzel
    vesktop
  # webcord
    kitty
    fastfetch
    # ... 其他软件包
  ];
}