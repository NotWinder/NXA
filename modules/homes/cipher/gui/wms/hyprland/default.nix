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
in {
  options.custom.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./config))
  );
  config = mkIf config.custom.programs.hyprland.enable {
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
      home.packages = with pkgs; [
        inputs'.hyprpolkitagent.packages.default
        grim
        slurp
        nwg-displays
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
