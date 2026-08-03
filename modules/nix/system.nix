{ self, ... }: {
  system = {
    # Automatic/Unattended upgrades in general are one of the dumbest things you can set up
    # on virtually any Linux distribution. While NixOS would logically mitigate some of its
    # side effects, you are still risking a system that breaks without you knowing. If the
    # bootloader also breaks during the upgrade, you may not be able to roll back at all.
    # tl;dr: upgrade manually, review changelogs.
    autoUpgrade.enable = false;

    # Globally declare the configurationRevision from shortRev if the git tree is clean,
    # or from dirtyShortRev if it is dirty. This is useful for tracking the current
    # configuration revision in the system profile.
    # MIGRATION ONLY (dendritic, Phase 0): pinned so toplevel store paths are
    # comparable across commits. This value feeds nixos-version -> system-path ->
    # the whole toplevel closure. Remove in Phase 4.
    configurationRevision = "dendritic-migration";
  };

  # Preserve the flake that built the active system revision in /etc
  # for easier rollbacks with nixos-enter in case we contain changes
  # that are not yet staged.
  # MIGRATION ONLY (dendritic, Phase 0): self (the flake source path) changes on
  # every commit and is embedded into /etc/nyx, which also breaks the toplevel
  # store-path equivalence gate. Pinned to a stable content-addressed file;
  # restore `self` in Phase 4.
  environment.etc."nyx".source = builtins.toFile "nyx" "pinned during dendritic migration (Phase 0)";
}
