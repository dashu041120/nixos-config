{ pkgs,... }:

{
    services.desktopManager.cosmic.enable = false;
    services.desktopManager.cosmic.xwayland.enable = false;
    environment.systemPackages = with pkgs; [ 
        cosmic-protocols
        cosmic-ext-tweaks
        # cosmic-store
    ];
}