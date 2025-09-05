{
  inputs,
  inputs',
  lib,
  config,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf optionals;
  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;

  winpaper = inputs'.winpaper.packages;
in {
  config.hm = {
    imports = [inputs.caelestia-shell.homeManagerModules.default];
    systemd.user.sessionVariables = mkIf (elem "quickshell/caelestia" prg.bar && env.desktop != "none") {
      CAELESTIA_WALLPAPERS_DIR = "${winpaper.wallpkgs}/share/wallpapers/";
    };
    programs.caelestia = mkIf (elem "quickshell/caelestia" prg.bar && env.desktop != "none") {
      enable = true;
      cli = {
        enable = true;
        settings = {
          theme = {
            enableTerm = false;
            enableHypr = false;
            enableDiscord = false;
            enableSpicetify = false;
            enableFuzzel = false;
            enableBtop = false;
            enableGtk = false;
            enableQt = false;
          };
        };
      };
      settings = {
        paths.wallpaperDir = "${winpaper.wallpkgs}/share/wallpapers/";

        border = {
          rounding = 10;
          thickness = 5;
        };

        bar = {
          status = {
            showAudio = true;
          };
        };

        background = {
          desktopClock = {
            enabled = true;
          };
          enabled = true;
          visualiser = {
            enabled = true;
            autoHide = true;
            rounding = "1";
            spacing = "1";
          };
        };

        services = {
          audioIncrement = 0.1;
          weatherLocation = "zahedan";
          useFahrenheit = false;
          useTwelveHourClock = false;
          smartScheme = true;
        };

        osd = {
          enabled = true;
          enableBrightness = false;
          enableMicrophone = true;
          hideDelay = "2000";
        };

        general = {
          apps = {
            terminal = ["alacritty"];
            audio = ["pavucontrol"];
          };
        };
      };
    };
    wayland.windowManager.hyprland.settings = mkIf (elem "quickshell/caelestia" prg.bar && env.desktop != "none") {
      exec-once = mkIf (!config.hm.programs.caelestia.systemd.enable) [
        "caelestia-shell"
      ];

      bind =
        [
          "Ctrl+Alt, C, global, caelestia:clearNotifs"
          ", XF86AudioPlay, global, caelestia:mediaToggle"
          ", XF86AudioPause, global, caelestia:mediaToggle"
          ", XF86AudioNext, global, caelestia:mediaNext"
          ", XF86AudioPrev, global, caelestia:mediaPrev"
          ", XF86AudioStop, global, caelestia:mediaStop"
          "$MOD+SHIFT, Space, global, caelestia:mediaToggle"
          "$MOD+SHIFT, Equal, global, caelestia:mediaNext"
          "$MOD+SHIFT, Minus, global, caelestia:mediaPrev"
          "$MOD, K, global, caelestia:showall"
          "$MOD, D, global, caelestia:launcher"
        ]
        ++ optionals (!config.hm.programs.caelestia.systemd.enable) [
          "$MOD+SHIFT, R, exec, caelestia-shell kill | sleep 1 | caelestia-shell"
        ]
        ++ optionals config.hm.programs.caelestia.systemd.enable [
          "$MOD+SHIFT, R, exec, systemctl --user restart caelestia.service"
        ];

      bindin = [
        #"Super, catchall, global, caelestia:launcherInterrupt"
        "$MOD, mouse:272, global, caelestia:launcherInterrupt"
        "$MOD, mouse:273, global, caelestia:launcherInterrupt"
        "$MOD, mouse:275, global, caelestia:launcherInterrupt"
        "$MOD, mouse:276, global, caelestia:launcherInterrupt"
        "$MOD, mouse:277, global, caelestia:launcherInterrupt"
        "$MOD, mouse_down, global, caelestia:launcherInterrupt"
        "$MOD, mouse_up, global, caelestia:launcherInterrupt"
      ];
    };
  };
}
