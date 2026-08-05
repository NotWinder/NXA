{ config
, lib
, osConfig
, ...
}:
let
  inherit (lib) mkForce;

  sys = osConfig.custom.system;
in
{
  home = {
    username = "${sys.mainUser}";
    homeDirectory = "${sys.homePath}";
    extraOutputsToInstall = [ "doc" "devdoc" ];

    stateVersion = "23.11";
  };

  systemd.user.startServices = "sd-switch";

  # Shared home-manager modules (formerly home/module.nix sharedModules)
  nix.package = mkForce osConfig.nix.package;
  programs.home-manager.enable = true;
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };
}