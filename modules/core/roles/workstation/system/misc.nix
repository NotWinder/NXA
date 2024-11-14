{
  # Firefox cache on tmpfs
  fileSystems."/home/winder/.cache/mozilla/firefox" = {
    device = "tmpfs";
    fsType = "tmpfs";
    noCheck = true;
    options = ["noatime" "nodev" "nosuid" "size=128M"];
  };
}
