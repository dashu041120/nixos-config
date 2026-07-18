{ programs, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    # package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      waveform
      pixel-art
      obs-noise
      obs-websocket
      obs-gstreamer
      obs-pipewire-audio-capture
    ];
  };

  home.packages = with pkgs; [
    v4l-utils
  ];
}