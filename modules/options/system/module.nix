{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elemAt;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkMerge;
  inherit (lib.lists) optionals;
  inherit (lib.types) enum listOf str bool package;
in {
  imports = [
    # boot/impermanence mounts
    ./boot.nix
    ./impermanence.nix

    ## network and overall hardening
    #./networking
    ./security.nix

    # filesystems
    ./fs.nix

    # virtualization
    ./virtualization.nix

    #  services related options
    ./services
  ];
  config = {
    warnings = mkMerge [
      (optionals (config.modules.system.users == []) [
        ''
          You have not added any users to be supported by your system. You may end up with an unbootable system!

          Consider setting {option}`config.modules.system.users` in your configuration
        ''
      ])
    ];
  };

  options.modules.system = {
    mainUser = mkOption {
      type = enum config.modules.system.users;
      default = elemAt config.modules.system.users 0;
      description = ''
        The username of the main user for your system.

        In case of a multiple systems, this will be the user with priority in ordered lists and enabled options.
      '';
    };

    users = mkOption {
      type = listOf str;
      default = ["winder"];
      description = "A list of home-manager users on the system.";
    };

    homePath = mkOption {
      type = str;
      default = "/home/winder";
      description = "Path to home directory of the mainUser.";
    };

    defaultUserShell = mkOption {
      type = package;
      default = pkgs.bash;
      description = "The Default Shell for the User.";
    };

    autoLogin = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable passwordless login. This is generally useful on systems with
        FDE (Full Disk Encryption) enabled. It is a security risk for systems without FDE.
      '';
    };

    sound = {
      enable = mkEnableOption "sound related programs and audio-dependent programs";
    };

    video = {
      enable = mkEnableOption "video drivers and programs that require a graphical user interface";
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth modules, drivers and configuration program(s)";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
      extraDrivers = mkOption {
        type = listOf str;
        default = [];
        description = "A list of extra drivers to enable for printing";
      };
    };
  };
}
