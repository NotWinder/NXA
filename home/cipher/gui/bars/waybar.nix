{ config
, lib
, ...
}:
let
  inherit (builtins) elem;
  inherit (config) custom;
  inherit (lib) mkIf;

  env = custom.usrEnv;
  prg = env.programs;
in
{
  config.hm = mkIf (elem "waybar" prg.bar && env.desktop != "none") {
    programs.waybar = {
      enable = true;
      settings = {
        bar = {
          layer = "top";
          position = "top";
          mod = "dock";
          margin-left = 10;
          margin-right = 10;
          margin-top = 7;
          margin-bottom = 0;
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          reload_style_on_change = true;

          modules-left = [
            "custom/smallspacer"
            "hyprland/workspaces"
            "custom/spacer"
            "mpris"
          ];
          modules-center = [
            "custom/padd"
            "custom/l_end"
            "custom/r_end"
            "hyprland/window"
            "custom/padd"
          ];
          modules-right = [
            "custom/padd"
            "custom/l_end"
            "group/expand"
            "network"
            "group/expand-3"
            "group/expand-2"
            "group/expand-4"
            "custom/wallchange"
            "memory"
            "cpu"
            "clock"
            "custom/notification"
            "custom/padd"
          ];

          "custom/led" = {
            format = "<span color='#021c18'>󰍿</span> <span color='#313436'></span> ";
            format-alt = "󰍿 <span color='#bbc2c7'></span> ";
            tooltip = false;
          };

          "upower" = {
            icon-size = 20;
            format = "";
            format-alt = "{}<span color='orange'>[{time}]</span>";
            tooltip = true;
            tooltip-spacing = 20;
            on-click-right = "pkill waybar & hyprctl dispatch exec waybar";
          };

          "upower#headset" = {
            format = " {percentage}";
            show-icon = false;
            tooltip = false;
          };

          "group/expand-4" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 600;
              children-class = "not-power";
              transition-to-left = true;
              click-to-reveal = true;
            };
            modules = [ "upower" "upower/headset" ];
          };

          "custom/smallspacer" = {
            format = " ";
          };
          "memory" = {
            interval = 1;
            rotate = 270;
            format = "{icon}";
            format-icons = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
            max-length = 10;
          };
          "cpu" = {
            interval = 1;
            format = "{icon}";
            rotate = 270;
            format-icons = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
          };

          "mpris" = {
            format = "{player_icon} {dynamic}";
            format-paused = "<span color='grey'>{status_icon} {dynamic}</span>";
            max-length = 50;
            player-icons = {
              default = "⏸";
              mpv = "🎵";
            };
            status-icons = {
              paused = "▶";
            };
            # ignored-players= ["firefox"]
          };

          "tray" = {
            "icon-size" = 16;
            "rotate" = 0;
            "spacing" = 3;
          };

          "group/expand" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 600;
              "children-class" = "not-power";
              "transition-to-left" = true;
              # "click-to-reveal"= true
            };
            modules = [ "custom/menu" "custom/spacer" "tray" ];
          };

          "custom/menu" = {
            format = "󰅃";
            rotate = 90;
          };

          "custom/notification" = {
            "tooltip" = false;
            "format" = "{icon}";
            "format-icons" = {
              "notification" = "󰅸";
              "none" = "󰂜";
              "dnd-notification" = "󰅸";
              "dnd-none" = "󱏨";
              "inhibited-notification" = "󰅸";
              "inhibited-none" = "󰂜";
              "dnd-inhibited-notification" = "󰅸";
              "dnd-inhibited-none" = "󱏨";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click-right" = "swaync-client -d -sw";
            "on-click" = "swaync-client -t -sw";
            "escape" = true;
          };

          "hyprland/window" = {
            #"format"= "{}"   #<--- these is the default value
            "format" = "<span  weight='bold' >{class}</span>";
            "max-length" = 120;
            "icon" = false;
            "icon-size" = 13;
          };

          "custom/power" = {
            "format" = "@{}";
            "rotate" = 0;
            "on-click" = "ags -t ControlPanel";
            "on-click-right" = "pkill ags";
            "tooltip" = true;
          };

          "custom/spacer" = {
            "format" = "|";
          };

          "hyprland/workspaces" = {
            "format" = "{icon}";
            "format-icons" = {
              "default" = "";
              "active" = "";
              #"default"= "○";
              #"default"= "●";
            };
          };

          "wlr/workspaces" = {
            "persistent-workspaces" = {
              "3" = [ ]; # Always show a workspace with name '3', on all outputs if it does not exists
              "4" = [ "eDP-1" ]; # Always show a workspace with name '4', on output 'eDP-1' if it does not exists
              "5" = [ "eDP-1" "DP-2" ]; # Always show a workspace with name '5', on outputs 'eDP-1' and 'DP-2' if it does not exists
            };
          };

          "cava" = {
            "cava_config" = "~/.config/cava/config";
            "framerate" = 60;
            "autosens" = 1;
            "bars" = 14;
            "lower_cutoff_freq" = 50;
            "higher_cutoff_freq" = 10000;
            "method" = "pulse";
            "source" = "auto";
            "stereo" = true;
            "reverse" = false;
            "bar_delimiter" = 0;
            "monstercat" = false;
            "waves" = false;
            "noise_reduction" = 0.77;
            "input_delay" = 2;
            "format-icons" = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
            "actions" = {
              "on-click-right" = "mode";
            };
          };

          "custom/script" = {
            "on-click" = "~/.config/waybar/volume.sh toggle";
            "format" = "";
          };

          "custom/cliphist" = {
            "format" = "{}";
            "rotate" = 0;
            "exec" = "echo ; echo 󰅇 clipboard history";
            "on-click" = "sleep 0.1 && cliphist.sh c";
            "on-click-right" = "sleep 0.1 && cliphist.sh d";
            "on-click-middle" = "sleep 0.1 && cliphist.sh w";
            "interval" = 86400; # once every day
            "tooltip" = true;
          };

          "custom/wbar" = {
            "format" = "𐌏{}"; #   # 
            "rotate" = 0;
            "exec" = "echo ; echo show app menu";
            "on-click" = "wofi --show drun";
            "on-click-right" = "wbarconfgen.sh p";
            "on-click-middle" = "sleep 0.1 && quickapps.sh kitty firefox spotify code dolphin";
            "interval" = 86400;
            "tooltip" = true;
          };

          "custom/theme" = {
            "format" = "{}";
            "rotate" = 0;
            "exec" = "echo ; echo 󰟡 pick color";
            "on-click" = "hyprpicker";
            "on-click-right" = "themeswitch.sh -p";
            "on-click-middle" = "sleep 0.1 && themeselect.sh";
            "interval" = 86400; # once every day
            "tooltip" = true;
          };

          "custom/wallchange" = {
            "format" = "{}";
            "rotate" = 0;
            "exec" = "echo ; echo 󰆊 switch wallpaper";
            "on-click" = "swww-random";
            "interval" = 900; # once every day
            "tooltip" = true;
          };
          "custom/mouse" = {
            "format" = "";
            "format-alt" = "";

            "on-click" = "m8mouse -dpi 1 -led 2 -speed 4";
            "on-click-right" = "m8mouse -dpi 1 -led 4 -speed 4";
            "on-click-middle" = "m8mouse -dpi 1 -led 7 -speed 4";
            "tooltip" = true;
          };

          "wlr/taskbar" = {
            "format" = "{icon}";
            "rotate" = 0;
            "icon-size" = 18;
            "icon-theme" = "Tela-circle-dracula";
            "spacing" = 0;
            "tooltip-format" = "{title}";
            "on-click" = "activate";
            "on-click-middle" = "close";
            "ignore-list" = [ "Alacritty" ];
            "app_ids-mapping" = {
              "firefoxdeveloperedition" = "firefox-developer-edition";
            };
          };

          "custom/spotify" = {
            "exec" = "mediaplayer.py --player spotify";
            "format" = " {}";
            "rotate" = 0;
            "return-type" = "json";
            "on-click" = "playerctl play-pause --player spotify";
            "on-click-right" = "playerctl next --player spotify";
            "on-click-middle" = "playerctl previous --player spotify";
            "on-scroll-up" = "volumecontrol.sh -p spotify i";
            "on-scroll-down" = "volumecontrol.sh -p spotify d";
            "max-length" = 25;
            "escape" = true;
            "tooltip" = true;
          };

          "idle_inhibitor" = {
            "format" = "{icon}";
            "rotate" = 0;
            "format-icons" = {
              "activated" = "󰥔";
              "deactivated" = "";
            };
          };

          "clock" = {
            "format" = "{:%I:%M %p}";
            "rotate" = 0;
            "on-click" = "ags -t ActivityCenter";
            "tooltip-format" = "<tt>{calendar}</tt>";
            "calendar" = {
              "mode" = "month";
              "mode-mon-col" = 3;
              "on-scroll" = 1;
              "on-click-right" = "mode";
              "format" = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                "today" = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "mode";
              "on-click-forward" = "tz_up";
              "on-click-backward" = "tz_down";
              "on-scroll-up" = "shift_up";
              "on-scroll-down" = "shift_down";
            };
          };

          "battery" = {
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 20;
            };
            "format" = "{icon}";
            "rotate" = 0;
            "format-charging" = "<span color='#a6d189'>󱐋</span>";
            "format-plugged" = "󰂄";
            # "format-alt"= "<<span weight='bold' color='#c2864a'>{time} <span weight='bold' color='white'>| <span weight='bold' color='#82d457'>{capacity}%</span></span></span>";
            "format-icons" = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
            #  "format-icons"= ["";"","","","","","",""],
            #"format-icons"= ["󰂎"; "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
            "on-click-right" = "pkill waybar & hyprctl dispatch exec waybar";
            #  "format-icons"= [<i class='fa-solid fa-wifi-slash'></i>];
          };

          "backlight" = {
            "device" = "intel_backlight";
            "rotate" = 0;
            "format" = "{icon}";
            "format-icons" = [ "󰃞" "󰃝" "󰃟" "󰃠" ];
            "scroll-step" = 1;
            "min-length" = 2;
          };

          "group/expand-2" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 600;
              "children-class" = "not-power";
              "transition-to-left" = true;
              "click-to-reveal" = true;
            };
            "modules" = [
              "backlight"
              "backlight/slider"
              "custom/smallspacer"
              "custom/led"
            ];
          };

          "group/expand-3" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 600;
              "children-class" = "not-power";
              "transition-to-left" = true;
              "click-to-reveal" = true;
            };
            "modules" = [ "pulseaudio" "pulseaudio/slider" ];
          };

          "network" = {
            "tooltip" = true;
            "format-wifi" = "{icon} ";
            "format-icons" = [ "󰤟" "󰤢" "󰤥" ];
            #  "format-wifi"= "<i class='fa-solid fa-wifi-slash'></i>";
            "rotate" = 0;
            "format-ethernet" = "󰈀 ";
            "tooltip-format" = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
            "format-linked" = "󰈀 {ifname} (No IP)";
            "format-disconnected" = " ";
            "tooltip-format-disconnected" = "Disconnected";
            "on-click" = "ags -t ControlPanel";
            "interval" = 2;
          };

          "pulseaudio" = {
            "format" = "{icon}";
            "rotate" = 0;
            "format-muted" = "婢";
            "tooltip-format" = "{icon} {desc} // {volume}%";
            "scroll-step" = 5;
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [ "" "" "" ];
            };
          };

          "pulseaudio#microphone" = {
            "format" = "{format_source}";
            "rotate" = 0;
            "format-source" = "";
            "format-source-muted" = "";
            "on-click" = "pavucontrol -t 4";
            "on-click-middle" = "volumecontrol.sh -i m";
            "on-scroll-up" = "volumecontrol.sh -i i";
            "on-scroll-down" = "volumecontrol.sh -i d";
            "tooltip-format" = "{format_source} {source_desc} // {source_volume}%";
            "scroll-step" = 5;
          };

          "custom/notifications" = {
            "tooltip" = false;
            "format" = "{icon} {}";
            "rotate" = 0;
            "format-icons" = {
              "email-notification" = "<span foreground='white'><sup></sup></span>";
              "chat-notification" = "󱋊<span foreground='white'><sup></sup></span>";
              "warning-notification" = "󱨪<span foreground='yellow'><sup></sup></span>";
              "error-notification" = "󱨪<span foreground='red'><sup></sup></span>";
              "network-notification" = "󱂇<span foreground='white'><sup></sup></span>";
              "battery-notification" = "󰁺<span foreground='white'><sup></sup></span>";
              "update-notification" = "󰚰<span foreground='white'><sup></sup></span>";
              "music-notification" = "󰝚<span foreground='white'><sup></sup></span>";
              "volume-notification" = "󰕿<span foreground='white'><sup></sup></span>";
              "notification" = "<span foreground='white'><sup></sup></span>";
              "none" = "";
            };
            "return-type" = "json";
            "exec-if" = "which dunstctl";
            "exec" = "notifications.py";
            "on-click" = "sleep 0.1 && dunstctl history-pop";
            "on-click-middle" = "dunstctl history-clear";
            "on-click-right" = "dunstctl close-all";
            "interval" = 1;
            "escape" = true;
          };

          "custom/keybindhint" = {
            "format" = " ";
            "rotate" = 0;
            "on-click" = "keybinds_hint.sh";
          };

          "custom/expand" = {
            "on-click" = "~/.config/hypr/scripts/expand_toolbar";
            "format" = "{}";
            "exec" = "~/.config/hypr/scripts/tools/expand arrow-icon";
          };

          # modules for padding

          "custom/l_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/r_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/sl_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/sr_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/rl_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/rr_end" = {
            "format" = " ";
            "interval" = "once";
            "tooltip" = false;
          };

          "custom/padd" = {
            "format" = "  ";
            "interval" = "once";
            "tooltip" = false;
          };

          "backlight/slider" = {
            "min" = 5;
            "max" = 100;
            "rotate" = 0;
            "device" = "intel_backlight";
            "scroll-step" = 1;
          };

          "pulseaudio/slider" = {
            "min" = 5;
            "max" = 100;
            "rotate" = 0;
            "device" = "pulseaudio";
            "scroll-step" = 1;
          };
        };
      };
    };
  };
}
