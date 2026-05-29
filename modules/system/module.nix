{
  imports = [
    ./boot/module.nix
    ./display/module.nix
    ./environment/module.nix
    ./fs/module.nix
    ./misc/module.nix
    ./networking/module.nix
    ./programs/module.nix
    ./services/module.nix
    ./users/module.nix
    ./security/module.nix

    ./btrfs-snapshots.nix
    ./secure-mount-options.nix
    ./impermanence.nix
    ./secrets.nix
    ./switch.nix
  ];
}
