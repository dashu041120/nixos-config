{pkgs, ...}: {
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ../../home/dashu/default.nix
  ];

  programs.git = {
    settings.user = {
      name = "dashu041120";
      email = "zhangjingduan@msn.com";
    };
  };
}