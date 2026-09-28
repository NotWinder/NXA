{ inputs, ... }:
{
  flake.modules.homeManager.dankMaterial = { config, lib, osConfig, pkgs, ... }:
    let
      inherit (lib) mkIf;
    in
    {
      home.packages = [
        inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.quickshell
      ];

      programs.niri = mkIf (osConfig.custom.programs.niri.enable && osConfig.custom.programs.dms.enable) {
        settings = {
          layer-rules = [
            {
              matches = [{ namespace = "^quickshell$"; }];
              place-within-backdrop = true;
            }
          ];

          binds = with config.lib.niri.actions; let
            sh = spawn "sh" "-c";
          in
          {
            "Mod+D".action = sh "dms ipc call spotlight toggle";
            "Ctrl+L".action = sh "dms ipc call lock lock";
            "Mod+Escape" = {
              allow-when-locked = true;
              action = sh "dms ipc call powermenu toggle";
            };
          };
        };
      };

      wayland.windowManager.hyprland = mkIf (osConfig.custom.programs.hyprland.enable && osConfig.custom.programs.dms.enable) {
        settings = {
          exec-once = [ "dms run" ];
          bind = [
            "$MOD, D, exec, dms ipc call spotlight toggle"
            "Ctrl, L, exec, dms ipc call lock lock"
            "$MOD, Escape, exec, dms ipc call powermenu toggle"
          ];
        };
      };
    };
}
