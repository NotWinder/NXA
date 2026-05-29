{ ... }: {
  config = {
    fileSystems = let
      defaults = ["nodev" "nosuid" "noexec"];
    in {
      "/boot".options = defaults;
    };
  };
}
