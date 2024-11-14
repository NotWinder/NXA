{
  config,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mainMod" = "SUPER";
      "$browser" = "chromium";
      monitor = [
        ",1440x900,auto,1"
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
  home.file."${config.xdg.configHome}/hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
