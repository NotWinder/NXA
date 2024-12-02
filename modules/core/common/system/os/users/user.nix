{
  #keys,
  config,
  pkgs,
  ...
}: let
  sys = config.modules.system;
in {
  users.users.${sys.mainUser} = {
    isNormalUser = true;

    # Home directory
    createHome = true;
    home = "${sys.homePath}";

    shell = pkgs.zsh;

    # Should be generated manually. See option documentation
    # for tips on generating it. For security purposes, it's
    # a good idea to use a non-default hash.
    #initialHashedPassword = "$2b$05$NI5/uV4JXUt/wq8hEN.NX.5rKCvCtj8JZih/seVcPIXNFIpw61v.y";
    #openssh.authorizedKeys.keys = [keys.notashelf];
    extraGroups = [
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
    ];
  };
}
