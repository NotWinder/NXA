{ config
, pkgs
, lib
, osConfig
, ...
}:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;
in
{
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./config))
  );
  config = mkIf osConfig.custom.programs.hyprland.enable {
    home.packages = with pkgs; [
      hyprpolkitagent
      grim
      slurp
      nwg-displays
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "hyprlang";
      systemd = {
        enable = false;
      };

      settings = {
        debug = {
          disable_logs = false;
        };
        source = [
          "~/.config/hypr/monitors.conf"
          "~/.config/hypr/workspaces.conf"
        ];
      };
    };
  };
}