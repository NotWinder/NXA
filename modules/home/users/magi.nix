# Per-user home-manager aspect for the magi host (Phase 3d).
#
# Composes the shared aspects this user wants; per-user deltas belong here,
# not in the shared files.
{ self, ... }: {
  flake.modules.homeManager.magi = {
    imports = [
      self.modules.homeManager.desktop
    ];
  };
}
