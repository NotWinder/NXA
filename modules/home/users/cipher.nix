# Per-user home-manager aspect for the cipher host (Phase 3d).
#
# Composes the shared aspects this user wants; per-user deltas belong here,
# not in the shared files.
{ self, ... }: {
  flake.modules.homeManager.cipher = {
    imports = [
      self.modules.homeManager.desktop
    ];
  };
}
