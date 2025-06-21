{ pkgs, username, ... }:
{
    # 暂时不用nh
    #TODO  : enable nh for garbage collection
#   programs.nh = {
#     enable = true;
#     clean = {
#       enable = true;
#       extraArgs = "--keep-since 7d --keep 5";
#     };
#     flake = "/home/${username}/nixos-config";
#   };

#   environment.systemPackages = with pkgs; [
#     # add useful tools for monitoring and cleaning up
#     nix-collect-garbage
#     nh
#     nix-output-monitor
#     nvd
#   ];

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic =  true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

