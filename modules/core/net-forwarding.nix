{ config, pkgs, ... }:

{
    services.tailscale.enable = true;

    # networking.firewall = {
    #     checkReversePath = "loose";
    #     allowedUDPPorts = [ 41641 ];
    # };

    environment.systemPackages = with pkgs; [
        tailscale
    ];

    # systemd.services.tailscale-autoconnect = {
    #     description = "Tailscale autoconnect";
    #     after = [ "network-online.target" "tailscaled.service" ];
    #     wants = [ "network-online.target" ];
    #     wantedBy = [ "multi-user.target" ];
    #     serviceConfig.Type = "oneshot";
    #     script = ''
    #         sleep 2
    #         status=$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)
    #         if [ $status = "Running" ]; then
    #             exit 0
    #         fi
    #         ${pkgs.tailscale}/bin/tailscale up
    #     '';
    # };
}