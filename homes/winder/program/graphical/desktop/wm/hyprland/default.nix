{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland.override { legacyRenderer = true; };
    settings = {
      "$mainMod" = "SUPER";
      "$browser" = "chromium";
      monitor = ",preferred,auto,1";
      #animation = import ./config/animation.nix;
      animations.enabled = false;
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
