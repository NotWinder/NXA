# niri window rules, split out of default.nix like hyprland's config/windowrule.nix.
{ lib
, osConfig
, ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf osConfig.custom.programs.niri.enable {
    programs.niri.settings = {
      window-rules = [
        {
          matches = [
            {
              app-id = ''r#"^firefox$"# title="^Picture-in-Picture$"'';
            }
          ];
          open-floating = true;
        }
        {
          geometry-corner-radius =
            let
              radius = 13.0;
            in
            {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        {
          matches = [
            { app-id = ''r#"^org\.keepassxc\.KeePassXC$"#''; }

            { app-id = ''r#"^org\.gnome\.World\.Secrets$"#''; }
          ];
          block-out-from = "screen-capture";
        }
      ];
    };
  };
}
