{ inputs
, config
, lib
, ...
}:
let
  inherit (lib) mkIf;

  sys = config.custom.system;
in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    # MIGRATION ONLY (dendritic, Phase 1): inputs.self.outPath embeds the flake
    # source path in NH_FLAKE -> set-environment -> the entire toplevel closure,
    # so every commit changes every host's toplevel store path, breaking the
    # store-path equivalence gate. Pin to a constant; restore `inputs.self.outPath`
    # in Phase 4.
    flake = if sys.nhFlakePath != null then sys.nhFlakePath else "dendritic-migration";
  };
}
