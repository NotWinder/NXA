{ pkgs
, lib
, osConfig
, ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib) getExe;
in
{
  imports = [
    ./binds.nix
    ./rules.nix
  ];

  config = mkIf osConfig.custom.programs.niri.enable {
    home.packages = with pkgs; [
      xwayland-satellite
      gnome-keyring
    ];
    programs.niri = {
      settings = {
        input = {
          keyboard = {
            numlock = true;
          };

          touchpad = {
            tap = true;
            dwt = true;
            natural-scroll = true;
            click-method = "clickfinger";
          };

          warp-mouse-to-focus.enable = true;
        };

        overview = {
          workspace-shadow = {
            enable = false;
          };
        };
        outputs."HDMI-A-1" = {
          mode = {
            height = 2160;
            width = 3840;
            refresh = 60.000;
          };
        };

        layout = {
          gaps = 14;

          background-color = "transparent";
          center-focused-column = "never";

          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
            { proportion = 1.0; }
          ];

          default-column-width = { proportion = 1.0; };
          focus-ring.enable = false;

          border.enable = false;

          shadow = {
            softness = 30;

            spread = 5;

            offset = {
              x = 0;
              y = 5;
            };

            color = "#0007";
          };
        };

        hotkey-overlay = {
          skip-at-startup = true;
        };
        prefer-no-csd = true;
        screenshot-path = "~/Media/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        xwayland-satellite = {
          enable = true;
          path = getExe pkgs.xwayland-satellite;
        };
      };
    };
  };
}
