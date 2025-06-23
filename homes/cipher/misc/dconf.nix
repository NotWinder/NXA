{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
in {
  config = mkIf sys.video.enable {
    dconf.settings = {
      # this is like a system-wide dark mode switch that some apps respect
      # equivalent of the following dconf command:
      # `conf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"`
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      # tell virt-manager to use the system connection
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
