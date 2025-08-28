{ programs, pkgs, ... }:

{
  programs.oh-my-posh = {
    enable = false;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    useTheme = "catppuccin_mocha";
  };
}
