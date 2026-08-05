# Per-user home-manager aspect for the lorian host (Phase 3d).
#
# Headless server: no GUI/themes/misc (xdg) composition — deltas belong here,
# not in the shared files.
{ self, ... }: {
  flake.modules.homeManager.lorian = {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.cli
    ];
  };
}
