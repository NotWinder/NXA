# Closure-captured home-manager aspect for DankMaterialShell (Phase 3c step 4).
#
# This module is loaded into the flake-parts module space (auto-imported under
# `modules/home/`). Its `inputs` argument comes from flake-parts' top-level
# specialArgs, and the deferredModule below closes over it — so no
# `extraSpecialArgs` plumbing is needed in the home-manager+NixOS wiring.
{ inputs, ... }: {
  flake.modules.homeManager.dankMaterial = { config, lib, osConfig, ... }:
    let
      inherit (lib) mkIf;
    in
    {
      imports = [ inputs.dms.homeModules.default ];

      programs.dank-material-shell = mkIf osConfig.custom.programs.dms.enable {
        enable = true;
        settings = {
          iconTheme = "Papirus-Dark";
        };
      };

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
              action = sh "dms ipc powermenu toggle";
            };
          };
        };
      };

      wayland.windowManager.hyprland = mkIf (osConfig.custom.programs.hyprland.enable && osConfig.custom.programs.dms.enable) {
        settings = {
          exec-once = [
            "dms run"
          ];
          bind = [
            "$MOD, D, exec, dms ipc call spotlight toggle"
            "Ctrl, L, exec, dms ipc call lock lock"
            "$MOD, Escape, exec, dms ipc powermenu toggle"
          ];
        };
      };
    };
}
