{
  wayland.windowManager.hyprland.extraConfig = let
  in ''

    # a submap for resizing windows
    bind = $MOD, S, submap, resize # enter resize window to resize the active window
    submap=resize
    binde=,right,resizeactive,10 0
    binde=,left,resizeactive,-10 0
    binde=,up,resizeactive,0 -10
    binde=,down,resizeactive,0 10
    bind=,escape,submap,reset
    submap=reset

    # workspace binds
    # binds * (asterisk) to special workspace
    bind = $MOD, KP_Multiply, togglespecialworkspace
    bind = $MODSHIFT, KP_Multiply, movetoworkspace, special

    # and mod + [shift +] {1..10} to [move to] ws {1..10}
    ${
      builtins.concatStringsSep "\n"
      (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = $MOD, ${ws}, workspace, ${toString (x + 1)}
            bind = $MOD SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)
    }
  '';
}
