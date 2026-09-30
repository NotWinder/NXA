{
  # DankMaterialShell compositor integration. The shell itself (packages and
  # the dms user service) comes from the NixOS side in
  # modules/system/display/wayland/dms.nix; this aspect only adds binds and
  # layer rules, and is inert unless custom.programs.dms.enable is set.
  flake.modules.homeManager.dankMaterial = { config, lib, osConfig, ... }:
    let
      inherit (lib) mkIf mkForce;

      dms = osConfig.custom.programs.dms.enable;
    in
    {
      programs.niri = mkIf (osConfig.custom.programs.niri.enable && dms) {
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
            # Replaces the swaylock bind from the niri aspect; Ctrl+L is left
            # to terminals and browsers.
            "Super+Alt+L".action = mkForce (sh "dms ipc call lock lock");
            "Mod+Escape" = {
              allow-when-locked = true;
              action = sh "dms ipc call powermenu toggle";
            };
          };
        };
      };

      wayland.windowManager.hyprland = mkIf (osConfig.custom.programs.hyprland.enable && dms) {
        settings = {
          # Hyprland's systemd integration is off here, so graphical-session.target
          # may never activate; start the dms unit explicitly.
          exec-once = [ "systemctl --user start dms.service" ];
          bind = [
            "$MOD, D, exec, dms ipc call spotlight toggle"
            "$MOD ALT, L, exec, dms ipc call lock lock"
            "$MOD, Escape, exec, dms ipc call powermenu toggle"
          ];
        };
      };
    };
}
