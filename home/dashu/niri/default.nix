{ pkgs, inputs, ... }: {
    imports = [
        # ./quickshell.nix
        # ./noctalia.nix
        ./niri.nix
        ./hypridle.nix
        
    ];
}