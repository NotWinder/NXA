{ config
, pkgs
, lib
, ...
}:
let
  inherit (builtins) elemAt;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkMerge mkDefault;
  inherit (lib.lists) optionals;
  inherit (lib.types) enum listOf nullOr str package;
in
{
  imports = [
    # boot/impermanence mounts
    ./boot.nix
    ./impermanence.nix

    ## network and overall hardening
    ./networking.nix
    ./security.nix

    # filesystems
    ./fs.nix

    # virtualisation
    ./virtualisation.nix

    #  services related options
    ./services
  ];
  config = mkMerge [
    {
      warnings = optionals (config.custom.system.users == [ ]) [
        ''
          You have not added any users to be supported by your system. You may end up with an unbootable system!

          Consider setting {option}`config.custom.system.users` in your configuration
        ''
      ];
    }
    {
      custom.system.printing.enable = mkDefault false;
    }
  ];

  options.custom.system = {
    mainUser = mkOption {
      type = enum config.custom.system.users;
      default = elemAt config.custom.system.users 0;
      description = ''
        The username of the main user for your system.

        In case of a multiple systems, this will be the user with priority in ordered lists and enabled options.
      '';
    };

    users = mkOption {
      type = listOf str;
      default = [ "winder" ];
      description = "A list of home-manager users on the system.";
    };

    homePath = mkOption {
      type = str;
      default = "/home/winder";
      description = "Path to home directory of the mainUser.";
    };

    nhFlakePath = mkOption {
      type = nullOr str;
      default = null;
      description = "Flake path for nh (NH_OS_FLAKE). Defaults to inputs.self.outPath when null.";
    };

    defaultUserShell = mkOption {
      type = package;
      default = pkgs.fish;
      description = "The Default Shell for the User.";
    };

    enableSshSecrets = mkEnableOption "Whether or not add the ssh options to the config(requires secrets)";

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
        default = [ ];
        description = "A list of extra drivers to enable for printing";
      };
    };
  };
}
