{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
  sing-box-url = builtins.readFile config.sops.secrets."sing-box-url".path;
  sing-box-conf-file = builtins.fetchurl sing-box-url;
  sing-box-conf = builtins.readFile sing-box-conf-file;
in {
  config = mkIf cfg.sing-box.enable {
    sops.secrets = {
      "sing-box-url" = {
        owner = config.users.users.winder.name;
        inherit (config.users.users.winder) group;
        neededForUsers = true;
      };
    };
    services.sing-box = {
      enable = true;
      settings = builtins.fromJSON sing-box-conf;
    };
  };
}
