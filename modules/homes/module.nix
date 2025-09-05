{
  inputs',
  self',
  self,
  config,
  lib,
  ...
}: let
  inherit (self) inputs;
  inherit (lib.modules) mkIf mkForce;
  inherit (config) modules;

  sys = modules.system;
  env = modules.usrEnv;
  defaults = env.programs.default;

  specialArgs = {inherit inputs self inputs' self' defaults;};
in {
  imports = [
    ./cipher/home.nix

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" sys.mainUser])
  ];
  home-manager = mkIf env.useHomeManager {
    # tell home-manager to be as verbose as possible
    verbose = true;

    # use the system configuration’s pkgs argument
    # this ensures parity between nixos' pkgs and hm's pkgs
    useGlobalPkgs = true;

    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;

    # move existing files to the .old suffix rather than failing
    # with a very long error message about it
    backupFileExtension = "hm.old";

    # extra specialArgs passed to Home Manager
    # for reference, the config argument in nixos can be accessed
    # in home-manager through osConfig without us passing it
    extraSpecialArgs = specialArgs;

    # Additional configuration that should be set for any existing and future users
    # declared in this module. Any "shared" configuration between users may be passed
    # here.
    sharedModules = [
      {
        # Ensure that HM uses t he same Nix package as NixOS.
        nix.package = mkForce config.nix.package;

        # Allow HM to manage itself when in standalone mode.
        # This makes the home-manager command available to users.
        programs.home-manager.enable = true;

        # Try to save some space by not installing variants of the home-manager
        # manual, which I don't use at all. Unlike what the name implies, this
        # section is for home-manager related manpages only, and does not affect
        # whether or not manpages of actual packages will be installed.
        manual = {
          manpages.enable = false;
          html.enable = false;
          json.enable = false;
        };
      }
    ];
  };
}
