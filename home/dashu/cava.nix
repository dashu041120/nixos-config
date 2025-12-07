{ pkgs, ... }: {
    home.packages = with pkgs; [
        cava
        cavalcade
        cavalier
        # astal.cava
        # cavasik
    ];
}