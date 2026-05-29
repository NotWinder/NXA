{
  inputs,
  inputs',
  pkgs,
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
    home.packages = [
      pkgs.gpu-screen-recorder
    ];
    programs.caelestia = mkIf (elem "quickshell/caelestia" prg.bar && env.desktop != "none") {
      enable = true;
      systemd.enable = false;
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
        appearance = {
          anim = {
            durations = {
              scale = 1;
            };
          };
          font = {
            family = {
              material = "Material Symbols Rounded";
              mono = "CaskaydiaCove NF";
              sans = "Rubik";
            };
            size = {
              scale = 0.8;
            };
          };
          padding = {
            scale = 0.8;
          };
          rounding = {
            scale = 0.8;
          };
          spacing = {
            scale = 0.8;
          };
          transparency = {
            enabled = false;
            base = 0.85;
            layers = 0.4;
          };
        };
        general = {
          apps = {
            terminal = ["alacritty"];
            audio = ["pavucontrol-qt"];
            playback = ["mpv"];
            explorer = ["thunar"];
          };

          battery = {
            warnLevels = [
              {
                level = 20;
                title = "Low battery";
                message = "You might want to plug in a charger";
                icon = "battery_android_frame_2";
              }
              {
                level = 10;
                title = "Did you see the previous message?";
                message = "You should probably plug in a charger <b>now</b>";
                icon = "battery_android_frame_1";
              }
              {
                level = 5;
                title = "Critical battery level";
                message = "PLUG THE CHARGER RIGHT NOW!!";
                icon = "battery_android_alert";
                critical = true;
              }
            ];
            criticalLevel = 3;
          };
          idle = {
            lockBeforeSleep = true;
            inhibitWhenAudio = true;
            timeouts = [
              {
                timeout = 6000;
                idleAction = "lock";
              }
              {
                timeout = 8000;
                idleAction = "dpms off";
                returnAction = "dpms on";
              }
              {
                timeout = 9000;
                idleAction = ["systemctl" "suspend-then-hibernate"];
              }
            ];
          };
        };
        background = {
          desktopClock = {
            enabled = true;
          };
          enabled = true;
          visualiser = {
            enabled = false;
            autoHide = true;
            rounding = 0.8;
            spacing = 0.8;
          };
        };
        bar = {
          clock = {
            showIcon = true;
          };
          dragThreshold = 50;
          entries = [
            {
              id = "logo";
              enabled = true;
            }
            {
              id = "workspaces";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "activeWindow";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "tray";
              enabled = true;
            }
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "statusIcons";
              enabled = true;
            }
            {
              id = "power";
              enabled = true;
            }
          ];
          persistent = true;
          scrollActions = {
            brightness = true;
            workspaces = true;
            volume = true;
          };
          showOnHover = true;
          status = {
            showAudio = true;
            showBattery = true;
            showBluetooth = true;
            showKbLayout = false;
            showMicrophone = false;
            showNetwork = true;
            showLockStatus = true;
          };
          tray = {
            background = false;
            compact = false;
            iconSubs = [];
            recolour = false;
          };
          workspaces = {
            activeIndicator = true;
            activeLabel = "󰮯";
            activeTrail = false;
            label = "  ";
            occupiedBg = false;
            occupiedLabel = "󰮯";
            perMonitorWorkspaces = true;
            showWindows = true;
            shown = 5;
          };
        };
        border = {
          rounding = 25;
          thickness = 10;
        };
        dashboard = {
          enabled = true;
          dragThreshold = 50;
          mediaUpdateInterval = 500;
          showOnHover = true;
        };
        launcher = {
          actionPrefix = ">";
          actions = [
            {
              name = "Calculator";
              icon = "calculate";
              description = "Do simple math equations (powered by Qalc)";
              command = ["autocomplete" "calc"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Scheme";
              icon = "palette";
              description = "Change the current colour scheme";
              command = ["autocomplete" "scheme"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Wallpaper";
              icon = "image";
              description = "Change the current wallpaper";
              command = ["autocomplete" "wallpaper"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Variant";
              icon = "colors";
              description = "Change the current scheme variant";
              command = ["autocomplete" "variant"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Transparency";
              icon = "opacity";
              description = "Change shell transparency";
              command = ["autocomplete" "transparency"];
              enabled = false;
              dangerous = false;
            }
            {
              name = "Random";
              icon = "casino";
              description = "Switch to a random wallpaper";
              command = ["caelestia" "wallpaper" "-r"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Light";
              icon = "light_mode";
              description = "Change the scheme to light mode";
              command = ["setMode" "light"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Dark";
              icon = "dark_mode";
              description = "Change the scheme to dark mode";
              command = ["setMode" "dark"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Shutdown";
              icon = "power_settings_new";
              description = "Shutdown the system";
              command = ["systemctl" "poweroff"];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Reboot";
              icon = "cached";
              description = "Reboot the system";
              command = ["systemctl" "reboot"];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Logout";
              icon = "exit_to_app";
              description = "Log out of the current session";
              command = ["loginctl" "terminate-user" ""];
              enabled = true;
              dangerous = true;
            }
            {
              name = "Lock";
              icon = "lock";
              description = "Lock the current session";
              command = ["loginctl" "lock-session"];
              enabled = true;
              dangerous = false;
            }
            {
              name = "Sleep";
              icon = "bedtime";
              description = "Suspend then hibernate";
              command = ["systemctl" "suspend-then-hibernate"];
              enabled = true;
              dangerous = false;
            }
          ];
          dragThreshold = 50;
          vimKeybinds = true;
          enableDangerousActions = false;
          maxShown = 7;
          maxWallpapers = 9;
          specialPrefix = "@";
          useFuzzy = {
            apps = false;
            actions = false;
            schemes = false;
            variants = false;
            wallpapers = false;
          };
          showOnHover = false;
          hiddenApps = [];
        };
        lock = {
          recolourLogo = false;
        };
        notifs = {
          actionOnClick = false;
          clearThreshold = 0.3;
          defaultExpireTimeout = 5000;
          expandThreshold = 20;
          expire = true;
        };
        osd = {
          enabled = true;
          enableBrightness = true;
          enableMicrophone = false;
          hideDelay = 2000;
        };
        paths = {
          mediaGif = "root:/assets/bongocat.gif";
          sessionGif = "root:/assets/kurukuru.gif";
          wallpaperDir = "${winpaper.wallpkgs}/share/wallpapers/";
        };
        services = {
          audioIncrement = 0.1;
          defaultPlayer = "Spotify";
          gpuType = "";
          #playerAliases= [{ "from": "com.github.th_ch.youtube_music"; "to": "YT Music" }]p
          weatherLocation = "zahedan";
          useFahrenheit = false;
          useTwelveHourClock = false;
          smartScheme = true;
          visualiserBars = 45;
        };
        session = {
          dragThreshold = 30;
          enabled = true;
          vimKeybinds = true;
          commands = {
            logout = ["loginctl" "terminate-user" ""];
            shutdown = ["systemctl" "poweroff"];
            hibernate = ["systemctl" "hibernate"];
            reboot = ["systemctl" "reboot"];
          };
        };
        sidebar = {
          dragThreshold = 50;
          enabled = true;
        };
        utilities = {
          enabled = true;
          maxToasts = 4;
          toasts = {
            audioInputChanged = true;
            audioOutputChanged = true;
            capsLockChanged = false;
            chargingChanged = false;
            configLoaded = true;
            dndChanged = true;
            gameModeChanged = true;
            numLockChanged = false;
          };
        };
      };
    };
    wayland.windowManager.hyprland.settings = mkIf (elem "quickshell/caelestia" prg.bar && env.desktop != "none") {
      exec-once = mkIf (!config.hm.programs.caelestia.systemd.enable) [
        "caelestia shell -d && caelestia shell lock lock"
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
          "$MOD, L, global, caelestia:lock"
          "$MOD, Escape, global, caelestia:session"
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
