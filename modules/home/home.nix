{username, pkgs, ...}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
    
    # Install Home Manager CLI（已通过 flake 管理，无需重复安装）
    # packages = with pkgs; [
    #   home-manager
    # ];
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
