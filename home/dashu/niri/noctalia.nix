{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    # inputs.noctalia.packages.${system}.default
    fuzzel
  # webcord
    # kitty
    # fastfetch
    # ... 其他软件包
  ];
}