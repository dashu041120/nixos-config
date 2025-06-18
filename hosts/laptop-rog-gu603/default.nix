{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  

  networking.hostName = "dashu-rog16"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  sound.enable = true;
  security.rtkit.enable = true; # PipeWire 推荐开启

  #for Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  }


  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    # tlp.settings = {
    #   CPU_ENERGY_PERF_POLICY_ON_AC = "power";
    #   CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    #   CPU_BOOST_ON_AC = 1;
    #   CPU_BOOST_ON_BAT = 1;

    #   CPU_HWP_DYN_BOOST_ON_AC = 1;
    #   CPU_HWP_DYN_BOOST_ON_BAT = 1;

    #   PLATFORM_PROFILE_ON_AC = "performance";
    #   PLATFORM_PROFILE_ON_BAT = "balance";

    #   INTEL_GPU_MIN_FREQ_ON_AC = 500;
    #   INTEL_GPU_MIN_FREQ_ON_BAT = 500;
      # INTEL_GPU_MAX_FREQ_ON_AC=0;
      # INTEL_GPU_MAX_FREQ_ON_BAT=0;
      # INTEL_GPU_BOOST_FREQ_ON_AC=0;
      # INTEL_GPU_BOOST_FREQ_ON_BAT=0;

      # PCIE_ASPM_ON_AC = "default";
      # PCIE_ASPM_ON_BAT = "powersupersave";
    # };
  };

  powerManagement.cpuFreqGovernor = "balance";

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];
  };
}

