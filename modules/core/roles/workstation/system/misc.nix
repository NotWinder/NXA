{config, ...}: let
  sys = config.modules.system;
in {
  # Firefox cache on tmpfs
  fileSystems."/home/${sys.mainUser}/.cache/mozilla/firefox" = {
    device = "tmpfs";
    fsType = "tmpfs";
    noCheck = true;
    options = ["noatime" "nodev" "nosuid" "size=128M"];
  };
}
