{ self, ... }:
{
  # Home-manager aspects, registered by name (Phase 3a/3b/3c/3d).
  #
  # Consumed by ../home/module.nix: `home-manager.users.<mainUser>.imports`
  # composes the aspects listed in `custom.usrEnv.home.aspects` (selected
  # per host in hosts/default.nix). Shared aspects live here; per-user
  # aspects (one file per host under `modules/home/users/`) compose the
  # shared ones and carry per-user deltas (Phase 3d).
  #
  # The closure-captured aspects (dankMaterial, zen, foot, randomize,
  # hyprlock, hyprpaper, xdg) are defined in separate files under
  # `modules/home/` (Phase 3c step 4). They close over flake-parts args
  # (`inputs`, `inputs'`, `self`) and are folded into the `gui`/`misc`
  # composition below via `self`, so no `extraSpecialArgs` is required.
  flake.modules.homeManager = {
    base = {
      imports = [ ./_lib/home/base.nix ];
    };

    cli = {
      imports = [ ./_lib/home/cipher/cli ];
    };

    gui = {
      imports = [
        self.modules.homeManager.dankMaterial
        self.modules.homeManager.zen
        self.modules.homeManager.foot
        self.modules.homeManager.randomize
        self.modules.homeManager.hyprlock
        self.modules.homeManager.hyprpaper
        self.modules.homeManager.hyprland
        self.modules.homeManager.niri
        self.modules.homeManager.sway
        ./_lib/home/cipher/gui
      ];
    };

    # Per-WM aspects (Phase 5 item 4): one named aspect per window manager,
    # each internally gated on `osConfig.custom.programs.<wm>.enable`. They
    # live outside the gui tree and are composed by name above.
    hyprland = {
      imports = [ ./_lib/home/wms/hyprland ];
    };

    niri = {
      imports = [ ./_lib/home/wms/niri ];
    };

    sway = {
      imports = [ ./_lib/home/wms/sway ];
    };

    misc = {
      imports = [
        self.modules.homeManager.xdg
      ];
    };

    themes = {
      imports = [ ./_lib/home/cipher/themes ];
    };
  };
}
