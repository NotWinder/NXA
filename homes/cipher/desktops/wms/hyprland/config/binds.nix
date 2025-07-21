{
  osConfig,
  defaults,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  terminal = "${defaults.terminal}";
  browser = "${defaults.browser}";
in {
  config = mkIf env.desktops.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      "$MOD" = "SUPER";
      binds = {
        scroll_event_delay = 10;
      };

      bind = [
        ## hyprland keybinds
        "$MOD, C, killactive, # closes (not kills) the active window."
        "$MOD SHIFT, C, forcekillactive, # kills the active window."
        "$MOD, V, togglefloating, # toggles the current window’s floating state."
        "$MOD, F, fullscreen, # toggles the focused window’s fullscreen mode."
        "$MOD SHIFT, M, exit, # exits the compositor with no questions asked."
        "$MOD, M, exec, uwsm stop # exits the compositor with no questions asked.(for uwsm users)"
        "ALT, tab, cyclenext # focuses the next window (on a workspace, if visible is not provided)"

        ## exec keybinds
        "$MOD, Q, exec, ${terminal}" # open the default terminal emulator
        "$MOD, R, exec, killall rofi || rofi -show drun" # open the application launcher (backup)
        "$MOD, E, exec, dolphin" # open the default file explorer
        "$MOD, O, exec, obsidian" # open the default file explorer
        "$MOD, G, exec, ${browser}" # open the default browser
        "$MOD, P, exec, nwg-displays" # open nwg-displays (for monitor managment)

        # Window Management
        ## Move windows
        "$MOD SHIFT, h, movewindow, l"
        "$MOD SHIFT, j, movewindow, d"
        "$MOD SHIFT, k, movewindow, u"
        "$MOD SHIFT, l, movewindow, r"
        ## Move focus with Mod + arrow keys
        "$MOD, h, movefocus, l"
        "$MOD, j, movefocus, d"
        "$MOD, k, movefocus, u"
        "$MOD, l, movefocus, r"
        ## Special workspace
        "$MOD SHIFT, U, movetoworkspace, special"
        "$MOD, U, togglespecialworkspace,"
        # The following mappings use the key codes to better support various keyboard layouts
        "$MOD, 1, workspace, 1"
        "$MOD, 2, workspace, 2"
        "$MOD, 3, workspace, 3"
        "$MOD, 4, workspace, 4"
        "$MOD, 5, workspace, 5"
        "$MOD, 6, workspace, 6"
        "$MOD, 7, workspace, 7"
        "$MOD, 8, workspace, 8"
        "$MOD, 9, workspace, 9"
        "$MOD, 0, workspace, 10"
        "$MOD, bracketleft, movetoworkspace, -1" # brackets [ or ]
        "$MOD, bracketright, movetoworkspace, +1"
        # Move active window and follow to workspace
        "$MOD SHIFT, 1, movetoworkspace, 1"
        "$MOD SHIFT, 2, movetoworkspace, 2"
        "$MOD SHIFT, 3, movetoworkspace, 3"
        "$MOD SHIFT, 4, movetoworkspace, 4"
        "$MOD SHIFT, 5, movetoworkspace, 5"
        "$MOD SHIFT, 6, movetoworkspace, 6"
        "$MOD SHIFT, 7, movetoworkspace, 7"
        "$MOD SHIFT, 8, movetoworkspace, 8"
        "$MOD SHIFT, 9, movetoworkspace, 9"
        "$MOD SHIFT, 0, movetoworkspace, 10"
        "$MOD SHIFT, bracketleft, movetoworkspace, -1" # brackets [ or ]
        "$MOD SHIFT, bracketright, movetoworkspace, +1"
        # Move active window to a workspace silently mainMod + CTRL [0-9]
        "$MOD CTRL, 1, movetoworkspacesilent, 1"
        "$MOD CTRL, 2, movetoworkspacesilent, 2"
        "$MOD CTRL, 3, movetoworkspacesilent, 3"
        "$MOD CTRL, 4, movetoworkspacesilent, 4"
        "$MOD CTRL, 5, movetoworkspacesilent, 5"
        "$MOD CTRL, 6, movetoworkspacesilent, 6"
        "$MOD CTRL, 7, movetoworkspacesilent, 7"
        "$MOD CTRL, 8, movetoworkspacesilent, 8"
        "$MOD CTRL, 9, movetoworkspacesilent, 9"
        "$MOD CTRL, 0, movetoworkspacesilent, 10"
        "$MOD CTRL, bracketleft, movetoworkspacesilent, -1" # brackets [ or ]
        "$MOD CTRL, bracketright, movetoworkspacesilent, +1"
        ## Scroll through existing workspaces with Mod + scroll
        "$MOD, mouse_down, workspace, e+1"
        "$MOD, mouse_up, workspace, e-1"

        ## Launcher
        "Ctrl+Alt, C, global, caelestia:clearNotifs"
        "Super, K, global, caelestia:showall"

        # Media
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
        "$MOD ALT, mouse_down, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%+"
        "$MOD ALT, mouse_up, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%-"
        "$MOD+SHIFT, mouse_down, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
        "$MOD+SHIFT, mouse_up, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
      ];
      # binds that will be repeated, a.k.a can be held to toggle multiple times
      binde = [
        # Resize windows
        "$MOD SHIFT, left, resizeactive,-50 0"
        "$MOD SHIFT, right, resizeactive,50 0"
        "$MOD SHIFT, up, resizeactive,0 -50"
        "$MOD SHIFT, down, resizeactive,0 50"

        # volume controls
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindin = [
        #"Super, catchall, global, caelestia:launcherInterrupt"
        "Super, mouse:272, global, caelestia:launcherInterrupt"
        "Super, mouse:273, global, caelestia:launcherInterrupt"
        "Super, mouse:275, global, caelestia:launcherInterrupt"
        "Super, mouse:276, global, caelestia:launcherInterrupt"
        "Super, mouse:277, global, caelestia:launcherInterrupt"
        "Super, mouse_down, global, caelestia:launcherInterrupt"
        "Super, mouse_up, global, caelestia:launcherInterrupt"
      ];
    };
  };
}
