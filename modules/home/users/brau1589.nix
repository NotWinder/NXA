# Per-user home-manager aspect for the brau1589 host (Phase 3d).
#
# Composes the shared aspects this user wants; per-user deltas belong here,
# not in the shared files.
{ self, ... }: {
  flake.modules.homeManager.brau1589 = {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.cli
      self.modules.homeManager.gui
      self.modules.homeManager.themes
      self.modules.homeManager.misc
    ];
  };
}
