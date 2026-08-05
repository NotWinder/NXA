# Closure-captured home-manager aspect for Hyprpaper (Phase 3c step 4).
#
# Loaded into the flake-parts module space; closes over `inputs'` so the
# hyprpaper package remains available without `extraSpecialArgs`.
{ inputs', ... }: {
  flake.modules.homeManager.hyprpaper = { lib, osConfig, ... }:
    let
      inherit (lib) mkIf;

      hyprpaper = inputs'.hyprpaper.packages.default;
    in
    {
      config = mkIf osConfig.custom.programs.hyprpaper.enable {
        services.hyprpaper = {
          enable = true;
          package = hyprpaper;
          settings = {
            ipc = "on";
            splash = false;
          };
        };
      };
    };
}
