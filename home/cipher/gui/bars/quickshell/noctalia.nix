{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.custom.programs.noctalia-shell = {
    enable = lib.mkEnableOption "Enable Noctalia Shell";
  };
  config.hm = mkIf config.custom.programs.noctalia-shell.enable {
    home.packages = [
      inputs'.noctalia-shell.packages.default
    ];

    programs.niri = mkIf (config.custom.programs.niri.enable && config.custom.programs.dms.enable) {
      settings = {
        spawn-at-startup = [{argv = ["noctalia-shell"];}];

        layer-rules = [
          {
            matches = [{namespace = "^quickshell$";}];
            place-within-backdrop = true;
          }
        ];

        binds = with config.hm.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          "Mod+D".action = sh "noctalia-shell ipc call appLauncher toggle";
          "Ctrl+L".action = sh "noctalia-shell ipc call lockScreen toggle";
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.custom.programs.hyprland.enable && config.custom.programs.noctalia-shell.enable) {
      settings = {
        exec-once = [
          "noctalia-shell"
        ];
        bind = [
          "$MOD+SHIFT, R, exec, noctalia-shell kill | sleep 1 | noctalia-shell"
          "$MOD, D, exec, noctalia-shell ipc call appLauncher toggle"
          "Ctrl, L, exec, noctalia-shell ipc call lockScreen toggle"
          "$MOD, H, exec, noctalia-shell ipc call notifications toggleHistory"
        ];
      };
    };
  };
}
