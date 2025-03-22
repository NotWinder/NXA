{
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;
  inherit (osConfig) modules;

  #inherit (import ./packages {inherit inputs' pkgs;}) hyprshot dbus-hyprland-env hyprpicker;

  env = modules.usrEnv;
in {
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./config))
  );
  config = mkIf env.desktops.hyprland.enable {
    #home.packages = [
    #  hyprshot
    #  hyprpicker
    #  dbus-hyprland-env
    #  #pkgs.nwg-displays
    #];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd = {
        enable = false;
        #variables = ["--all"];
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
