{
  config,
  lib,
  ...
}: let
  inherit (lib) optionals;
  inherit (config) modules;

  sys = modules.system;
  prg = modules.usrEnv.programs;
in {
  users.users.${sys.mainUser} = {
    isNormalUser = true;

    # Home directory
    createHome = true;
    home = "${sys.homePath}";

    shell = sys.defaultUserShell;

    # Should be generated manually. See option documentation
    # for tips on generating it. For security purposes, it's
    # a good idea to use a non-default hash.
    initialHashedPassword = "$y$j9T$7H7kkKRmdM5yfcD4gg95a0$hKdDMx96CcOUU3cDYwz02rII48G6RHloZSngWJGfuh5";
    extraGroups =
      [
        "wheel"
        "systemd-journal"
        "audio"
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "nix"
        "network"
        "networkmanager"
        "wireshark"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
      ]
      ++ optionals prg.cli.adb.enable [
        "adbusers"
      ];
  };
}
