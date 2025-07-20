{ programs, pkgs, ... }:

{
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    useTheme = "catppuccin_mocha";
  };
}
