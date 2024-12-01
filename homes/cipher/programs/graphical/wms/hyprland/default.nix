{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mainMod" = "SUPER";
      "$browser" = "zen";
      source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ];
      animation = import ./config/animation.nix;
      bind = import ./config/bind.nix;
      bindm = import ./config/bindm.nix;
      decoration = import ./config/decoration.nix;
      dwindle = import ./config/layouts/dwindle.nix;
      env = import ./config/env.nix;
      exec-once = import ./config/exec-once.nix;
      general = import ./config/general.nix;
      gestures = import ./config/layouts/gestures.nix;
      input = import ./config/input.nix;
      master = import ./config/layouts/master.nix;
      windowrule = import ./config/windowrule.nix;
    };
  };
}
