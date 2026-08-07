# Per-user home-manager aspect for the brau1589 host (Phase 3d).
#
# Composes the shared aspects this user wants; per-user deltas belong here,
# not in the shared files.
{ self, ... }: {
  flake.modules.homeManager.brau1589 = { config, pkgs, lib, osConfig, ... }:
    let
      inherit (lib) mkIf;

      # Cycle power profiles (power-saver -> balanced -> performance) via
      # power-profiles-daemon and notify the result.
      profile-cycle = pkgs.writeShellScriptBin "profile-cycle" ''
        current="$(powerprofilesctl get)"
        case "$current" in
          power-saver) next="balanced" ;;
          balanced) next="performance" ;;
          *) next="power-saver" ;;
        esac
        powerprofilesctl set "$next"
        notify-send -a 'power' 'Power profile' "$next"
      '';
    in
    {
      imports = [
        self.modules.homeManager.base
        self.modules.homeManager.cli
        self.modules.homeManager.gui
        self.modules.homeManager.themes
        self.modules.homeManager.misc
      ];

      config = {
        home.packages = [ profile-cycle ];

        wayland.windowManager.niri.settings.binds = mkIf osConfig.custom.programs.niri.enable {
          "Mod+F5".action = "spawn profile-cycle";
        };

        wayland.windowManager.hyprland.settings.bind = mkIf osConfig.custom.programs.hyprland.enable [
          "$MOD, F5, exec, profile-cycle"
        ];
      };
    };
}
