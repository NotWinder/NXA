{
  inputs',
  osConfig,
  defaults,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  # nix advantages
  inherit (import ../packages {inherit inputs' pkgs;}) propaganda;

  terminal = "${defaults.terminal}";
  browser = "${defaults.browser}";

  locker = getExe env.programs.screenlock.package;
in {
  wayland.windowManager.hyprland.settings = {
    "$MOD" = "SUPER";

    # keyword to toggle "monocle" - a.k.a no_gaps_when_only
    "$kw" = "dwindle:no_gaps_when_only";
    "$disable" = ''act_opa=$(hyprctl getoption "decoration:active_opacity" -j | jq -r ".float");inact_opa=$(hyprctl getoption "decoration:inactive_opacity" -j | jq -r ".float");hyprctl --batch "keyword decoration:active_opacity 1;keyword decoration:inactive_opacity 1"'';
    "$enable" = ''hyprctl --batch "keyword decoration:active_opacity $act_opa;keyword decoration:inactive_opacity $inact_opa"'';
    #"$screenshotarea" = ''hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"''

    bind = [
      "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
      "$MOD, M, exit," # exit Hyprland session
      "$MOD, C, killactive,"
      "$MOD, F, fullscreen," # fullscreen focused window
      #bind = $mainMod SHIFT, Q, exec, $scriptsDir/KillActiveProcess.sh TODO:KillActiveProcess
      "$MOD,V,togglefloating," # toggle floating for the focused window
      "$MOD ALT, V, exec, hyprctl dispatch workspaceopt allfloat"
      #bind = CTRL ALT, L, exec, $scriptsDir/LockScreen.sh # screen lock
      "$MOD SHIFT, L, exec, ${locker}" # lock the screen with swaylock
      #bind = CTRL ALT, P, exec, $scriptsDir/Wlogout.sh # power menu
      "$MOD SHIFT, Escape, exec, wlogout -p layer-shell" # logout menu

      ## FEATURES / EXTRAS
      #bind = $mainMod, H, exec, $scriptsDir/KeyHints.sh # help file
      #bind = $mainMod ALT, R, exec, $scriptsDir/Refresh.sh # Refresh waybar, swaync, rofi
      #bind = $mainMod ALT, E, exec, $scriptsDir/RofiEmoji.sh # emoji menu
      #bind = $mainMod, S, exec, $scriptsDir/RofiSearch.sh # Google search using rofi
      #bind = $mainMod SHIFT, B, exec, $scriptsDir/ChangeBlur.sh # Toggle blur settings
      #bind = $mainMod SHIFT, G, exec, $scriptsDir/GameMode.sh # Toggle animations ON/OFF
      #bind = $mainMod ALT, L, exec, $scriptsDir/ChangeLayout.sh # Toggle Master or Dwindle Layout
      #bind = $mainMod ALT, V, exec, $scriptsDir/ClipManager.sh # Clipboard Manager
      #bind = $mainMod SHIFT, N, exec, swaync-client -t -sw # swayNC notification panel

      ## FEATURES / EXTRAS (UserScripts)
      #bind = $mainMod, E, exec, $UserScripts/QuickEdit.sh # Quick Edit Hyprland Settings
      #bind = $mainMod SHIFT, M, exec, $UserScripts/RofiBeats.sh # online music using rofi
      #bind = $mainMod, W, exec, $UserScripts/WallpaperSelect.sh # Select wallpaper to apply
      #bind = $mainMod SHIFT, W, exec, $UserScripts/WallpaperEffects.sh # Wallpaper Effects by imagemagick
      #bind = CTRL ALT, W, exec, $UserScripts/WallpaperRandom.sh # Random wallpapers
      #bind = $mainMod ALT, O, exec, hyprctl setprop active opaque toggle # disable opacity on active window
      #bind = $mainMod SHIFT, K, exec, $scriptsDir/KeyBinds.sh # search keybinds via rofi
      #bind = $mainMod SHIFT, A, exec, $UserScripts/Animations.sh #hyprland animations menu

      ## Waybar / Bar related
      #bind = $mainMod, B, exec, pkill -SIGUSR1 waybar # Toggle hide/show waybar
      #bind = $mainMod CTRL, B, exec, $scriptsDir/WaybarStyles.sh # Waybar Styles Menu
      #bind = $mainMod ALT, B, exec, $scriptsDir/WaybarLayout.sh # Waybar Layout Menu

      # Dwindle Layout
      "$MOD, J, togglesplit," # dwindle
      "$MOD SHIFT, P,pseudo," # pseudotile focused window

      # Master Layout
      "$MOD CTRL, D, layoutmsg, removemaster"
      "$MOD, I, layoutmsg, addmaster"
      "$MOD, J, layoutmsg, cyclenext"
      "$MOD, K, layoutmsg, cycleprev"
      "$MOD CTRL, Return, layoutmsg, swapwithmaster"

      # Works on either layout (Master or Dwindle)
      "$MOD, M, exec, hyprctl dispatch splitratio 0.3"

      # group
      "$MOD, T, togglegroup" # toggle group
      "$MOD SHIFT, T, changegroupactive" # change focus to another window

      # Cycle windows if floating bring to top
      "ALT, tab, cyclenext"
      "ALT, tab, bringactivetotop"

      ## Screenshot keybindings NOTE: You may need to press Fn key as well
      #bind = $mainMod, Print, exec, $scriptsDir/ScreenShot.sh --now  # screenshot
      #bind = $mainMod SHIFT, Print, exec, $scriptsDir/ScreenShot.sh --area # screenshot (area)
      #bind = $mainMod CTRL, Print, exec, $scriptsDir/ScreenShot.sh --in5 # screenshot  (5 secs delay)
      #bind = $mainMod CTRL SHIFT, Print, exec, $scriptsDir/ScreenShot.sh --in10 # screenshot (10 secs delay)
      #bind = ALT, Print, exec, $scriptsDir/ScreenShot.sh --active # screenshot (active window only)

      ## screenshot with swappy (another screenshot tool)
      #bind = $mainMod SHIFT, S, exec, $scriptsDir/ScreenShot.sh --swappy #screenshot (swappy)

      ## Move windows
      "$MOD CTRL, left, movewindow, h"
      "$MOD CTRL, right, movewindow, l"
      "$MOD CTRL, up, movewindow, k"
      "$MOD CTRL, down, movewindow, j"

      # Move focus with Mod + arrow keys
      "$MOD, left, movefocus, h"
      "$MOD, right, movefocus, l"
      "$MOD, up, movefocus, k"
      "$MOD, down, movefocus, j"

      # Workspaces related
      #bind = $mainMod, tab, workspace, m+1
      #bind = $mainMod SHIFT, tab, workspace, m-1

      # Special workspace
      "$MOD SHIFT, U, movetoworkspace, special"
      "$MOD, U, togglespecialworkspace,"

      # The following mappings use the key codes to better support various keyboard layouts
      # 1 is code:10, 2 is code 11, etc
      # Switch workspaces with mainMod + [0-9]
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

      # Move active window and follow to workspace mainMod + SHIFT [0-9]
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

      ## Scroll through existing workspaces with mainMod + scroll
      "$MOD, mouse_down, workspace, e+1"
      "$MOD, mouse_up, workspace, e-1"
      "$MOD, L, workspace, e+1"
      "$MOD, H, workspace, e-1"

      # workspace controls
      "$MOD SHIFT,L,movetoworkspace,+1" # move focused window to the next ws
      "$MOD SHIFT,H,movetoworkspace,-1" # move focused window to the previous ws

      #-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      ''$MOD SHIFT,H,exec,cat ${propaganda} | ${pkgs.wl-clipboard}/bin/wl-copy && ${pkgs.libnotify}/bin/notify-send "Propaganda" "ready to spread!" && sleep 0.3 && ${lib.getExe pkgs.wtype} -M ctrl -M shift -k v -m shift -m ctrl -s 300 -k Return'' # spread hyprland propaganda

      "$MOD, Q, exec, ${terminal}"
      "$MOD, D, exec, rofi -show drun -theme ~/.config/rofi/global/rofi.rasi"
      ''$MOD, R, exec, killall tofi || run-as-service $(tofi-drun --prompt-text "Run")''
      ''$MOD, D,exec, killall anyrun || run-as-service $(anyrun)''

      # window operators
      "$MOD,N,exec,hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))" # toggle no_gaps_when_only

      # screenshot and receording binds
      ''$MOD SHIFT,P,exec,$disable; grim - | wl-copy --type image/png && notify-send "Screenshot" "Screenshot copied to clipboard"; $enable''
      "$MOD SHIFT,S,exec,$disable; hyprshot; $enable" # screenshot and then pipe it to swappy
      "$MOD, Print, exec, grimblast --notify --cursor copysave output" # copy all active outputs
      "ALT SHIFT, S, exec, grimblast --notify --cursor copysave screen" # copy active screen
      "ALT SHIFT, R, exec, grimblast --notify --cursor copysave area" # copy selection area

      # OCR
      "$MOD SHIFT,O,exec,ocr"

      # Toggle Statusbar
      "$MOD SHIFT,B,exec, ags -t bar"

      "$MOD, E, exec, dolphin"
      "$MOD, G, exec, ${browser}"
      "$MOD, R, exec, wofi --show drun"
      "$MOD, P, exec,nwg-displays"
      "$MOD, escape, exec, bash ~/.config/waybar/scripts/power-menu/powermenu.sh"

      "$MOD, O, exec, game-mount"
      "$MOD, SHIFT O, exec, game-umount"
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
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      # brightness controls
      '',XF86MonBrightnessUp,exec,ags --run-js "brightness.screen += 0.05"''
      '',XF86MonBrightnessDown,exec, ags --run-js "brightness.screen -= 0.05"''
    ];
    # binds that are locked, a.k.a will activate even while an input inhibitor is active
    bindl = [
      # media controls using keyboards
      ", xf86AudioPlayPause, exec, $scriptsDir/MediaCtrl.sh --pause"
      ", xf86AudioPause, exec, $scriptsDir/MediaCtrl.sh --pause"
      ", xf86AudioPlay, exec, $scriptsDir/MediaCtrl.sh --pause"
      ", xf86AudioNext, exec, $scriptsDir/MediaCtrl.sh --nxt "
      ", xf86AudioPrev, exec, $scriptsDir/MediaCtrl.sh --prv"
      ", xf86AudioStop, exec, $scriptsDir/MediaCtrl.sh --stop"
      ", xf86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", xf86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];
  };
}
