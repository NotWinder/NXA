{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  winpaper = inputs'.winpaper.packages;
  env = modules.usrEnv;
in {
  config = mkIf (env.programs.screenlock == "hyprlock") {
    programs.hyprlock = {
      enable = true;
      package = inputs'.hyprlock.packages.default;
      settings = {
        "$font" = "Monospace";

        general = {
          hide_cursor = false;
        };

        background = {
          path = "${winpaper.wallpkgs}/share/wallpapers/Bill.png";
          blur_passes = 2;
        };

        input-field = [
          {
            size = "20%, 5%";
            outline_thickness = 3;
            inner_color = "rgba(0, 0, 0, 0.0)";

            outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
            fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

            font_color = "rgb(143, 143, 143)";
            fade_on_empty = false;
            rounding = 15;

            font_family = "$font";
            placeholder_text = "Input password...";
            fail_text = "$PAMFAIL";

            dots_spacing = 0.3;

            position = "0, -20";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            text = "$TIME";
            font_size = 90;
            font_family = "$font";

            position = "0, -150";
            halign = "center";
            valign = "top";
          }
        ];
      };
      extraConfig = "
        animations {
            enabled = true
            bezier = linear, 1, 1, 0, 0
            animation = fadeIn, 1, 5, linear
            animation = fadeOut, 1, 5, linear
            animation = inputFieldDots, 1, 2, linear
        }
    ";
    };
  };
}
