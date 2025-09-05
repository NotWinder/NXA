{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config.hm = mkIf (elem "quickshell/noctalia" prg.bar && env.desktop != "none") {
    home.packages = [
      inputs'.noctalia-shell.packages.default
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "noctalia-shell"
      ];
      bind = [
        "$MOD+SHIFT, R, exec, noctalia-shell kill | sleep 1 | noctalia-shell"
        "$MOD, D, exec, noctalia-shell ipc call appLauncher toggle"
        "$MOD, L, exec, noctalia-shell ipc call lockScreen toggle"
        "$MOD, H, exec, noctalia-shell ipc call notifications toggleHistory"
      ];
    };
  };
}
