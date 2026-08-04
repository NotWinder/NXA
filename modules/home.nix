{ ... }:
{
  # Home-manager aspects, registered by name (Phase 3b).
  #
  # Coarse aspects mirror the former home/cipher sub-trees; per-user
  # aspects replicate the old home/<host>/home.nix shims exactly
  # (cipher = direct path import, others = one-level wrapper) so that
  # the NixOS module expansion is node-for-node identical.
  flake.modules.home = {
    base = {
      imports = [ ./_lib/home/base.nix ];
    };

    cli = {
      imports = [ ./_lib/home/cipher/cli ];
    };

    gui = {
      imports = [ ./_lib/home/cipher/gui ];
    };

    misc = {
      imports = [ ./_lib/home/cipher/misc ];
    };

    themes = {
      imports = [ ./_lib/home/cipher/themes ];
    };

    cipher = ./_lib/home/cipher/home.nix;

    amadeus = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    brau1589 = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    heu = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    lorian = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    magi = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    salieri = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };

    wired = {
      imports = [ ./_lib/home/cipher/home.nix ];
    };
  };
}
