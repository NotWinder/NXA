{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib) getExe;
  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  config = mkIf (env.desktop == "niri") {
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
    hm = {
      home.packages = with pkgs; [
        xwayland-satellite
        gnome-keyring
      ];
      programs.niri = {
        settings = {
          spawn-at-startup = [{argv = ["dms" "run"];}];
          input = {
            keyboard = {
              numlock = true;
            };

            mouse.accel-speed = 1.0;
            touchpad = {
              tap = true;
              dwt = true;
              natural-scroll = true;
              click-method = "clickfinger";
            };

            warp-mouse-to-focus.enable = true;
          };

          overview = {
            workspace-shadow = {
              enable = false;
            };
          };
          outputs."HDMI-A-1" = {
            mode = {
              height = 2160;
              width = 3840;
              refresh = 60.000;
            };
          };

          layout = {
            gaps = 14;

            background-color = "transparent";
            center-focused-column = "never";

            preset-column-widths = [
              {proportion = 0.33333;}
              {proportion = 0.5;}
              {proportion = 0.66667;}
              {proportion = 1.0;}
            ];

            default-column-width = {proportion = 1.0;};
            focus-ring.enable = false;

            border.enable = false;

            shadow = {
              softness = 30;

              spread = 5;

              offset = {
                x = 0;
                y = 5;
              };

              color = "#0007";
            };
          };

          hotkey-overlay = {
            skip-at-startup = true;
          };
          prefer-no-csd = true;
          screenshot-path = "~/Media/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          window-rules = [
            {
              matches = [
                {
                  app-id = ''r#"firefox$"# title="^Picture-in-Picture$"'';
                }
              ];
              open-floating = true;
            }
            {
              geometry-corner-radius = let
                radius = 13.0;
              in {
                top-left = radius;
                top-right = radius;
                bottom-left = radius;
                bottom-right = radius;
              };
              clip-to-geometry = true;
              draw-border-with-background = false;
            }
            {
              matches = [
                {app-id = ''r#"^org\.keepassxc\.KeePassXC$"#'';}

                {app-id = ''r#"^org\.gnome\.World\.Secrets$"#'';}
              ];
              block-out-from = "screen-capture";
            }
          ];

          layer-rules = [
            {
              matches = [{namespace = "^quickshell$";}];
              place-within-backdrop = true;
            }
          ];

          binds = with config.hm.lib.niri.actions; let
            sh = spawn "sh" "-c";
          in {
            "Mod+Q".action = spawn "alacritty";

            "Mod+E".action = spawn "dolphin";
            "Mod+G".action = spawn "${prg.default.browser}";
            "Super+Alt+L".action = spawn "swaylock";

            "Super+Alt+S" = {
              allow-when-locked = true;
              action = sh "pkill orca || exec orca";
            };

            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
            };

            "Mod+O" = {
              repeat = false;
              action = toggle-overview;
            };

            "Mod+C" = {
              repeat = false;
              action = close-window;
            };

            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-down;
            "Mod+Up".action = focus-window-up;
            "Mod+Right".action = focus-column-right;
            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-workspace-down;
            "Mod+K".action = focus-workspace-up;
            "Mod+L".action = focus-column-right;

            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Down".action = move-window-down;
            "Mod+Shift+Up".action = move-window-up;
            "Mod+Shift+Right".action = move-column-right;
            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+J".action = move-window-to-workspace-up;
            "Mod+Shift+K".action = move-window-to-workspace-down;
            "Mod+Shift+L".action = move-column-right;

            "Mod+Home".action = focus-column-first;
            "Mod+End".action = focus-column-last;
            "Mod+Ctrl+Home".action = move-column-to-first;
            "Mod+Ctrl+End".action = move-column-to-last;

            "Mod+Ctrl+Left".action = focus-monitor-left;
            "Mod+Ctrl+Down".action = focus-monitor-down;
            "Mod+Ctrl+Up".action = focus-monitor-up;
            "Mod+Ctrl+Right".action = focus-monitor-right;
            "Mod+Ctrl+H".action = focus-monitor-left;
            "Mod+Ctrl+J".action = focus-monitor-down;
            "Mod+Ctrl+K".action = focus-monitor-up;
            "Mod+Ctrl+L".action = focus-monitor-right;

            "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
            "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;
            "Mod+U".action = focus-workspace-down;
            "Mod+I".action = focus-workspace-up;
            "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
            "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
            "Mod+Ctrl+U".action = move-column-to-workspace-down;
            "Mod+Ctrl+I".action = move-column-to-workspace-up;

            "Mod+Shift+Page_Down".action = move-workspace-down;
            "Mod+Shift+Page_Up".action = move-workspace-up;
            "Mod+Shift+U".action = move-workspace-down;
            "Mod+Shift+I".action = move-workspace-up;

            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action = focus-workspace-down;
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action = focus-workspace-up;
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-down;
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action = move-column-to-workspace-up;
            };

            "Mod+WheelScrollRight".action = focus-column-right;
            "Mod+WheelScrollLeft".action = focus-column-left;
            "Mod+Ctrl+WheelScrollRight".action = move-column-right;
            "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

            "Mod+Shift+WheelScrollDown".action = focus-column-right;
            "Mod+Shift+WheelScrollUp".action = focus-column-left;
            "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
            "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

            "Mod+1".action = focus-workspace 1;
            "Mod+2".action = focus-workspace 2;
            "Mod+3".action = focus-workspace 3;
            "Mod+4".action = focus-workspace 4;
            "Mod+5".action = focus-workspace 5;
            "Mod+6".action = focus-workspace 6;
            "Mod+7".action = focus-workspace 7;
            "Mod+8".action = focus-workspace 8;
            "Mod+9".action = focus-workspace 9;
            "Mod+0".action = focus-workspace 10;

            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+R".action = switch-preset-column-width;
            "Mod+Shift+R".action = switch-preset-window-height;
            "Mod+Ctrl+R".action = reset-window-height;
            "Mod+W".action = maximize-column;
            "Mod+F".action = fullscreen-window;

            "Mod+Ctrl+F".action = expand-column-to-available-width;

            "Mod+Shift+C".action = center-column;

            "Mod+Ctrl+C".action = center-visible-columns;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            "Mod+V".action = toggle-window-floating;
            "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

            "Mod+T".action = toggle-column-tabbed-display;

            "Print".action.screenshot = {show-pointer = false;};
            #"Ctrl+Print".action.screenshot = {screenshot-screen = true;};
            #"Alt+Print".action.screenshot = {screenshot-window = true;};

            "Mod+Escape" = {
              allow-inhibiting = false;
              action = toggle-keyboard-shortcuts-inhibit;
            };

            "Mod+Shift+E".action = quit;
            "Ctrl+Alt+Delete".action = quit;

            "Mod+Shift+P".action = power-off-monitors;

            "Mod+D".action = sh "dms ipc call spotlight toggle";

            "Ctrl+L".action = sh "dms ipc call lock lock";
          };
          xwayland-satellite = {
            enable = true;
            path = getExe pkgs.xwayland-satellite;
          };
        };
      };
    };
  };
}
