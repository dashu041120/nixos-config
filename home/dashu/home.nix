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
    stateVersion = "26.05";
    shell.enableZshIntegration = true;
    shell.enableBashIntegration = true;
    # Install Home Manager CLI（已通过 flake 管理，无需重复安装）
    # packages = with pkgs; [
    #   home-manager
    # ];
  };
  
  # home.file.".config/plasma-workspace/env/nix.sh".text = ''
  #   # Ensure Nix environment is available in Plasma (SDDM) sessions.
  #   for nix_init in \
  #     /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
  #     /nix/var/nix/profiles/default/etc/profile.d/nix.sh \
  #     /etc/profile.d/nix-daemon.sh \
  #     /etc/profile.d/nix.sh; do
  #     if [ -r "$nix_init" ]; then
  #       . "$nix_init"
  #       break
  #     fi
  #   done

    # if [ -d "$HOME/.cargo/bin" ]; then
    #   export PATH="$HOME/.cargo/bin:$PATH"
    # fi
  
  #   if ! command -v nix >/dev/null 2>&1 && [ -d /nix/var/nix/profiles/default/bin ]; then
  #     export PATH="/nix/var/nix/profiles/default/bin:$PATH"
  #   fi
  # '';
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
}
