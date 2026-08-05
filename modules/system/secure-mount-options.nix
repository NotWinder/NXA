{ config, lib, ... }: {
  config = lib.mkIf config.custom.system.boot.isUEFI {
    fileSystems = let
      defaults = ["nodev" "nosuid" "noexec"];
    in {
      "/boot".options = defaults;
    };
  };
}
