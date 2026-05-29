{ config
, lib
, ...
}:
let
  inherit (config) custom;
  inherit (lib) mkIf;

  type = custom.device.type;
  acceptedTypes = [ "desktop" "laptop" ];
in
{
  config = mkIf (builtins.elem type acceptedTypes) {
    # enable flatpak, as well as xdgp to communicate with the host filesystems
    services.flatpak.enable = true;

    environment.sessionVariables.XDG_DATA_DIRS = [ "/var/lib/flatpak/exports/share" ];
  };
}
