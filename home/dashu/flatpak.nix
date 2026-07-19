{ pkgs, lib, ... }:
{
  services.flatpak = {
    enable = true;
    update.onActivation = true;

    remotes = [
      { name = "flathub"; location = "https://mirrors.cernet.edu.cn/flathub"; }
    ];

    packages = [
      "com.github.tchx84.Flatseal"
      "com.usebottles.bottles"
      "com.github.Matoking.protontricks"
      "com.github.vikdevelop.ProtonPlus"
      "com.github.nickvdp.CrossMacro"
      "io.github.flattool.Warehouse"
      "io.missioncenter.MissionCenter"
      # "io.podman_desktop.PodmanDesktop"
      "net.davidotek.pupgui2"
      # "org.kde.kdenlive"
      "io.github.vikdevelop.SaveDesktop"
    ];
  };
}
