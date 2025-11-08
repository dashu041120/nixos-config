{ programs, pkgs, ... }:

{
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;

      # profiles.default.extensions = with pkgs.vscode-extensions; [
      #   ms-python.python            # Python support
      #   ms-toolsai.jupyter          # Jupyter support
      #   ms-vscode.cpptools          # C/C++ support
      #   esbenp.prettier-vscode      # Code formatter
      #   dbaeumer.vscode-eslint      # ESLint support
      #   # eamodio.gitlens             # GitLens for Git integration
      #   # ms-azuretools.vscode-docker # Docker support
      #   bbenoist.nix
      # ];
    };
  };
}