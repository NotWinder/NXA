{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.custom.programs.dms = {
    enable = lib.mkEnableOption "Enable Niri as a window manager";
  };

  config.hm = {
    imports = [
      inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    ];
    programs.dankMaterialShell = mkIf config.custom.programs.dms.enable {
      enable = true;
    };
    programs.niri = mkIf (config.custom.programs.niri.enable && config.custom.programs.dms.enable) {
      settings = {
        spawn-at-startup = [{argv = ["dms" "run"];}];

        layer-rules = [
          {
            matches = [{namespace = "^quickshell$";}];
            place-within-backdrop = true;
          }
        ];

        binds = with config.hm.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          "Mod+D".action = sh "dms ipc call spotlight toggle";
          "Ctrl+L".action = sh "dms ipc call lock lock";
        };
      };
    };
    wayland.windowManager.hyprland = mkIf (config.custom.programs.hyprland.enable && config.custom.programs.dms.enable) {
      settings = {
        exec-once = [
          "dms run"
        ];
        bind = [
          "$MOD, D, exec, dms ipc call spotlight toggle"
          "Ctrl, L, exec, dms ipc call lock lock"
        ];
      };
    };
  };
}
