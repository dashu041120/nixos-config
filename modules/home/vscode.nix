{ programs, pkgs, ... }:

{
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      # isInsiders = false;
      # Options = 
      # [
      #   # https://wiki.archlinux.org/title/Wayland#Electron
      #   "--ozone-platform-hint=auto"
      #   "--ozone-platform=wayland"
      #   # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
      #   # (only supported by chromium/chrome at this time, not electron)
      #   "--gtk-version=4"
      #   # make it use text-input-v1, which works for kwin 5.27 and weston
      #   "--enable-wayland-ime"
      #   # "--password-store=gnome" # use gnome-keyring as password store
      # ];
      extensions = with pkgs.vscode-extensions; [
        ms-python.python            # Python support
        ms-toolsai.jupyter          # Jupyter support
        ms-vscode.cpptools          # C/C++ support
        esbenp.prettier-vscode      # Code formatter
        dbaeumer.vscode-eslint      # ESLint support
        eamodio.gitlens             # GitLens for Git integration
        ms-azuretools.vscode-docker # Docker support
      ];
    };
  };
}