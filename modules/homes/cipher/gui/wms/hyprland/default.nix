{
  config,
  inputs',
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;
  inherit (config) modules;

  env = modules.usrEnv;
in {
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./config))
  );
  config = mkIf (env.desktop == "Hyprland") {
    services.displayManager.sessionPackages = [inputs'.hyprland.packages.hyprland];
    programs.hyprland = {
      enable = true;
      # set the flake package
      package = inputs'.hyprland.packages.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      withUWSM = true;
      systemd.setPath.enable = true;
    };

    hm = {
      home.packages = [
        inputs'.hyprpolkitagent.packages.default
        pkgs.grim
        pkgs.slurp
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
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
  };
}
