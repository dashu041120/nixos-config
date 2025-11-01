{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # lowLatency.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  #TODO: enable pipewire-pulse
  # hardware.alsa.enablePersistence = true;
  environment.systemPackages = with pkgs; [ pulseaudioFull ];

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  # services.pipewire.extraConfig.pipewire."92-low-latency" = {
  #   "context.properties" = {
  #     "default.clock.rate" = 48000;
  #     "default.clock.quantum" = 32;
  #     "default.clock.min-quantum" = 32;
  #     "default.clock.max-quantum" = 32;
  #   };
  # };

}
