{ pkgs,... }:

{
    services.desktopManager.cosmic.enable = true;
    services.desktopManager.cosmic.xwayland.enable = true;
    environment.systemPackages = with pkgs; [ 
        cosmic-protocols
        cosmic-ext-tweaks
        cosmic-store
    ];
}