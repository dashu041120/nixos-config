{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types mkIf;

  # Theme variant definitions
  themeVariants = {
    "Marathon-MapScreen" = {
      resolutions = {
        "1600x900"  = "theme_900p.txt";
        "1920x1080" = "theme_1080p.txt";
        "2560x1440" = "theme_1440p.txt";
      };
    };
    "Marathon-NewCascadia" = {
      resolutions = {
        "1600x900"  = "theme_900p-1080p.txt";
        "1920x1080" = "theme_900p-1080p.txt";
        "2560x1440" = "theme_1440p.txt";
      };
    };
    "Marathon-TitleScreen" = {
      resolutions = {
        "1600x900"  = "theme_900p.txt";
        "1920x1080" = "theme_1080p.txt";
        "2560x1440" = "theme_1440p.txt";
      };
    };
    "Marathon-UESC" = {
      resolutions = {
        "1600x900"  = "theme_900p.txt";
        "1920x1080" = "theme_1080p.txt";
        "2560x1440" = "theme_1440p.txt";
      };
    };
  };

  # Build the theme derivation
  # Usage: marathon-theme { variant = "Marathon-TitleScreen"; resolution = "1920x1080"; }
  # Or override: (marathon-theme {}).override { variant = "Marathon-UESC"; }
  marathon-theme =
    {
      variant ? "Marathon-TitleScreen",
      resolution ? "1920x1080",
    }:
    let
      variantConfig = themeVariants.${variant}
        or (throw "Unknown Marathon theme variant: ${variant}. Available: ${builtins.toString (builtins.attrNames themeVariants)}");
      themeFile = variantConfig.resolutions.${resolution}
        or (throw "Unsupported resolution ${resolution} for ${variant}. Available: ${builtins.toString (builtins.attrNames variantConfig.resolutions)}");
    in
    pkgs.stdenv.mkDerivation {
      pname = "marathon-grub-theme-${variant}";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "Woysful";
        repo = "Marathon-Grub-Themes";
        rev = "main";
        hash = "sha256-WcPuFoyIESUwSmOa6wK6+3p7O13l+eziHU4jIEIY9Pw=";
      };

      installPhase = ''
        mkdir -p $out/grub/themes/marathon
        cd ${variant}

        # Copy all assets (fonts, icons, images, selection graphics)
        cp -r . $out/grub/themes/marathon/

        # Rename the selected resolution theme.txt as the default theme.txt
        cp ${themeFile} $out/grub/themes/marathon/theme.txt
      '';

      meta = with lib; {
        description = "Marathon GRUB Theme - ${variant} (${resolution})";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };

in
{
  options.boot.loader.grub.marathon-theme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Marathon GRUB theme.";
    };

    variant = mkOption {
      type = types.enum (builtins.attrNames themeVariants);
      default = "Marathon-TitleScreen";
      description = ''
        Theme variant to use.

        Available variants:
        - Marathon-MapScreen: Map-screen style with sidebar boot menu
        - Marathon-NewCascadia: Minimalist terminal-style with New Cascadia font
        - Marathon-TitleScreen: Title-screen style with boot menu on the left
        - Marathon-UESC: UESC styled with green accents and centered boot menu
      '';
    };

    resolution = mkOption {
      type = types.enum [ "1600x900" "1920x1080" "2560x1440" ];
      default = "1920x1080";
      description = ''
        Screen resolution for the theme.

        Supported: 1600x900, 1920x1080, 2560x1440.
        Themes will not display correctly at unsupported resolutions.
      '';
    };
  };

  config = mkIf config.boot.loader.grub.marathon-theme.enable {
    boot.loader.grub =
      let
        cfg = config.boot.loader.grub.marathon-theme;
        theme = marathon-theme {
          inherit (cfg) variant resolution;
        };
      in
      {
        theme = "${theme}/grub/themes/marathon";
      };
  };
}
